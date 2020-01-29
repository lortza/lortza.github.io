---
layout: post
title:  "How to make a list of links in a Rails view"
date:   2020-01-23
published: false
---
### The Problem
I have a food planning app where I make a list of recipes that I will prepare for the week. Each week has its own list of recipes. This is really handy, but sometimes I'd like to be able to click on the recipe name to go to that recipe's page instead of searching for the recipe first. This is easy if we wanted to output a list on a view page like this:
```erb
<!-- app/views/food_plans/index.html.erb -->

<% food_plan.recipes.each do |recipe| %>
  <li><%= link_to recipe.title, recipe_path(recipe) %></li>
<% end %>
```
We'd then have something that looked like:
<hr/>
#### Plan for 12/31/2019
* <a href="https://minimalistbaker.com/spicy-jackfruit-tacos-1-pot-meal/" target="_blank">Awesome Tacos</a>
* <a href="https://tasty.co/recipe/pizza-dough" target="_blank">Amazing Pizza</a>
* <a href="https://cafedelites.com/best-fluffy-pancakes/" target="_blank">Delicious Pancakes</a>
<hr/>

But I didn't want a vertical bulleted list with a bunch of `<li>` tags. I wanted a single `<p>` that had linked recipe titles separated by a comma, like this:
<hr/>
#### Plan for 12/31/2019
<p>
  <a href="https://minimalistbaker.com/spicy-jackfruit-tacos-1-pot-meal/" target="_blank">Awesome Tacos</a>,
  <a href="https://tasty.co/recipe/pizza-dough" target="_blank">Amazing Pizza</a>,
  <a href="https://cafedelites.com/best-fluffy-pancakes/" target="_blank">Delicious Pancakes</a>
</p>
<hr/>


### A Solution
As it turns out, this is not nearly as simple as iterating over a list. Who knew? But here's how I made that single list of comma-separated recipe titles displayed in a single `<p>` tag:

First, I did the wishful-thinking part where I wrote a helper method that would do all of the _magic_ for me.

```erb
<!-- app/views/food_plans/index.html.erb -->

<h2><%= food_plan.start_date %></h2>
<p><%= display_recipes(food_plan) %></p>
```

Then, I filled out the helper method. Mapping over the list of links got us pretty far. But, it was returning a string of HTML and not actually rendering the HTML. The secret sauce is wrapping it in `raw()`.
```ruby
# app/helpers/food_plans_helper.rb

def display_recipes(food_plan)
  raw(food_plan.recipes.map do |recipe|
    link_to recipe.title, recipe
  end.join(', '))
end
```
And now I have what I want, HTML output that looks like this:
```html
<h2>Plan for 12/31/2019</h2>
<p>
  <a href="https://minimalistbaker.com/spicy-jackfruit-tacos-1-pot-meal/" target="_blank">Awesome Tacos</a>,
  <a href="https://tasty.co/recipe/pizza-dough" target="_blank">Amazing Pizza</a>,
  <a href="https://cafedelites.com/best-fluffy-pancakes/" target="_blank">Delicious Pancakes</a>
</p>
```

Word of caution. Don't do using `raw()` willy-nilly. Any time you're rendering user-entered data raw, you're making yourself vulnerable to hackers.

Here's the [GitHub pull request with my code](https://github.com/lortza/food_planner/pull/182).
