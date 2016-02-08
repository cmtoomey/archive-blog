---
layout: post
section-type: post
title: Tableau & Github
category: Collaboration
tags: [ 'XML', 'git', 'hacks' ]
---
![Shippit](https://cmtoomey.github.io/img/squirrelpor-1435851730-44.jpg)

##How collaboration is done!
---

By themselves, anybody can handle a Tableau project. But, if **size(team) > 1**, collaborating is really hard - copy/paste workbooks, replace datasources, and don’t even think about version control (Saving Files as Rev1, Rev2, Rev3 doesn’t count).

**There is a better way**. What if multiple people could work on multiple dashboards, simultaneously? What if you could test out features and calculations without duplicating workbooks? What if you could fix things that break, and push those fixes out to everyone who is working? What if you could treat Tableau like a true agile project?

It can be done - and I’m going to show you how. Things are a little more complicated, so we’ll do a sample workflow together. I’ll show you how Tableau behaves under the hood, and some ways you can manage that behavior.

###Ready?
---
Let's talk about the squirrel. For those of you who don't know, that is the ShipIt Squirrel. At GitHub, the entire culture is geared around delivery - shipping new features. If you go back to the first post on [Tableau + Git](https://cmtoomey.github.io/tutorial/2015/05/16/gitstarted.html), you may remember the GitHub Flow. The central premise of Flow is [publish often, trust your teammates, and always be making things better.](http://excid3.com/blog/finishing-is-all-that-matters/)

To refresh your memory, everything in Git is centered around the commit: the uniquely-identified package of all changes you've made, with a description of those changes. As you commit and request to have to those changes integrated into the master branch (as part of the GitHub Flow), you are communicating with your teammates about what you've done and why you did it that way.

This gives you some insurance if something goes wrong, because you're work is parallel to what's in production. You can focus on new features without downtime. It's a nice way to live.

![Flow](https://cmtoomey.github.io/img/githubflow-1435852680-31.png)

A typical project is comprised  Master branch - which is always in production (i.e. on Tableau Server), and other branches representing features and fixes. You can represent this process as a network graph that looks something like this.

![Commits](https://cmtoomey.github.io/img/git-1436395964-31.gif)
Courtesy of Mapbox Studio

You branch out, merge in. You can automatically merge - but only if you know your code is up to spec. Otherwise, you’ll use a **PULL REQUEST**. This is the best part - collaborative code review that maintains the history. When everyone agrees - SHIP IT.

In the Tableau world, this means you only ever have to deal with TWBs and datasources. Once you have committed (or merged) to MASTER, publish to Tableau Server from your desktop. Git maintains all the versions and branches, and Server hosts the production version. If you need to make changes: pull, branch, edit, push, Pull Request, merge, publish. No zipping/unzipping required. GitHub doesn't care what type of files it stores, so extracts work too.

###Hold onto your butts - here comes some code

Unlike my previous post, where I used the GitHub app...everything from here on out is going to be on the command line. Why? The application (while great) makes it hard to have the level of control  that we want in our Tableau workflow, especially since Tableau does some funky stuff under the hood.

![CMD](https://cmtoomey.github.io/img/commandline-1435853438-81.gif)
Don't be afraid!

---

###The Setup
I’m assuming you already have Git installed on your machine. If not, [follow these instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). [Windows Users](https://git-for-windows.github.io/) click here. This will install Git on your machine, as well as Git Bash - your command line editor.

{**UPDATE: Since the original post was published, GitHub has redone the look and feel of their repository pages. It's largely the same layout, just more elegant. All the same buttons are there, so don't worry!**}

Go to Github.com (or wherever your repository is going to live). Create an account, or login if you already have one. Click on Repositories, and click on the “New” button. Give it a name (mine is NAME), initialize with a README.MD, click CREATE REPOSITORY. Looks like this:

![Part1](https://cmtoomey.github.io/img/gitrepo.gif)

At the top of your repo will be a section that looks like this. Click the clipboard icon to copy the link to your clipboard.

![Clone](https://cmtoomey.github.io/img/clone-1435854062-40.png)

Somewhere on your computer, create a folder, call it whatever you want (mine will be on my desktop and called GitHubDemo).

####The Command Line

For Mac, open up Terminal (⌘-Space, type “Terminal,” hit Enter) . For Windows, open up the Command Prompt (Windows-button, search “Git Bash,” hit Enter). Navigate to your folder – mine is on my desktop, so the command is: **cd Desktop, cd GitHubDemo.**

>**The Windows Command Line** Because you are using GitBash, and not CMD, you can take advantage of a few cool tricks. If you tuck your folder away on your HD, you don't have to endlessly type cd/whatever to get where you need to go. Find the folder in Windows Explorer and drag it into the command line. If you want to see what's in the folder, type *ls*, it's the same as typing *dir*. Unfortunately, you can't copy and paste like you can in a Mac, you'll have to right-click and select "Paste." The good news is that this is getting fixed (FINALLY!) in Windows 10.

Now that we are in the folder, we are going to do our first Git command: [CLONE](https://git-scm.com/docs/git-clone). Type git clone and paste the link that you copied from your repository. You should see something like this:

![gitclone](https://cmtoomey.github.io/img/gitclone-1435854394-36.gif)

Open your folder and you’ll see a folder with the name of your repository. Open that folder and you’ll see README.MD. (You could just clone straight to the desktop or any other parent folder, but I like to keep a big repository folder that I can clone things into, so I always know where my projects live).

####To tableau - but don't close the command line!!

Start a new Tableau workbook, connect to Superstore (lame, I know), and save the workbook to the folder we just cloned into. Go back to your command line – you will (might) need to navigate down into the new folder – cd Tableau – and type *git status*. If you aren’t in the correct folder, you’ll see ```fatal: Not a git repository (or any of the parent directories): .git```. This usually means you are one level above the actual repository. Otherwise you should see something like this:

![Status](https://cmtoomey.github.io/img/gitstatus-1435854837-77.gif)

We’ve made a change and Git knows. It’s now showing an untracked change in the repository (that’s why it’s red). We want to add those changes to the tracking, commit the changes, and push it up to the repository. To do this, we need three more commands: *git [add](https://git-scm.com/docs/git-add), git [commit](https://git-scm.com/docs/git-commit), git [push](https://git-scm.com/docs/git-commit)*.

There’s a little bit of syntax here that will make life easier:

1. **git add .** (yes, include the period) – this will add all the changes you made to the repository. You can add as many times as you want before committing.
2. **git commit –m “some text here”** – this will commit your changes, basically serving as the next step in the historical record. The –m indicates the message you want to append to the commit, the more detailed the better, so you can remember what is going on.
3. If you forget the –m, you’ll likely see a big blank screen. This is meant for a larger commit message. It’s annoying, and if you land there, hit **ESC:wq** (you need to include the colon).
git push. This pushes your changes up to the remote repository, making it accessible to anyone who is using it.

If you go to GitHub.com, you should see those changes reflected in your repository.
This is the process we are going to repeat as we develop our workbook. Make changes, save, git add, git commit, git push (ACP). Git it? Good.

---

###Now for the fun part - under Tableau's hood

As with all workbooks – you start with Sheet 1. Let’s make it a bar chart -> Customer Segment and Sales. Name it “Bars.” Save. Now open up the TWB in XML and you’ll see what’s changed (I’m going to fold the XML up to make it easier to see).

![FirstChange](https://cmtoomey.github.io/img/firstchange-1435855213-46.png)

Add a second sheet, let’s make a map. State and Profit. Call it “Map” and Save.

![SecondChange](https://cmtoomey.github.io/img/secondchang-1435855259-100.png)

Add a third sheet, let’s do Customer Orders -> Customer Name, Distinct count of Order IDs. Call it “Customers” and Save.

![ThirdChange](https://cmtoomey.github.io/img/thirdchange-1435855288-16.png)

Aha!! Tableau writes it’s worksheets alphabetically, while windows are as they appear in the workbook. Let’s ACP these changes.

---

####SIDEBAR: Calculation Behavior in Tableau
You can find your calculations for searching for the “calculation” tag in the XML. It may live in a <column> tag, but it is slightly different from the rest. First, it has a “caption” attribute, that’s the Calculation Name you see in the UI. Next it has a datatype, format, and name. The Name attribute is important, because it is how Tableau actually references calculations internally. It looks like this **name=”[Calculation_##########]”** and Tableau assigns the number.

Why do you care about this? When you write the calculation, Tableau arranges it in the datasource by the name attribute, not by caption – which means you really don’t have any control over where it lands, line-wise. That means there is more opportunity for merge conflicts. This is compounded when you put the measure in play – it inserts both that <column attribute…> tag and a <column-instance> tag, but it uses the [Calculation_###] reference, not it’s name…so that’s a lot of opportunity for disruption.

---

###LET’S COLLABORATE A LITTLE - AND SEE WHAT HAPPENS

Let’s say that someone else has cloned the repository (or you cloned someone else's) and is doing some work. There’s a few things to remember.

If the datasource is local – your collaborator(s) will need a copy, because we aren’t publishing a TWBX. When they make the change, it will rewrite the <connection> string in the <datasources> section of the XML. What this means is that every time they push changes, and you pull them, you'll have to re-locate the datasource.

**BEST PRACTICE** Either publish your data source to server, connect to a database, or put an extract/copy in your repository. You can set the master on publish.

When it comes to collaboration, there are really only two types of workflows: Back-and-forth and parallel.

####Back-and-forth
Here’s the next git command you’ll need to know: [pull.](https://git-scm.com/docs/git-pull)

You do some work, GitACP. Your collaborator does *git pull*  to get those changes and then does work, save, GitACP. Rinse/repeat. Everything should be ok. You can distribute the work, but it’s is pretty boring and you don’t get the time savings of everyone working on something at the same time.

![PushPull](https://cmtoomey.github.io/img/pushpull-1435857794-52.png)

####Parallel
Just imagine – a distributed team, working on a single workbook, never having to paste datasources, worksheets, or dashboards. Just pull and push and everything will be great!

Not quite.  Everything you’ve done to this point still applies, but when work is people are working on the same sheets at the same time, there’s always the possibility for a conflict.

**Example**: Let’s just say that you and your collaborator both change the order or the worksheets (Why? I don’t know – some people are picky about workbook layout). You put “Map” first and they put “Customer” first. Person A pushes and its accepted. Person B pushes, gets an error like this. It tells you to pull first, because you are out of date, and when you do you get a **MERGE CONFLICT**.

![Conflict](https://cmtoomey.github.io/img/mergeconfli-1435856042-41.png)

What’s going on here? Git treats all changes equally, so if two people make a change to the same line and commit them, it doesn’t have any logic for saying who’s edits should win. If you open your workbook in your IDE (after you see the CONFLICT error), it will look something like this.

![ConflictTab](https://cmtoomey.github.io/img/mergeconfli-1435856077-3.png)

Anything between the **<<<<<<< HEAD and =======** indicates your changes. Anything between **======= and >>>>>>> 8fcc4064a9f041b8bd40e74d9e017d5ccf91a328** are the other person’s changes. You have to go through and manually resolve the order. Anything between **>>>>>>> 8fcc4064a9f041b8bd40e74d9e017d5ccf91a328 and <<<<<<< HEAD** is common to both – you can leave that alone.
So how do you fix it? You have three options.

BUT, before you begin – you actually have to figure out what the right answer is. This might be the best part about using Git with Tableau – it will force you to actually collaborate with your peers. You aren’t just sharing code, but talking about what you are doing and more importantly, why you are doing it that way. Everybody learns how to do things better.

####First Fix - Manual Delete, Copy, Paste
This method is no fun, but you should start here anyways.

Assuming you want to keep everything, you’ll need to hold on to the stuff you are cutting out, so you can reassemble it later.

**EASY**: Let’s assume we are going to keep your changes and then move the other person’s changes down. All you have to do is delete the portions between the tags that reflect the incorrect code. In this case, just delete everything between  ======= and >>>>>>>. Because nothing is net new, this will resolve your issues. Now just GitACP and done.

**HARD**: If there are more complicated edits (beyond the simply renaming case we detail here), you’ll need to get your hands a little dirty. Inside of your IDE, open a new file (doesn’t matter what kind) and start cutting and pasting the “other” content in. This is where the common elements are helpful, you can use those to fill in the gaps between conflicts. Assemble a full set of text between tags, and just paste it at the bottom (i.e. paste a <worksheet> between <worksheets>). If it feels like you are doing UNION operation in XML, it is. Do that for all the sections with the conflict tags.

When you are done with this, I would recommend using your IDE’s Beautify package ([Brackets](https://github.com/brackets-beautify/brackets-beautify), [Atom](https://atom.io/packages/atom-beautify)). This will auto-align your code for you - making it both easier to read and matching the source format (that way Tableau doesn’t break when it opens). Plus, if the XML moves out of whack when you Beautify, you know something is wrong.

####Second Fix - Merge Tools
If you don’t want to wade through lines and lines of code (who does?) - there are a number of tools that can help you quickly find and correct merge conflicts. I recommend either [Deltawalker](http://www.deltawalker.com/) or [KDiff3](http://kdiff3.sourceforge.net/). If you want to use something else, you need to make sure it supports 3-way editing (Original + Edited + Final). That way you can see both sides of the merge and what the final will be - otherwise, you’ll be flying blind when you clean up the merge.

Once you have picked one, you need to tell Git to make it your merge tool. In your terminal type *git config --global merge.tool <tool>*. Now, when you have a merge conflict, simply type [git mergetool](https://git-scm.com/docs/git-mergetool) and it will open your tool of choice (when a merge conflict is present).

![Mergetool1](https://cmtoomey.github.io/img/2-1436387463-50.gif)

KDiff’s bottom section is what wins it for me - I can edit in place, from all three options. That way, if I have easy edits, I can just pick which side. If I need to move content around (to stack worksheets around, for example), I can quickly navigate to where I want to go, copy, paste, save, done.

####Third Fix - Script it
I told you there would be some code. We’ll use the <thumbnail tag> as an easy example of how this method works. I’m going to use the [Python Element Tree](https://docs.python.org/2/library/xml.etree.elementtree.html) module to do my XML editing.

#####The ```<thumbnail>``` tag

What you will notice as you go through this process is the ```<thumbnail>``` tag with lots of characters. This is a binary encoding of an image and changes all the time. This means it’s probably going to generate a ton of merge conflicts. The good news is that you can delete everything between the ```<thumbnails></thumbnails>``` tags and the workbook will stay functional.

Since it’s basically worthless, can we get rid of it automatically? YES. How? Git Hooks. **WARNING: Git Hooks are local - they don't come with a clone. You'll have to put them in each time - and make sure your collaborators have them as well. Otherwise, you'll be pumping out scripted edits, and they'll have no idea.**

Hooks are a handy feature - custom scripts you can fire at certain points in the Git workflow. They all live in the .git/hooks directory of your repository. There are two categories of hooks: client-side and server-side (which just determine where the script actually runs). I’m going to focus on client-side. Within this category, we have [9 options](https://www.atlassian.com/git/tutorials/git-hooks/local-hooks). I’m going to use the pre-commit hook, since it runs as soon as I type git commit, but before the commit message. To accomplish this, I’ve written a very basic Python script.

<pre><code data-trim class="python">
    #!/usr/bin/env python#
    These are the tools you need to do all the things
    import xml.etree.ElementTree as ET
    import subprocess
    import osimport glob
    # This gets the current working directory
    wd = os.getcwd()
    # We are going to search for TWB, so we put store that for later
    pattern = ‘*.twb’
    # Since we run this after git add, we need to undo those changes
    subprocess.call([”git”,”reset”])
    # Now we find all the files in our folder that end in TWB
    for name in glob.glob(wd+”/”+pattern):    
    # Then we parse them into the XML tree    
        tree = ET.parse(name)    
    # Then we get the root directory    
        root = tree.getroot()    
    # Then we find all the thumbnails tags    
        thumbnails = tree.findall(‘thumbnails’)    
    for thumbnails in thumbnails:        
    # Then we find all the thumbnail tags        
        thumbnail = thumbnails.findall(‘thumbnail’)        
        for thumbnail in thumbnail:            
    # then we delete the thumbnail tags            
            thumbnails.remove(thumbnail)    
    # Then we overwrite on top of the other file    
        tree.write(name)    
        break
    # then we re-do our git add so the commit works correctly
    subprocess.call([”git”,”add”,”.”])
    # because this all happens before the commit message, everything gets captured correctly
</code></pre>


Now navigate to your local repository, find .git/hooks/pre-commit.sample. Rename the folder to pre-commit, paste in that code and you are good to go. Every time you make a commit, it will strip out the thumbnails so you don’t have to worry about them creating merge conflicts anymore.

I used it to find and replace a single tag, but there’s no reason you couldn’t do things like style tag replacement (hello style guides) or even automate merge conflict resolution (since the << == >> syntax remains the same, you just have to find and store XML snippets for later use).

###HOME STRETCH

We’ve covered about 85% of how to merge GitHub & Tableau’s Flow. However, everything we’ve done is a straight-line along the MASTER branch. To do GitHub + Tableau right, you want to incorporate branches and rebasing.

Why? Remember, anything on MASTER should be in production...but not everything is ready to go all the time. There's QA, UX, new features, calculation checking, etc. We don’t really want to edit against the master, so Git provides us with the handy concept of [branching](https://git-scm.com/docs/git-branch). This allows you to then checkout that branch and do work without affecting the production version.

When you are done, you push your work, and then submit a [Pull Request](https://help.github.com/articles/using-pull-requests/). This allows you to discuss the work with your team, make changes, and then merge it back into MASTER. That's collaboration, son.

But what if you are doing work on a branch, and something happens to MASTER (someone changes the style guide, or something breaks and gets fixed)? Initially, you will be behind the curve - but you can use [rebase](https://git-scm.com/docs/git-rebase) to catch up. Let’s see it in action and call it a day.

####Branch

You’ve got your Tableau workbook all ready to go. We want to explore some data, but not sure it needs to live in the production workbook...so let’s branch our workflow.

In our Terminal, type *git branch experiment* (you can call it whatever you want). This will create the branch, now we want to use it - to get on the experiment branch, type *git checkout experiment*. You’ll get a notification that you have switched. Now you need to push that branch to GitHub: *git push origin experiment.*

Open your workbook and create a worksheet called “Numbers.” I added Customer Segment, Container, and Sales on Text. Save. GitACP. Now go to GitHub and on your repository page, you can see both branches. If you don't believe that branching is actually working, after you commit, close Tableau, do git checkout master, Open Tableau. "Numbers" won't be there.

![Branch](https://cmtoomey.github.io/img/screenshot-1436396872-16.png)

Those two green buttons are how you initiate a Pull Request. The little one on the left will give you a dialog that compares changes, tells you if the changes can be automatically merged, and allows you to open the Pull Request. The button on the top right jumps that page and goes straight to the request page. Click either one.

Now you have to give the request a title and explain what you did and why it should be merged. That way, the reviewer can know what to look for. Once you are done, it can be reviewed and merged. Once the conversation is complete, you can SHIP IT (meaning merge it in).

![Convo](https://cmtoomey.github.io/img/screenshot-1436397283-80.png)

Hit Merge, comment, and Confirm. Done. Now delete the branch and everything is so fresh and so clean clean. You’ll want to do a pull the next time you open your Terminal so you can get all the changes from the new branch. Also, delete your local copy of the branch with *git branch -D <name>*.

####rebase

Last step. Here’s the setup - let’s say you’ve successfully built a branch, just as I describe above. You are doing work, but then you find out that someone went and made changes on MASTER (someone probably wanted different colors on the map or something). Your branch is now behind MASTER, and you don’t want to start over.

![Rebase](https://cmtoomey.github.io/img/screenshot-1436392455-38.png)

You can use git rebase to rewind your branch commits (your changes MUST be committed), fast forward to the end of MASTER (or whatever branch you are on), and then apply the commits on top. **WARNING: These changes are subject to line in/out comparisons and could result in merge conflicts. It all depends on the nature of your changes.**

Checkout your branch and add a sheet. I added Shipping: Container + Shipping Costs. Git add, commit, **don’t push**. Now we find out that someone didn’t like the colors on the bar chart, so they changed them to orange and blue. You always want to be up to date, so how to get those changes?

While on your current branch, you need to get the updated content from MASTER, so run *git fetch origin*. That will bring the updated changes into your branch, so you can rebase against them. Now run *git rebase origin*. You can also run *git pull --rebase origin master*. Here’s a sample output

![Rebase2](https://cmtoomey.github.io/img/screenshot-1436399757-24.png)

Now your workbook is up-to-date, push your commits (you might need to push with *git push --set-upstream origin <name>*) and submit a pull request.

###THAT’S GITHUB+TABLEAU

Thanks for sticking around. This should be enough to get your started on your GitHub journey. You may run into some issues with more complicated workflows. For more help, check out these [videos](https://www.youtube.com/playlist?list=PLg7s6cbtAD15G8lNyoaYDuKZSKyJrgwB-), StackOverflow, GitHub directly, or ask the Twittersphere - we’re all here to help.

In case you were wondering, the graph of this blog looks like this.

![Graph](https://cmtoomey.github.io/img/screenshot-1436400484-49.png)

If you have any questions, feel free to ping me on Twitter!
