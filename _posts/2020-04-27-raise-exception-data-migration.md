---
layout: post
title:  "Migrate Data More Safely in Rails by Raising an Exception"
date:   2020-04-27
published: true
---
A data migration can fail but still end up in an "up" state. This is a problem because you'll probably try to roll back that unsuccessful migration, but will fail because the logic in your `down` method most likely depends on the logic in your `up` method executing correctly.

Let's say your `up` method is supposed to create a record and your `down` is supposed to undo that by deleting that record. In this case, your `down` would fail because it wouldn't be able to find this record to be able to delete it -- because it was not created succesfully in the first place.

```ruby
class AddMittensToCats < ActiveRecord::Migration[6.0]
  def up
    # This could fail silently, for example, the name "Mittens" may be
    # taken already. However the migration `up` would have completed running
    # successfully. Now we're in a pinch.

    Cat.create!(name: 'Mittens')
  end

  def down
    # If "Mittens" the cat were never actually created in the "up" method,
    # this line will fail, saying "can't call delete on NilClass". So you
    # won't be able to roll back and you'll be stuck in an "up" state for
    # your migration. Yikes.

    Cat.find_by(name: 'Mittens').delete
  end
end
```

A safer approach is to do a data check in the `up` migration that throws an exception if your expectations are not met. This will cause the `up` method to fail and the migration transaction to rollback, thus not trapping you in a broken state. For example:

```ruby
class AddMittensToCats < ActiveRecord::Migration[6.0]
  def up
    Cat.create!(name: 'Mittens')

    unless Cat.find_by(name: 'Mittens').present?
      raise ActiveRecord::Exception
      # OR something like
      raise '*** DATA CHECK FAILED ***'
    end
  end

  def down
    Cat.find_by(name: 'Mittens').delete
  end
end
```

If you need more space to do an elaborate query for your data check, break it out into a different method:

```ruby
class AddMittensToCats < ActiveRecord::Migration[6.0]
  def up
    Cat.create!(name: 'Mittens')

    data_check
  end

  def down
    Cat.find_by(name: 'Mittens').delete
  end

  def data_check
    # You can make your checking logic as complicated as you
    # need it to be to feel comfortable that it worked correctly.

    expected_result = Cat.find_by(name: 'Mittens').present?
    raise '*** DATA CHECK FAILED ***' unless expected_result
  end
end
```

Now when you run your migrate command, if the data in your `up` didn't execute properly, your command line will tell you:
```
*** DATA CHECK FAILED ***
This and following migrations have been rolled back
```
And you just saved yourself a big headache.
