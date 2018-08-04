---
layout: post
title:  Filtering Rails Table Records with Javascript
date:   2018-04-02
---

I like Rails. I've felt pretty darned comfortable in the Rails ecosystem for a couple of years now. Branching out into javascript features, however, has been out of my comfort zone. It makes the learning hard, but so satisfying when I figure out something new!

Today I decided to implement a filter on a table to practice DOM manipulation. The context for this post's code is [a sample app](https://github.com/lortza/single_page_crud) (Rails 5.0.6, Ruby 2.4.2, postgres) with a main table called `critters`. The `critters` table lists a bunch of pets with some details about them.

As I learn my way out of my belief that "front end JS just does magic and those who wield it are magicians," I'm finding that most of the solutions are not terribly complex. Phew!

Here's how I implemented filtering by critter name via vanilla javascript.

## Add a Filter Input Field to the View

On the index page, I added an input field above the table so a user can type the name of the critter they're looking for. The input field lives within the `filter` class.

```erb
<!-- app/views/critters/index.html -->
...
<div class="filter">
  <label>On-Page Javascript Filtering:</label>
  <input type="text" name="filter" id="filter" placeholder="Filter by Critter Name" class="form-control">
</div> <!-- filter -->

<table>
...
```

```scss
/* assets/stylesheets/shared.scss */

.filter {
  text-align: center;
  margin: 20px auto;
  width: 50%;
  min-width: 300px;
}
```

## Set Up the Javascript File

If you use [Rails generators](http://guides.rubyonrails.org/command_line.html#rails-generate) like `rails g controller Critter`, you'll get some nice freebies like stylesheets and CoffeeScript files named after your asset. This is handy for keeping code organized. In this case, I took advantage of my freebie and renamed my `critters.coffee` to `critters.js` to house my javascript.

If I weren't working in Rails, I would have put this javascript in a `<script>` tag at the bottom of the `index.html.erb` file. But _I am_ in Rails, so I put it in its Railsy place. The down side is, the file will run whenever it wants -- unless I tell it otherwise. I wrapped my code in a `DOMContentLoaded` listener, so it will run when the DOM is ready.


```js
// app/assets/javascripts/critters.js

// Listen for the DOM to be loaded before running any of the
// javascript inside this function
document.addEventListener('DOMContentLoaded', function(){

  // CODE GOES HERE

})
```


## Locate the Filter Field with Javascript and Add an Event Listener

Inside the `critters.js` file, I located the input field from the `index` page and added an event listener to it. The listener responds every time a user lifts their finger off of a key while in this field. When that happens, it fires off a callback function called `filterCritters`.

```js
// app/assets/javascripts/critters.js

// Locate the filter input field in the HTML
const filter = document.querySelector('.filter > input');

// Listen for each keystroke release happening in this field
filter.addEventListener('keyup', filterCritters)
```

## Write the Filtering Function

Now for the fun part. The `filterCritters` function is a callback function, so it automatically has an argument for the "event" that was listened for. Here, I'm refering to it as `e`. I grab the input text from the input field via the event's `target` function.

```js
// app/assets/javascripts/critters.js
...
function filterCritters(e){
  // Capture the text from the filter input field
  const inputText = e.target.value.toLowerCase()

  // Grab all `tr`s, then loop through them to get the critter name.
  document.querySelectorAll('tbody > tr').forEach(function(tr){
    // Extract the critter name text out of the tr by finding it
    // inside the element with the `name` class
    const critterName = tr.querySelector('.name').textContent.toLowerCase()
    ...
  })
}
```

```erb
<!-- app/views/critters/_critter.html.erb -->

<tr id="critter_<%= critter.id %>">
  <!-- Add the class `name` to the h4 housing the name data -->
  <td><h4 class="name"><%= critter.name %></h4></td>
  ...
```

Back inside the `<tr>` loop, it's time to hide/show the `<tr>`s based on whether the critter name matches the input data.

```js
// app/assets/javascripts/critters.js
...
document.querySelectorAll('tbody > tr').forEach(function(tr){
  const critterName = tr.querySelector('.name').textContent.toLowerCase()

  // If the input text appears anywhere in the critter's name, use default
  // display settings. Otherwise, hide the `<tr>`
  if(critterName.includes(inputText)){
    tr.style.display = ''
  } else {
    tr.style.display = 'none'
  }
})
```

Tip: if you try to use `tr.style.display = 'block'` to counteract the `display = 'none'`, you're going to get some funky formatting. Use `display = ''` to allow the browser to render its default display settings for a `<tr>`.

## Add a Reset Button to the HTML

Though you can see all of the critters again by deleting the text from the input field, a "Reset" button is a nice feature. Add a `link_to` to the view up inside the `div class="filter">`:

```erb
<!-- app/views/critters/index.html.erb -->
...
<div class="filter">
  <label>On-Page Javascript Filtering:</label>
  <input type="text" name="filter" id="filter" placeholder="Filter by Critter Name" class="form-control"><br>

  <!-- Add a link to "reset" the view using Bootstrap button classes.
       Give the link an id of 'reset-button'. -->
  <%= link_to 'Reset', '', class: 'btn btn-sm btn-secondary', id: 'reset-button' %>
</div> <!-- filter -->
...
```

## Locate the Reset Button with Javascript

Now that there's a button, find it with javascript and set an event listener on it with a callback function of `resetResults`.

```js
// app/assets/javascripts/critters.js
...
// Locate the reset button via its id
const reset = document.querySelector('#reset-button');

// Add an event listener to run a callback after a click
reset.addEventListener('click', resetResults)
```

## Write the `resetResults` Callback

The callback function is ready to fire. To reset the table back to its original state, clear the input field and set `<tr>` display back to default.

```js
function resetResults(e){
  // Clear the filter text out of the input field.
  document.querySelector('.filter > input').value = ''

  // Loop through all of the `tr`s and reset their display to the default.
  document.querySelectorAll('tbody > tr').forEach(function(tr){
    tr.style.display = ''
  })

  // Prevent the link from reloading the page
  e.preventDefault()
}
```

### Recap: All of the Javascript

Just to recap, this is what all of the Javascript looks like together:

```js
// app/assets/javascripts/critters.js

// Listen for the DOM to finish loading
document.addEventListener('DOMContentLoaded', function(){

  // Locate the filter field in the HTML
  const filter = document.querySelector('.filter > input');
  filter.addEventListener('keyup', filterCritters)

  // Locate the reset button in the HTML
  const reset = document.querySelector('#reset-button');
  reset.addEventListener('click', resetResults)

  function filterCritters(e){
    // Capture the text from the filter input field
    let inputText = e.target.value.toLowerCase()

    // Grab all <tr>s that can be filtered and loop through them
    document.querySelectorAll('tbody > tr').forEach(function(tr){

      // Extract the text out of the tr
      const critterName = tr.querySelector('.name').textContent.toLowerCase()

      if(critterName.includes(inputText)){
        tr.style.display = ''
      } else {
        tr.style.display = 'none'
      }
    })
  }

  function resetResults(e){
    // Clear the filter text out of the input field.
    document.querySelector('.filter > input').value = ''

    // Loop through all of the `tr`s and reset their display to the default.
    document.querySelectorAll('tbody > tr').forEach(function(tr){
      tr.style.display = ''
    })

    // Prevent the link from reloading the page.
    e.preventDefault()
  }
})
```


So that's it! Since this approach does not hit the database, it is a nice solution for fast filtering of data on a single page. If you're using pagination, you won't be filtering anything beyond what you see on the current page and will need to implement a different solution.
