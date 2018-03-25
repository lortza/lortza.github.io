---
layout: post
title:  Using Git is like Sending Packages in the Mail
date:   2017-07-22 11:00
---

So you've just gotten your feet wet with web development or programming and in the whirlwind of setting up your machine for class, you have a <a href="github.com" target="_blank" rel="noopener noreferrer">GitHub</a> account and <a href="https://git-scm.com/" target="_blank" rel="noopener noreferrer">Git</a> installed on your machine. The trouble is, though you understand that Git is version-control software, you still don't really understand the whole staging and committing process. What's the differences between `git add` and `git commit`?

Git is very feature rich, so there is plenty to learn. But what helped me wrap my head around the basics was to think about the Git process of saving and sharing files like packing a box full of gifts to ship off to my mom. In the example below, we're sending gifts to your mom. You've chosen some weird stuff. I hope she likes alligator figurines... :)

## Part 1: The process of shipping a box of gifts to your mom
You've been gathering a bunch of gifts to send to your mom. What things do you need in order to make that happen?
<ul>
  <li>Your pile of gifts
    <ul>
      <li>jar of fancy local cajun jam</li>
      <li>jambalaya spice mix</li>
      <li>delicate alligator figurine</li>
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
Hooray! Now you know how Git works... almost.

## Part 2: The process of pushing your code to GitHub
Now that we're clear on how to ship stuff to Mom, here's the process again with git-speak:

1) You've been gathering gifts for your mom -- i.e. doing work on files on a branch you're calling `gifts_for_moms_house`

 - `cajun_jam.html`
 - `jambalaya_mix.html`
 - `alligator.html`
 - `ipad.html`

2) Place each gift (or each file you're ready to send) into the box one at a time or dump them all in at once. Now all of your files are in "staging."

```bash
git add cajun_jam.html   # add a single file

# - or -
git add .                # add all recently-changed files
```

3) Close the box and tape it up, including a little note for your mom. In git-speak, this is "committing" your files in a single "commit" with a commit message. After committing, your files are out of staging and the staging area is empty.

```bash
git commit -m "Gifts for the family"
```

4) Hand the package to the mail carrier who is conveniently standing on your front porch, waiting for your package. In git-speak, this is when we `push` to GitHub.

```bash
git push
```

5) The mail carrier tells you your box is missing an address and suggests one based on the branch you're on: `origin gifts_for_moms_house`

6) Affix your mom's address (a.k.a. branch name) on it and hand the box back to the mail carrier, who then takes the package to the central post office.

```
git push --set-upstream origin gifts_for_moms_house
```

Your job here is done and it's in the hands of the postal service now. So how does your mom actually get those lovely gifts?

## Part 3: The process of pulling code down from GitHub
GitHub is like a huge digital post office in the cloud, which is organized by repositories (a.k.a. repos). When you're working on projects with other people, you will set up a repository for that specific project and everyone on the team will have access to it. In this case, let's say your whole family works on a project repo called `family_gifts` and within that repo, you have several branches. The branch you've seen already is called `gifts_for_moms_house`. You've told your mom that gifts are waiting for her in that branch and that she needs to request delivery of them. Okay, so we're losing the acutal post office metaphor a bit, but now this is what your mom will do:

1) Makes sure she's inside the `family_gifts` directory on her command line.

2) Gets a list of all branches that exist in the family's GitHub repo

```
git fetch
```

3) Sees that `gifts_for_moms_house` is there, like you said it was, and checks it out on her machine:

```
git checkout gifts_for_moms_house
```

4) Requests delivery of those files:

```
git pull
```

And that's it! She now has the files you sent to her. If only we could actually send gifts this way.

## Part 4: Handling Mistakes

The thing I didn't really understand when I was first learning to use Git was why in the heck we bother with the two steps of adding AND committing? Can't that be just one step? Sure, you can set up your Git that way. But I don't, and this is why: *I know I'm going to make mistakes. I'm going to make lots of mistakes all over the place and at every step of the process. Everyone does.*

The process outlined above of adding files, committing, and pushing doesn't always go smoothly. So let's start over from scratch and learn how to handle it when stuff goes wrong.

You're happily adding gifts to the box for your mom and have just added the last one. Now that you're looking at that delicate alligator figuring sitting in the box (in staging), it occurs to you that you maybe should have wrapped it in something protective before putting it in the box. Whoops! Now you need to take it out of the box, wrap it up, and then put it back in the box. Good thing you haven't sealed up that box (committed) yet!

### Removing a file from staging (getting that alligator back out of the box)

Take the alligator file out of staging (out of the box) while leaving the others in place:

```
git reset alligator.html
```

After ensconsing it in bubble wrap, we can add it back to the box with:

```
git add alligator.html
```

Phew! Okay, surely we're ready to commit now, so we do:

```
git commit -m "gifts for mom"
```

Super! The box is all taped up and ready to hand to the mail carrier... but you know, it sure would be thoughtful if you spent a little time setting up and charging that iPad for your mom so all she has to do is turn it on. But the box is taped up. How do we get that iPad back out of the taped-up box?

### Undoing a commit, fixing the problem, and redoing the commit

Have no fear! Git can do that. First, take the tape off and take the gifts back out of the box. Even though it looks a little scary, this will not undo any of the changes you've made to those files, it will just un-package them from the commit and take them out of staging:

```
git reset HEAD~
```

Spend as much time as you'd like setting up the iPad (fixing that file you want to change), then add all of the gifts (all of the files) back into the box again:

```
git add .
```

And the great news is, we have reusable tape! To seal the commit back up with the original commit message and to leave a clean history:

```
git commit -c ORIG_HEAD
```


Understanding Git is a big learning curve for a lot of new developers, so if you have any suggestions on how to make this explanation easier to understand, <a href="http://localflavormarketing.com/contact/">please drop me a line</a>!
