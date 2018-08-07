---
layout: post
title:  'Personal Challenge: Action Cable Responses from both the DOM and the Console'
date:   2018-07-31
---
Google's [Firebase](https://firebase.google.com/) is a database tool that (among many other things) pushes updated data to all instances of a browser. I think that is pretty nifty. I also think that it's a bit unreasonable to restructure an existing Rails app's entire Postgres situation just for this one feature. For this reason, I started to explore Rails' [Action Cable](https://guides.rubyonrails.org/action_cable_overview.html).

The [Rails docs](https://guides.rubyonrails.org/action_cable_overview.html) docs say:

> Action Cable seamlessly integrates WebSockets with the rest of your Rails application. It allows for real-time features to be written in Ruby in the same style and form as the rest of your Rails application, while still being performant and scalable. It's a full-stack offering that provides both a client-side JavaScript framework and a server-side Ruby framework. You have access to your full domain model written with Active Record or your ORM of choice.

As a personal challenge, I built an app that tracks the status of vehicles on a car lot. It pushes updates to users' browsers via Action Cable when the `status_id` field of a car changes. It works both for browser-initiated and console-initiated updates. Normally in an app, the browser-initiated updates would suffice, but I wanted to go the extra mile. In the case of [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load)-style database updates, there wouldn't be a user sending changes from the DOM to the controller. I needed my app to be able to response with Action Cable even if the database were being updated in some other way.

## The Rules for My Challenge

* When a DOM user updates a car's status via the browser, they get the normal Rails notice and all other users get a jQuery alert via Action Cable.
* If an update happens via the console, all users get an alert via Action Cable.
* Only send an alert when the `car.status_id` field is updated
* Do _not_ send an alert when a `Car` record is created

### The App Stats

* Ruby 2.5.0
* Rails ~> 5.0.1
* Postgres ~> 0.18
* Redis 3.3.1


## How it Works

Instead of giving details of a full Action Cable implementation, I'll just hit the highlights needed to make both the DOM/controller-driven and console-driven approaches work in the same app. If you'd like a full tutorial on implementing Action Cable, here are 2 suggestions:

* [alerts via the console](https://medium.com/rubyinside/action-cable-hello-world-with-rails-5-1-efc475b0208b)
* [alerts via the DOM](https://www.learnenough.com/action-cable-tutorial)

### The Action Cable Channel

Action Cable needs a channel for objects to subscribe to, so we set up a `status_notifications_channel` for our specific car status-related notifications.

```ruby
# app/channels/status_notifications_channel.rb

class StatusNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "status_notifications_channel"
  end
end
```

### The Cars Controller

At some point, we need to initiate a broadcast and it _seems_ like the `cars_controller` would be a good place for that. But knowing when and what to broadcast is not the `cars_controller`'s job. All it cares about is passing data between the car views and data source. So we give it an object that already knows the broadcasting info, which lets the controller stick to its normal duties.

```ruby
# app/controllers/cars_controller.rb

def update
  # Pass the @car and its updated params to the `CarWithBroadcast` class
  @car_with_broadcast = CarWithBroadcast.new(@car, car_params)

  respond_to do |format|
    # And use that class's object just as we would have used the @car object under default circumstances
    if @car_with_broadcast.save
      format.html { redirect_to cars_url, notice: "The #{@car_with_broadcast.car.display} was successfully updated." }
      format.json { render cars_url, status: :ok, location: @car_with_broadcast.car }
    else
      format.html { render :edit }
      format.json { render json: @car_with_broadcast.car.errors, status: :unprocessable_entity }
    end
  end
end
```

### The Broadcasting Class

The `CarWithBroadcast` class holds the what/when logic of broadcasting a car's status. So we give it a `@car` and let it initiate a broadcast to the `status_notifications_channel`.

```ruby
# app/models/car_with_broadcast.rb

class CarWithBroadcast
  attr_reader :car

  def initialize(car, params)
    @car = car
    @car.assign_attributes(params)
    @status_changed = @car.status_id_changed?
  end

  def save
    if car.valid?
      car.save
      # Here we broadcast a message to the `status_notifications_channel` via ActionCable's methods
      ActionCable.server.broadcast('status_notifications_channel', car.to_broadcast) if @status_changed
      true
    else
      false
    end
  end
end
```

The `Car` class knows how it wants to talk about itself in a broadcast. Hence the `car.to_broadcast` above.

```ruby
# app/models/car.rb

class Car < ApplicationRecord
  ...
  def to_broadcast
    {
      status: status.with_id,
      car_id: id,
      message: "The #{display} is now #{status.display}."
    }
  end

  def display
    "#{color.display} #{make} #{model}"
  end
end
```

### The Alert Coffee Script

When the `status_notifications_channel` receives the broadcast data, we use Coffee Script and jQuery to insert the HTML for the alert message.

```coffeescript
# app/assets/javascripts/channels/status_notifications.coffee

App.status_notifications = App.cable.subscriptions.create "StatusNotificationsChannel",
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').html("<p class='alert'>#{data.message} <span class='dismiss'>X</span></p>")
    $("##{data.car_id}").text("#{data.status}")
    $("##{data.car_id}").parent().addClass('highlight')

    $('.dismiss').on 'click', ->
      $('.alert').remove()
      $("##{data.car_id}").parent().removeClass('highlight')

```

### Sending Alerts

#### From the DOM

* Go to `localhost:3000` in 2 browser windows, the second one as an incognito window.
* Edit & Save a car via the web interface.
* See the normal notice in User 1's browser and the alert message in User 2's browser. Clear the alerts.


#### From the Console

* Update a car's status in the console (as below) and see the both users' browsers receive the alert.

```ruby
# rails console

CarWithBroadcast.new(Car.first, {status_id: Status.last.id}).save
```

## Why Didn't You...?

So why not use an `after_update` callback in the `Car` model instead of creating the `CarWithBroadcast` class? With a model callback, we're inextricably tied to having a broadcast happen _every_ time a `car` object is updated. The `CarWithBroadcast` class gives us the flexibility to choose where and when we want to broadcast.

For example, updating a `car` in the console like this does not produce the alert,

```ruby
# rails console

Car.first.update!(status_id: 2)
```

and that makes for a better user experience if you need to make changes to the production database and you don't need users to witness the whole process. If we had used `after_update` the broadcast would have been sent -- and possibly without our realizing it.

The `CarWithBroadcast` class is not a _perfect_ solution. It feels a little clunky and the naming seems a touch off. But it's the solution for right now and when the code grows, a better name and purpose may reveal itself.
