---
layout: post
title:  How to Build a Sinatra App - Part 3 Deploying to Heroku
date:   2024-12-10
published: true
---

See How to Build a Sinatra App [Part 1]({% post_url 2024-10-27-sinatra-from-scratch-pt1 %}) and [Part 2]({% post_url 2024-10-27-sinatra-from-scratch-pt2 %}) if you need help building a Sinatra App from scratch.

I already have an account at [Heroku](https://www.heroku.com/ruby) where I pay for the [shared Eco dyno pool](https://www.heroku.com/pricing). This means I can quickly and easily spin up any app on Heroku and it is included in my $5/mo fee. You'll need to be willing to pay some amount in order to deploy to Heroku. If you're not, look into [Fly.io](https://fly.io/). They have some free options. 

## Preparing Our App for Heroku
Now that our app is working locally, we'd like to deploy it to the interwebs to we can use it. First, ensure you have a `Procfile` and `config.ru` and file:
```bash
# Procfile

web: bundle exec ruby application.rb -p $PORT
```


```ruby
# config.ru

require './application'
run Sinatra::Application
```

If you don't already have them, add them and commit them with git. 


## Creating Our App on Heroku via the Heroku CLI
[This handy post by Heroku](https://blog.heroku.com/32_deploy_merb_sinatra_or_any_rack_app_to_heroku) outlines most of the steps on the Heroku side for you. First, install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) with Homebrew if you don't already have it:
```
brew tap heroku/brew && brew install heroku
```

The Heroku CLI commands start with `heroku`, so we'll log in with:
```
heroku login
```

From inside our project root directory, we'll need to create an app on Heroku. You can pass it a custom name, but it will have to be unique.
```bash
heroku create your_app_name

# If you want Heroku to generate a random name for you:
heroku create

# For my project I'll run:
heroku create yogaposeplaylist
```
This will create the application for you on Heroku and output the url and the remote address, like:
```
https://yogaposeplaylist-12345.herokuapp.com/ | https://git.heroku.com/yogaposeplaylist.git
```

In a  browser, go to your application url (our example is https://yogaposeplaylist-12345.herokuapp.com/) and you'll see placeholder content from Heroku.

To ensure your git remotes are in place, type `git remote -v`. You'll see output like:
```
heroku	https://git.heroku.com/yogaposeplaylist.git (fetch)
heroku	https://git.heroku.com/yogaposeplaylist.git (push)
origin	git@github.com:user-name/yogaposeplaylist.git (fetch)
origin	git@github.com:user-name/yogaposeplaylist.git (push)
```

We'll want to ensure our app will know it is in the production environment when it is on Heroku, so we'll set the environment variable in Heroku:
```bash
heroku config:set RACK_ENV=production
```

## Deploying
Now all you have to do to deploy is push it to the Heroku remote with:
```bash
git push heroku main
```
You'll see a bunch of output in your console and when it is done, go back to that url in the browser and you'll see your app. 

If anything goes wrong, sign in to [https://dashboard.heroku.com/apps](https://dashboard.heroku.com/apps) and click on your app name. You'll see an option to look at logs. Use those to pinpoint what may have gone wrong. 


