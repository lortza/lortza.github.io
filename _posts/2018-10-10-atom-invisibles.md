---
layout: post
title:  'How to Toggle the Visibility of Whitespaces in Atom'
date:   2018-10-10
published: true
---

I recently started working in `html.slim`, which is whitespace sensitive. In order to edit my `slim` files successfully, I wanted to be able to see whitespaces. I did this in Atom like this:

1. Enable "Show Invisibles"
2. Make Invisibles Actually Visible
3. Enable the Toggling of Invisibles
4. BONUS: Turn off Whitespace Trimming for `html.slim` Files Only

## 1. Enable "Show Invisibles"
Atom calls these whitespaces "invisibles." Go to `Atom > Preferences > Editor`.

Scroll _past_ the section on Invisibles. You'll find a checkbox that says "Show Invisibles". Check that box.

## 2. Make Invisibles Actually Visible -- optional
This part is optional and it depends on the theme you have. If when you turn on Invisibles, you still can't see them, you may need to adjust the color or opacity of those characters in the Atom `style.less` stylesheet file.

Go to `Atom > Stylesheet`

Add your preferred CSS to a class called `.invisible-character` inside the `atom-text-editor` code block:

```
atom-text-editor {
  .invisible-character {
    opacity: 1;
  }
}
```

## 3. Enable the Toggling of Invisibles
Since I don't work in `slim` all of the time, I don't want to see invisibles all of the time. You can create a keyboard shortcut to toggle invisibles by adding this to your `keymap.cson` file.

Go to `Atom > Keymap`

Add your preferred shortcut to the `atom-text-editor` namespace. Here, I'm using `ctrl i`:

```
'atom-text-editor':
   'ctrl-i': 'window:toggle-invisibles'
```

## 4. BONUS: Turn off Whitespace Trimming for slim Files Only
All of that showing of whitespaces is very useful, but in my case, I still had one more hurdle in my workflow for `slim` files. I have the `whitespaces` package installed, which I love because it trims unnecessary trailing whitespaces from the ends of each line. This is fantastic for _most_ file types I encounter. However, it causes problems in `slim` because sometimes you actually need a trailing whitespace. This is how I was able to [turn off whitespace trimming in for only slim files]({% post_url 2018-10-09-whitespaces-slim %}).
