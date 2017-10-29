---
layout: post
title:  Using Git is like Sending Packages in the Mail
date:   2017-07-22 11:00
---

So you've just gotten your feet wet with web development or programming and in the whirlwind of setting up your machine for class, you have a <a href="github.com" target="_blank" rel="noopener noreferrer">GitHub</a> account and <a href="https://git-scm.com/" target="_blank" rel="noopener noreferrer">Git</a> installed on your machine. The trouble is, though you understand that Git is version-control software, you still don't really understand the whole staging and committing process. What's the differences between `git add` and `git commit`?

Git is very feature rich, so there is plenty to learn. But to help you wrap your head around the basics, think about the Git process of saving and sharing files like packing a box full of gifts to ship off to your mom. So let's start there.

## Part 1: The process of shipping a box of gifts to your mom
So you've been gathering a bunch of gifts to send to your mom. What things do you need in order to make that happen?
<ul>
  <li>Your pile of gifts
<ul>
  <li>your favorite pair of pants that you need her to repair</li>
  <li>the fragile family heirloom you've been meaning to return to her</li>
  <li>an iPad</li>
</ul>
</li>
  <li>A box for shipping</li>
  <li>Some tape</li>
  <li>Your mom's shipping address</li>
  <li>A postal service</li>
</ul>
Now let's walk through the steps we take to make it happen:
<ol>
  <li>Place each gift into the box</li>
  <li>Close the box and tape it up, including a little note for your mom</li>
  <li>Affix your mom's address on it</li>
  <li>Set the package on your front porch, assuming the postal service will pick it up when they make their rounds (we're pretending that the postage is free)</li>
</ol>
Hooray! Now you know how Git works.

## Part 2: The process of pushing your code to GitHub
Okay, so that wasn't too helpful. So here's the process again with Git-speak:

1. You've been gathering gifts (or doing work on files: `pants.html`, `heirloom.html`, and `ipad.html`) on a branch you're calling `gifts_for_moms_house`

2. Place each gift (or each file you're ready to send) into the box one at a time or all at once. Once everything's in the box, we say all of your files are in "staging."
<pre>  git add heirloom.html    # for one-at-a-time
  - or -
  git add .                # for all files at once
</pre>
3. Close the box and tape it up, including a little note for your mom. Now your files will be "committed" in a single "commit" (or box) with a commit message.
<pre>git commit -m "gifts for mom"</pre>
4. Set the package on your front porch, assuming the postal service will pick it up
<pre>git push</pre>
5. The postal worker tells you your box is missing an address and suggests one based on the branch you're on: `origin gifts_for_moms_house`

6. Affix your mom's address (a.k.a. branch name) on it and hand the box back to the postal worker, who then delivers the package
<pre>git push --set-upstream origin gifts_for_moms_house</pre>
Ahh, it is starting to make sense? Now the thing I didn't really understand when I was first learning this was why in the heck we bother with the two steps of adding AND committing? Can't that be just one step? Sure, you can set up your git that way. But I don't recommend it and this is why: <strong>You're going to make mistakes. You're going to make lots of mistakes all over the place and at every step of the process. I do. Everyone does.</strong>

### Handling Mistakes
So let's start over. You're happily adding gifts to the box for your mom and have just added the last one. Now that you're looking at that fragile heirloom sitting in the box (in staging), it occurs to you that you maybe should have wrapped it in something protective before putting it in the box. Whoops! Now you need to take it out of the box, wrap it up, and then put it back in the box. Good thing you haven't sealed up that box (committed) yet!

#### Removing a file from staging (getting that heirloom back out of the box)

Take the heirloom file out of staging (out of the box) while leaving the others in place:
<pre>git reset heirloom.html</pre>
After we wrap it up securely, we can add it back to the box with:
<pre>git add heirloom.html</pre>
Phew! Okay, surely we're ready to commit now, so we do:
<pre>git commit -m "gifts for mom"</pre>
Super! The box is all taped up and ready to set out on the front porch... but you know, it sure would be nice of you if you spent a little time setting up and charging that iPad for your mom so all she has to do is turn it on. Oh crap. How do we get that iPad back out of the taped-up box?

#### Undoing a commit, fixing the problem, and redoing the commit (untaping that box, adding the set-up iPad, and taping the box back up)

Have no fear! Git can do that. First, take the tape off and take the gifts back out of the box. Even though it looks a little scary, this will not undo any of the changes you've made to those files, it will just un-package them from the commit and take them out of staging:
<pre>git reset HEAD~</pre>
Spend as much time as you'd like setting up the iPad (fixing that file you messed up royally), then add all of the gifts (all of the files) back into the box again:
<pre>git add .</pre>
And the great news is, we have reusable tape! To seal the commit back up with the original commit message and to leave a clean history:
<pre>git commit -c ORIG_HEAD</pre>
Awesome! Now you can set your box out on the front porch (push your files). So now, how does your mom actually get those lovely gifts?

## Part 3: The process of pulling code down from GitHub
GitHub is like a huge digital post office in the cloud, which is organized by repositories (a.k.a. repos). When you're working on projects with other people, you will set up a repository for that specific project and everyone on the team will have access to it. In this case, let's say your whole family works on a project repo called `family_gifts` and within that repo, you have several branches. The branch you've seen already is called `gifts_for_moms_house`. You've told your mom that gifts are waiting for her in that branch and that she needs to request delivery of them. Okay, so we're losing the metaphor a bit, but now this is what your mom will do:

1. Makes sure she's inside the `family_gifts` directory on her command line.

2. Gets a list of all branches that exist in the family's GitHub repo
<pre>git fetch</pre>
3. Sees that `gifts_for_moms_house` is there, like you said it was, and checks it out on her machine:
<pre>git checkout gifts_for_moms_house</pre>
4. Requests delivery of those files:
<pre>git pull</pre>
And that's it! She now has the files you sent to her. If only we could actually send fragile heirlooms this way.

Understanding Git is a big learning curve for a lot of new developers, so if you have any suggestions on how to make this explanation easier to understand, <a href="http://localflavormarketing.com/contact/">please drop me a line</a>!