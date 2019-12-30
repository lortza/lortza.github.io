---
layout: post
title:  "Write a script to run all CI checks locally"
date:   2019-12-30
published: true
---

I love having my CI service keep me in line by running a bunch of checks when I push a commit to my GitHub repo. However, sometimes I'd like to run them myself locally before pushing. Currently, I like to run RSpec and my Ruby and CSS linters. To make this easier, I created a script file in my project root directory that will run all of my CI checks for me locally. This is how I did it:

### 1. Create the script file
From inside the project root folder, create a new folder called `script` and a file called `run_ci_checks`
```bash
# Example:
my_project/script/run_ci_checks
```

In that file, add all of the CI checks you'd like to run. Mine looks like this:
```
#!/bin/sh

echo '==== RUNNING RSPEC ====='
bundle exec rspec

echo '==== RUNNING RUBOCOP ====='
bundle exec rubocop

echo '==== RUNNING CSS LINT ====='
bundle exec scss-lint app/assets/stylesheets/**.scss

echo 'DONE'
```

### 2. Make this file readable from the command line
To make this file readable from the command line, from inside my new `/script` directory, I ran:
```bash
chmod -R 777 ./
```

You can now run this script from the command line like this:
```bash
./script/run_ci_checks
```

### 3. Make an alias
Since my fingers are lazy and don't like typing, I made an alias for this inside my `.bash_profile` then ran `source ~/.bash_profile` so my terminal was up to date:
```bash
# open .bash_profile file from the command line with:
open ~/.bash_profile

# then add this line inside the .bash_profile file and save
alias lint='./script/run_ci_checks'

# on the command line, refresh reload the .bash_profile for this terminal session
source ~/.bash_profile
```

Now I can simply type my `lint` alias from inside my project root folder and this script will run all of my checks for me.
