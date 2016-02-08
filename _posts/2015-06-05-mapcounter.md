---
layout: post
section-type: post
title: Native Filled Maps?
category: Mapping
tags: [ 'maps', 'firebird', 'hack' ]
---
## A Counterpoint: It's either ok to hack, or its not.

First, credit where credit is due. Cheers, Craig!

![Toast](https://cmtoomey.github.io/img/cheers-1434653852-61.gif)

That is an excellent showcase of Alteryx+Tableau solving a very real (and very frustrating problem). If you don’t know what I’m talking about - [go read it and](http://www.theinformationlab.co.uk/2015/06/05/using-alteryx-to-create-tableau-filled-maps/) come back.

As a token of my appreciation, I’ve got a small gift for you and your readers. But before I hand it over (and it really is a token) - I’d like to present a few counterpoints.

### The world changes, but it really stays the same

I get that Tableau doesn't support the same geographic hierarchies for everywhere in the world, but that's just a matter of time and available data. If you need that information, pull it off of [OpenStreetMap](http://overpass-turbo.eu/) and then write it directly into Firebird. Or better yet, contribute that data into OSM and then tell Tableau it's ready to go. That helps everyone.

Maps, by their very nature, don’t change all that much. Borders are relatively static, as are most other governmentally defined geographies. Points of interest, like parks and airports, don’t exactly move around, and adding them in seems to save only a marginal amount of time. If the world isn't actually changing fast enough to affect the interpretation of data, how much detail I actually *need (not want)*?

If that information is present on the basemap, that should be sufficient context to plot data on top of. The need vs want discussion is important given the size constraints of Tableau’s Firebird DB - more date = more size. But seriously, if your governmentally-defined geographies don't exist, go get or make them yourself, use Craig's module and then share the expanded DB.

Custom geography is a whole other story. Their role in a particular analysis or reporting environment needs to be carefully considered - how detailed are your shapes; do you need to integrate that spatial data with business data; joined or blended. What they are meant to do or help achieve relates directly to how they should be presented. Making it easier to get them into Tableau from external workflows is a big win.

All of that is to say, I get the question, but for non-custom geographies, the tools are out there and Tableau users are smart - so help yourself. This means this is less about maps and more about hacking.

### Hacking Tableau is about opportunity for improvement.

I question the following statement:

>*Well you could [edit Firebird], but that wouldn’t be very good practice. For a start you’d be overriding Tableau’s work, meaning that you’re not going to easily get the defaults back, and you’re going to have to do it on every single machine which will open your workbook including your server.*

 First off, hacking of Tableau is a time-honored and corporately-acknowledged practice. The only rule about hacking should be to not reverse engineer Tableau's source (or at least don't publish it). It's always unsupported (until it's not) and you always make a backup. The reason the community is so hungry for better maps is that both the existing basemaps, shapes, and mapping processes are painful. By producing a method that mimics what Tableau does natively gives weight to that existing process...which is why you needed to build something in the first place.  

 I want Tableau's maps to be better, have better data, better styling, and easier access to change all of those things. I want to keep all the standard shapes that Tableau ships with with AND have my own too. I want to add what I want, when I want. If that requires a hack, it's all unsupported anyway, so you'd be better off seizing the opportunity to solve the underlying problem.

### What are you really after?

I do understand the desire to have my (or your) geographies within Tableau Desktop and integrated with that data…but I think that’s not actually the point of the question.

Tableau’s maps aren’t actually all that functional. You don’t have any control over styling - I know I hate it when I spend a lot of time perfecting a dashboard’s look and feel only to be hamstrung by a black or gray map. You don’t have active control over layers - everything else is a quick filter/parameter, why not map controls?

Furthermore, the way Tableau handles the maps - as images that you plot points on via coordinates - leaves out all the rich information that geography has to offer. This gets aggravate when we use filled maps, because what information we do have is then obscured by the shapes and their fill.

Maps are all about context - how the world looks and is organized at any given point in time, plus any additional information that may have been added. I don’t want to lose that context by painting on top of it with shapes, I want those shapes as part of my context and be able to control and update that context as elegantly as Craig’s macro does.

All of this goes back to my original post - that not everything needs to be done within the confines of Tableau’s UI and toolset. It’s not about what **Tableau can do**, it’s about what **you can do with Tableau**.

### A Small Gift

Now that you have finished reading - here’s the gift. Part of the new Alteryx macro requires you to run a series of batch scripts to create, lock, and unlock your new fancy Firebird DB. If you were going to use this macro just once, you would just run them by clicking.
But if you use it as Craig intends, you’ll want the unlock/lock phase automated. So I did that. Here’s how it works.

Download the [Chaos Reigns Within Macro Pack.](http://www.chaosreignswithin.com/2014/09/blog-macro-pack-2014-q3-release.html)

Download [these two macros.](https://github.com/cmtoomey/FirebirdMacros)

Attach the “Label Block until Done” to either your current workflow or open up Craig’s and attach it to the very first step.

![Block](https://cmtoomey.github.io/img/block-1434653967-69.png)

To the top caret, attach a Conditional Runner, and tell it to run the UnlockFirebird Macro. This macro is a carbon copy of Craig’s batch script, wrapped as a Text Input and run through a Run Command. It’s a handy way of dynamically writing and running scripts within Alteryx…plus it all goes to your TEMP folder, so you don’t need any special privileges.

![Runner](https://cmtoomey.github.io/img/runner-1434653985-33.png)

Reroute the rest of the macro to the bottom caret.

At the end, repeat, except use the LockFirebird Macro.

**Yay Automation!**

Again, all the points to Craig and the InformationLabs - and if Craig does happen to read this post, and somehow finds me at TC15, his next beer is on me.
