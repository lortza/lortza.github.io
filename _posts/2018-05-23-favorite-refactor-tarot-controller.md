---
layout: post
title:  My Favorite Refactor - A Look Back at Growth
date:   2018-05-23
---

When I first started learning programming, I made a command line app that does tarot readings. (You can play with that app [here](https://repl.it/@lortz/tarotreadings).) As a first project, it's really lovely! It works and has no bugs. The logic is very linear and doesn't take advantage of any principles of OOP -- except for saving values in instance variables... all over the place. It was a little unruly in that regard. And it was this version of past me that needed to turn that command line app into a Rails app. I was totally overwhelmed.

## My First Foray from Command Line into Rails

My goal with the app was to have a web page with 3 random cards on it, each card position having its own meaning. I called that a spread:

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

So I made a `SpreadController` controller. I wasn't really sure what a controller *did* exactly, but I knew it made pages. I also knew I wanted my app to have 3 different types of spreads, so I made 3 different `spread` methods: `spread1`, `spread2`, and `spread3`.

```ruby
class SpreadController < ApplicationController

  def spread1
   ...
  end #spread1

  def spread2
   ...
  end #spread2

  def spread3
    ...
  end #spread3

end
```

I knew that to make a "reading," I'd need a spread of cards -- meaning a page that had spaces for cards, and the cards to go in them. I was already confusing myself with the naming of objects. So I did what I knew:


```ruby
class SpreadController < ApplicationController

  def spread1
    # I grabbed all of the cards from the magical database
    @cards = Card.all

    # I hoisted a reading array to hold the cards I'd be using
    @reading = []

    # I grabbed 3 of the cards from the variable that held the cards
    @cards.sample(3).each do |card|
      # and I pushed them into the reading array.
      @reading.push(card)
    end
  end

end
```

I did this exact same thing for `spread2` and `spread3`. It worked and there were no bugs! In fact, it felt like I used *all* of my Ruby knowledge at once in these controller actions. Hooray for total n00b me!

## The First Refactor

About a year later, I came back to the project to see if there was anything to refactor. I decided this controller could use some work. I had a much better understanding of how controllers work and how the router and controller work together. I wanted pretty urls like `/readings/relationship`. So I renamed my controller to `ReadingsController` and renamed my methods as well. I also condensed all of that hoisting, eaching, and pushing into 1 line for each method.

```ruby
class ReadingsController < ApplicationController

  def relationship
    @cards = Card.all.sample(3)
  end

  def confidence
    @cards = Card.all.sample(4)
  end

  def conflict
    @cards = Card.all.sample(8)
  end

  def index
  end

end
```

That felt like a really tidy refactor! My controller was much skinnier and the methods made more sense to read. Unfortunately, my views were all still hard-coded HTML with matching Bootstrap modal and jQuery for *each card on the page*. And I was extracting data from the `@cards` array using the index number to insert it into custom text about the reading.

```erb
<!-- Multiply this code by as many cards as there are on a page.
     That's a lot of hard-coded HTML. -->


<!-- Truncated Sample of Card 1 HTML -->
<h4>You</h4>
<a href="#card1Modal" role="button" data-toggle="modal">
  <div id="firstcard">
    <%= image_tag @reading[0].imagefile %>
  </div>
</a>

<div class="modal fade" id="card1Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

  <!-- SO MUCH Bootstrap HTML goes here... -->
  <h4>The <%= @reading[0].name %> Card Represents:</h4>
  <%= image_tag @reading[0].imagefile %>
  <h3>Your Role in This Relationship</h3>
  <p>According to the <%= @reading[0].name %> card, you are currently manifesting qualities like <%= @reading[0].meaning.downcase %> in this relationship.</p>
</div>

<!-- Card 1 Javascript -->
<script type="text/javascript">
  jQuery(document).ready(function(){

    $("#firstcard").on("click", function() {
      $('.firstcard-hidden').css("display", "block");
    });
  });
</script>
```

I was storing data about the readings in the HTML, but that was a problem for another day. It worked and there were no bugs! Hooray!

## The Major Refactor

About a year later, it was time to face that problem. I needed to make this app scalable. I wanted to be able to make a bunch of new readings on a whim AND I wanted those readings each to have as many cards as necessary in them. I wanted a 3-card reading to be treated no differently than a 10-card reading and I wanted an admin section in which to build these readings.

The current setup was no longer sustainable. It was time to restructure. My schema grew from just a `cards` table to one that included:

```
cards
- name
- keywords
- image_file

readings
- name
- description
- image_file

reading_positions
- reading_id
- theme
- meaning
```

And now my `ReadingsController` finally became RESTful with proper `show` and `index` actions.

```ruby
class ReadingsController < ApplicationController
  ...
  def show
    positions = @reading.positions.order(:position_number).to_a
    cards = Card.all.sample(positions.count)
    @positioned_cards = positions.zip(cards)
  end

  def index
    @readings = Reading.all
  end

  private
  ...
end
```

That is a *much* skinnier controller than where I started. More importantly, it was following the principles of [RESTful routing](https://codeplanet.io/principles-good-restful-api-design/) and [OOP](http://www.poodr.com/), and the [conventions of Rails controllers](http://guides.rubyonrails.org/action_controller_overview.html). It also enabled me to handle my HTML and jQuery iteratively from inside an `each` loop.

```erb
<% @positioned_cards.each do |position, card| %>
  <%= render 'positioned_card', position: position, card: card %>
<% end %>
```

## And it will keep on changing...

I have to be honest. Though this refactor happened months ago, as I was writing this post, I just moved all of my `positioned_card` code into the partial you see mentioned above. It had been living on the show page, directly inside the `each` loop.

Which brings me to my point that this codebase will keep changing as the scope of the project changes and as my skillset changes.

In this look back, it's been interesting for me to see what I understood at any given time and then how I used all of my current knowledge to build the best thing I could. Learning software engineering can feel daunting! There is an insurmountable amount of things to learn and directions to go -- plus a lot of conflicting opinions about which direction is the best direction to go. It is easy to feel like I'll never "get there." It is good to take a moment to reflect on how much I've grown in the past couple of years and it is so exciting to imagine how much more I'll be able to accomplish in the future.

