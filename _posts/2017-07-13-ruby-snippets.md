---
layout: post
title:  How to make ruby shortcuts (snippets) in Sublime Text
date:   2017-07-13
---

Typing Ruby erb tags is a past time pursued intentionally by... no one? Well, certainly not me! The characters `<%= %>` don't exactly flow off of my fingertips. So how do people get around typing these irritating-but-crucial characters?

I use my beloved SublimeText snippets. <a title="SublimeText3" href="https://www.sublimetext.com/3" target="_blank" rel="noopener noreferrer">SublimeText 3</a> is a popular text editor among rubyists and it has a lot of great features. One of my favorites is snippets.

## What is a snippet?
A snippet is a keystroke shortcut you create that will generate text for you. There are some built-in snippets in Sublime that make my life easier. For example, if you type `lorem + TAB` you'll get a short paragraph of lorem ipsum placeholder text.

So how do we get to automate those pesky erb tags? By making our own custom snippets.

In SublimeText 3, go to Tools/Developer/New Snippet

<img class="aligncenter size-large wp-image-1152" src="http://localflavormarketing.com/wp-content/uploads/2017/07/snippets01-980x422.png" alt="open a new snippet template" width="640" height="276" />

You'll get a snippet template that looks like this:

```html
<!-- new_snippet_file -->

<snippet>
  <content><![CDATA[
Hello, ${1:this} is a ${2:snippet}.
]]></content>
  <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
  <!-- <tabTrigger>hello</tabTrigger> -->
  <!-- Optional: Set a scope to limit where the snippet will trigger -->
  <!-- <scope>source.python</scope> -->
</snippet>
```

It looks a little crazy, but don't panic. It's all really useful stuff and I'll get to that in a bit. First, let's cut to the chase and make those erb tags.


## The TLDR

Assuming you want your shortcut word to be `erb`, delete everything in that file and replace it with this:

```html
<snippet>
  <content><![CDATA[<%= ${1} %>]]></content>
  <tabTrigger>erb</tabTrigger>
  <description>&#60;&#37;&#61;&#37;&#62;</description>
  <scope>text.html.ruby</scope>
</snippet>
```
Save the file as `html-erb.sublime-snippet`.

Now, when you're inside an erb file like `index.html.erb`, you can simply type your new shortcut + TAB and you get your erb tags. Hooray!

```
# type this:
erb + TAB

# get this:
<%=  %>
```
## What it's doing and how to customize

The `content` tags house the end result of the snippet. The `${1}` is where your cursor will end up after you hit `TAB`.

```html
<!-- the content -->
<content><![CDATA[<%= ${1} %>]]></content>
```

The `tabTrigger` tags hold the shortcut word you'll use before triggering the shortcut with the TAB key

```html
<!-- the tab trigger -->
<tabTrigger>erb</tabTrigger>
```

The `description` tags are optional and display more meaning if you have several similar snippets. This one is super gnarly because it is using code to literally display the characters `<%= %>`. You could simply type "erb tag" and be done with it.

```html
<!-- the description -->
<description>&#60;&#37;&#61;&#37;&#62;</description>
```

The `scope` tags are also optional and limit the snippet to running in only the types of files you designate here. This scope limits this snippet to work in erb files only. If you want your snippet to work in all file types, delete this line.

```html
<!-- the scope -->
<scope>text.html.ruby</scope>
```

Here's an <a title="sublime scopes" href="https://gist.github.com/iambibhas/4705378?reference=localflavormarketing.com" target="_blank" rel="noopener noreferrer">excellent gist with a list of scopes for SublimeText 2</a>, most of which work in SublimeText 3 as well.


## Building a more complex snippet

So let's build a new snippet. Here's one I use a lot:

```html
<!-- This snippet code... -->

<snippet>
  <content><![CDATA[
    <a href="${1}" target="${2:_blank}" alt="${3}" title="${3}">${4}</a>
    ]]></content>
    <tabTrigger>a</tabTrigger>
    <description>a href</description>
    <scope>text.html, text.html.ruby</scope>
  </snippet>
```

```html
<!-- ... Generates this html: -->

<a href="" target="" alt="" title=""></a>
```

This is the core of the snippet code. It will generate a blank snippet:

```html
<!-- this generates a blank snippet -->

<content><![CDATA[   ]]></content>
```
Much like the <a title="The Dash Between Songs" href="https://www.youtube.com/results?search_query=the+dash+between&amp;page=&amp;utm_source=opensearch" target="_blank" rel="noopener noreferrer">myriad of country songs</a> based on <a title="The Dash Between" href="http://www.rontranmer.com/the-dash-between" target="_blank" rel="noopener noreferrer">this poem</a>, it's that space between those brackets that's important -- and a lot less cheesy. This is what's between the brackets for this specific snippet:

```html
<content><![CDATA[

  <a href="${1}" target="${2:_blank}" alt="${3}" title="${3}">${4}</a>

 ]]></content>
```

The `${1}` is the first tab-stop placeholder. This means that after I type my trigger of `a` plus the `TAB` key, all of that html shows up and my cursor is placed in the 1st placeholder inside `href=""`. Now I can type or paste a URL:


```html
<!-- at placeholder 1 -->
<a href="http://www.google.com" target="" alt="" title=""></a>
```

When I hit the `TAB` key _again_, it moves to the second placeholder, `${2:_blank}`, which is inside the `target=""`. This placeholder is special because I gave it a default value of `_blank`. If I want to replace that default value with something else, I could type that right here.

```html
<!-- at placeholder 2 -->
<a href="http://www.google.com" target="anything_i_want" alt="" title=""></a>
```

But I like it as `_blank`, so I hit the `TAB` key again and move on to the next placeholder.

The third placeholder, `${3}`, is also special because there are two of them: one in the `alt=""` and one in the `title=""`. My cursor will actually be in both of those spaces at the same time, so whatever I type will show up in both of those places.

```html
<!-- at placeholder 3 -->

<!-- two placeholders with the same number will output the same value -->
<a href="${1}" target="${2:_blank}" alt="${3}" title="${3}">${4}</a>

<!-- resulting in this -->
<a href="http://www.google.com" target="_blank" alt="the googles" title="the googles">${4}</a>
```
*Kaboom!* right? This discovery opened up my world of snippet-making.

Now, hit the `TAB` key again, and we're in placeholder #4. Nothing special here. I can fill it out, hit `TAB` again and my cursor will move to the first space outside of the snippet.

```html
<!-- at placeholder 4 -->
<a href="http://www.google.com" target="_blank" alt="the googles" title="the googles">Google</a>
```
So hopefully this gets you started on a path to using SublimeText more efficiently so you can spend less time typing and more time coding. Though you'll start to discover your snippet needs pretty easily on your own. Here are some ideas:

  - get `binding.pry` with `pry`
  - commenting your closing `div`s with the name of the class you've assigned them
  - commenting your closing ruby method `end`s or closing javascript `}` braces
  - building our your `initialize(args)` like `@name = args[:name]`s

Also, in case you want to reference a snippet you've already made, check out this post I recently wrote about <a href="http://localflavormarketing.com/how-to-access-your-sublime-snippets/">how to easily access your existing snippets</a>.
