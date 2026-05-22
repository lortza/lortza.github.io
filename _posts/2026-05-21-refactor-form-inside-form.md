---
layout: post
title:  A form inside a form? Say it ain't so! How to submit a form from inside a different form
date:   2026-05-21
published: true
---

## TL;DR: It Ain't so.
But it is _almost_ so. You still can't put a `<form>` tag inside another `<form>` tag and have valid HTML, but you _can_ put input fields and submit them from inside another form. And it's pretty neat.

## The Context for This Post
I recently wrote about this in my post [Adding tags dynamically from a parent form using Stimulus, requestjs, and Turbo Streams]({% post_url 2026-04-14-add-tags-from-parent-form %}) where I explain a Stimulus solution for being able to add new tags to the user account from inside a recipe's form. The crux of the situation is that you can't have a `<form>` tag nested inside another `<form>` tag. In the previous post, I side-stepped the double form scenario by implementing a Stimulus solution. I have seen this Stimulus approach before and implementing it let me play with all kinds of fun bells and whistles. That original implementation is in [this PR](https://github.com/lortza/food_planner/pull/1275).

Recently, a friend reminded me of a second implementation option that is so sleek and elegant, I couldn't help but gather all of those bells and whistles that I built and toss them out the window (_bye!_). In general, I try to use as few tools as possible when implementing a feature. This refactor let me remove a gem and a Stimulus controller, and lean on default Rails form behavior, so I was bubbling over with gleeful joy as I implemented it.

## The Refactor
The work for this refactor is in [this PR](https://github.com/lortza/food_planner/pull/1300).

### Step 1. Swap the Stimulus Controllers to Rails Forms
The recipe form partial gets a shiny new tags form at the top, just outside of the recipe form itself. Yep, it's empty. And it stays empty.

```html
<!-- app/views/recipes/_form.html.erb -->

<!-- The new empty tags form -->
<%= form_with(model: current_user.tags.new, url: tags_path, html: { id: "tag-creation" }) do %>
<% end %>

<!-- the existing recipe form -->
<%= form_with(model: recipe) do |form| %>
  <!-- Not empty! The recipe form fields go here, but are not shown for simplicity. -->
<% end %>
```

Then the Tags section _inside_ of the recipes form sheds its connection to the `inline_tag_creator_controller.js` and converts the button to a regular form submit button by targeting that new empty form with the `form` attribute set to the empty form's `id` value of `"tag-creation"`. This is that "almost so" thing I mentioned above. While were not putting a tags `<form>` tag _inside_ of the recipes `<form>` tag, we are putting an input and submit button for the tags form inside of the recipes form. 

It changes from this:

```html
<!-- app/views/recipes/_form.html.erb -->

<%= form_with(model: recipe) do |form| %>
  <!-- Other recipe form fields here -->

  <!-- This div has the stimulus controller and related value assigned -->
  <%= tag.div(data: {controller: "inline-tag-creator", inline_tag_creator_url_value: tags_path}) do %>
    <%= render partial: 'form_new_tag_field' %>
    <%= tag.button(type: "button", data: { action: "click->inline-tag-creator#createTag" }) do %>
      Add Tag
    <% end %> 
  <% end %> 
<% end %> 
```

To this:
```html
<!-- app/views/recipes/_form.html.erb -->

<!-- Notice the html id attribute of "tag-creation" to identify this empty form -->
<%= form_with(model: current_user.tags.new, url: tags_path, html: { id: "tag-creation" }) do %>
<% end %>

<%= form_with(model: recipe) do |form| %>
  <!-- Other recipe form fields here -->

  <!-- All stimulus artifacts have been removed from this wrapping div -->
  <%= tag.div do %>
    <!-- The input field partial will have changes too. See below. -->
    <%= render partial: 'form_new_tag_field' %>
    <!-- The button tag drops `data`, changes `type`, and adds a `form` id -->
    <%= tag.button(type: "submit", form: "tag-creation") do %>
      Add Tag
    <% end %> 
  <% end %> 
<% end %> 
```

### Step 2. Update the tags input field partial to connect to its new tags form

The tags input field gains `form` and  `name` attributes to tie it to the `Tag` and model and then loses the `data` attribute that drove the Stimulus controller behavior.

It changes from this:
```html
<!-- app/views/recipes/_form_new_tag_field.erb -->

<%= tag.input(
  data: {
    inline_tag_creator_target: "input",
    action: "keydown.enter->inline-tag-creator#createTag"
  },
  <!-- ...and other attributes -->
) %>
```

To this:
```html
<!-- app/views/recipes/_form_new_tag_field.erb -->

<%= tag.input(
  form: "tag-creation", <!-- Connect the input to the tags form -->  
  name: "tag[name]", <!-- Create the paramaterized data the rails controller needs -->  
  <!-- ... and other unchanged attributes -->  
) %>
```

### Step 3. Remove the gem and the Stimulus controller
* Delete file `app/javascript/controllers/inline_tag_creator_controller.js`
* Remove `gem "requestjs-rails"` from `Gemfile` (and run `bundle install` to update the  `Gemfile.lock`)
* Remove `import "@rails/request.js"` from `app/javascript/application.js`



## What This Refactor Does for Us

### Pros
* Uses default Rails form submission behavior -- it's always preferable to have code that does the expected thing
* Removes a gem dependency -- one fewer gem to keep updated
* Removes a Stimulus controller -- once more layer of technology to interact with when developing
* Streamlines the form HTML -- no more Stimulus artifacts scattered around several lines

### Cons
* It is a little jarring to see an empty form on the top of the page
* It requires a little more attention to notice that the `<input>` field inside the recipes form is not part of the recipes form

Doing a refactor like this is satisfying. While I did enjoy having an example of the other approach in my codebase to reference, my desire for simplicity almost always outweighs opportunities for bells and whistles and this was no exception.