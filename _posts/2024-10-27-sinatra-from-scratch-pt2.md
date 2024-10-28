---
layout: post
title:  How to Build a Sinatra App - Part 2 Rendering Views
date:   2024-10-27
published: true
---

If you don't have your basic Sinatra app set up yet, see [my previous post]({% post_url 2024-10-27-sinatra-from-scratch-pt1 %}). Otherwise, let's get ready to dig in and build this app!

Now let's add some project folders and files to our app via the command line:
```
mkdir models && touch models/playlist.rb && touch models/pose.rb
mkdir views && mkdir views/playlists && mkdir views/poses
mkdir public && touch public/application.css
```

## Getting into ActiveHash
The data I am using in this application is static, so I'm not going to use a database. Instead, I'm going to store my data in hashes. I could use plain old regular hashes, but I am going to pull in a gem that is also available to Rails. I am doing this so I can get dot notation on my data-storing classes along with some other bells and whistles.

In the Gemfile, add this gem (check [the gem on github](https://github.com/active-hash/active_hash) for the laterst version):
```ruby
gem 'active_hash', '~> 2.3.0'
```

Also (spoiler alert, I want to be able to use `titleize`, so I'm pulling in another Rails gem). Add this gem to the `Gemfile`:
```ruby
gem 'activesupport-inflector', '~> 0.1.0'
```

If you're feeling a little miffed that I'm pulling in select Rails gems, feel free to write your own functionality. Part of this Sinatra side-project journey for me is cherry picking the smallest slices of assistance vs rolling my own during small moments of free time. I've chosen gems in these last two cases, but do what makes you happy!

Okay while we're here in the `Gemfile`, we're also going to need a couple of Sinatra gems to help with routes. Add these to the `Gemfile`:
```ruby
gem 'sinatra-contrib' # https://sinatrarb.com/contrib/multi_route.html
gem 'emk-sinatra-url-for' # path helpers https://github.com/emk/sinatra-url-for/
```

We're also going to want `gem 'pry'` so we can easily look at our data and do debugging, so let's get that in there. Our `Gemfile` now looks like:
```ruby
source 'https://rubygems.org'

ruby '3.2.2'

gem 'sinatra'
gem 'active_hash', '~> 2.3.0'
gem 'activesupport-inflector', '~> 0.1.0'
gem 'puma'
gem 'rake'
gem 'rackup'
gem 'sinatra-contrib' # https://sinatrarb.com/contrib/multi_route.html
gem 'emk-sinatra-url-for' # path helpers https://github.com/emk/sinatra-url-for/

group :development do
  gem 'pry'
end
```

Save and then `bundle`.

And then require these gems in the app by adding them to the `application.rb` file. Our file now looks like:
```ruby
# Gems
require 'sinatra'
require 'sinatra/multi_route' # from sinatra-contrib gem
require 'sinatra/url_for'
if settings.environment == :development
  require 'pry'
end

# Routes
get '/' do
  "Hello World!"
end
```


Okey doke, now let's build out our models. Let's pretend that there are 5 yoga poses, each named with a number. I'm planning to use real images and real yoga pose names in this project, but for the sake of this blog post, I'm just going to use these numbers and placeholder images. So in the `models/pose.rb` file, add:
```ruby
# In Sinatra, we have to require any gem we're using in a file:
require 'active_hash'
require 'active_support/inflector' # for the 'titleize' behavior

class Pose < ActiveHash::Base
  fields :name, :image_file

  # This method allows me to name a pose `:standing_forward_bend` for
  # programming convenience while displaying it as "Standing Forward
  # Bend" in the views:
  def display_name
    name.to_s.titleize
  end

  self.data = [
    { id: 1, name: :one, image_file: 'https://placehold.co/100?text=One'},
    { id: 2, name: :two, image_file: 'https://placehold.co/100?text=Two'},
    { id: 3, name: :three, image_file: 'https://placehold.co/100?text=Three'},
    { id: 4, name: :four, image_file: 'https://placehold.co/100?text=Four'},
    { id: 5, name: :five, image_file: 'https://placehold.co/100?text=Five'}
  ]
end
```
What's going on in that class up there? We now have pose data stored in a hash that we can access with that easy breezy dot notation just like we would a regular Ruby object. We can do:
```ruby
Pose.all # => array with all the hashes
Pose.first.name # => :one
Pose.find(4).display_name # => 'Four'
Pose.find_by(name: :three) # => { id: 3, name: :three, image_file: 'https://placehold.co/100?text=Three'}
Pose.where(id: 3..) # => array with poses 3, 4, and 5
```

I chose to symbolize these names because I am going to be building out data in my `Playlist` class that references instance of this `Pose` class by `name`. I could absolutely reference them by `id` like a database would, but as a human, I prefer the readablity of names. In reality, yoga pose names can be long -- like "standing forward bend", so using a symbol like `:standing_forward_bend` feels more concrete to me and less prone to error (like rogue caps or spaces if I were to `find_by(name: "standing forward bend")`).

Now let's get to that `Playlist` class in the `models/playlist.rb` file. Let's pretend we have 2 playlists that we've built from those 5 poses we built above:
```ruby
require 'active_hash'

class Playlist < ActiveHash::Base
  fields :display_name, :poses

  self.data = [
    { id: 1, display_name: 'One Two One', poses: [
      Pose.find_by(name: :one),
      Pose.find_by(name: :two),
      Pose.find_by(name: :one)
    ]},
    { id: 2, display_name: 'One to Five', poses: [
      Pose.find_by(name: :one),
      Pose.find_by(name: :two),
      Pose.find_by(name: :three),
      Pose.find_by(name: :four),
      Pose.find_by(name: :five)
    ]},
  ]
end
```

In that class, I've built 2 playlists that are consuming the `Pose` objects. As I said, I'm referencing them by symbolized `name`. Now in our app we can do things like...

```ruby
@playlists = Playlist.all

@playlists.each do |playlist|
  playlist.display_name
end
```
...which looks eerily like what we'd do on a playlists `index` page, so let's render this content on an index page!

Now, if we want to have access to this model on our `index` page (and we do), we're going to need to add the models to our `application.rb` file. I add them after the gems and before the routes:
```ruby
# Gems
require 'sinatra'
require 'sinatra/multi_route' # from sinatra-contrib gem
require 'sinatra/url_for'
if settings.environment == :development
  require 'pry'
end

# Models
require_relative 'models/pose'
require_relative 'models/playlist'

# Routes
get '/' do
  "Hello World!"
end
```


## Routes that render a view file
In addition to adding the models, we're going to need to add a new route to the `application.rb`:
```ruby
get '/playlists' do
  @playlists = Playlist.all
  # yep, you need this weird symbolized string syntax:
  erb :'playlists/index'
end
```

Let's take a look at that data before we render it in the view so we know what we have to work with. Put a `binding.pry` in there like this:
```ruby
get '/playlists' do
  @playlists = Playlist.all
  binding.pry  # <-- stick it right here
  erb :'playlists/index'
end
```
Now save the file, start (or restart) your server, and go to [http://localhost:4567/playlists](http://localhost:4567/playlists).

In the server output, you can see the `binding.pry` breakpoint. Let's play around with that `@playlists` object to see what `ActiveHash` is giving us:
```ruby
@playlists.all
@playlists.first
@playlists.first.id
@playlists.first.display_name
@playlists.first.poses
@playlists.first.poses.first
@playlists.first.poses.first.id
@playlists.first.poses.first.display_name
```
Our hashes are acting just like Ruby objects! Pretty neat.

Okay, get out of `pry` with `exit`, then stop the server (`cmd` + `c`). Remove the `binding.pry` from your route. We won't need this breakpoint anymore.

We do need a view file though, so make an `index.erb` (not `index.html.erb`) for your playlists:

```html
<!-- views/playlists/index.erb -->
<h1>Playlists Index</h1>

<ul>
  <% @playlists.each do |playlist| %>
    <li><%= playlist.display_name %></li>
  <% end %>
</ul>
```

Restart your server and go back to [http://localhost:4567/playlists](http://localhost:4567/playlists). You should see a bulleted list of playlists. Hooray! (Take note that `/playlists` is not the same as `/playlists/`. So if you're having troble rendering this in the browser, this maybe why. 🤦‍♀️ Check out [the Sinatra docs for routes](https://sinatrarb.com/intro.html) to see how to handle that.)

Well it's nice that we can see the list of playlists, but it's kind of boring if we can't click on each name. So how do we get to a show page for a playlist?

## Routing to a show page with an id
As you may guess, back in the `application.rb`, we need a new route:
```ruby
# this route takes an :id param, like /playlists/42
get '/playlists/:id' do
  # and we use that param to find our specific playlist
  @playlist = Playlist.find(params[:id])
  erb :'playlists/show'
end
```

And a new view for the `show` page:
```html
<!-- views/playlists/show.erb -->
<h1><%= @playlist.display_name %></h1>

<ul>
  <% @playlist.poses.each do |pose| %>
    <li><%= pose.display_name %></li>
  <% end %>
</ul>
```

Restart your server and go to [http://localhost:4567/playlists/2](http://localhost:4567/playlists/2) and you'll see our glorious show page for playlist "One to Five". And since none of us cares to memorize `id` numbers for random internet pages, next, we'll link to this show page from the playlists index page.

## Linking from the index to the show page
In the `views/playlists/index.erb` file, replace this:
```html
<li><%= playlist.display_name %></li>
```
with this:
```html
<li><a href='<%= url_for "/playlists/#{playlist.id}" %>'><%= playlist.display_name %></a></li>
```
Is that link syntax ugly? Ohhhhh yeah it is. I haven't looked into how to make links much prettier in Sinatra, so for now, this gets the job done.


## Add a layout for consistent page design
And lastly, now that we have a few pages in our application, we're probably going to want a nav bar and we're probably going to want that on more than one page. We can accomplish this with an HTML layout.

Create a file called `layout.erb` and save it in your `views` folder. Fill it with basic HTML boilerplate and place a `<%= yield %>` where you want your page content to go.

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="robots" content="noindex">
    <link href="<%= url('/application.css') %>" rel="stylesheet" type="text/css" />
    <title>Yoga Pose Playlist</title>
  </head>
  <body>
    <nav>
      <a href="<%= url_for '/' %>">Yoga Pose Playlist</a>
    </nav>

    <!-- Your page content will render here: -->
    <%= yield %>

  </body>
</html>
```

When you refresh your page, you'll see your new content.

Now there is no styling on that nav bar. You have a file called `application.css` where you can put all of the styling you'd like. I'll leave that up to you.

But that's it! You have all of the building blocks of basic app functionality. It's been interesting for me to see how light and simple Sinatra feels compared to Rails -- even though I miss having link helpers and am bothered by the clutter of the `application.rb` file. But these are preferences built from habit and habit is always worth challenging.

I hope you've enjoyed this foray into Sinatra and that whatever project you're working on that lead you here inspires and challenges you in all of the good ways!
