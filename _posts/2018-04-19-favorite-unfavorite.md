---
layout: post
title:  Favorite/Unfavorite Toggle on Single Rails Model
date:   2018-04-19
---

If you're looking to add a system of favoriting / unfavoriting to a single Rails 5 model, you're in the right place.

This post uses the example of a single-user task list app that allows you to click a ☆ next to the task name to toggle that task's "favorite" setting. The task is updated with javascript, so you stay right there on the tasks index page and there is no reloading of the page.

```
ex:
★ Wrestle with kittens  <== favorite & best ever!!
☆ Take out the trash    <== meh, not my favorite
```

These are the steps to accomplish the favoriting:

  - Add the "favorite" boolean field to the tasks table
  - Add favoriting methods to the task model
  - Set up the routes and controller actions
  - Add a view helper toggle ★\|☆ and link destinations
  - Wire up the javascript for updating without refreshing


## Add the Favorite Boolean to the Tasks Table

Generate a new migration to add the new boolean column to the existing `tasks` table. On the command line, type:

```bash
rails g migration AddFavoriteToTasks favorite:boolean
```

Open the migration file (the last file in your db/migrate directory) and add `default: false` to the `add_column` method:

```ruby
# db/migrate/20180419165453_add_favorite_to_tasks.rb

class AddFavoriteToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :favorite, :boolean, default: false
  end
end
```

Save the file and run the migration:

```bash
rake db:migrate
```

Take a look at the `schema.rb` file to ensure the new `favorite` column is there.

```ruby
# db/schema.rb

ActiveRecord::Schema.define(version: 20180419165453) do

  create_table "tasks", force: :cascade do |t|
    t.text     "name"
    t.text     "description",   default: ""
    t.boolean  "favorite",      default: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
```

If your Rails server is running, now is a good time to restart it. I have forgotten to do this many times. It usually comes back to bite me when I try to save a value to my new field and it won't save.

Another step that's easy to miss is adding your new field to the params whitelist in the matching controller. Missing this step will also cause your form submissions to skip saving data in that field.

```ruby
# app/controllers/tasks_controller.rb

class TasksController < ApplicationController
  ...
  private

  def task_params
    params.require(:task).permit(:name, :description, :favorite)
  end
 ...
end
```


## Add Favoriting Methods to the Task Model

Open the `task` model and add these public methods.

```ruby
# app/models/task.rb

class Task < ApplicationRecord
  ...
  # Set the task's favorite setting to true and save the task
  def favorite!
    self.favorite = true
    self.save!
  end

  # Set the task's favorite setting to false and save the task
  def unfavorite!
    self.favorite = false
    self.save!
  end
  ...
end
```

At this point, it's a good idea to pop into your rails console to make sure these methods work.
```ruby
# Start rails server
rails console

# Set variable t to the first task
t = Task.first

# Check the value of t's favorite boolean
t.favorite # ==> false

# Call the `favorite!` method
t.favorite!

# Check the value of t's favorite boolean
t.favorite # ==> true. Great! It works.

# Call the `unfavorite!` method
t.unfavorite!

# Check the value of t's favorite boolean
t.favorite # ==> false. Great! It works.
```


## Set up the Routes and Controller Actions
The only actions we'll need to do with our `favorites` are `update` and `destroy`.

```ruby
# config/routes.rb

Rails.application.routes.draw do
  ...
  root 'tasks#index'
  resources :tasks
  resources :favorites, only: [:update, :destroy]

end
```

Create a new controller file for the favorites controller. Just like in the routes file, we only need the `update` and `destroy` actions.

```ruby
# app/controllers/favorites_controller.rb

class FavoritesController < ApplicationController

  before_action :set_task, only: [:update, :destroy]

  # Write the update action that corresponds to the update route
  def update
    # Use the `favorite!` method to set the task's favorite boolean to true
    @task.favorite!
    redirect_to tasks_url
  end

  # Write the update action that corresponds to the destroy route
  def destroy
    # Use the `unfavorite!` method to set the task's favorite boolean to false
    @task.unfavorite!
    redirect_to tasks_url
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

end
```


## Add a View Helper to Toggle ★\|☆ and Link Destination

With the routing and controller actions in place, it's time to write the links in the view. Add a view helper called `favorite_unfavorite` to the task in the view. Pass it the task as an argument.

```erb
# app/tasks/_task.html.erb
...
<h1><%= favorite_unfavorite(task) %> <%= task.name %></h1>
```


 This example uses Font Awesome icons. [Check out their getting started to get a CDN link](https://fontawesome.com/get-started) or...

 ```html
 <!-- app/views/layouts/application.html.erb -->

 <!DOCTYPE html>
  <html>
    <head>
      ...
      <!-- Add CDN as the last line before your `</head>` -->
      <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet">
    </head>
  ...
  </html>
 ```

Define the `favorite_unfavorite` method in the tasks helper using the icon classes and the links to the `favorites_controller`'s `destroy` and `update` methods.

```ruby
# app/helpers/tasks_helper.rb

module TasksHelper

  def favorite_unfavorite(task)
    # If the task has been favorited...
    if task.favorite
      # Show the ★ and link to "unfavorite" it
      link_to raw("<i class='fa fa-star favorite'></i>"), favorite_path(task), method: :delete
    else
      # Show the ☆ and link to "favorite" it
      link_to raw("<i class='far fa-star'></i>"), favorite_path(task), method: :patch
    end
  end
end
```

Lastly, give a little style to the stars.

```css
# app/assets/stylesheets/tasks.scss

.fa-star {
  float: left;
  font-size: 70%;
  margin-top: 5px;
  margin-right: 5px;
}

.favorite { color: yellow; }
```

At this point, you should be able to click on a star by a task name to toggle its favorite state. The index page WILL be reloading at this point. But not for long...

## Wire up the Javascript for Updating Without Refreshing the Index Page

Head back over to the task view and add a unique identifier to the parent object. Here we can take advantage of [Rails' `dom_id` method](https://apidock.com/rails/ActionView/RecordIdentifier/dom_id) which will generate a unique id based on the object's model and its id number in the table.

```erb
# app/tasks/_task.html.erb

<article id="<%= dom_id(task) %>">
  <h1><%= favorite_unfavorite(task) %> <%= task.name %></h1>
  <p><%= task.description %></p>
</article>
```

The `<article id="<%= dom_id(task) %>">` will output something like `<article id="task_25">`, which is perfect for our javascript needs.

In the task helper, update the links in the `favorite_unfavorite` method to include `remote: true`. This will indicate to the controller that we want to use javascript to carry out the response to this request.

```ruby
# app/helpers/tasks_helper.rb

module TasksHelper
...
  def favorite_unfavorite(task)
    if task.favorite
      # Add `remote: true` to the link
      link_to raw("<i class='fa fa-star favorite'></i>"), favorite_path(task), remote: true, method: :delete
    else
      # Add `remote: true` to the link
      link_to raw("<i class='far fa-star'></i>"), favorite_path(task), remote: true, method: :patch
    end
  end

end
```

Go back to the favorites controller and remove the instruction to redirect to the index from both the `update` and the `destroy` methods:

```ruby
# app/controllers/favorites_controller.rb

class FavoritesController < ApplicationController
...
  def update
    @task.favorite!
    # redirect_to tasks_url <== remove this
  end

  def destroy
    @task.unfavorite!
    # redirect_to tasks_url <== remove this
  end
  ...
end
```

Create a new folder called `favorites` in `app/views` and make `js.erb` files for both the `update` and the `destroy` methods inside of it.

```
- app/views/favorites/
  - destroy.js.erb
  - update.js.erb
```

Put this code in both of those files. Yep, it's redundant.

```js
// Use that handy `dom_id` from before to identify the correct
// <article> on the index page and then grab its star <i>
let starIcon = document.querySelector("#task_<%= @task.id %>").querySelector('.fa-star')

// Reuse the logic from the `favorite_unfavorite` method to
// update the star icon styles and the link destination
starIcon.parentElement.outerHTML = "<%= escape_javascript(favorite_unfavorite(@task)) %>"
```

And there you have it! Now you can toggle the stars to your heart's delight without reloading the index page. If you'd like to see a similar example of this feature done with jQuery, check out [this post by Dan Cunning](https://www.topdan.com/ruby-on-rails/ajax-toggle-buttons.html).
