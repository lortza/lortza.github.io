---
layout: post
title:  'Set up a Shell Script on Mac for Postgres Backups'
date:   2018-10-01
---

I was recently setting up a new computer and I needed to back up and restore several PostgreSQL databases in the process. It occurred to me that typing `pg_dump db_name > /really-long-path-to-dropbox-folder/db_name_again-today's_date.sql` followed by
`postgres db_name < /really-long-path-to-dropbox-folder/db_name_again-today's_date.sql` over and over again could be simplified by a script in my terminal. And it was. This is how I did it, with a lot of help from [this post](https://medium.com/devnetwork/how-to-create-your-own-custom-terminal-commands-c5008782a78e).

1. Create a Scripts File
2. Source the Scripts File in the `.bash_profile`
3. Set the File Permissions
4. Echo a Hello World
5. Try a Manual Version
6. Incorporate Some Global Variables from the Shell

### 1. Create a Scripts File

In my root folder, I created a file called `.my_custom_scripts.sh` and opened it in SublimeText
```bash
# Go to my root folder
cd ~

# Create a new file to house my scripts
touch .my_custom_scripts.sh

# Open the scripts file in Sublime
subl ~/.my_custom_scripts.sh
```

### 2. Source the Scripts File in the .bash_profile

The `.bash_profile` holds configurations for the Terminal on mac. So in order to get this scripts file to load every time a new Terminal session is started, I needed to source the scrips file in the `.bash_profile`. Then, just for convenience, I created an alias called `scripts` that would open `.my_custom_scripts.sh`.

```bash
# Load my custom commands into Terminal
source ~/.my_custom_commands.sh

# Open my scripts file
alias scripts='subl ~/.my_custom_commands.sh'
```

### 3. Set the File Permissions
After creating the file, I needed to modify the permissions of it so that I could access it via terminal commands. In the terminal I ran:
```
chmod +x .my_custom_commands.sh
```

### 4. Echo a Hello World

Just to make sure everything is set up so far, I wrote a super simple function to output 'Hello World'.

```shell
#!/bin/bash

function sample_echoer() {
  echo 'Hello World'
}

# > sample_echoer
# => Hello World
```

### 5. Try a Manual Version

Since I knew exactly the command I wanted to run, I tried a manual version of it to see if it would work. In order to get the accurate path to my Dropbox folder, I selected an existing file in the Dropbox folder and dragged it into terminal. I copied the relevant parts and went from there.

```shell
#!/bin/bash

function dump_dev() {
  echo 'pg_dump db_name > /User/my_username/Dropbox/db_backups/db_name_2018_09_30.eql'
}
```

Just running `dump_dev` in the terminal created a new file in my Dropbox folder called `db_name_2018_09_30.eql`. Hooray! It worked.

### 6. Incorporate Some Global Variables from the Shell

Once I established that everything was working so far, I decided to start using some global variables from the shell to make my life easier. My goals:

- Be inside of the root folder of a Rails app when I call `dump`, so I wanted to be able to grab my current directory name. The default project database name in rails is the project's root directory name + the environment (ex: `_development`)
- Be able to use this script on my 2 different computers. Those computers have different usernames, so hardcoding `my_username` wasn't going to work.
- Append the database filename that's saved to Dropbox with today's date.

```shell
#!/bin/bash

function dump_dev(){
  # Grab today's date and format it like 2018_09_30
  today=$(date +'%Y_%m_%d')

  # Grab the name of the Rails root directory
  project=$(basename `pwd`)

  # Incorporate the variables in the script. $USER is the shell variable that gives you the current computer username.
  pg_dump ${project}_development -O -x > /User/${USER}/Dropbox/db_backups/${project}_development_${today}.sql
}
```

And that worked! My next goal was to be able to restore the database on my other computer from the Dropbox file. In order to do this, I needed my `restore_dev` script to take an argument with the location of the backup file that I wanted to use. In shell, you can access the first argument with `$1`. (The second argument is `$2`, and so on.)

Again, I planned to run this script from within the Rails project root directory, so I had access to that `basename` variable. In the terminal, I wanted to run `restore_dev` and then drag the file from Dropbox into the terminal window to supply the argument.

```shell
#!/bin/bash

function restore_dev(){
  # Grab the name of the Rails root directory
  project=$(basename `pwd`)

  # Take advantage the $1 argument variable for the pathname
  psql ${project}_development < $1
}
```

And that's it. I sure do like when I get to make my life a little bit more efficient. :)
