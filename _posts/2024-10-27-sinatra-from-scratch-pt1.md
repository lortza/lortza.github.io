---
layout: post
title: How to Build a Basic Sinatra App - Part 1 Basic Setup
date: 2024-10-27
published: true
---

I've been a Rails developer for a while now so I recently built an app in Sinatra for fun. To help me with this project, I read [the Sinatra docs](https://sinatrarb.com/intro.html) and a lot of blog posts, but nothing really outlined what a basic app needed for setup. Now I'm building my second Sinatra app and I decided to capture my steps so it is easier for you (and tbh, FutureMe) to get started with a basic Sinatra app.

This post assumes a working knowledge of Ruby apps and some Rails background. Also this app does not include a database. The app I'm building is going to use Ruby hashes (all fancied up as [ActiveHash](https://github.com/active-hash/active_hash)) instead of database tables, so if you need a database in your Sinatra app, you'll need to do some googling to wire up your db.

I once had a full Rails app for yoga playlists. I learned a bunch of yoga a decade ago and naturally, I built an app for it.😂 ¯\\_(ツ)_/¯ It was database-backed and had all of the bells and whistles. When Heroku discontinued its free tier, I chose to kill that app. Now, several years later, I am resurrecting it as a Sinatra app, foregoing a database because Heroku charges extra for databases.💸 Now you know the impetus. Let's get started!

## Getting Started

Let's get started by creating the main folder for the application via the command line and `cd`ing into it:

```
mkdir yogaposeplaylist && cd "$_"
```

We'll need these files for basic app setup. Create them via the command line:

```
touch application.rb
touch config.ru
touch Gemfile
touch Procfile
touch .ruby-version
touch README.md
```

Then I like to open the whole project folder in VS Code with:

```
code .
```

But you can do whatever you want.

Now let's add some gems to the `Gemfile`. At the time of this post, I'm using Ruby 3.2.2, but you should use the latest version of any of Ruby and any of the gems I mention in this post:

```ruby
# Gemfile

source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'sinatra'
gem 'puma'
gem 'rake'
gem 'rackup'
```

Put the Ruby version number in the `.ruby-version` file:

```
'3.2.2'
```

Then bundle the gems by running `bundle` on the command line:

```
bundle
```

You should now see a `Gemfile.lock` file in your project directory.

We'll set up our `rack` configuration here in the `config.ru` file:

```ruby
# config.ru

require './application' # <- this is pointing to our application.rb file
run Sinatra::Application
```

In the `Procfile`, we'll need to tell Heroku how we like to run our application. If you're not planning to deploy your app, you can skip this step.

```bash
# Procfile

web: bundle exec ruby application.rb -p $PORT
```

The next file is the `application.rb` file, which is the centerpiece of our app. This is where we load all of our necessary dependencies as well as declare our routes. Since I am personally used to the way Rails splits out config from routes and other concerns, so I find this file to be kind of messy. Alas, we're here in Sinatra to see what it's like outside of the magic kingdom 🪄 of Rails, right? 😂

We'll be requiring all of the basic gems we need for the app to run. At this point, we don't have a lot to add. Paste this code into the `application.rb` file:

```ruby
# application.rb

require 'sinatra'
```

Also keep in mind: **Any time you make changes to your `application.rb` file, you need to restart the server** -- which I'll tell you how to do in a bit.

## Rendering Content

For now, let's put a basic "hello world" message on the home page. To do so, add this route with content to the `application.rb` file:

```ruby
get '/' do
  'Hello World!'
end
```

Our `application.rb` file now looks like this:

```ruby
# application.rb

# Gems
require 'sinatra'

# Routes
get '/' do
  'Hello World!'
end
```

In the `README.md` file, I like to put basic instructions that will help FutureMe remember how to do basic things:

```
# README
This application uses Sinatra to render yoga poses in playlists.

Run server locally with:
ruby application.rb

In the browser:
http://localhost:4567


## Resources
* Docs: https://sinatrarb.com/intro.html
* Helpers: https://www.sitepoint.com/sinatras-little-helpers/
* Extensions: https://sinatrarb.com/extensions.html
```

And now it is time to run the app! Just like the README says, on the command line, run just like you would any Ruby file:

```bash
ruby application.rb

# You can kill the server with `cmd c`.
```

Then in the browser go to: [http://localhost:4567/](http://localhost:4567/)

You should see "Hello World!" on the screen. 🎉

And that's it! That's a basic Sinatra app. Anne out. 🎤💥

<hr>

If you'd like to keep going, in [this next post]({% post_url 2024-10-27-sinatra-from-scratch-pt2 %}), I will be rendering some `index` and `show` pages as well as using `ActiveHash` to organize data without a database.
