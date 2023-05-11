---
layout: post
title:  "Autopopulating Rails Form Data with Vanilla Javascript"
date:   2019-04-07
published: true
---
The context for this work is an exercise tracking app. There is an `Exercise` model that has information about an exercise (ex: push-ups), including default `set` and `rep` values:

```ruby
# db/schema.rb

create_table "exercises", force: :cascade do |t|
  t.string "name"
  t.text "description"
  t.integer "default_reps"
  t.integer "default_sets"
end
```

Every time we track having done an exercise, that is captured as an `ExerciseLog` object. An `ExerciseLog` belongs to an `Exercise` and has values for the actual `set`s and `rep`s performed.

```ruby
# db/schema.rb

create_table "exercise_logs", force: :cascade do |t|
  t.bigint "exercise_id"
  t.datetime "datetime_occurred"
  t.integer "sets"
  t.integer "reps"
end
```

As a user, I found it tedious to enter in basically the same `set` and `rep` information each time I logged an exercise. It was especially tedious because I was doing this data entry on my phone during workouts.

### The Solution
I went with vanilla Javascript making an AJAX call to the selected exercise and updating the DOM elements with the response. This is not the only solution available, but it is the solution I chose, and it's working well for me.

#### Step 1: Return JSON from the exercises controller
In order to have access to the `exercises` data, we needed to tell the controller to respond with JSON when requested. Exercises controller before:
```ruby
# controllers/exercise_controller.rb

class ExercisesController < ApplicationController
  # ...
  def show
    @exercise = Exercise.find(params[:id])
  end
  # ...
end
```

Exercises controller after:
```ruby
# controllers/exercise_controller.rb

class ExercisesController < ApplicationController
  # ...
  def show
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @exercise, status: :ok }
    end
  end
  # ...
end
```

*Side note:* _if you want to modify the shape of the JSON data_ before serving it, you can remove the `@exercise` object from the controller response and instead render a `jbuilder` template.
```ruby
# controllers/exercise_controller.rb

class ExercisesController < ApplicationController
  # ...
  def show
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render :show } # <-- remove exercise object and render partial
    end
  end
  # ...
end
```

Set up the `jbuilder` template:
```ruby
# views/exercises/show.json.jbuilder
json.partial! "exercises/exercise", exercise: @exercise



# views/exercises/_exercise.json.jbuilder
# return only those 2 fields... or whatever you want to return
json.extract! exercise, :default_reps, :default_sets
json.url exercise_url(exercise, format: :json)
```

#### Step 2: Build the AJAX call
Now that we have data available to us, we need to be able to fetch it. This is done with a javascript `fetch` call like this where the `url` is the api endpoint we just created:

```javascript
function getExercise(url) {
  // pass in the api endpoint as the url
  fetch(url)
    .then(response => response.json())
    // use the response to populate the DOM
    .then(populateDOM)
    // make sure to resolve the fetch promise with an error message
    .catch(err => console.log(err));
}
```

#### Step 3: Extract the exercise id from the DOM

The fetching method is just _a part_ of the javascript adventure. We can't really call that api endpoint without knowing the object's id number. A standard rails `show` endpoint looks like `http://yourdomain/controller/object-id.json`, or:

```bash
http://yourdomain/exercises/1.json
```

In order to complete that call, we need to grab the selected value from the dropdown. We'll get that using the standard, Rails-issued form id:

```javascript
// Find the dropdown menu
const exerciseDropdown = document.getElementById('exercise_log_exercise_id');
```

We can then use that to build that API endpoint:
```javascript
// Automagically get your domain
const baseUrl = window.location.origin
// Build the API url with these components.
// BE SURE TO INCLUDE the .json extension or you're gonna have a bad time.
const apiUrl = `${baseUrl}/exercises/${initialExerciseId}.json`
```


#### Step 4: Configure the on-change event listener
Create an on-change event listener on the dropdown menu. This will trigger any of your subsequent javascript any time the dropdown menu selected value has changed.

```javascript
exerciseDropdown.addEventListener('change', function (event) {
  event.preventDefault();
  // Grab the id from the selected dropdown item
  const selectedExerciseId = event.target.value;
})
```

#### Step 5: Putting it all together

Now that we have the basic components, we need to put this all together.

```javascript
// assets/javascripts/exercise.js

// First, wrap everything in a DOMContentLoaded event listener.
document.addEventListener('DOMContentLoaded', function () {
  // Set up JS variable for your dropdown
  const exerciseDropdown = document.getElementById('exercise_log_exercise_id');

  // Create JS variables for the fields in the form where you want your new
  // JSON data to populate. You can use the default Rails ids here.
  const sets = document.getElementById('exercise_log_sets');
  const reps = document.getElementById('exercise_log_reps');
  const repLength = document.getElementById('exercise_log_rep_length');


  // Make a function to populate those form fields
  function populateDOM(data) {
    sets.value = data.default_sets;
    reps.value = data.default_reps;
    repLength.value = data.default_rep_length;
  }

  // Make a function to hit that API endpoint
  function getExercise(url) {
    fetch(url)
      .then(response => response.json())
      .then(populateDOM)
      .catch(err => console.log(err));
  }

  // Listen for the user to change the dropdown menu. This will trigger all of our JS to happen.
  exerciseDropdown.addEventListener('change', function (event) {
    event.preventDefault();
    // Grab the id from the selected dropdown item
    const selectedExerciseId = event.target.value;
    // Build the API endpoint
    const baseUrl = window.location.origin
    const apiUrl = `${baseUrl}/exercises/${selectedExerciseId}.json`

    // make the AJAX call
    getExercise(apiUrl);
  })
});
```
