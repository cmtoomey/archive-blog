---
layout: post
section-type: post
title: A Sith Tableau Server
category: server
tags: [ 'automation', 'hacks', 'tutorial' ]
---

Before TableauCon2015 (or #DATA15 for the Twitterati), my colleagues and I went looking for better ways to do all things Tableau Server. Having spent many hours clicking and waiting, I knew there had to be a better way to deploy, administer, and upgrade Server.

Taking inspiration from the web-application community (specifically Heroku - where you get a button to deploy everything all at once!), we built an application that allows you to fully automate your Server experience. It's called LaunchPad (although the name is going to change, stupid Business Objects trademark), and it's a one-stop-shop for all your deployment (on AWS) needs.

In doing that project, I was asked about how to provide similar administration for on-premise or hybrid deployments of Server. Not every wants to use the cloud, and I'd wager that most Tableau Server customers can go and physically touch the box their machine. It is an interesting challenge - how do we take what we know about automating Server, and provide a frictionless method (meaning access needs to be automatic so that it can be scripted and executed remotely and unattended) for administration?

You want remote access, full automation, and the easier interactions with your Tableau Server? Let's bend Tableau Server to our will.

---

#Welcome to the Dark Side

![Vader](https://cmtoomey.github.io/img/vader.gif)

###Warning: Everything below this line is completely unsupported!

If you are like me, I want to automate everything, and Remote Desktop is such a pain. I want to write a script, schedule it, and run it from anywhere - for all the things.

<span title="You can also do this with Powershell">Today, you'll see that [three letters](https://technet.microsoft.com/en-us/magazine/ff700227.aspx) will set you free from (almost) everything that is painful about Tableau Server.</span>

##SSH

SSH stands for [Secure Shell](https://en.wikipedia.org/wiki/Secure_Shell) and it's a method to login and execute commands remotely. Once you are authenticated, you can run programs, download and install software, and transfer files (among many other things). These connections are encrypted via a public key system, so only the NSA is listening. You never have to use Remote Desktop again. SSH + tabadmin solves (almost) everything.

![impossible](https://cmtoomey.github.io/img/impossible.gif)

Here's an example. Let's say you're getting ready to add SSL to your Server. Normally your workflow would look like this:

1. Put the certificates in a network drive (you might even be tricky and have Server's file system mapped onto your machine)
2. Remote into your machine
3. Create an SSL folder
4. Copy the certificate into \\SSL
5. Stop the Server
6. Open "Configure Tableau Server"
7. Update the SSL Tab
8. Start Tableau Server
9. Close your Remote Desktop Session

With SSH, here's your workflow

1. Open your command line
2. Type SCP [File1] USERNAME@machine.com: "\\Tableau\\TableauServer\\SSL"
3. Type SSH USERNAME@machine.com
4. Use the following script

<pre><code data-trim class="batch">
tabadmin stop && tabadmin set ssl.enabled true && tabadmin set ssl.cert.file [\Path\to\CRT] && tabadmin set ssl.key.file [\Path\to\KEY] && tabadmin configure && tabadmin start

</code></pre>

![Done](https://cmtoomey.github.io/img/palpatine1.gif)

Here's how it works.

---

###Installation

To start, you'll need to access to a Tableau Server. Any version, doesn't matter (just not your production box). I know I said you wouldn't have to use Remote Desktop ever again, but that's not entirely true. You do only have to do it once.

Install, and get onto your desktop. Next, you need to download the SSH server software. For this, I'm going to use [Bitvise SSH Server](https://www.bitvise.com/ssh-server-download). There are a few others, but this one was the easiest to setup and use. For testing and non-commercial uses, it's free (although you lose out on a few enterprise-grade features). To use this for reals, you'll need to pony up $100 + tax (so have your friends in OR hook you up).

Installation is fast (this is in realtime)

![Install](https://cmtoomey.github.io/img/sshinstall.gif)

You need to remember to start the server when you are done, and to make sure your machine's firewall is accepting connections on port 22 (the default SSH port). The good news is that, using default settings, traffic on port 22 will not conflict with Tableau Server's [default port requirements](http://onlinehelp.tableau.com/current/server/en-us/ports.htm).

Now that the server is installed and running, you need to get yourself setup.

---

###Setup

To actually use SSH, you need a client that can run the SSH protocol.

Life is a little bit different for Windows and Mac users, so I'll cover both separately.

####Mac users

Hit ⌘ - Space and type Terminal. That's it. OSX is built on UNIX, of which SSH is a core service, so Terminal can handle SSH out-of-the-box. This is what I'll be using for the rest of this post.

####Windows users

Life is a little more complicated for Windows users. You can't just open CMD and type SSH, you need another piece of software. There are lots of options, but FREE is always better, so I'm going to show you how to use [Cygwin](https://cygwin.com/install.html). Cygwin is a group of tools that give Windows users a Linux-like experience. Like Bitvise, it's straightforward to get setup. **Note: there is a free version, which I'll be showing you, but also a commercially-supported one by [RedHat](http://www.redhat.com/services/custom/cygwin/).**

+ Download the EXE (setup-x86.exe) from the Cygwin website.

+ Run the EXE and follow the prompts - I'm going to use the defaults for the root directory but you can put it wherever you are comfortable (or have permissions).

![root](https://cmtoomey.github.io/img/root.png)

+ Specify Direct Connection and pick a mirror that is close to you, or in your same country (I used http://cygwin.mirror.constant.com)

+ By default, you'll get a bunch of packages (like SSL, which we'll use in a minute). We need to add SSH. In the search box, type SSH and then select all the packages that appear. You'll also want to add SCP, WGET, and CURL the same way.

![Packages](https://cmtoomey.github.io/img/cygwin.gif)

When you are done, use the Start Menu shortcut to see if it works. We are going to run a PWD to print the working directory and then SSH to make sure the packages were installed correctly. (**Don't delete the installer, you'll need it to add more packages**)

![test](https://cmtoomey.github.io/img/cygwintest.gif)

You can now use the Cygwin terminal for everything from here on out...**BUT** that's a whole bunch of extra clicks, why can't we just use those fancy new commands inside of your bog-standard command line. YOU CAN!

Open up your command line and type the following (adjusting the path for wherever you installed Cygwin):

    set PATH=%PATH%;C:\cygwin\bin

When you've done that, type ssh and see what happens.

![path](https://cmtoomey.github.io/img/cygwinpath.gif)

Now you can do all your favorite windows and Linux-like things from your command line.

---

###SSH in action

Now that you are all setup, let's take our new toy for a spin. You need three things to make this work:

1. The Username you will be logging in with
2. That user's password
3. DNS or IP address of the machine

Once you have those, open your terminal and type

    ssh USERNAME@machine.com

![initial](https://cmtoomey.github.io/img/ssh.gif)

You might get a prompt saying that the authenticity of the host you are attempting to connect to cannot be established. That's basically SSH's way of saying **"Here be Dragons, you still good?"** Type yes, and the next time around, you won't be prompted. You're storing that host's information in a file called known_hosts.

Now that we are in, let's check on the status of our Tableau Server.

![status](https://cmtoomey.github.io/img/status.gif)

That's cool - [tabadmin is everywhere](https://cmtoomey.github.io/automation/2015/10/07/tabadminpath.html). Now you can do whatever you want on the machine. If you don't want to read my previous post, just use the same command you used for adding Cygwin to the PATH.

That process is all well and good, but if you are anything like me, I forget my passwords all the time. Especially if they are super-strong like the ones auto-generated by AWS. What if there was a way for my Tableau Server to create trust with me and my machine so that I could just type ssh USER@machine.com and do stuff? Like a permanent, encrypted, Trusted Ticket that's way more secure than a goofy password.

You're in luck - SSH is designed to do just this. It's called Public Key Authentication.

---

###Creating and Deploying a Public Key

Here's how this works. You are going to create a keypair, with a public half and a private half. We are going store the private half on our machine, and place the public half on the remote machine we want access to. SSH will read your private key, check it against the public key, and if they match, you are authenticated.

The general process is as follows:

1. Create a keypair
2. Move the private key to a file called "authorized_keys" that lives within a .ssh folder in the HOME directory. In our case that is C:\\Users\\Administrator. We'll need to create that and then hide it so people don't go poking around where they shouldn't be.
3. Get BitVise to associate the keypair with the Windows account we are logging in with (this is a Windows thing).

1 & 2 can be done via SSH and a fancy command called SCP (Secure Copy); 3 can be achieved via BitVise's [command line interface](https://www.bitvise.com/ssh-server-guide-scriptable), also managed via our SSH session.

Ready?

####Create a keypair

I'll walk you through the steps, which I found in this handy video from [Tuts+](https://www.youtube.com/watch?v=-J9wUW5NhOQ).

Navigate into a directory that you feel safe storing these keys. I'm using my .ssh folder (type cd ~, cd .ssh or c:\Users\USERNAME on Windows). If you are on Windows, you might not have a .ssh folder. You can create one, and then make it hidden (so people don't accidentally stumble on your keys)

<pre><code data-trim class="bash">  
mkdir .ssh
attrib +h “C:\Users\USERNAME\.ssh”

</code></pre>

Now that you are in the right folder, let's make some keys. Here's the command

<pre><code data-trim class="bash">  
ssh-keygen
</code></pre>

You can use the defaults for the keyname. When you get asked for a passphrase, you can include one for added security. You will be prompted for this passphrase when you use your key, but this is a demo, so we're going to skip it. It will look like this:

![keygen](https://cmtoomey.github.io/img/keypair.gif)

Once you are done, if you are interested in what a keypair actually looks like, you can type

<pre><code data-trim class="bash">  
cat id_rsa
cat id_rsa.pub

</code></pre>

That's it, you're all keyed up. Now the homestrech, making BitVise recognize the key.

####SSH + SCP FTW

To do this, we need to make a few changes to BitVise on our Tableau Server and then copy our key over. Specifically, we need this box to get checked.

![sync1](https://cmtoomey.github.io/img/bitvise1.png)

As I mentioned earlier, BitVise has an excellent command line interface for doing this sort of thing (and it's a great example of how easy it is to make changes to a remote machine without RDP).

1. Open Terminal and SSH into your machine - you'll have to use your password, but this will be the last time.
2. CD into the folder where BitVise lives. In this case it's \Program Files\BitViseSSHServer, you'll need to run cd \ and then navigate
3. We are going to use a built-in tool called BSSCFG, which allows us to make the changes we need. Here's the commands

<pre><code data-trim class="bash">  
bsscfg settings importText -i
access.authKeySync true
commit

</code></pre>


Here's the process

![config](https://cmtoomey.github.io/img/ssh1.gif)

and the end result

![result](https://cmtoomey.github.io/img/bitvise2.png)

Don't end your session, we need to make one more change - adding the .ssh folder to your user account.

1. Navigate back up to the C:\ directory
2. Navigate to C:\Users\Username
3. Type the following (just like in the Cygwin example)

<pre><code data-trim class="bash">  
mkdir .ssh
attrib +h “C:\Users\USERNAME\.ssh”

</code></pre>

Like so:

![sshfolder](https://cmtoomey.github.io/img/ssh folder.gif)

Now close your session. We are going move your id_rsa.pub file to the .ssh folder and add it to a file called authorized_keys. Once we are done, you (and only you) will be able to access your Tableau Server remotely.

1. Open your Terminal.
2. Navigate to .ssh
3. Type the following

<pre><code data-trim class="bash">  
scp id_rsa.pub USERNAME@MACHINE.com:"C:\Users\USERNAME\.ssh\authorized_keys"

</code></pre>

That will copy id_rsa.pub into the folder you just specified, with the filename authorized_keys.

![keys](https://cmtoomey.github.io/img/keys.png)

Now the moment of truth. If we did everything correctly, the next time we type ssh USERNAME@Machine.com, we should be logged in directly.

Let's give it a shot.

![boom](https://cmtoomey.github.io/img/sshfinal.gif)

---

Now you have complete remote access to your Tableau Server, and can do all kinds of fun stuff with it. Perhaps as a test, you should take the Cygwin installer you downloaded earlier, and see if you can get it running from the command line. Here's a hint:

    setup-x86.exe -q -s “http://cygwin.mirror.constant.com”
    set PATH=%PATH%;C:\cygwin\bin

Welcome to the Dark Side.

![sith](https://cmtoomey.github.io/img/vader1.gif)
