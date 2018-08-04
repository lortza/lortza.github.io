---
layout: post
title:  How to Get Ruby Data into a Javascript File in Rails
date:   2018-08-04
---
The key here is to figure out where and when the Javascript is being called and then pass the Ruby data to it as an argument. In my case, I have a form field that displays a remaining character count. The count is updated on every `keyup` by javascript. I wanted to use the number value stored in my model's `CHARACTER_MAX` constant instead of manually entering it in both the model validations and the javascript.

## Problem

I want to get this value of 170 from here...

```ruby
# app/models/apology.rb

class Apology < ActiveRecord::Base
  # 1) I want to get this value of 170...
  CHARACTER_MAX = 170

  def character_max
    CHARACTER_MAX
  end
  ...
end
```

to here...

```javascript
// app/assets/javascripts/apologies.js

// 2) into this js variable
let characterMax = 170

let displayRemainingCharacters = function(){
  let currentCount = textBox.value.length
  let remainingCharacters = characterMax - currentCount
  //...
}
document.addEventListener('keyup', displayRemainingCharacters)
```
...so the javascript can give accurate form feedback and I don't have to keep track of multiple places in my codebase where that number appears.

## Solution

Wrap the javascript in a function that takes an argument and pass the model data to it as the argument.

```javascript
// app/assets/javascripts/apologies.js

// 1) Wrap the JS in a function that takes a characterMax argument
let remainingCharacters = function(characterMax){
  // (side note: in Rails you'll want to account for turbolinks load
  // time with an event listener as well)
  document.addEventListener('turbolinks:load', function () {
    ...
    let displayRemainingCharacters = function(){
      let currentCount = textBox.value.length
      // 2) Use that characterMax argument in the logic
      let remainingCharacters = characterMax - currentCount
      document.querySelector('#character-count').textContent = remainingCharacters
      ...
    }
    document.addEventListener('keyup', displayRemainingCharacters)
  });
}
```

Call that `remainingCharacters` function in the Rails form view where the javascript is needed:

```erb
<!-- app/views/apologies/_form.html.erb -->

<%= form_for(@apology) do |f| %>
  <div class="character-count-container">
    <!-- This '.character-count' span is changed by the javascript -->
    <span id="character-count"><%= @apology.character_max %></span> characters remaining
  </div>
  <%= f.text_area :body, required: true %>

  <%= f.submit %>
<% end %>

<script>
  // 1) Pass the model data as an argument to
  // the 'remainingCharacters' function
  remainingCharacters(<%= @apology.character_max %>)
</script>

```
