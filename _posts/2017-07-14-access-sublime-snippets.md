---
layout: post
title:  How to Access Your Sublime Snippets
date:   2017-07-14 20:53
---

Once I discovered the power of SublimeText's snippet feature, there was no turning back. Any time I find myself typing a thing that could be automated, I make a snippet for it. The trouble is, sometimes I like to look back at my existing snippets, but I couldn't get to them easily. Well, I've solved that problem today and figured I'd share it with you. Here is how to easily access your existing Sublime snippets on a mac.

Step 1. Create an alias called <code>snippets</code> in your <code>.bash_profile</code>.
In terminal, open your <code>.bash_profile</code> file in your default text editor.

{% highlight ruby %}
# if sublime is set as your default text editor
open ~/.bash_profile

# if you use the subl shortcut
subl ~/.bash_profile
{% endhighlight %}

Step 2. Add one of these aliases to the bottom of your file (or next to any other aliases you may have)

{% highlight ruby %}
# for SublimeText 3
alias snippets='cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User ; ls'

# for SublimeText 2
alias snippets='cd ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User ; ls'
{% endhighlight %}

Step 4. Save the <code>.bash_profile</code> file

Step 5. Restart terminal

Step 6. Try it out!
Type your new alias at your command prompt

{% highlight ruby %}
snippets
{% endhighlight %}

This will open the snippets directory and show a list of all existing snippets. From here, you can open any of those snippet files in your default text editor with:

{% highlight ruby %}
open file_name_goes_here

{% endhighlight %}

or if you prefer to open the snippets folder in Finder window, you can open a finder window like this:

{% highlight ruby %}
cd ../; open User

{% endhighlight %}

That's it! This discovery has really made my day. I hope it's helpful to you too.

If you need a refresher on how to create your own sublime snippets, check out <a href="http://localflavormarketing.com/how-to-make-ruby-shortcuts-snippets-in-sublime-text/">this post I recently wrote</a> on the topic.