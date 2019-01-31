---
layout: post
title:  "How to Get Hex Codes from Any Part of Your Mac Screen"
date:   2019-01-30
---
Need to get some HEX codes for an image you have locally on your computer? As it turns out, if you have OS X 10.10 Yosemite or higher, you already have an application on your Mac that can do this for you. [Digital Color Meter](https://support.apple.com/guide/digital-color-meter/welcome/mac) measures and displays the color values of pixels displayed on your screen -- which lets you extract HEX codes.

Here is an example of how to do it. First, open Digital Color Meter by hitting `shift + tab` to open Spotlight search and searching for it by name.

![My helpful screenshot](/img/posts/digitalcolormeter1.png)


Once it's open, go to `View`>`Display Values` and select `Hexadecimal`.

![My helpful screenshot](/img/posts/digitalcolormeter2.png)

Currently, I have this lovely photo of Grumpy Cat on my desktop. If I want to get a HEX code from his nose, I just mouse over the area I want to capture and see the RGB values output below.

![My helpful screenshot](/img/posts/digitalcolormeter3.png)

Majestic, isn't it?

In order to get a HEX code that you can use for CSS or other styles, you'll want to grab the last 2 digits from each color value. See the red box below.

![My helpful screenshot](/img/posts/digitalcolormeter4.png)

You'll end up with `#8A534E` because `R: 0x8A` + `G: 0x53` + `B: 0x4E`  == `#84534E`.
