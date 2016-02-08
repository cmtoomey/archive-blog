---
layout: post
section-type: post
title: Tabadmin Everywhere
category: automation
tags: [ 'automation', 'server' ]
---

<div class="titleheader">
  <img src="https://cmtoomey.github.io/img/bb8-1444240686-65.gif" alt="..." />
  <div class="titletitle">
    <h3>BB8 agrees, you should automate more!</h3>
  </div>
</div>

---

# Confession: I think Tableau Server is clunky

In a perfect world, Tableau Server would allow me to do the following:

1. Automate all my administrative tasks - that includes deployment and maintenance. It should be so easy a robot can do it.
2. Server installation, upgrades, and integration with third-party services should be as easy as shopping on Amazon. Search, select, deploy.
3. Tableau Server downtime should no longer be a thing.
4. I should never have to use Remote Desktop. ***EVER!***

But unfortunately, it does none of those things. So I decided to make Tableau Server do all those things.

### Wait a minute - that sounds like Tableau Server on Linux!

In principle yes. I'm sure Tableau has a full port of Server to Linux on it's roadmap, unless [Tamas Foldi beats them to it](http://databoss.starschema.net/tableau-server-on-linux-data-engine/). Even then, not everyone will migrate immediately, and nobody should be left out.

Tableau already has a tool, TABADMIN, to help with one-off administrative tasks, so let's start there.

---

There's a great video on [Automating Tableau Server](http://tableauafterdark.com/2015/09/are-you-backing-up/) that is a great place to start. To the authors' credit, being able to script and schedule things like backup, ziplogs, and cleanup is the right way to go. If you look carefully, you'll see one glaring issue:

# Tabadmin is tedious

Everytime you want to use it, you have to type in the same commands to navigate to the Server\\Version\\bin directory. Then do all kinds of copy, move, and delete actions to get things where you want or need them. This is a recipe for pain - all because TABADMIN isn't a first class citizen.

You should be able to just type *TABADMIN [WHATEVER]* and do whatever you want. If that was possible, then you could just navigate to any location you want, run *TABADMIN [WHATEVER]* have the output deposited right there. **PLUS,** you don't have to deal with as many character escapes or hard-coding of directories. Just type and go.

How? Just follow these **FOUR EASY STEPS**

**1. Create a one-line batch file** - Open up Notepad, Wordpad, Atom, Brackets, or your favorite text editor and type the following:

    @"C:\Program Files\Tableau\Tableau Server\9.1\bin\tabadmin.exe" %*

You will have to adjust the path to fit your installation of Tableau Server. I always install on C:.

**2. Save it as tabadmin.bat**

**3. Move it to C:\Windows\System32**

**4. Open your command line and type tabadmin -h** - like so (be patient, I was running Tableau Server on a very tiny box):

![tabadmin](https://cmtoomey.github.io/img/tabadmin-1444238541-98.gif)

What is going on here? You are putting tabadmin on your **[PATH](https://en.wikipedia.org/wiki/PATH_(variable))**, an environmental variable that tells Windows where certain executables live, so they can be called anywhere. The standard PATH is SYSTEM32, which means that Windows is looking there when you type into the command line. By putting the shortcut batch file into SYSTEM32, the command line knows that tabadmin = tabadmin.bat, which is mapped back to 9.X\bin.

### So how to automate?

Now we can run all admin functions from anywhere on the command line, we can put our outputs wherever we want. Backups and logs are no good sitting in the \bin folder. I don't want to write the extra lines to move it somewhere, I just want it to be somewhere useful so let’s use Dropbox. (**WARNING - Dropbox is for example only. You'll probably want to use a network drive because Server backups can be BIG!**)

While on your machine, sign up or sign into Dropbox and [download the installer](https://www.dropbox.com/install). This will map a local folder to your machine and will sync to your Dropbox account, and be available anywhere.

### SCRIPT IT!

<pre><code data-trim class="bash">  
cd C:\Users\USER\Dropbox (or whatever your network folder is)
tabadmin backup -d
tabadmin ziplogs mylogs.zip
tabadmin cleanup

</code></pre>

Save it as backup.bat (or something easy to remember). When it runs, it will put everything in Dropbox for easy access.

Let's go one step further and make things even simpler.

<pre><code data-trim class="bash">  
#cd C:\Users\USER\Dropbox (or whatever your network folder is)
tabadmin backup -d
tabadmin ziplogs mylogs.zip
tabadmin cleanup

</code></pre>

Comment out the first line, and save backup.bat to Dropbox. The folder that gets created upon installation is considered LOCAL on every machine you have connected to Dropbox, just like a network drive. oNow you have automatically distributed it everywhere Dropbox lives, and when you run backup.bat, you'll get your backup file in an easy to share location. Don't like Dropbox? Use a networked drive or any other cloud-based storage solution.

Here's the best part, you can edit your script from your own machine, without going through Remote Desktop. Just map the folder and open the script. Update in place!

### Schedule it!

Let's add one more key feature: scheduling. We can add the script to the Task Scheduler and have it run on whatever interval you want.

[Here's how](http://windows.microsoft.com/en-US/windows/schedule-task#1TC=windows-7):
1. Open Task Scheduler (it lives in the Control Panel or you can just press the Windows Button and type "Task Scheduler").
2. Click Action and "Create Basic Task"
3. Give it a name and click "Next"
4. Give it a schedule - let's just say weekly
5. Browse to your newly-created backup.bat file
6. Click "Finish"

That's it - now you can run any tabadmin task you want, schedule it, and add tasks without ever leaving your desktop!

---

Up next (eventually): What sort of things can TABADMIN do?
