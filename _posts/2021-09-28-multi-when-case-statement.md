---
layout: post
title:  "TIL multiple values in a ruby case statement 'when' block"
date:   2021-09-28
published: true
---

Today I learned that you can include multiple options in a Ruby case statement.

I have a helper method that I use to determine which [Bootstrap](https://getbootstrap.com/) class to use when styling the flash message on a page:

```ruby
def bootstrap_flash_class(type)
  case type
  when 'alert' then 'warning'
  when 'error' then 'danger'
  when 'notice' then 'success'
  when 'warning' then 'warning' # <-- RUBOCOP NO LIKEY
  else
    'info'
  end
end
```
(Yes, I use Bootstrap in my personal projects. I am aware of how dreadfully uncool I am.)

Rubocop was telling me that it didn’t like me making a second decision about what should return a value of `'warning'`.

```bash
Offenses:

app/helpers/application_helper.rb:18:5: W: Lint/DuplicateBranch: Duplicate branch body detected.
    when 'warning' then 'warning'
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Well aw jeeeeze Rubocop, I want more than one input to return `'warning'`! So I googled it and :oh-snap: you _can_ include multiple options in that `when` block: <a href='https://stackoverflow.com/a/10197397' target='_blank'>https://stackoverflow.com/a/10197397</a>. As it turns out, in a case statement, a `,` is the equivalent of a `||` in an `if` statement. Neat!

So I tucked that little nugget of knowledge in my back pocket for later and updated my case statement:

```ruby
def bootstrap_flash_class(type)
  case type
  when 'alert', 'warning' then 'warning'
  when 'error' then 'danger'
  when 'notice' then 'success'
  else
    'info'
  end
end
```

High five, Rubocop! Thanks for the lesson.
