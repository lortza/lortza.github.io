---
layout: post
title:  "Move Code Up/Down a Line in VS Code"
date:   2019-01-28
published: true
---
I've been using Atom for a while, but I figured I'd give Visual Studio Code a shot. For the past few weeks, I've used it here and there, chipping away at customizing it to my liking. In Atom, I love to nudge blocks of code up and down, one line at a time using `ctrl`+`cmd`+`[arrow]`. This is not a default behavior in VS Code, so I set up those keybindings myself. Here's how I did it:

# 1. Open the Keybindings file
Open the keybindings file via `File` > `Preferences` > `Keyboard Shortcuts`.

# 2. Add these Keybindings
In your `keybindings.json`, add the following binding hashes into the array. Remember to add commas between them:

```javascript
// keybindings.json
[
 {
   "key": "ctrl+cmd+up",
   "command": "editor.action.moveLinesUpAction",
   "when": "editorTextFocus"
 },
 {
   "key": "ctrl+cmd+down",
   "command": "editor.action.moveLinesDownAction",
   "when": "editorTextFocus"
 }
]
```

And that's it! The your new keybindings will take effect immediately after save.

### Pro Tip
If you'd like to do your future self a solid favor, consider creating a repo  with all of your favorite IDE keybindings and settings. This way, whenever you need to set up a new computer, you'll save yourself a ton of configuration hours by just having this info ready to go.
