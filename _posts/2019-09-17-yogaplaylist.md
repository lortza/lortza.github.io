---
layout: post
title:  "Looking Back Down the Mountain: Growth from a set of Garageband files to Rails 6 & JS"
date:   2019-09-17
published: true
---

I recently [wrote a post]({% post_url 2019-09-16-down-the-mountain %}) about why reflecting on growth is important. So that's what this post is about.

Back in roughly 2013, I had recorded a bunch of yoga pose audio tracks and thought it would be cool to automate playing them with a playlist app. But instead of it being a regular playlist, I wanted to programmatically set the amount of time that a person would hold each pose. For example, 10 seconds, then do the next pose. Since I had no programming skills at the time, this idea manifested as loooong mp3 files that I made with Garageband. I mean, as tedious as it was to manually move 60 individual audio snippets along a time line in Garageband -- for three completely different Garageband files (10 sec, 20 sec, and 30 sec), a girl’s gonna get it done, right? And I did. I've been using those audio track compilations for the past few years.

Fast forward to today... and now that I have programming skills... guess what!

I built that app. It occurred to me last weekend that, oh, I could build that now. So I did. I have an app with a playlist full of poses where I can set the hold time. In other words, I just built the thing I wished I could have built back in 2013 and I’m appreciating the learning and the work I’ve done to get here.

So hey, good job, me! And this is what I ended up building:


This app has a simple, single purpose: to play a list of individual yoga audio tracks in evenly set intervals. For example:
```
play track for pose 1
hold for 20 seconds
play track for pose 1
hold for 20 seconds
play track for pose 1
hold for 20 seconds
play ending chime
```

As this is an app I built simply as a utility for myself, I focused on function over fancy. This is what a playlist looks like on mobile.

<img src="https://github.com/lortza/yogaplaylist/raw/master/public/screenshots/playlist_show_mobile.png" title="playlist show page" alt="playlist show page" class="post-image">

A playlist has a name, a hold time, and `has_many :playlist_poses`, which is the join table for a many-to-many relationship. A pose can be on many playlists and a playlist has many poses.

A pose has a name, image, and audio file. Here is what the poses index page looks like:

<img src="https://github.com/lortza/yogaplaylist/raw/master/public/screenshots/poses_index.png" title="poses index page" alt="poses index page" class="post-image">


I love the flexibility I have in this app. First, there is flexibility in creating a playlist without needing to re-record audio tracks. I can simply reuse them at any time in a playlist. For example, if I _really wanted_ to go back and forth between warrior 1 and warrior 2 five times in a row, I can do that.

<img src="https://github.com/lortza/yogaplaylist/raw/master/public/screenshots/so_many_warriors.png" title="playlist with repeated poses" alt="playlist with repeated poses" class="post-image">

Second, there is flexibility in the amount of time I want to spend any given day doing a yoga playlist. Some days, I may have a full 30 minutes, so I'll use a hold time of 30 seconds on my "flexibility playlist". Other days (much like this past week when I had a mean cold), I may choose to do an 8 second hold. I could still get through all of the poses and I still did something good for my body that day -- whereas if I had been locked in to a 30-second hold, that would not have happened. I added a `duration` calculation, to give me an idea of how long it will take to get through the playlist with a given per-pose `hold_time`.

### Show me the Magic
Is the magic of the hold time in a Ruby `sleep(30)`? Lol. My backend-oriented heart wishes. No, it is in a javascript `forEach` loop with a `setTimeout`. And it looks like this:

```
console.log('Begin!');
audioTracks.forEach(function(item, index, array) {
  setTimeout( (function( index ) {
    return function() {
      console.log(`playing: ${item}`);
      const track = new Audio(`/audio_files/${item}`);
      track.play().catch(e => { console.log(e); });
    };
  }(index)), (holdTime * index) );
});
```
_[see the code](https://github.com/lortza/yogaplaylist/blob/master/app/views/playlists/show.html.erb#L52-L60)_

While building this loop, I chose to output all of the tracks to the console as a sanity check. Then I decided to leave them in place in production... as a sanity check ;) Also shout out to [@tomrich82](https://github.com/tomrich82) for being a voice of reason as I struggled in this async world.

<img src="https://github.com/lortza/yogaplaylist/raw/master/public/screenshots/playlist_show_console.png" title="playlist running with console output" alt="playlist running with console output" class="post-image">

That's pretty much all there is to it! I ran into some i-have-no-idea-what-i'm-doing territory with the changes to the Rails 6 asset pipeline. With Rails 6, one does not simply plop javascript into a .js file and call it a day. Webpacker is involved. For this project, I circumvented my Webpacker woes and was able to move forward with launching a beta version for myself by putting the javascript directly in the HTML pages where it was needed. My next step will be learning how to do this TheRightWay<sup>TM</sup>, using Webpacker. 
