---
layout: post
title:  'Single Page CRUD App in Rails: Part 1 - New Records'
date:   2018-03-09
published: true
---

I've been wanting to make the UX of my Rails apps more streamlined, and in some cases, that means a little AJAX. So I built [a sample app](https://github.com/lortza/single_page_crud) (Rails 5.0.6, Ruby 2.4.2) to interact with my postgres database via AJAX and vanilla javascript. This app has a main table called `critters` where I list a bunch of pets and a helper table called `cities` where I list the cities where they live.

This series of posts walks through the process of building out the CRUD (create, read, update, destroy) actions from the `index` page via AJAX (no reloading/refreshing necessary). Since each of the CRUD actions takes several steps, I've broken this post into a few different posts, each focusing on one of the actions:

- [Part 1: New Records (this post)]({% post_url 2018-03-09-single-page-crud-p1 %})
- [Part 2: Deleting Records]({% post_url 2018-03-16-single-page-crud-p2 %})
- [Part 3: Editing Records]({% post_url 2018-03-23-single-page-crud-p3 %})

## Adding a New Record
Let's add a button that says "New Critter" that will make a form appear on this page above the critters table. The following key things need to happen here to make a new record:

1. Create a placeholder for the `new` form
2. Add a `new` link with `remote: true`
3. Set up the controller `new` action and supporting javascript

### 1. Create a Placeholder for the `new` Form
To do that, we need a placeholder in the HTML so the javscript knows where to render this form.

```erb
<!-- views/critters/index.html.erb -->

<h1>Critters</h1>

<!-- Insert an empty div with an id -->
<div id="new-form-placeholder"></div>

<table class="table">
  <thead>
  ...

```

### 2. Add a `new` Link with `remote: true`
We need to tell the controller we're aiming for javascript and not the usual HTML response format. Add a `link_to` with the `new_critter_path` in the normal way. Then append it with `remote: true`.

```erb
<!-- views/critters/index.html.erb -->

<h1>Critters</h1>

<div><%= link_to '+ New Critter', new_critter_path, remote: true %></div>

...
```

### 3. Set up the Controller `new` Action and Supporting Javascript
The `remote: true` told the controller to deal in javascript, so we need to tell it how to respond with javascript:

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
...

  def new
    @critter = Critter.new
    respond_to :js         #<-- here
  end
```

This also means that the controller is expecting to find a file called `new.js`. Since we're going to render a little erb in our file, we'll call ours `new.js.erb`. This will meet the needs of our syntax and the controller.

In this file, we want to tell the javascript to render the `new` form partial on the index page. Our javascript grabs the placeholder div by its id, uses the Rails helper `escape_javascript` to execute javascript's `preventDefault()` function, and then renders the partial.

```js
// app/views/critters/new.js.erb

// Locate the placeholder in the DOM
let placeholder = document.getElementById("new-form-placeholder")

// Insert the partial as the content of the placeholder div
placeholder.innerHTML = "<%= escape_javascript(render partial: 'new' ) %>"


// Another Option:
// Condensed both of those lines above to 1 line.
// It's your call on what you feel is more readable.
document.getElementById("new-form-placeholder").innerHTML = "<%= escape_javascript(render partial: 'new' ) %>"
```

In Rails, when rendering a partial, we call it `'new'` but Rails will be looking for a file called `_new`. Create a file called (or rename your existing file to) `_new.html.erb` to stand in as your "new" view, and give it this content:

```erb
<!-- app/views/critters/_new.html.erb -->

<h3>New Critter</h3>
<!-- Render the form partial, passing it @critter, which was
     set in the controller's `new` action -->
<%= render 'form', critter: @critter %>
```

*To be clear* you need both `new.js.erb` and `_new.html.erb` files.

The `_new.html.erb` file is rendering _another_ partial, `_form.html.erb`, that actually houses the form. This is Rails convention and it will come in handy later when we go to edit a record. The `_form.html.erb` behaves as it usually does, with one exception: it needs to be set to `remote: true`. When I was working through this step, I first set the `submit` button link to `remote: true` and _that does not work_. Instead, you need to set the form action to `remote: true`.

```erb
<!-- app/views/critters/_form.html.erb -->

<!-- Set the form action to remote: true like this: -->
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
    <!-- Don't try to add `remote: true` to
         this button. It won't work. -->
    <%= f.submit %>
  </div>
<% end %>
```

At this point, you should be able to go to your index page, click the "New Critter" button, and see your form appear on the page. Hooray!

If you have the default Rails `create` action set up in your controller, you can test creating a new record now. Your critter record will save, but your view will not change. This is the expected behavior. You can refresh the page and the new critter record will appear in the table.

But we want MORE, right? We still want to see the new critter record show up on the index page without needing to refresh the page.


## Displaying the New Record on the Index Page
Now that we've created the new record, we want to display it on the index page. These key things need to happen here to display the record via AJAX:

1. Convert the HTML in the table record to a partial
2. Set an `id` on the `<tbody>` element
3. Set up the controller `create` action and supporting javascript

### 1. Convert the HTML in the Table Record to a Partial
To make a new record appear in the table via javascript, we'll need a partial to house the data from that record. Each "record" is a row in the table, so extract the whole table row (`<tr>`) out into a partial called `_critter.html.erb`.

```erb
<!-- views/critters/_critter.html.erb -->

<tr>
  <td><h4><%= critter.name %></h4></td>
  <td>is a <%= critter.color %> critter who lives in <%= critter.city.name %>"</td>
  <td><%= link_to 'Edit', edit_critter_path(critter) %></td>
  <td><%= link_to 'Destroy', critter, method: :delete, data: { confirm: 'Are you sure?' } %></td>
</tr>

```


```erb
<!-- views/critters/index.html.erb -->
...
<table>
  ...
  <tbody>
    <% @critters.each do |critter| %>

      <!-- Replace the table row with a partial,
           passing it the local critter object -->
      <%= render 'critter', critter: critter %>

    <% end %>
  </tbody>
</table>

```


### 2. Set an `id` on the `<tbody>` Element
Go back to your `index.html.erb`. We need to choose a specific place to add the new critter record via javascript. I'm choosing the `<tbody>` as a parent. This way, when we insert each new record partial, it will be added as a child `<tr>` to that `<tbody>` parent element.

```erb
<!-- views/critters/index.html.erb -->
...
<table>
  ...
  <tbody id="critters"> <!-- Add an id here so we can find it with javascript -->
    <% @critters.each do |critter| %>
      <%= render 'critter', critter: critter %>
    <% end %>
  </tbody>
</table>
```


### 3. Set up the Controller `create` Action and Supporting Javascript
Do you remember how we set up the `new` action? We'll use this method to set the `create` action to respond to javascript:

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
  ...
  def create
    @critter = Critter.new(critter_params)
    @critter.save
    respond_to :js         #<-- here
  end

  ...
  private
  def set_critter
    @critter = Critter.find(params[:id])
  end

  def critter_params
    params.require(:critter).permit(:name, :city_id, :color)
  end
  ...
```

Now that the controller is looking for a `create.js` file, we need to supply it with one. Following the pattern of how we set up the `new` action, we'll create a `create.js.erb` to render the javascript. We don't need to make the `_create.html.erb` file, because we don't need to render a "create" partial. Instead, we'll be rendering our `_critter.html.erb` partial.

```javascript
// app/views/critters/create.js.erb

// Locate the <tbody> in the HTML
let tableBody = document.querySelector('tbody#critters')

// Insert the newly-populated `_critter` partial as the first row in the
// table, passing it the @critter value as defined in the controller's
// `create` action
tableBody.insertAdjacentHTML('afterbegin', "<%= escape_javascript(render partial: 'critter', locals: {critter: @critter} ) %>")

// Make the form disappear by setting the placeholder div's content
// to an empty string
document.getElementById("new-form-placeholder").innerHTML = ""
```

Give it a whirl! Refresh your index page, then add a new critter. You'll see your new record appear as the last record in the table.

## Next: Deleting Records
Alright! That's it for creating and displaying new records. It's time to move on to [Part 2: Deleting Records from the Index Page]({% post_url 2018-03-16-single-page-crud-p2 %}).
