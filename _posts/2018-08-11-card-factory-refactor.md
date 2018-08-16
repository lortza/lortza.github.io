---
layout: post
title:  'Refactor: Solving a Pesky Naming Problem'
date:   2018-08-11
---

Back in February, I wrote [a post about a refactor]({% post_url 2018-02-26-card-factory %}) to [this app](http://modernmystic.herokuapp.com/) that made use of a factory-style class for some nifty data construction. Recently, I've found myself being bothered by a couple of things in that refactor, so thought I'd take a crack at making it better.

## My List of Things to Address

### 1. My controller still knows too much
Here in the controller, the `show` action does a lot of asking around and building of data before it can get down to the business of delivering data to the `show.html.erb` view.

```ruby
# app/controllers/readings_controller.rb

class ReadingsController < ApplicationController
  ...
  def show
    positions = @reading.positions.order(:position_number).to_a
    cards = CardFactory.build_cards(positions.count)
    @positioned_cards = positions.zip(cards)
  end
  ...
end
```

### 2. The name of my factory doesn't seem quite right

The model that produces a modified, view-ready `Card` object is called a `CardFactory`. That's not accurate because it's instantiating _card-like_ objects, not actual `Card` objects and not `CardFactory` objects. Hmmm.

```ruby
# app/models/card_factory.rb

class CardFactory
   def initialize(card, name, theme, keywords, orientation)
    @card = card
    @name = name
    @theme = theme
    @keywords = keywords
    @orientation = orientation
  end
```

In addition, the end goal of this class is to provide the controller with a set of card-like objects when what the controller _really needs_ is a set of data with card-like objects matched up to reading position objects:

```ruby
# app/controllers/readings_controller.rb

class ReadingsController < ApplicationController
  ...
  def show
    # This is what I really want:
    @positioned_cards = [array-of-cards+positions]
  end
  ...
end
```

I think I'm asking too much of the wrong things from a model with this name.

### 3. My tests are hard to write

As I was writing my `it` statements for this class, I found myself being confused about my expectations for its purpose.

```ruby
describe 'a valid card factory' do
  context 'when has valid params' do
    # But why does a 'factory' object need to be valid?
    # I actually need a card-like object to be valid.
    ...  

describe '.build_cards' do
  it 'returns an array of card factory objects' do
    # But I actually want an array of card-like objects,
    # not an array of factories.
    ...
```
And that's what pretty much sealed the deal. So, according to my husband, I spent some time doing this:

<a href="https://twitter.com/JenMsft/status/1027018324037623810"><img src="https://pbs.twimg.com/media/DkCzXJ2U4AE1sWk.jpg" title="When you try to choose a meaningful variable name by twitter.com/JenMsft" alt="Narcos' Pablo Escobar, thinking in various locations" class="post-image"></a>

And then I set out to refactor this thing.

## The Refactor

The `CardFactory` name was bothering me, not because I needed a better name, but because the thing I was trying to name was confused about its purpose. During a conversation with my [mentor](https://www.linkedin.com/in/scott-maslar-b1650b36/), we realized that it needed to be two different models. So the `CardFactory` model ended up diverging into a `ReadingCard` model and a `ReadingCardSet` model, each with a more job-specific name.

A `ReadingCard` will generate that card-like object I've been wanting and that's all it does.

```ruby
# app/models/reading_card.rb

class ReadingCard

  # Now I can logically validate these objects and test for validation
  include ActiveModel::Validations

  attr_reader :card, :name, :theme, :keywords, :orientation

  # Bonus refactor: the copious arguments required are now  
  # delivered via keywords for accuracy instead of as
  # fixed-position arguments
  def initialize(card:, name:, theme:, keywords:, orientation:)
    @card = card
    @name = name
    @theme = theme
    @keywords = keywords
    @orientation = orientation
  end

  delegate :id, :image_file, :arcana_id, :suit_id, to: :card

  validates :card, :name, :theme, :keywords, :orientation, presence: true

  def reversed?
    @orientation == 'reverse'
  end

end
```

A `ReadingCardSet` decides how many `ReadingCard`s are needed for a `Reading` and it knows how to align `ReadingCard` data with `ReadingPosition` data. It puts all of this together and delivers a single set of data for the `ReadingsController` to consume.

```ruby
# app/models/reading_card_set.rb

class ReadingCardSet

  # All of this logic used to live in the 'ReadingsController#show'
  def self.build_set(reading)
    # The responsibility of knowing how to `order` positions is now
    # in the ReadingPositions model
    positions = reading.positions.ordered.to_a
    reading_cards = self.build_cards(positions.count)
    positions.zip(reading_cards)
  end

  private

  def self.build_cards(qty)
    cards = Card.all.sample(qty)
    orientation_options = ['reverse', 'upright']

    reading_cards = []

    cards.each do |card|
      orientation = orientation_options.sample
      built_theme = card.send("#{orientation}_theme")
      built_keywords = card.send("#{orientation}_keywords")
      built_name = orientation == 'upright' ? card.name : "Reversed #{card.name}"

      built_card = ReadingCard.new(
                    card: card,
                    name: built_name,
                    theme: built_theme,
                    keywords: built_keywords,
                    orientation: orientation
                  )
      reading_cards << built_card if built_card.valid?
    end
    reading_cards
  end

end
```

The `ReadingsController` is relieved of its duty to build that set and now simply gets to deliver the display data that's been handed to it.

```ruby
# app/controllers/readings_controller.rb

class ReadingsController < ApplicationController
  ...
  def show
    @positioned_cards = ReadingCardSet.build_set(@reading)
  end
  ...
end
```

And my tests finally make sense since these two new models now have clarity of purpose.

## Future Improvements

I really like how this refactor has gone. However, I don't love that the view still has to know the anatomy of the `@positioned_cards` array in order to display data correctly.

```erb
<!-- app/views/readings/show.html.erb -->

<!-- This loop has to know that 'position' comes first
     and 'card' comes second in the array of pairs -->
<% @positioned_cards.each do |position, card| %>
  <%= render 'positioned_card', position: position, card: card %>
<% end %>
```

I'll address that in my next refactor session.
