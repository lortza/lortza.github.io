---
layout: post
title:  'Single Page CRUD App in Rails: Part 2 - Deleting Records'
date:   2018-03-16
published: true
---

This is the second post in my Single Page CRUD App in Rails series. In this series, I explain how to make changes to database records directly on the index page without reloading or refreshing the page. If you haven't seen [Part 1: New Records]({% post_url 2018-03-09-single-page-crud-p1 %}), I recommend you check it out first as it sets the stage for the app's codebase. The code in this tutorial is from [an app I built](https://github.com/lortza/single_page_crud) in Rails 5.0.6, Ruby 2.4.2.

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

To delete a record, we first have to find it in the HTML. The easiest way to do this is to assign the record's id number to the `<tr>` like this: `<tr id="critter_3">`. Then we retrieve it later with javascript.

```erb
<!-- views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>"> <!-- Add a unique id to the tr -->
  <td><h4><%= critter.name %></h4></td>
  ...
</tr>
```

### 2. Convert the "Delete" Link to `remote: true`
Inside that `<tr>`, we need to tell the delete link to request javascript instead of following the usual HTTP protocol. Like we did with the "New Critter" button, we'll add `remote: true` to the "Delete" link.

```erb
<!-- views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>">
  ...
  <td><%= link_to 'Delete', critter, method: :delete, data: { confirm: 'Are you sure?' }, remote: true %></td>
</tr>
```

### 3. Set up the Controller `destroy` Method
Next we need to look at the controller's `destroy` method because it handles the HTTP `delete` action. Tell it how to respond to the request for javascript by setting `respond_to` to `js`:

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

The controller is now expecting to find a file called `destroy.js`, so we need to make one. Our  javascript will incorporate a little erb syntax, so create a file called `destroy.js.erb` in the `app/views/critters/` directory and put this in it:

```js
// app/views/critters/destroy.js.erb

alert("Hey! The destroy.js.erb file is responding!")
```

If you refresh your page, then click the delete button, you'll get an alert box that says "Are you sure?". Click "ok", then you'll see a new box pop up that says "Hey! The destroy.js.erb file is reponding!" After you dismiss that box, you'll notice that your content is still on the index page -- even though it's been removed from the database. This is the expected behavior. Now we need to remove it from the index with javascript.

### 4. Remove the Record from the `index` Page
Let's replace that alert in the `destroy.js.erb` file with the line that will actually remove the record from the index page. The `@critter` object was defined in the controller's `destroy` action, so we have access to its `id`. We will use that to find the exact `<tr>` on the table. Then we remove it by calling `.remove()` on it.

```js
// app/views/critters/destroy.js.erb

document.querySelector("#critter_<%= @critter.id %>").remove()
```

Voila! That's it! Refresh your page again, then go through the process of deleting another record. You should see that your record is no longer on the index. Pretty nifty ;)

## Next: Editing Records
Alright! That's it for creating and displaying new records. It's time to move on to [Part 3: Editing Records from the Index Page]({% post_url 2018-03-23-single-page-crud-p3 %}).
