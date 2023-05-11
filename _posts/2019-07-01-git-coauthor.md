---
layout: post
title:  "Easily add co-authors to your git commits with this script"
date:   2019-07-01
published: true
---
I recently learned about git's [`Co-authored-by` feature](https://help.github.com/en/articles/creating-a-commit-with-multiple-authors) which allows you to add collaborators to your commits. I do a lot of pairing at work and I find that using this feature makes it easy to ensure my non-keyboard pairing contributors are getting the credit they deserve. Also, it can be handy to see all authors of a commit to help create context for why code changes happen.

## The Manual Way
Adding a co-author is pretty straightforward. You leave your commit message closing quote open, add 2 hard returns, then add their git credentials like this:

```
$ git commit -m "Refactor usability tests.
>
>
Co-authored-by: Your Coworker <y_coworker@example.com>
Co-authored-by: Your Other Coworker <y_o_coworker@example.com>"
```

Hooray! I really like this feature. Since I am more inspired by writing scripts than I am by memorizing the syntax of every neat feature I find, I wrote a ruby script to do this one for me.

## The Script Way
### Step 1: Write the Script
I created a file called `git_coauthor.rb` and stored it in a directory I called `~/ruby_scripts/`. I also make sure to comment in the script so that I remember how to use it and what it outputs.

```ruby
# ~/ruby_scripts/git_coauthor.rb


# Takes git co-author usernames and a commit message and make them coauthors.
# ex: gca
# outputs to:
# git commit -m 'fix the thing'
#
# Co-authored-by: jsmith <jsmith@yourdomain.com>
# Co-authored-by: jdoe <jdoe@yourdomain.com>

puts "Enter your commit message:"
message = gets.chomp

puts "Enter all co-authors' names separated by a space. ex: jsmith jdoe"
authors = gets.chomp.split(' ')

output = "git commit -m '#{message} \n \n \n"

authors.each do |author|
  output += "Co-authored-by: #{author} <#{author}@yourdomain.com>"
  output += ", \n" unless author == authors.last
end
output += "'"

wrapped_output = `#{output}`
system('echo', wrapped_output)
```
It is janky? yaaaaassss. Does it work beautifully? yaaaaassss.

### Step 2: Make an Alias
I then call this file by running `ruby` and the filename via an alias that I saved in my `.bash_profile`.

``` bash
# ~/.bash_profile

alias gca='ruby ~/ruby_scripts/git_coauthor.rb'
```

### Step 3: Run It
Running the script is simple. After doing a `git add`, I run this instead of a `git commit -m ""`. The prompts walk me through adding a commit message and a list of collaborator names.

The script writes the commit for me and when I push it to GitHub, I get to see this commit with all 3 of our faces next to it. Hooray! Sharing is caring!

Sample output:

```bash
$ git add .
$ gca
Enter your commit message:
Fix the thing

Enter all co-authors names separated by a space. ex: jsmith jdoe
ebennes gconstanza
```
That's it! Now check the log to see how it worked:

```bash
$ git log
commit: 5hg63j4h5g6jh4g6jh34g66jgg7 (HEAD-> branch_name)
Author: arichardson <arichardson@seinfeld.com>
Date: Mon Jul 1 14:45:21 2019 -0400

  Fix the thing

  Co-authored-by: ebennes <ebennes@seinfeld.com>
  Co-authored-by: gconstanza <gconstanza@seinfeld.com>
```

### It's Your Turn!
This script works well for me as an employee where we all have the same email domain. You may have a different situation, so feel free to refactor this to suit your needs.
