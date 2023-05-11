---
layout: post
title:  "Fetch open source contributor branches easily with this Ruby script"
date:   2019-06-28
published: true
---
I've recently gotten a bunch of pull requests to one of my projects on GitHub. I wanted to review the work and run tests on branches created by these contributors locally on my computer but without actually cloning and setting up push abilities.

## The Manual Way
Thankfully, git has a way to do this for you. It's pretty simple, but it requires a lot of copying and pasting of arguments.

```
git fetch git@github.com:theirusername/reponame.git theirbranch:ournameforbranch
```

After doing this two times, I decided that I wanted to write a script to make it easier. I started writing a script in bash, but then decided that I wanted something a little fancier, so I hopped into Ruby and made it happen.

## The Script Way
I created a file called `fetch_open_source.rb` and stored it in a directory I called `~/ruby_scripts/`. I also make sure to comment in the script so that I remember how to use it and what it outputs.

```ruby
# Runs the command to pull an open source contribution
# git fetch git@github.com:theirusername/reponame.git theirbranch:ournameforbranch

# envoke with: `fetch_open_source` then follow prompts

puts 'Enter their username:branchname'
input = gets.chomp
input = input.split(":")
theirusername = input.first
theirbranch = input.last

puts 'Enter their repo name for this project (skip if same as yours):'
input = gets.chomp
reponame = input == '' ? Dir.pwd.split('/').last : input

puts 'Enter the issue number'
issuenumber = gets.chomp

puts 'Enter that you want to call this branch:'
ournameforbranch = gets.chomp
ournameforbranch = theirbranch if ournameforbranch == ''

output = `git fetch git@github.com:#{theirusername}/#{reponame}.git #{theirbranch}:#{issuenumber}_#{theirusername}_#{ournameforbranch}`

system('echo', output)
```

### Step 2: Make an Alias
I then call this file by running `ruby` and the filename via an alias that I saved in my `.bash_profile`.

``` bash
# ~/.bash_profile

alias fetch_open_source="ruby ~/ruby_scripts/fetch_open_source.rb"
```

### Run it
Now I go to the pull request on github and simply copy their `username:branchname` info and then run the script:

```bash
fetch_open_source
```

I follow the prompts and then I can check out the new local branch:

```bash
git checkout ournameforbranch
```

Tada! Writing this script was a game changer for me in terms of frustration when trying to review others' work. Now I can knock out branches like a champ and get down to the business getting open source work done.
