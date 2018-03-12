---
layout: post
title:  How to fix it when the Rails Server is already running, but not where you can find it
date:   2017-11-30
---

Have you ever accidentally closed a terminal tab while the `rails server` was still running and weren't able to find it again?

I've done this a couple of times and couldn't quite find the answer before. This meant the only way out was restarting my machine. Ug. I really dislike doing that. But today, when I overflowed my server stack and accidentally closed the window (yikes), I was able to find an answer -- at last!

The sad, sad message when I tried to start `rails s` again:

```bash
A server is already running. Check /Users/my_computer_name/your_project_location/tmp/pids/server.pid.
Exiting
```

On OSX, you can run this:

```bash
sudo lsof -iTCP -sTCP:LISTEN -P | grep :3000
```


You'll either get nothing back (which means no server is running) OR something like this (which is what I got):

```bash
ruby      56134 computer_name   11u  IPv4 0xe3ccaa0e8651f54d      0t0  TCP :3000 (LISTEN)
```

Grab that number (in my case 56134) and killll it:

```bash
kill -9 56134
```

this post is brought to you with help from [this stackoverflow question](https://stackoverflow.com/questions/24627701/a-server-is-already-running-check-tmp-pids-server-pid-exiting-rails)
