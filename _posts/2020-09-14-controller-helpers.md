---
layout: post
title:  "Accessing the link_to helper in a Rails controller and adding a link to a flash message"
date:   2020-09-14
published: true
---
In my food planning app, after clicking a link to add all recipe ingredients to a shopping list, I display a flash message that looks like:

```bash
38 items added to your Grocery list.
```

Which is actually:
```
[calculated integer] [pluralized word] added to your [list name] list.
```

After having this feature in place for a while, I found myself wanting to be able to click on the list name in the flash message to take me to that shopping list. So how do you put a link in a flash message?

## Step 1: Accessing the `link_to` helper inside a Rails controller
If you want to access some of the useful helper methods while inside the scope of a controller, you can pull them in with `ActionController::Base.helpers`. In this example, I wanted to take advantage of `link_to` and `pluralize` and interpolate them into a flash message:

```ruby
# ShoppingListItemBuildersController

def create
  ...
  flash[:notice] = flash_message(ingredient_ids)
  ...
end

private

def flash_message(ingredient_ids)
  pluralized_items = ActionController::Base.helpers.pluralize(ingredient_ids.length, 'item')
  link = ActionController::Base.helpers.link_to(@shopping_list.name.titleize, shopping_list_path(@shopping_list))

  "#{pluralized_items} added to your #{link} list."
end
```

At this point, we're half way there. We have a flash message that looks like this:
```
38 items added to your <a href="/shopping_lists/7">Grocery</a> list.
```
That's just HTML and not an actual clickable link. We have a little more work to do.

## Step 2: Make the link clickable

In order for the HTML passed into the flash message to be rendered as live HTML and not text, I called the `html_safe` method on it in my flashes partial.

```html
<!-- app/views/shared/_flashes.html.erb -->

<% flash.each do |type, message| %>
  <div class="flash-notice">
    <%= message.html_safe %>
  </div>
<% end %>
```

Now, be careful here, [like the docs say](https://apidock.com/rails/String/html_safe), "It is your responsibility to ensure that the string contains no malicious content."
