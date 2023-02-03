---
layout: post
title:  "Understanding the Observer Pattern"
date:   2019-07-02
published: true
---

The Observer Pattern is a convenient way to update several objects when one object changes state. For example, let's say we have a website that tracks the status of real estate properties. A `property` can go through several different states such as "coming soon", "for sale", "pending sale", and "sold."

```ruby
class Property
  attr_reader :street_address, :price, :sale_status

  def initialize(street_address:, price:, sale_status:)
    @street_address = street_address
    @price = price
    @sale_status = sale_status
  end
end
```

There are also a few different parties that may be interested in to know when that state changes, for example realtors, owners, potential buyers, tax entities, and banks. We'll start with just `Realtor`s:

```ruby
class Realtor
end
```

## A Property doesn't care who follows it
Do you think Beyonce sends individual messages to every single one of her followers when she's going to be touring in their cities? Nope. She posts that information once and the people who subscribe to those notifications get those notifications. Our `property` feels the same way (though between you and me, our property is no Beyonce).

```ruby
property = Property.new(
  street_address: '123 Main Street',
  price: '300,000',
  sale_status: 'coming soon'
)

property.tell_everybody_everything  # <= Um, no. We're not doing that.
```

This is not a `property`'s job. A `property`'s job to is to know about property stuff. That is all. But a `property` is willing to permit observers to "follow" it, or "subscribe" to certain state changes. We do this by initializing it with an `observers` attribute.

```ruby
class Property
  attr_reader :street_address, :price, :sale_status

  def initialize(street_address:, price:, sale_status:)
    @street_address = street_address
    @price = price
    @sale_status = sale_status
    @observers = []  # <= Empty array for storing observers
  end
end
```

And then we give the class some methods to interact with this array of observers:

```ruby

# Methods for interacting with obeservers
def add_observer(observer)
  @observers << observer
end

def remove_observer(observer)
  @observers.delete(observer)
end

def notify_observers
  @observers.each do |observer|
    observer.update(self)
  end
end
```
## The Property decides when to notify observers

Beyonce doesn't tell you _everything_. Neither does our `property`. Let's notify our observers when the `sale_status` changes:

```ruby
def sale_status=(new_status)
  @sale_status = new_status
  notify_observers
end
```

Now we give the `property` an observer that is a `Realtor`:

```ruby
realtor = Realtor.new
property.add_observer(realtor)
```

## The observing object decides how to react
Give the observing object something to do when it gets notified:

```ruby
class Realtor
  def update(property)
    puts "#{self.class} says: Hello Commission! The property at #{property.street_address} is now #{property.sale_status}."
  end
end
```

## The property just does it's thing
Now when the `sale_status` changes, the observer pattern is triggered and all of the observers get notified:

```ruby
property.sale_status = 'sold'
# => Realtor says: Hello Commission! The property at 123 Main Street is now sold.
```

## People've been smashing that subscribe button...
Let's say this property has even more observers.

```ruby
class PotentialBuyerNews
  def update(property)
    puts "#{self.class} says: The listing you're following at #{property.street_address} is now #{property.sale_status}."
  end
end

class TaxEntity
  def update(property)
    puts "#{self.class} says: Send a sales tax bill to #{property.street_address} on a value of $#{property.price}."
  end
end

class Bank
  def update(property)
    puts "#{self.class} says: Start racking up interest on $#{property.price} for #{property.street_address}."
  end
end
```

We can add them all at once:

```ruby
class Property
  def bulk_add_observers(observers)
    @observers << observers
    @observers.flatten!
  end
end

realtor = Realtor.new
potential_buyer_news = PotentialBuyerNews.new
tax_entity = TaxEntity.new
bank = Bank.new

property.bulk_add_observers([
  realtor,
  potential_buyer_news,
  tax_entity,
  bank
])
```

Again, the property doesn't need to do any more work when more observers are added, but the effects ripple outward:

```ruby
# The property updates its status once and...
property.sale_status = 'sold'

# we get output from all of the observers:
"Realtor says: Oh snap! The property at 123 Main Street is now sold."
"PotentialBuyerNews says: The listing you're following at 123 Main Street is now sold."
"TaxEntity says: Send a sales tax bill to 123 Main Street on a value of $300,000."
"Bank says: Start racking up interest on $300,000 for 123 Main Street."
```

That's pretty nifty.

## Refactor Extractor

Now that our observer is in place and working well, let's pull out all of those observer-related methods into their own module:

```ruby
module Notifier
  def add_observer(observer)
    @observers << observer
  end

  def bulk_add_observers(observers)
    @observers << observers
    @observers.flatten!
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end
```

And then include the module in the `Property` class:
```ruby
class Property
  include Notifier

  attr_reader :street_address, :price, :sale_status
  ...
```

Now our `Property` class stays cleaner and the observer functions all live in one logical place.

## The Ruby language is down with this pattern
Ruby likes a good old fashioned observer pattern and makes it a little easier for us by providing an [`Observable` module](https://ruby-doc.org/stdlib-2.5.6/libdoc/observer/rdoc/Observable.html) that includes some of the functionality that we built here in our `Notifier` module. [This Medium post](https://medium.com/@nakshtra17/ruby-design-pattern-observer-method-eb7cb2a8d382) does a nice job of incorporating Ruby's `Observable` module into an example.

If you dig reading about patterns like this, check out [Design Patterns in Ruby](https://www.goodreads.com/book/show/2278064.Design_Patterns_in_Ruby) by Russ Olsen. That's where I learned about this pattern and a few others.
