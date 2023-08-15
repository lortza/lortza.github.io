---
layout: post
title:  "How to Use Rails' alias_attribute"
date:   2020-04-16
published: true
---
### What it's For...
Renaming an attribute. Ever have an attribute on your Rails model that you wish you had named something else? And actually renaming the table column is not feasible? A solution I have used in this case is `alias_attribute` to rename the attribute associated with that table column. It looks like this:

```ruby
# in your model file

alias_attribute :new_aliased_name, :old_attribute_name
```

For example, let's say we have a model called `Article` that has a `header` attribute and we'd like to change it to `title`. Using `alias_attribute` in the `app/models/article.rb` file will write the new getter and setter for us.

```ruby
# renaming from `header` to `title`

# this one-liner
alias_attribute :title, :header

# is the same as
def title
  header
end

def title=(title)
  self.header = title
end
```
Now when we refer to `article.title` anywhere in the codebase, we'll be returning the value for `header`.

### What it's Not For...
As per [this stack overflow post](https://stackoverflow.com/a/39836732), I discovered that I had been using this incorrectly to make handy aliases for relationships between models. Yikes. This meant:
* I was not setting myself up to get all of the Rails magic<sup>TM</sup>
* I was calling items publicly 2 different ways which is confusing and makes future refactors harder
* I was not able to test these relationship associations in model specs <-- Double yikes. Big red flag there.

In this example, we want to rename our `User` model's relationship with `posts` to `articles`:
```ruby
class User
  # Wrong way
  has_many :posts
  alias_attribute :articles, :posts

  # Right way
  has_many :articles, class_name: 'Post'
end
```

And in the specs
```ruby
class User
  # Wrong way
  it { should have_many(:posts) }

  # Right way
  it { should have_many(:articles) }
end
```
