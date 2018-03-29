---
layout: post
title:  Single Page CRUD App in Rails - Part 3 - Editing Records
date:   2018-03-23
---

Well here we are in the final stretch of making our Rails app AJAX CRUDdy! In this series, I explain how to interact with database records on the index page without reloading or refreshing the page.

I saved this section for last because it builds on patterns we used in both the [creating (Part 1)]({% post_url 2018-03-09-single-page-crud-p1 %}) and the [destroying (Part 2)]({% post_url 2018-03-16-single-page-crud-p2 %}) processes. If you haven't seen the previous parts, I recommend you start with [Part 1: New Records]({% post_url 2018-03-09-single-page-crud-p1 %}) as it sets the stage for the app's codebase. The code in this tutorial is from [an app I built](https://github.com/lortza/single_page_crud) in Rails 5.0.6, Ruby 2.4.2.

## Editing a Record

These are the key things we'll need to do to edit a record from the index page via AJAX:

1. Set the record partial's "Edit" link to `remote: true`
2. Set up the controller `edit` method
3. Render an `edit` partial
4. Set the `edit` form to `remote: true`


### 1. Set the Record Partial's "Edit" Link to `remote: true`
When we click the "Edit" link on a record, we want to have the edit form appear in the table directly below that record. Rendering the form requires AJAX and we invoke it by using the Rails helper `remote: true`.

Each record in our critters table is rendered using a partial called `_critter.html.erb`. In the partial, add `remote: true` to the end of the "Edit" `link_to` helper like this:

```erb
<!-- app/views/critters/_critter.html.erb -->
...
<td><%= link_to 'Edit', edit_critter_path(critter), remote: true %></td>
...
```

This will tell the controller that we want to use an AJAX response, not the default HTTP response.

### 2. Set up the Controller `edit` Method
Using `remote: true` told the controller to speak in AJAX terms. We need to provide the `edit` method with a way to respond to this request. We do that by telling it to `respond_to :js`:

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
  ...
  def edit
    respond_to :js     #<- here
  end
...
```

### 3. Render an `edit` Partial
By default in Rails, controller methods render a view file as their last action. Unless you specify a different view, the view it renders will be the one named the same as the controller method. After the `edit` controller method runs, Rails looks in the `app/views/critters` directory for a file named `edit.[some extension]`. Since we told it to respond to javascript (with `:js`), it's looking for a file called `edit.js`.

Let's name our file `edit.js.erb` so it can handle the erb syntax we'll be using inside it. We want the javascript in this file to find the form placeholder div, then render the form partial in it.

Create that file and put this content in it:

```js
// app/views/critters/edit.js.erb

// Locate the record being edited by its id, then render
// the `edit` partial as the sibling immediately after it
document.querySelector("#critter_<%= @critter.id %>").insertAdjacentHTML('afterend', "<%= escape_javascript(render partial: 'edit') %>")
```

This javascript file is pointing to an "edit" partial that we haven't made yet. So let's make it. In Rails, when rendering a partial, we call it with `'edit'`, but Rails will be looking for a file named `_edit`. Create a file called (or rename your existing file to) `_edit.html.erb`, and give it this content:

```erb
<!-- app/views/critters/_edit.html.erb -->

<!-- Give the form <tr> a unique id -->
<tr id="edit-form-<%= @critter.id %>">
  <td colspan='4'>
    <!-- Render the form partial INSIDE A <tr>, passing it @critter,
         which was set in the controller's `edit` action -->
    <%= render 'form', critter: @critter %>
  </td>
</tr>
```

The form is being rendered in a `<tr>`, which makes it fit nicely in the table. The key here is that the form is also within the `<tr>`'s `<td>`. A form can either completely wrap a table, or be inside of a single `<td>`, but it can't wrap a `<tr>`. This tripped me up, so I'm passing that learned-it-the-hard-way knowledge on to you.

You'll see above that the new `<tr>` has its own id. We'll need this later to make the form disappear after the form submits.

### 4. Set the `edit` Form to `remote: true`
Did rendering the `_form.html.erb` partial in the last step look familiar? This is where we get to reap the benefits of using a partial in a previous step by reusing it for our `edit` action. We already set this form's action to `remote: true`. So we're already done with this step. BOOM! High five to our past selves for being so thoughtful.

```erb
<!-- app/views/critters/_form.html.erb -->

<!-- It's already set to remote: true FTW! -->
<%= form_for(critter, remote: true) do |f| %>
  <div class="field">
    <%= f.label :name %>
    <%= f.text_field :name, class: 'form-control' %>
  </div>
  ...
```

At this point, you can refresh your browser and click the "Edit" link. Your edit form should pop up. Submitting it won't do what you want it to do yet.

## Updating a Record
When editing a record, step #1 is changing the data in the form (`edit`), and step #2 is saving (`update`) that change to the database. We've enabled the editing, now we need to enable the saving. These are the key things we'll need to do to update a record from the index page via AJAX:

1. Set up the controller `update` method and supporting partials
2. Identify each record `<tr>` by id
3. Render the updated record on the index page

### 1. Set up the Controller `update` Method
Our form action is already communicating via `remote: true` that it wants to be processed with AJAX. Now we need to tell the controller's `update` method how to handle that request. We do that, once again, with `respond_to :js`.

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
  ...
  def update
    @critter.update(critter_params)
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

The controller wants to render an `update.js` file, so let's give it one. Create a file called `update.js.erb` in the `app/views/critters/` directory and give it this content as a sanity check:

```js
// app/views/critters/update.js.erb

alert("Update.js.erb reporting for duty");
```

Now when you refresh, click edit, then click update on the form, you should see that message pop up in your browser. If you dismiss the box and refresh the page, you'll see that your record has been updated. YAY! Our data is flowing correctly. Now we need to make the index page reflect that change via AJAX.

### 2. Identify Each Record `<tr>` by Id
To update a specific HTML element with new data, we first need to be able to identify it. Again, we can thank ourselves for the work we've already done. The `<tr>`s in the `_critter.html.erb` partial already have unique ids:

```erb
<!-- views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>"> <!-- A unique id is already here -->
  <td><h4><%= critter.name %></h4></td>
  ...
</tr>
```


### 3. Render the Updated Record on the Index Page
Now that we can identify the correct `<tr>`, we can replace it with a partial that's been freshly-populated with your new data. We don't need to see the edit form any more, so we'll remove it from the table. Jump back to the `update.js.erb` file and replace all of the contents with this:

```js
// app/views/critters/update.js.erb

// Find the existing critter <tr> by id, then replace it
// with the newly-populated partial (which is also a <tr>).
document.querySelector("#critter_<%= @critter.id %>").outerHTML = "<%= escape_javascript(render partial: 'critter', locals: {critter: @critter} ) %>"

// Remove the "edit" form from the table
document.querySelector("#edit-form-<%= @critter.id %>").remove()

```

Huzzah! That's it! Give it a try from start to finish by adding a new critter, editing it, then deleting it. You now have a fully-functional AJAX CRUD index page in Rails 5. As this app is currently set up, it's not handling validations or form failures. That will be a topic for another post.

I hope this series has been useful to you as it has been for me. It's nice to finally have this AJAX CRUD app under my belt.
