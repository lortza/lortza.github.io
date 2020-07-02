---
layout: post
title:  "Code Review Tips for Beginners"
date:   2020-07-01
published: true
---

The first time I needed to do a code review, I felt nervous and I was sure that I had nothing to offer. Compared to my coworkers, I was the newest at programming and certainly newest to the codebase. I wasn't sure what value I could bring to a code review. Since then, I've gotten quite a few code reviews under my belt, so today when an intern asked for input on how to do a good code review, I realized that I had quite a bit to share. These are some lessons I've learned over time on how to do a code review when you feel like you've got nothing to offer.

## How do I know what the code in this Pull Request supposed to be achieving?
The pull request summary should be an excellent source of context for the work being done. It should explain what it hopes to achieve and any context around that. Often times it will link to a related GitHub issue. If it is lacking, leave a comment asking for context or clarification on the context given.

## I'm encountering this code (and concept for this feature/project) for the first time. How do I know if it works?
This is hard. There isn't one single answer to this question. For me, I like to look at every line of code and ask myself some questions:
* Do I understand what this line of code does (in its smallest form)? like, do I understand that it's sorting an array or returning a hash? If not, leave a comment asking for clarification.
* Are these variables/methods/classes named in a clear way? As a person encountering the code for the first time, you're in a great position to answer this question. If it's not easy-to-grasp instantly, ask for clarification and/or make a suggestion for something that's more clear. Would a future version of yourself with even _less_ context understand it? 90% of our work is reading code. We should make it easy on ourselves.
* What would happen if this method broke? Could this method produce unexpected `nil`s? if this method failed, are we handling it gracefully?
* Is this new behavior covered with tests? Do the tests cover all of the edge cases that you can think of? Do the tests ask the hard-hitting questions that give you confidence in this method's expected behavior? Both happy and sad paths? If not, leave a comment asking if it is possible that X might happen. Perhaps a new test is needed.
* If you want to, pull the branch and render it locally. Is it doing what you expect it to do?
* Is everything spelled correctly? A misspelled variable is easy to go but will cause problems.

Thinking like this on a brand new subject on brand new code is hard brain work. When you're done, high five yourself because you just did hard work!

## Even after doing a code review, I still don't feel comfortable officially approving it. When should I approve?
You never have to approve anything. Also, you should never approve anything you're not comfortable approving. You can review and comment on pull requests without doing an official GitHub "review". Personally, I do that one heck of a lot more than any approvals. I've also paired on a lot of code reviews to help me build my reviewing skills and to help get pull requests out the door.

## As it turns out...
All of these things are incredibly valuable for the person asking for a review. And in my experience so far, most of the time I haven't had any context for the code I've been asked to review. So I start with these basics and go from there.
