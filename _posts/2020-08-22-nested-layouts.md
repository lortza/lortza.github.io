---
layout: post
title:  "Nested Layouts in Rails"
date:   2020-08-22
published: true
---

Nested layouts in rails are pretty neato. You can get a lot of styles and consistency across your site without writing a whole lot of code. I wanted to take advantage of all of the styles I have in place in my `app/views/layouts/application.html.erb` file, but also wanted to render another custom layout with a sidebar and content area _inside_ the application layout for the static pages on my site.
![nested layouts](/img/posts/2020_08_22_arrow_illustration.png)

My static pages are all rendered by the `PagesController`, so I created a file called `app/views/layouts/pages.html.erb` to hold the HTML for the sidebar and main content of those pages.

To nest the pages layout HTML inside the application layout HTML, I used a `content_for` tag. In the `app/views/layouts/application.html.erb` I accounted for yielding a block named `:pages_layout`. Now, when rendering a page, if a block called `content_for :pages_layout` appears in the HTML, we'll use the special `pages` layout.

```html
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>...</head>
  <body>
    <%= render 'shared/navbar' %>

    <%= content_for?(:pages_layout) ? yield(:pages_layout) : yield %>

    <%= render 'shared/footer' %>
  </body>
</html>
```

Then in `app/views/layouts/pages.html.erb`, I wrapped the HTML in a `content_for?` block _and_ provided a `yield` for the HTML that comes from the static pages themselves (ex: `app/views/pages/about.html.erb`). By the way, there is no Rails Magic<sup>TM</sup> in the naming of `:pages_layout`. You can call it whatever you want as long as you call it the same thing in both places.

```html
<!-- app/views/layouts/pages.html.erb -->

<% content_for :pages_layout do %>
  <div class="sidebar">
    <h3>This is my sidebar</h3>
    <p>Yay sidebar stuff.</p>
  </div>

  <div class="main-content">
    <!-- Content from the static pages, ex: app/views/pages/about.html.erb
         will be rendered by this yield. -->
    <%= yield %>
  </div>
<% end %>

<!-- be sure to include this render tag for the application layout -->
<%= render template: 'layouts/application' %>
```

So the app knows to use this `pages` layout for all of the static pages, I set the default layout in the `PagesController`:
```ruby
# app/controllers/pages_controller.rb

class PagesController < ApplicationController
  layout 'pages'

  def about; end
  def contact; end
  def store; end
end
```

Now whatever I put in the `app/views/pages/about.html.erb` (as well as Contact and Store pages) will appear with a navbar, background image, sidebar, main content, and footer. And all I have to include in that file is the HTML for the main content area:

```html
</h1>About</h1>
<p>Hello, my name is Anne. Sometimes I write code.</p>
```

This is _so much less code_ and much easier to maintain than building out a sidebar and main content area for each of these static pages. #winning

If you want to, you can nest _endlessly_ by following that same pattern. See the [Rails Docs](https://guides.rubyonrails.org/layouts_and_rendering.html#using-nested-layouts) for more help.
