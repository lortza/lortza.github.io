---
layout: post
title:  "Code Review Tips for Beginners"
date:   2020-07-01
published: true
---

The first time I needed to do a code review, I felt nervous and I was sure that I had nothing to offer. Compared to my coworkers, I was the newest at programming and certainly newest to the codebase. I wasn't sure what value I could bring to a code review. Since then, I've gotten plenty of reviews under my belt, so today when our newest junior team member asked for input on how to do a code review, I realized that I had quite a bit to share. You may feel like you don't know where to start or have anything to offer, but fear not. Your input is valuable. These are some lessons I've learned over time on how to extract the value you bring into a code review.

## How do I know what the code in this Pull Request supposed to be achieving?
And in my experience so far, most of the time I haven't had any context for the code I've been asked to review. So I look to the pull request summary as my top source of context for the work being done. It should explain what the pull request hopes to achieve and any context around that. Often times it will link to a related GitHub issue. If this summary is lacking, leave a comment asking for context or clarification on the context given.

## I'm encountering this code (and concept for this feature/project) for the first time. How do I know if it works?
This is hard. There isn't one single answer to this question. And knowing if "it" works is a huge topic. For me, I like to break it down by looking at every line of code and asking myself these questions:

### Do I understand what this line of code does (in its smallest form)?
For example, do I understand that it's sorting an array or returning a hash? If not, leave a comment on the pull request asking for clarification.

### Are these variables/methods/classes named in a clear way?
As a person encountering the code for the first time, you're in a great position to answer this question. If it's not easy-to-grasp instantly, ask for clarification and/or make a suggestion for something that's more clear. Would a future version of yourself with even _less_ context understand it? 90% of our work is reading code. We should make it easy on ourselves.

### What would happen if this method broke?
Could this method produce unexpected `nil`s? If this method fails, are we handling it gracefully? Does the logic in this method depend too much on knowledge about some other method or object? Does this method make incomplete assumptions about what it is receiving?

### Is this new behavior covered with tests?
Do the tests cover all of the edge cases that you can think of? Do the tests ask the hard-hitting questions that give you confidence in this method's expected behavior? Both happy and sad paths? If not, leave a comment asking if it is possible that X might happen. Perhaps a new test is needed.

### Try it out
If you want to, pull the branch and render it locally. Is it doing what you expect it to do?

### Is everything spelled correctly?
It's easy to misspell or mistype a name and that will most certainly cause problems.

### Is there any cruft in there?
In the process of drafting code, sometimes we leave trails of commented out code or some rogue debugger lines that we _mean_ to delete, but end up forgetting. Keep your eye out for those things. And sometimes we'll end up intentionally leaving a comment in the code that explains what a method is supposed to do. Perhaps in this case, renaming a method to be more specific will resolve the need for that comment.

### Does this HTML look ADA-compliant?
Educate yourself with even just a few [ADA-compliance](https://www.w3.org/standards/webdesign/accessibility) topics and keep an eye out for them. If you're unsure, do a little research or put it back on the pull request author to investigate more.

### Can we handle user submissions that aren't in the format we expect?
When we're dealing with any sort of code that takes form input from an external user, expect chaos to ensue. If we're using any of this user-input data to do any matching in the database, have we written code to ensure it is formatted properly or that our queries can handle variation in input?

## Even after doing a code review, I still don't feel comfortable officially approving it. When should I approve?
You never have to approve anything. Also, you should never approve anything you're not comfortable approving. You can review and comment on pull requests without doing an official GitHub "review". Personally, I do that one heck of a lot more than any approvals. The questions above help to figure out if the tiny pieces are working. You'll probably have to go over it several times to make sure you understand the bigger picture. But if you still don't feel comfortable with understanding the big picture, or if your Spidey Sense is tingling and you don't know why, ask someone to help you figure out why. If a pull request is so big that it is intimidating to you, it's probably intimidating to other people too. I've paired on a lot of code reviews to help me build my reviewing skills and to help get big pull requests out the door.

## As it turns out...
All of these little things are incredibly valuable for the person asking for a review. You may be imagining that a person has spent hours polishing every last line before asking for a review. This may not be the case. You're probably reading a first or second draft, not someone's Magnum Opus. Assume everyone is open to feedback -- that's why they're asking, right? And everyone can use the help of a proofreader. The more code you review, the more comfortable you'll get with the discomfort of doing it. :)

Thinking like this on a brand new subject on brand new code is hard brain work. When you're done, high five yourself because you just did hard work!
