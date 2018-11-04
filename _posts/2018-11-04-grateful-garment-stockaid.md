---
layout: post
title:  "Grateful Garment StockAid Project Setup"
date:   2018-11-04
---

## What is StockAid?
[StockAid](https://github.com/GratefulGarmentProject/StockAid/) is an inventory management system built in Ruby on Rails for [The Grateful Garment Project](https://gratefulgarment.org/) which provides clothing and toiletries for victims of sexual assault. The StockAid software was created by a couple of people in California and is maintained by volunteers. The purpose of the software is to help the small staff at Grateful Garment Project organize inventory and fulfill orders placed by the many hospitals and clinics in LA area who need these supplies for their patients.

## Women Who Code
I am excited to see the [Women Who Code](https://www.womenwhocode.com/) [Austin chapter](https://www.meetup.com/Women-Who-Code-Austin/) jump into working on the [StockAid](https://github.com/GratefulGarmentProject/StockAid/) project! I met the creators of StockAid at RailsConf 2017 and have been contributing code to this project when I am able to. The setup instructions in the repo are in flux, so I wanted to outline the steps I took to get it up and running on my machine as to make it easier for you Women Who Code contributors to get started at our [upcoming meetups](https://www.meetup.com/Women-Who-Code-Austin/events/). Be sure to check out the [Contributor Code of Conduct](https://github.com/GratefulGarmentProject/StockAid/blob/master/CODE_OF_CONDUCT.md) before getting started.

## Set Up Your Local Environment

### Install Ruby
Go to the [Gemfile](https://github.com/GratefulGarmentProject/StockAid/blob/master/Gemfile) to find out which version of Ruby it requires. As of November 4, 2018, it is ruby 2.4.4, so that is the example I will use in this post. It is subject to change, so please check the [Gemfile](https://github.com/GratefulGarmentProject/StockAid/blob/master/Gemfile).

Using [RVM](https://rvm.io/), check which ruby versions you have installed. ([Installing RVM](https://rvm.io/rvm/install))
```
rvm list
```
If you don't see `ruby-2.4.4` in your list, run:
```
rvm install "ruby-2.4.4"
```
Tell RVM to use Ruby 2.4.4
```
rvm use ruby-2.4.4
```

### Postgres Setup
Check to see if you have PostgreSQL installed:
```
postgres -V
```
You should see something like: `postgres (PostgreSQL) 10.5`. If you don't, [here's how to install it on mac](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb)

## Set up the Project

1) Go to the project's GitHub repo: [https://github.com/GratefulGarmentProject/StockAid/](https://github.com/GratefulGarmentProject/StockAid/)

2) On the top right of the screen, click "Fork".

3) Once forked into your own GitHub account, click the "Clone or Download" button.

4) Copy that url and then on your command line, `git clone` it to you local machine:
```
git clone git@github.com:your-github-username/StockAid.git
```
5) Set up a remote called `upstream` so you'll be able to easily keep your `master` branch up to date with theirs
```
git remote add upstream https://github.com/GratefulGarmentProject/StockAid
```
6) `cd` into the project directory and bundle all of the gems:
```
cd StockAid
bundle-install
```
7) The project has a CLI tool to help you set up your environmental variables. Run it with:
```
rake setup
```
You will be asked a number of questions in the command line. Here is how you can answer them:

- **What is your site's name?**: `stockaid`

- **What is your postgres username?**
You will need to enter your postgres username here. If you don't know it, it is most likely the same as your main computer username. You can check it in a separate terminal tab by running `psql`. This will get you into your postgres database interface. The database that you are currently connected to will appear as the prompt and it is usually also reflective of your postgres username. Make note of that as your username and then quit postgres with `\q`.

- **What is your postgres password?**
I seem to get away with just entering my postgres username in here again
- **What is your Google API key?**: `12345`

8) Run `rvm .`
9) Set up your database:
  ```
  rake db:create
  rake db:migrate
  rake db:seed
  ```
10) Start the rails server
  ```
  rails s
  ```
11) Browse to `http://localhost:3000/`

12) Check the [seeds file](https://github.com/GratefulGarmentProject/StockAid/blob/master/db/seeds.rb#L32) to find a sample user profile that you'd like to use to sign in. I often use:
```
email: "site_admin@fake.com"
password: "Password1"
```

## WIP Selecting an Issue to Work On
The project's features and bugs are being managed with a Waffle Board: [https://waffle.io/GratefulGarmentProject/StockAid](https://waffle.io/GratefulGarmentProject/StockAid)

1) Look in the `Backlog` column to find an issue you'd like to work on.

2) Assign yourself to that ticket and move it from `Backlog` to `In Progress`.

3) Pull the latest version of the `master` branch to your machine.

```bash
# get access to the branches from the upstream remote
git fetch upstream

# check out your local master branch
git checkout master

# on your master branch, merge the contents of their master into your master
git merge upstream/master
```

4)  From your `master` branch, create a new feature branch for the ticket you want to work on. Name it with the issue number followed by description. Ex:
```
git checkout -b 612-reports-downloaded-into-csv
```
5) Be sure to write tests for any work you contribute. The project uses [rspec](http://rspec.info/).

## WIP: Communicating Status
Since this is a volunteer-run project, people are often popping in to work on tickets in their spare time. It is important for all of us to communicate clearly, so anyone can understand what is going on with any feature or bug at any given time.

If you have blocker questions, ask them in the github issue?


## Submitting Your Contribution
Once you've completed your work on your local machine, run the test suite (`rspec`) and RuboCop (`rubocop`) to make sure all of the test are passing and your code matches their style guide.

Push your feature branch to GitHub and click "Submit a pull request". Set up a request from your repo's feature branch to the main repo's master branch. In the body of your pull request, be sure to include details about what the problem was and how you solved it. Screenshots are very helpful.

Move the ticket in Waffle to the `Review` column. From here, the project owners will either approve the work or come back to you with requests for change.  

## Celebrate!
You just contributed to an open source project that helps other women! This is what it means to use your powers for good. High five, sister!
