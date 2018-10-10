---
layout: post
title:  'How to Enable the Trimming of Whitespaces by Language in Atom'
date:   2018-10-09
---

I have the [`whitespaces` package](https://github.com/atom/whitespace) installed in Atom, which I love because it trims unnecessary trailing whitespaces from the ends of each line. This is fantastic for _most_ file types I encounter. However, it causes problems in `slim` because sometimes you actually need a trailing whitespace. This is how to disable whitespace trimming for `slim` files:

Open `config.cson` via the Atom menu: `Atom > Config`

You'll see a bunch of stuff like this:

```
"*":
  autosave:
    enabled: true
  core:
    excludeVcsIgnoredPaths: false
    ignoredNames: [
      ".git"
      "log"
      "tmp"
    ]
    telemetryConsent: "limited"
```

At the bottom of the file, outside of the `"*"` namespace, create a scope of `.slim.text` and turn off `removeTrailingWhitespace` inside of it, like this:

```
"*":
  autosave:
    enabled: true
    ...

".slim.text":
  whitespace:
    removeTrailingWhitespace: false
```

This is super handy, but it doesn't solve _all_ of the whitespace problems. I may still have to contend with those spaces that happen in empty-lines. To help with that, I set up the ability to [toggle the visibility of whitespaces]({% post_url 2018-10-10-atom-invisibles %}).
