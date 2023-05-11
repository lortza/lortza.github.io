---
layout: post
title:  "The Rails migration 'change' method is more magic than I thought"
date:   2020-01-29
published: true
---

Here's a big fat TIL. The Rails `change` method can add a column back, _including it's original data type_, if you tell it to.  <img src='https://emojis.slackmojis.com/emojis/images/1450319447/26/mindblown.gif?1450319447' title='mindblown' class='emoji' > I know this works in Rails 6. I'm not sure about other versions.

## TL;DR
Do this:
```bash
rails g migration RemoveIsCoolFromUsers, is_cool
```
Get this:
```ruby
class RemoveIsCoolFromUsers < ActiveRecord::Migration
  # on up: removes the column
  # on down: adds the column back as the boolean data type
  def change
    remove_column :users, :is_cool, :boolean
  end
end
```

## The Longer Version
Here's the scenario. We have a `users` table and we don't need the `is_cool` column anymore, so we plan to drop it.
```
# users table

users
-----
is_cool: boolean <-- don't need this anymore
email: string
full_name: string
```

Normally, I'd generate a migration like this:
```bash
rails g migration RemoveIsCoolFromUsers
```

I'd get a migration file that looks like this:
```ruby
class RemoveIsCoolFromUsers < ActiveRecord::Migration
  def change
  end
end
```
and then I'd fill it in like this:
```ruby
class RemoveIsCoolFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_cool
  end
end
```

Since I'm doing a destructive migration by removing a column, I want to ensure a successful rollback (adding the column back in again) by being explicit about this column being a `boolean` data type as it was before. To do that, I normally break that `change` method up into the 2 older syntax methods: `up` and `down`.

```ruby
class RemoveIsCoolFromUsers < ActiveRecord::Migration
  # runs when we call rake db:migrate
  def up
    remove_column :users, :is_cool
  end

  # runs when we call rake db:rollback
  def down
    add_column :users, :is_cool, :boolean
  end
end
```

As it turns out, I've been doing it the long way this whole time. Jeeze Louise. Now here's the magic: `change` knows how to do all of this for you if you pass it the column name and data type like this:
```bash
rails g migration RemoveIsCoolFromUsers, is_cool:boolean
```
which gives you this in the migration file:

```ruby
class RemoveIsCoolFromUsers < ActiveRecord::Migration
  # on up: removes the column
  # on down: adds the column back as the boolean data type
  def change
    remove_column :users, :is_cool, :boolean
  end
end
```

Now `change` will know to add this column back as a boolean data type! <img src='https://emojis.slackmojis.com/emojis/images/1490980812/1982/awesome.png?1490980812' title='awesome' class='emoji'> That is pretty neato. Now, if my migrations are any more complicated than simply removing a single column, I still see myself wanting to have the explicit `up` and `down` actions lined out. That decision isn't so much about being an old dog as it is about not quite understanding the limitations of this new trick just yet.

### FYI: Deleting columns will cause data loss
Also, please note, if you delete a column and add it back, you will lose your data. So ya know, always be _sure_ you want to delete a column before you do so. In fact, if you use the `strong_migrations` gem, you will be prompted to `ignore` a column before you can remove it. You can read more about that on the [strong_migrations github page](https://github.com/ankane/strong_migrations).
