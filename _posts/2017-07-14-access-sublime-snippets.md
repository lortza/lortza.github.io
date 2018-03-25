---
layout: post
title:  How to Access Your Sublime Snippets
date:   2017-07-14 20:53
---

Once I discovered the power of SublimeText's snippet feature, there was no turning back. Any time I find myself typing a thing that could be automated, I make a snippet for it. The trouble is, sometimes I like to look back at my existing snippets, but I couldn't get to them easily. Well, I've solved that problem today and figured I'd share it with you. Here is how to easily access your existing Sublime snippets on a mac.

Step 1. Create an alias called `snippets` in your `.bash_profile`.
In terminal, open your `.bash_profile` file in your default text editor.

```bash
# if sublime is set as your default text editor
$ open ~/.bash_profile

# if you use the subl shortcut
$ subl ~/.bash_profile
```

Step 2. Add one of these aliases to the bottom of your file (or next to any other aliases you may have)

```bash
# .bash_profile

# for SublimeText 3
alias snippets='cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User ; ls'

# for SublimeText 2
alias snippets='cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User ; ls'
```

Step 4. Save the `.bash_profile` file

Step 5. Restart terminal

Step 6. Try it out!
Type your new alias at your command prompt

```bash
$ snippets
```

This will open the snippets directory and show a list of all existing snippets. From here, you can open any of those snippet files in your default text editor with:

```bash
$ open file_name_goes_here
```

or if you prefer to open the snippets folder in Finder window, you can open a finder window like this:

```bash
$ cd ../; open User
```

Personally, my favorite spin is to map my alias to open a sublime project folder with all of my snippets. This way, I can move around easily between all existing snippet files:
```bash
# my .bash_profile
alias snippets='cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User ; subl .'

# terminal
$ snippets
```

That's it! This discovery has really made my day. I hope it's helpful to you too.

If you need a refresher on how to create your own sublime snippets, check out <a href="http://localflavormarketing.com/how-to-make-ruby-shortcuts-snippets-in-sublime-text/">this post I recently wrote</a> on the topic.
