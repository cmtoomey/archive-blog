---
layout: post
section-type: post
title: Tableau XML Let's Git Started
category: Tutorial
tags: [ 'git', 'XML' ]
---

After spending time with Tableau's XML in the previous post, you probably thought, “why do I care about this? I can do everything I need inside of Tableau Desktop.”

That may be true, but what if I told you that you can have REAL Tableau version control AND collaborate with anyone, all because of that XML. How?

![Octocat](https://cmtoomey.github.io/img/cat-1434652245-28.png)
*Octocat to the Rescue*

**TL:DR** Tableau is XML (which is code). GitHub is a repository for storing and managing code as it is produced. Tableau + Github = a place to store all your Tableau work, track your changes, and share with others. Oh – and you can automate the flow of data to and from GitHub.

### What is GitHub?

GitHub is a web-based code-sharing and repository (or repo for short) service. At the core of GitHub is Git - a version control system that allows users to clone a repo to your local computer (that’s where your project lives), make and save edits, and then upload your changes. GitHub also provides access control and collaboration features so that users across the world can work on the same project simultaneously.

Each set of changes is called a [commit](https://git-scm.com/docs/git-commit). Committing requires annotation of the changes and every commit, with the line-by-line differences from the most recent commit is tracked by the system. This means you can easily revert to a previous version if a change breaks something.

You can also create [branches](https://git-scm.com/docs/git-branch), which are parallel paths used for new features or tests. Once a branch is compete, it can then be [merged](https://git-scm.com/docs/git-merge) back into the master. Merges can be done automatically, but when other people are working on the same codebase, the best practice is to ask for a [pull request](https://help.github.com/articles/using-pull-requests/), so that other people can check your work before it gets integrated.

### Flowing with GitHub
GitHub has spent some time thinking about how to do work efficiently. Their easy-to-follow solution is called the [GitHub Flow](https://guides.github.com/introduction/flow/index.html). The basic premise is that your core work lives on *master* and all updates or other features live on *branches*. This way, you can always work, test, make updates, and publish fast. It supports individual and team-based projects and ensures that everyone's work gets checked, but can be fixed fast if necessary.

It looks something like this:

![GitHubFlow](https://cmtoomey.github.io/img/githubflow-1435852680-31.png)

There are a few rules:

1. Anything in the master branch is production ready.
2. Create a branch for anything new - like a new dashboard - and give it a descriptive name.
3. Do your work and commit your changes with well-written descriptions.
4. Open a Pull Request so others can review your work.
5. Have a real discussion.
6. Merge and deploy to production.
7. Rinse and Repeat.

### So how does one get started with GitHub?

It's possible that you already have Git installed on your computer. To make things easier, you can get a copy of GitHub's new desktop client for either [Windows or Mac](https://desktop.github.com/).  Install the client and sign up for a GitHub account. If you aren't prompted, you can go [here](https://github.com/) to sign up.

You can start your own repo, or you can leverage other people's work. Before we start our own project, let's start with some existing work.

#### Cloning and Forking: Jump right in!

[Cloning](https://help.github.com/articles/cloning-a-repository/) a repo downloads a complete copy of the project directly onto your desktop. You can only clone if the repo is public or if you are a listed contributor on the project. All your commits are pushed up to the original repo, so it is best to branch off so as not to mess up the original work.

[Forking](https://help.github.com/articles/fork-a-repo/) puts a copy of the repo into your GitHub account and you can clone directly from there. All your work is then pushed up to your repository. If you think your work should be added to the original, you can still submit a pull request. For example, the design of this blog is a fork of the original author's, and I just modified the styling.

Anyone can clone, fork, or contribute with just a few clicks. **It's collaboration all around!**

#### Starting your own project

Before you can do anything, you need a place to put your stuff, your very first repo.

![Repo](https://cmtoomey.github.io/img/gitrepo.gif)

On your GitHub page, create a new repository. Give it a name, a description, check “Initialize this repository with a README,” and click “Create Repository.” That will take you to your repo page, which will look something like this.

![RepoPage](https://cmtoomey.github.io/img/repo-1434652646-45.png)

Click on “Clone in Desktop” and you are ready to get started!
Now, go do some Tableau work and save your TWB(X) into the repo folder you made on your computer. Immediately after, if you go to your GitHub Desktop application and you’ll see something like this:

![GitHub1](https://cmtoomey.github.io/img/firstcommit-1434652695-93.png)

In the bottom right, I added a note with a description to my change. This is called a commit message, it helps others know what changes I made. When I make my commit, it adds all the changes into a single block. I can stack commits, each with their own message, which creates the historical narrative of the project.

All of these changes are made to my local repo. If I click on History, I’ll see that change. The left side of the screen is the history; with the right side being the set of changes, user name, commit ID (for version control), and time. The circle indicates that it’s unsynced with my actual repo on GitHub.

![CommitList](https://cmtoomey.github.io/img/commitlist-1434652728-51.png)

If I want to change the color scheme from Green-Red to Blue-Red, I'll see this after I save:

![Commit](https://cmtoomey.github.io/img/commit-1434652804-46.png)

What you are seeing is the updates to the XML – the green section is being the changes and the red section is what the TWB used to have in it. Now I commit those changes. and my worksheet is ready to go.

In order to sync it with my repo, I just click SYNC button in the upper-right-hand corner. Let’s see what that looks like on GitHub.com.

![OnGitHub](https://cmtoomey.github.io/img/github-1434652833-30.png)

You can see my most recent commit in the comment. If I click on it, I can see the actual XML. Above it, you’ll see this:

![topline](https://cmtoomey.github.io/img/topline-1434652875-93.png)

+ Raw will open up the XML in your browser, quite ugly (hence the name).
+ Blame will open up the commit and all the details about it, primarily who did that work
+ History will show you all the commits. You can see the XML at every phase if you like.

I can get a similar view in my GitHub application, simply by clicking on History. I can then click on a commit, hit the gear icon and roll back my repo to that version. If I revert to the “Added Sales Map,” and then open Tableau, my map is back to Red-Green. This doesn’t count as a commit, but will be logged as a change that needs to be synced.

>*Please be careful with this! Remember, because we are using the GitHub Flow – anything that’s in the master branch should be production ready. That’s why you go through the process, to make sure you don’t have mistakes in a production workbook…but you can fix it if you absolutely have to. That’s one downside to using the application, typically you have to run this from the command line, which puts an intermediate layer between you and revising history.*

Ok – that’s enough to get started with. You know the basics of GitHub and how to get started with it using Tableau. There’s a lot more to come in – branching, merging, collaboration, and how to handle conflicts. I’ll also go through how to use the git command line (gasp!) – which is essential for doing some advanced workflows.

> ##### UPDATE: While Tableau announced Version Control at #DATA15, my personal opinion is that this is equivalent to saving V1, V2, V3 of your workbook...except it's being saved on Tableau Server. Hopefully they are only managing diffs between workbooks! We still don't have a solution for true multi-user collaboration on a workbook...hence the continued existence of this post!
