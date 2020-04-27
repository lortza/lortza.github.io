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
    # this could fail silently and your up method would still complete successfully
    Cat.first_or_create!(name: 'mittens')
  end

  def down
    # if "mittens" the cat were never created, this down method will fail
    Cat.find_by(name: 'mittens').delete
  end
end
```

A safer approach is to do a data check in the migration which throws an exception if your expectations are not met. This will cause the `up` method to fail and the migration transaction to rollback, thus not trapping you in a broken state.

```ruby
class AddMittensToCats < ActiveRecord::Migration[6.0]
  def up
    Cat.create!(name: 'mittens')

    unless Cat.find_by(name: 'mittens').present?
      raise ActiveRecord::Exception
      # OR something like
      raise '*** DATA CHECK FAILED ***'
    end
  end

  def down
    Cat.find_by(name: 'mittens').delete
  end
end
```

If you need more space to do an elaborate query, break your data check out into a different method:

```ruby
class AddMittensToCats < ActiveRecord::Migration[6.0]
  def up
    Cat.create!(name: 'mittens')

    data_check
  end

  def down
    Cat.find_by(name: 'mittens').delete
  end

  def data_check
    # You can make your checking logic as complicated as you
    # need it to be to feel comfortable that it worked correctly.
    expected_result = [complicated query logic]

    unless expected_result
      raise '*** DATA CHECK FAILED ***'
    end
  end
end
```
