---
layout: post
title:  "TIL CSS's only-child pseudo class can easily show/hide content without additional conditional logic"
date:   2022-10-20
published: true
---

I’ve been messing around in Rails 7's Hotwire features with [this tutorial](https://www.hotrails.dev/turbo-rails/empty-states) and today I learned something pretty neato about CSS. Instead of building out a bunch of conditional show/hide logic in both ruby and javascript, you can use CSS to do that show/hide for you using the only-child pseudo class. :mindblown: :heart_eyes: That’s heckin neat.

Here’s a scenario, let’s say we have an index page where we list all of the cats :meow:, but presently there are no cats :scream_cat:. On the index page, we'd like to see a prompt to add some cats.

```html
<!-- app/views/cats/index.html.erb -->

<ul class="cats">
  <%= render "cats/add_cats_prompt" %>
  <% @cats.each do |cat| %>
    <li><%= cat.name %></li>
  <% end %>
</ul>
```

Here's the move: we place the render statement for the `add_cats_prompt` partial _inside_ a parent object (the `<ul>`) that will contain _only_ this prompt and the cat records. In this case, we’ve got a list that will be full of cats, but now there are no cats. We expect to see the content from the prompt partial because the prompt partial is the _only child_ of this parent DOM element.

This is what the partial looks like:
```html
<!-- app/views/cats/_add_cats_prompt.html.erb -->

<li class="empty-state empty-state--only-child">
  Hey you don't have any cats! <%= link_to 'Make one right meow!', new_cat_path %>
</li>
```

The css for the `empty-state--only-child` class says to hide this DOM element (aka the partial) if it is not the only child and to display it if it is the only child.
```css
/* app/assets/stylesheets/components/_empty_state.scss */

.empty-state {
  padding: var(--space-m);
  text-align: center;

  /* using this --only-child to help show/hide the "hey make a cat"
  prompt content on the cats#index page */
  &--only-child {
    display: none;

    &:only-child {
      display: revert;
    }
  }
}
```

Wow that’s so much lighter than a bunch of ruby & javascript show/hide logic everywhere! Imagine the alternative. We're talking about some ruby stuff that would look like this on the index page:
```html
<!-- app/views/cats/index.html.erb -->

<ul class="cats">
  <% if @cats.empty? %>
    <%= render "cats/add_cats_prompt" %>
  <% end %>
  <% @cats.each do |cat| %>
    <li><%= cat.name %></li>
  <% end %>
</ul>
```

But then what if we expect [SPA](https://developer.mozilla.org/en-US/docs/Glossary/SPA)-like behavior on this page where new cats are added by other users and our browser updates automatically? Now we need to add in javascript or Rails Action Cable logic after `create`, after `destroy`, and probably some other scenarios that start to get complicated. No thanks. This lightweight approach has really made my day. :grinning:
