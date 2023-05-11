---
layout: post
title:  "Refactor from a hardcoded button to a dropdown form in Rails 6"
date:   2020-02-29
published: true
---
### The Problem
I have a food planning app where I make a list of recipes that we will prepare for the week. Each week has its own list of recipes. Before heading out to the grocery store, I click button to dump all of the ingredients from all of the recipes into my grocery list. This feature does a little arithmetic and organizes ingredients by my grocery store's aisles. It's pretty swell. Though my app has many shopping lists, the button was hard-coded to dump onto my "Grocery" list because it is my main list.

The hard-coded button:

![The hardcoded button](/img/posts/2020_02_29_button.png)

The hard-coded button code:
```erb
<%= link_to '+ Add All Ingredients to Grocery List',
            shopping_list_item_builders_path(
              shopping_list_id: current_user.shopping_lists.default.id,
              ingredient_ids: ingredient_ids
            ),
            method: 'POST',
            class: button_classes('info')
%>
```

Recently I was visiting my parents out-of-state and doing some cooking at their house. I wanted to dump a few recipes' ingredients to a shopping list, but **not** my usual "Grocery" list. Now my hard-coded button felt a little too, well, hardcoded. And this is the cool thing about building your own tools. When you bump up against a feature you'd like to change, _you can just change it_. [#winning](https://images.app.goo.gl/JdVQEjGq2wzrsYED9) [#makeitso](https://images.app.goo.gl/Zu4fES7jKKyfPTk29)


### My Solution
I thought it would be nice to have a dropdown where I could choose the list -- and of course, to save myself clicks, I'd make the default value my preferred "Grocery" list. No need to give myself more clicks than the original button feature.

The new dropdown:

![The new dropdown](/img/posts/2020_02_29_dropdown.png)

The dropdown code:
```erb
<%= form_tag(shopping_list_item_builders_path, method: 'post', id: 'add-to-list-form' ) do %>
  <%= hidden_field_tag :ingredient_ids, ingredient_ids %>
  <%= select_tag :shopping_list_id,
                 options_from_collection_for_select(current_user.shopping_lists.by_favorite, :id, :name),
                 class: 'form-control'
  %>
  <%= submit_tag 'Add', class: 'btn btn-outline-info' %>
<% end %>
```

Since this data is not interacting directly with an ActiveRecord model, I'm using a `form_tag` instead of a `form_for` and am feeling on-edge because `form_tag` always makes me doubt everything I know. "But this time, everything will be fine," I told myself.

The `hidden_field_tag` is passing in the `ingredient_ids` just like it was in the button link. And the `select_tag` is the dropdown with all of the `current_user`'s shopping lists. That little `by_favorite` scope on the `current_user.shopping_lists` is what is putting my "Grocery" list at the top of the dropdown for my convenience. So far so good. Everything is fine.

#### Now, this is where it gets weird
The `hidden_field_tag` encodes the `ingredient_ids` array as a space-separated string (`"1 2 3"`), not an array of stringfied ids (`["1", "2", "3"]`) like the button link was doing. This means my controller was cranky. The `permitted_params` was expecting an **array** of ids, so it could generate `shopping_list_item`s based on them:

```ruby
def permitted_params
  # see this pretty little default array?
  params.permit(:shopping_list_id, ingredient_ids: [])
end
```

Well a `String` type is not the same as an `Array` type so my controller kept telling me that the naughty `ingredient_ids` param key that was harboring an illegal string of data was not a permitted param. So after reading the entire internet on the topic of passing arrays into `hidden_field_tag`s, I discovered that no one had a good solution. Everything is not as fine as it was an hour ago. Sigh. It was time to take this feature implementation down to Jankytown.

#### And this is where it gets janky<sup>TM</sup>
Well fine. Have it your way `hidden_field_tag`. Like any good rubiest who has logged her hours doing [CodeQuizzes](https://www.codequizzes.com/ruby), I converted that string of `id`s into the array I needed right there in the controller. :grimace:

```ruby
# hello janky string-to-array conversion
actual_array_of_ids = permitted_params[:ingredient_ids].split(' ').map(&:to_i)
```

And then passed that into the method where I needed it:
```ruby
method_that_wanted_those_ids(actual_array_of_ids)
```
Huzzah! And now I can add all ingredients from a recipe to any shopping list I choose. Did I get to write the beautiful code I wanted to for this feature? Nope. Do I have the feature I want? Youbetcha. Next time I need to populate another shopping list, it will be easy peasy and that feels pretty good.

Here's the [GitHub pull request with my code](https://github.com/lortza/food_planner/pull/211).
