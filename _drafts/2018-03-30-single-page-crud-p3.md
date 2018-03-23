---
layout: post
title:  Single Page CRUD App in Rails - Part 3 - Editing Records
date:   2018-03-30
---

This is the second post in my Single Page CRUD App in Rails series. If you haven't seen Part 1: New Records, I recommend you check it out first.

Since each of the crud actions takes several steps, I've broken this post into a few different posts, each focusing on one of the actions.

- [Part 1: New Records]({% post_url 2018-03-20-single-page-crud-p1 %})
- [Part 2: Deleting Records]({% post_url 2018-03-23-single-page-crud-p2 %})
- Part 3: Editing Records (WIP)

# Editing a Record

THIS IS ALL COPIED FROM THE PREVIOUS POST... MUST EDIT IT
I want to be able to click a button that says "New Critter" and have a form appear on this same page just above the existing table of critters. These key things need to happen here to make a new record:

1. Create a placeholder for the `new` form
2. Add a `new` link with `remote: true`
3. Set up the controller `new` action and supporting javascript

### 1. Create a placeholder for the `new` form
In order to do that, we need a placeholder in the HTML so the javscript knows where to render this form.

```erb
<!-- views/critters/index.html.erb -->

<h1>Critters</h1>

<!-- Insert an empty div with an id -->
<div id="critter-form-placeholder"></div>

<table class="table">
  <thead>
  ...

```

### 2. Add a `new` link with `remote: true`
Add a `link_to` with the `new_critter_path` in the normal way. Then append it with `remote: true`. This tells the controller the we're aiming for javascript and not the usual html format.

```erb
<!-- views/critters/index.html.erb -->

<h1>Critters</h1>

<div><%= link_to '+ New Critter', new_critter_path, remote: true %></div>

...
```

### 3. Set up the controller `new` action and supporting javascript
Since our link says `remote: true`, we need to provide the controller with the appropriate instructions to handle it. It's expecting to see javascript, so we need to tell it to  respond with javascript:

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
...

  def new
    @critter = Critter.new
    respond_to :js
  end
```

This also means that the controller is expecting to find a file called `new.js`. Since we're going to render a little erb in our file, we'll call ours `new.js.erb` and the controller will still be satisfied.

In this file, we want to tell the javascript to render the `new` form partial on the index page. To do that, grab the placeholder div using the id, then use the rails helper `escape_javascript` to execute javascript's `preventDefault()` function and render the partial.

```js
// app/views/critters/new.js.erb

$('#critter-form-placeholder').html("<%= escape_javascript(render partial: 'new' ) %>");

document.getElementById("critter-form-placeholder").style.display = "block";
```

In rails, when rendering a partial, we call it `'new'` but rails will be looking for a file called `_new`. Create a file called (or rename your existing file) `_new.html.erb` to stand in as your "new" view.

```erb
<!-- app/views/critters/_new.html.erb -->

<h3>New Critter</h3>
<%= render 'form', critter: @critter %>

```

*Just to be clear* you need both `new.js.erb` and `_new.html.erb` files.

The `_new.html.erb` file is rendering _another_ partial, `_form.html.erb`, that actually houses the form. This is rails convention and it will come in handy later when we go to edit a record. The `_form.html.erb` behaves as it usually does, with one exception: it needs to be set to `remote: true`. When I was working through this step, I first set the `submit` button link to `remote: true` and _that does not work_. Instead, you need to set the form action to `remote: true`.

```erb
<!-- app/views/critters/_form.html.erb -->

<!-- Set the form action to remote: true -->
<%= form_for(critter, remote: true) do |f| %>
  <div class="field">
    <%= f.label :name %>
    <%= f.text_field :name, class: 'form-control' %>
  </div>

  <div class="field">
    <%= f.label :color %>
    <%= f.text_field :color, class: 'form-control'  %>
  </div>

  <div class="field col-sm-12">
    <%= f.label :city %>
    <%= f.collection_select :city_id, City.all.order(:name), :id, :name, class: 'form-control'  %>
  </div>

  <div class="actions">
    <%= f.submit %><!-- Don't try to `remote: true` this button. It won't work. -->
  </div>
<% end %>
```

At this point, you should be able to go to your index page, click the "New Critter" button, and see your form appear on the page. Hooray!

If you fill out and submit your form, your critter record will save (assuming you have the default rails `create` action set up in your controller), but your view will not change. This is the expected behavior. You can refresh the page and the new critter record will appear in the table.

But we want MORE, right? We still want to see the new critter record show up on the index page without needing to refresh the page.


# Displaying the New Record on the Index Page
Now that we've created the new record, we want it to display dynamically on the index page. These key things need to happen here to display the record dynamically:

1. Set an `id` on the `tbody` element
2. Convert the HTML in the table record to a partial
3. Set up the controller `create` action and supporting javascript


### 1. Set an `id` on the `tbody` element
Jumping back to the `index` page, we need to choose a specific place for the new critter record to be added via javascript. I'm choosing the `<tbody>` as a parent.

```erb
<!-- views/critters/index.html.erb -->

...
<table>
  ...

  <tbody id="critters"> <!-- Add an id here so we can find it with javascript -->
    <% @critters.each do |critter| %>
    <tr>
      <td><h4><%= critter.name %></h4></td>
      <td>is a <%= critter.color %> critter who lives in <%= critter.city.name %>"</td>
      <td><%= link_to 'Edit', edit_critter_path(critter), remote: true %></td>
      <td><%= link_to 'Destroy', critter, method: :delete, data: { confirm: 'Are you sure?' } %></td>
    </tr>
    <% end %>
  </tbody>
</table>

```


### 2. Convert the HTML in the table record to a partial
In order to make a new record appear in the table via javascript, we'll need a partial to house that record. Each "record" is just a row in the table, so  extract the table row out into a partial.

```erb
<!-- views/critters/_critter.html.erb -->

<tr>
  <td><h4><%= critter.name %></h4></td>
  <td>is a <%= critter.color %> critter who lives in <%= critter.city.name %>"</td>
  <td><%= link_to 'Edit', edit_critter_path(critter), remote: true %></td>
  <td><%= link_to 'Destroy', critter, method: :delete, data: { confirm: 'Are you sure?' } %></td>
</tr>

```


```erb
<!-- views/critters/index.html.erb -->

...
<tbody id="critters">
  <% @critters.each do |critter| %>

    <!-- Replace the table row with a partial, passing it the local critter object -->
    <%= render 'critter', critter: critter %>

  <% end %>
</tbody>
...

```


### 3. Set up the controller `create` action and supporting javascript




# Next Step: Deleting Records
Alright! That's it for editing records. My next post on deleting records is coming soon.

