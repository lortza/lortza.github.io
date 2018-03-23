---
layout: post
title:  Single Page CRUD App in Rails - Part 2 - Deleting Records
date:   2018-03-23
---

This is the second post in my Single Page CRUD App in Rails series. In this series, I explain how to make changes to database records from the index page without reloading or refreshing the page. If you haven't seen [Part 1: New Records]({% post_url 2018-03-20-single-page-crud-p1 %}), I recommend you check it out first as it sets the stage for the app. This code is from my app built in Rails 5.0.6, Ruby 2.4.2.

- [Part 1: New Records]({% post_url 2018-03-20-single-page-crud-p1 %})
- [Part 2: Deleting Records (this post)]({% post_url 2018-03-23-single-page-crud-p2 %})
- Part 3: Editing Records (WIP)

## Deleting a Record

The process for deleting a record is very similar to the process for creating a new record. These key things need to happen in order to delete a record:

1. Identify each record `<tr>` by id
2. Convert the "Delete" link to `remote: true`
3. Set up the controller `destroy` method
4. Remove the record from the `index` page


### 1. Identify Each Record `<tr>` by Id
In the last post, we set up a partial for each record called `_critter.html.erb` and it looked like this:

```erb
<!-- views/critters/_critter.html.erb -->

<tr>
  <td><h4><%= critter.name %></h4></td>
  <td>is a <%= critter.color %> critter who lives in <%= critter.city.name %>"</td>
  <td><%= link_to 'Edit', edit_critter_path(critter) %></td>
  <td><%= link_to 'Destroy', critter, method: :delete, data: { confirm: 'Are you sure?' } %></td>
</tr>
```

In order to delete a record, we first have to be able to identify it. Fortunately for us, we already have an id for each record (courtesy of `critter.id`) and we can just add it to each record's `<tr>` element. Since javascript gets cranky about ids starting with numbers, we'll create our id in this format: `critter_3`

```erb
<!-- views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>"> <!-- Add a unique id to the tr -->
  <td><h4><%= critter.name %></h4></td>
  ...
</tr>
```

### 2. Convert the "Delete" Link to `remote: true`
Still working inside the `_critter.html.erb` partial, we need to tell the existing delete link to request javascript instead of following the usual HTTP protocol. Just like we did with the "New Critter" button, we'll add `remote: true` to the "Delete" link.

```erb
<!-- views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>">
  ...
  <td><%= link_to 'Delete', critter, method: :delete, data: { confirm: 'Are you sure?' }, remote: true %></td>
</tr>
```

### 3. Set up the Controller `destroy` Method
The controller's `destroy` method handles the HTTP `delete` action, so we need to tell it how to respond to this request for javascript. We do that the same way we did in the other controller actions, by setting `respond_to` to `js`:

```ruby
# app/controllers/critters_controller.rb

class CrittersController < ApplicationController
  ...
  def destroy
    @critter.destroy
    respond_to :js  #<-- here
  end
...
```

The controller is now expecting to find a file called `destroy.js`, so we need to make one. We'll be using a little erb syntax in our file, so we'll create a file in the `app/views/critters` directory called `destroy.js.erb` and the controller will still be happy.

```js
// app/views/critters/destroy.js.erb

alert("Hey! The destroy.js.erb file is responding!")
```

If you refresh your page, then click the delete button, you'll get an alert box that says "Are you sure?". Click "ok", then you'll see a new box pop up that says "Hey! The destroy.js.erb file is reponding!" After you dismiss that box, you'll notice that your content is still on the index page. This is the expected behavior. All that's left is to remove it with a little javascript.

### 4. Remove the Record from the `index` Page
Remove that alert line from your `destroy.js.erb` file and replace it with the line that will actually remove the record. Here we're using the `@critter` object that was defined in the controller's `destroy` action to find the exact `<tr>` on the table. Then we remove it by calling `.remove()` on it.

```js
// app/views/critters/destroy.js.erb

$("#critter_<%= @critter.id %>").remove();

```

Voila! That's it! Refresh your page again, then go through the process of deleting another record. You should see your record has been removed from the index and the page was not reloaded via the controller. Pretty nifty ;)

# Next: Editing Records
Alright! That's it for deleting records. My next post on editing records from the index page is coming soon.

