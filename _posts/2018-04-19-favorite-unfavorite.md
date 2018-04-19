---
layout: post
title:  Quick & Dirty Favorite/Unfavorite Toggle on Single Rails Model
date:   2018-04-19
---

If you're looking to add a quick & dirty system of favoriting / unfavoriting to a single Rails 5 model, you're in the right place.

This post uses the example of a task list app that allows you to click a ☆ next to the task name to toggle that task's "favorite" setting. The task itself updates with HTTP and will refresh the index page upon click of the star. In a subsequent post, I'll get into updating the favorite status via javascript so no page reload is needed.

```
ex:
★ Wrestle with kittens  <== favorite & best ever!!
☆ Take out the trash    <== meh, not my favorite
```

These are the steps to accomplish the favoriting:

  - Add the Favorite Boolean to the Tasks Table
  - Add Favoriting Methods to the Task Model
  - Set up the Routes and Controller Actions
  - Add a View Helper to Display the Star Toggle ★ / ☆


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


## Add a View Helper to Display the Star Toggle ★ / ☆

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

And that's it. Now you should be able to click on a star by a task name to toggle its favorite state.

