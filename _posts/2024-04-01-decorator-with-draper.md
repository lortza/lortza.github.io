---
layout: post
title:  "Exploring decorators with the Draper gem"
date:   2024-04-01
published: true
---

Over the weekend, I implemented a decorator in a personal app using the [draper gem](https://github.com/drapergem/draper).

## App Context
I have an app that tracks logging of various physical therapy-related various activities -- for example physical therapy session logs, pain occurrence logs, allergy drop dose logs, and exercise logs. Each type of log has its own display name, an icon associated with it, and some css classes around color.

Before implementing the decorator class, I had to assign these unique attributes either by hard-coding in a custom partial for each log type or by passing them as local variables into a shared partial.
```html
<div class="log-border physical-therapy-border-color">
  <p class="physical-therapy-color">
    <span class="material-icon">physical_therapy</span>
    PT Session: <%= log.occurred_at %>
  </p>
  <p><%= log.details %></p>
</div>
```

After implementing the decorator, I can call these attributes like methods on each object, reducing my need for partials
```html
<div class="log-border <%= log.css_name %>-border-color">
  <p class="<%= log.css_name %>-color">
    <span class="material-icon"><%= log.icon_name %></span>
    <%= log.display_name %>: <%= log.occurred_at %>
  </p>
  <p><%= log.details %></p>
</div>
```

While doing this work of implementing a decorator, I felt like it was overkill for these minimal features, but I was looking for an excuse to play with a decorator and this is what I did with it. It was a good exercise and I learned about some of the pain points as well. And now with the decorators in place, I can start moving view-helper logic out of the view helpers and into the appropriate decorators. I can also move any model methods that don't really belong in models into the decorators where they belong.


## Why use draper?
I considered building out my own decorators, but draper sold me on its convenience methods and help in workarounds for things like:
* pagination
* decorating collections (ex: `@logs = PhysicalTherapyLogDecorator.decorate_collection(logs)`)
* decorating instances (ex: `@log = current_user.physical_therapy_logs.new.decorate`)

I was a little disappointed that there was not an easy solution for decorating class level methods, but I can always build out a module for extending into models if I need to.


## Pain Points
**Updating specs.** All of my spec objects were plain versions of the model. I needed to provide decorated versions of those object in order to have access to those methods.

**Shared partials.** I have a shared partial that I use on the Edit page of all of my models. In that partial, I reference the name of the model class like "Are you sure you want to delete this PainLog?". That class became a "PainLogDecorator", which is not what I wanted. So I changed the partial to call the decorator method `display_name`. Easy peasy! _Except_ that I was using that shared partial in my non-decorated models as well. Ug. So my choice was to either decorate _all_ of the other models that didn't otherwise need a decorator or make a separate partial for decorated objects. Given the domain of the decorated objects, it made more sense to give them their own partial and leave the existing partial as-is for the non-decorated models.

**Actually decorating 😂.** You do indeed have to decorate the object if you want to have access to the decorator methods. In draper gem-speak, this means calling `decorate` on any object or collection in each controller method just before it gets sent to the view. This could get complicated depending on the collection.

## Conclusion
Draper makes decorating pretty darned easy. I'm looking forward to seeing what all I can make it do for me.