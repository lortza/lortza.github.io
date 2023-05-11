---
layout: post
title:  Using a Factory to Randomize Whether a Card is Drawn Right-side Up or Upside Down
date:   2018-02-26
published: true
---

> UPDATE: Holy smokes! I've just refactored the code in this post to be even better :) See it in [this new post]({% post_url 2018-08-11-card-factory-refactor %}).

## Building the Original App
A couple of years ago, I build a Rails app that could do tarot card readings for me. (Here are the [live app](http://modernmystic.herokuapp.com/) and [repo](https://github.com/lortza/tarot).) A tarot reading, though it takes years of experience for professional readers to deeply understand cards, contexts, and people, can also be done with a `card`s table and Ruby's `sample` method. Obviously, you'll miss out on the insight of a professional reader, but it's still pretty fun.

I built this app initially as a bootcamp final project, and have since used it as an opportunity to refactor and add new features as my skills grow. Recently, I added the exciting new feature of having cards appear both right-side up and upside down. This feature makes the app experience much closer to the actual tarot reading experience, and is the centerpiece of this post.

## The Anatomy of Tarot Reading App
From the perspective of an app, a deck of tarot cards can be distilled down to a set of data with each card having a name and meaning. Likewise, a "reading" has a set number of positions in which to place a card, and each position in the reading has a context.

For example, a 3-card relationship reading, you have 3 positions, each with a different context:

```
    Position 1         Position 2          Position 3
       You          The Other Person    The Relationship
     ________           ________            ________
    |        |         |        |          |        |
    | card 1 |         | card 2 |          | card 3 |
    |  goes  |         |  goes  |          |  goes  |
    |  here  |         |  here  |          |  here  |
    |________|         |________|          |________|
```

In pseudocode, implementing this functionality looks like this:
```
- count the number of positions needed for the reading
- grab a random selection of cards to fill those positions
- deal out each card into each position
- display the card name and meaning inside each position context for the user to see
```

That works out like this in the `ReadingsController`:

{% highlight ruby linenos %}
# app/controllers/readings_controller.rb

class ReadingsController < ApplicationController
  ...
  def show
    @reading = Reading.find(params[:id])

    # Grab the reading's positions
    positions = @reading.positions

    # Grab enough random cards to fill the positions
    cards = Card.all.sample(positions.count)

    # Assign a card to each position
    @deal = positions.zip(cards)
  end
  ...
end
{% endhighlight %}

Then in the view, we can access the data for both the reading position and the card:
{% highlight erb linenos %}
<!-- app/views/readings/show.html.erb -->
...
<% @deal.each do |position, card| %>
  <article>
    <h2><%= position.name %></h2>
    <h3><%= card.name %></h3>
    <p><%= card.meaning %></p>
  </article>
...
{% endhighlight %}


Great! I was really happy with the way the app worked when I first built it. But gnawing in the back of my mind was the fact that in reality, when you draw tarot cards, sometimes the card shows up upside down, *and upside down (i.e. 'reversed') cards have different meanings than they do when they're right-side up (i.e. 'upright')*. That's right. A single card actually has 2 meanings. Oh boy.

## Adding in "Reversed" Cards
So how do you solve this kind of thing? I didn't want to have 2 different records in the database (upright & reversed) for each card because that would be redundant, messy data, and would make it possible for me to draw both the upright and reversed version of a card in the same reading. No good.

I decided to stay with one database record per card and added the reversed meaning column to the cards table. My updated schema looked more like this:

{% highlight ruby linenos %}
# db/schema.rb

create_table "cards", force: :cascade do |t|
  t.string "name"
  t.text "upright_meaning"
  t.text "reverse_meaning"
  ...
end
{% endhighlight %}


### And now for the fun part: flipping card upside down.
I achieved this using a factory. Check out line 8 below. Instead of pulling cards directly from the `Card` class, now we're pulling them from the `CardFactory` where they're created to arrive to us exactly as we need them: with randomly assigned 'upright' or 'reverse' data.

{% highlight ruby linenos %}
# app/controllers/readings_controller.rb

class ReadingsController < ApplicationController
  ...
  def show
    @reading = Reading.find(params[:id])
    positions = @reading.positions
    cards = CardFactory.build_cards(positions.count)
    @deal = positions.zip(cards)
  end
{% endhighlight %}


Let's pseudocode what we want that `CardFactory` to do:

```
We want our factory to:
- take a number argument so it knows how many cards to produce
- grab a random selection of Cards in that quantity
- randomly assign an orientation (upright/reverse) to each card
- manufacture complete cards with a name and meaning
  - If that card is upright, I want to see:
    card.name = 'The Fool'
    card.meaning = 'New Beginnings: innocence, journey, spontaneity, free spirit, change'
  - If that card is reversed, I want to see:
    card.name = 'The Fool Reversed'
    card.meaning = 'Resistance: stuck, foolishness, risk-taking, recklessness'
- deliver all manufactured cards in an array
```
This way, in our view, we don't have to worry about knowing when to call `upright_meaning` or `reverse_meaning` because the attribute simply will be called `meaning`. Now isn't that tidy?

Let's look at how the `CardFactory` actually produces these cards.

{% highlight ruby linenos %}
# app/models/card_factory.rb

class CardFactory
  attr_reader :card, :name, :meaning

   # Give the CardFactory object the attributes we'll need
   # to access in the view
   def initialize(card, built_name, built_meaning)
    @card = card
    @name = built_name
    @meaning = built_meaning
  end

  # Allow this CardFactory object to access this attribute
  # directly from the @card
  delegate :id

  def self.build_cards(qty)
    # Grab the right quantity of randomly selected Cards
    raw_cards = Card.all.sample(qty)

    # Set up the orientation options
    orientation_options = ['reverse', 'upright']

    # Hoist that built_cards placeholder
    @built_cards = []

    raw_cards.each do |card|
      # Select a random orientation
      orientation = orientation_options.sample

      # Use that orientation to pull the appropriate meaning
      # from the Card object. If the orientation is 'upright', that
      # interpolated 'send' is essentially calling 'card.upright_meaning'
      # or... 'card.reverse_meaning' for 'reverse'
      built_meaning = card.send("#{orientation}_meaning")

      # Use that orientation to modify the card name if needed
      built_name = orientation == 'upright' ? card.name : "#{card.name} Reversed"

      # Use our newly-built data to construct the new CardFactory object
      built_card = CardFactory.new(card, built_name, built_meaning)

      # and push it into the cards that will be delivered to the controller
      @built_cards << built_card
    end
    @built_cards
  end
end
{% endhighlight %}


### The New Functionality with Upside down Cards
Now with access to reversed meanings, our readings are more realistic. If I hop on over to [modernmystic.herokuapp.com](http://modernmystic.herokuapp.com/) (and wait for those free dynos to spin up), I can do a relationship reading with results like this (only more pretty with css):

```
    Position 1            Position 2              Position 3
        Me             The Other Person        The Relationship
     _________            __________              __________
    |         |          |          |            |          |
    |  The    |          |  3 of    |            |  9 of    |
    | Chariot |          |  Wands   |            | Swords   |
    |         |          | Reversed |            | Reversed |
    |_________|          |__________|            |__________|
    "self-control,       "dreamer, careless,    "persepctive, moving
    willpower,            untrustworthy          forward after
    ambition, focus"      partners"              failure"
```

Ha ha ha ha! Though I'm pretty pleased with the outcome of the app, it looks like I've got a little work to do on a relationship in my life. brb...
