---
layout: post
title:  "A good use of Rails Model Callbacks"
date:   2020-03-15
published: true
---
### What it's For...
Processing some input on the same model. Let's say we have a `User` model with a `full_name` field. Since this is user-entered data and we can't control what a user enters, we may end up getting a bunch of extra white spaces that will cause problems in our queries.

In this case, we could use a `before_save` callback to process that data before it is saved to our database.

```ruby
# app/models/user.rb

class User
  before_save :strip_whitespaces

  def strip_whitespaces
    self.full_name = full_name.strip
  end
end
```

This is a simple transformation that saves us some headaches with our data and does not reach beyond this model. That's why this callback feels safe to do.


### What it's Not For...
I'm not an expert and this can be hotly debated. So I'll offer you _my opinion_. Callbacks are sneaky. Unlike other methods, they're not necessarily easy to spot or predict. Using them makes it easy to get blindsided by surprise behavior and side effects.

Recently, I wanted to build out some assets when a new user set up an account. I did the quick and easy thing first -- I set up an `after_create` callback on my `User` model like so:

```ruby
# Don't do this

class User
  after_create :build_all_the_things

  def build_all_the_things
    # builds all the things for this user
    Category.build_default(self)
    Topic.build_default(self)
    FavoriteCatPhoto.build_default(self)
  end
end
```
This approach was handy to play with my proof of concept, but the moment I started testing, I ran into trouble. All of my tests were broken because _every time_ I created a `user` in any of my specs (which is a _lot_ of times), I was also building out all of these extra assets and all of my original test assumptions were now wrong (but in reality, they weren't). It slowed down my test suite and just made unit tests clunky. My `User` model now had to know about these _other_ models that were part of this building method. Plus, _SURPRISE!_. An unsuspecting developer (a.k.a. future me) would need to know this in advance to work in this test suite. I considered overriding callbacks for the test environment, but that was a red flag, so I chose another path forward.

### A Better Way
To solve my problem, I made a service object & method that handled building out all of the assets. Then, I called that method from the `registrations_controller` so these assets would be built out only once and only when a user registered for an account. This kept my `User` unit tests clean and separated those asset-building concerns into their own unit-testable service object.

```ruby
# app/controllers/registrations_controller.rb

def create
  user = User.find_by(id: params[:id])

  if user.save?
    # Add in a service object here amongst the other post-save actions
    AccountSetupService.generate_user_assets(user)
  else
    # do other stuff
  end
end
```

Is this approach the answer every time? Nah. But it worked for this situation and I'm glad I came to this solution because my code is much cleaner now.
