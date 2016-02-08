---
layout: post
section-type: post
title: Tableau and Mapbox Studio
category: mapping
tags: [ 'maps', 'mapbox','conference' ]
---

<div class="titleheader">
  <img src="https://cmtoomey.github.io/img/mapboxmaps-1449166935-66.png" alt="..." />
  <div class="titletitle">
    <h3>From #Data15 to You!</h3>
  </div>
</div>

---

For those of you who were at Tableau Conference 2015, one of the more exciting announcements was the native integration of [Mapbox](https://www.mapbox.com/) into Tableau. What was first a hack pioneered by [Zen Master Craig Bloodworth](http://www.theinformationlab.co.uk/2014/01/21/information-lab-brings-new-mapping-tableau/) of the Information Lab and perfected by [Zen Master Anya A’Hearn of Datablick](http://datablick.com/2015/02/04/fast-and-fabulous-custom-maps-using-mapbox-in-tableau/) is now part of Tableau itself.

###This is a big deal

Why? Two reasons:

+ First, it marks the first time a third party platform has been directly integrated into Tableau. Hopefully this foreshadows more integrations to come (Github?).
+ Second, this directly solves (meaning it’s supported) one of the more vexing issues that Tableau users have faced: how do I get my geographic data into Tableau and make it look just as beautiful as the rest of my data?

If by this point, you haven’t gotten your hands-on the beta, do it now! Everything you see here applies to all versions of Tableau, but 9.2 is where it’s all native.

###How Tableau and Mapbox play nicely

If you attended Anya A’Hearn and Allan Walker’s talk at #Data15, you may have seen one [Matt Irwin](https://twitter.com/mtirwin) on stage, talking about who Mapbox is and what they do. The key point to remember is that while Mapbox helps you produce beautiful maps, they are largely an API company. They want to help you move and interact with your geographic data, and maps are just the most visible part of that goal.

If you haven’t seen them, [you should check them out](https://www.mapbox.com/developers/). Or just take a look here.

![APIs](https://cmtoomey.github.io/img/screenshot-1449167520-9.png)

The blue box represents how Tableau is integrating with Mapbox. It’s called the Tile API. Here’s how it works. Tableau Desktop requests a set of images from Mapbox, using the MapID that you specify, at the best available quality. To understand how Tableau actually handles image quality, just go to the next section.

Those tiles (or rather PNGs) are painted, just like background images, and then your data are plotted on top. You move or zoom the map, Tableau gets more tiles. Seamless.

All you have to do is follow Tableau’s instructions, courtesy of Tableau’s own [Kent Marten](http://www.tableau.com/about/blog/2015/11/go-deeper-mapping-tableau-92-46154):

![Instructions](https://cmtoomey.github.io/img/screenshot-1449167702-68.png)

###Let's see how that works

I log in and see what happens

![login](https://cmtoomey.github.io/img/mapboxlogin-1449167743-85.gif)

I can get my Access Token, but how do I get my styles? What is Classic? **What is going on here!?!**

Let’s got back to Kent’s instructions, but just a little further down:

![Instructions2](https://cmtoomey.github.io/img/screenshot-1449167826-37.png)

Ok, so I first need Mapbox Studio Classic - which is a desktop application

![Studio](https://cmtoomey.github.io/img/studiooptio-1449167925-96.gif)

Mapbox has a [great styling tutorial](https://www.mapbox.com/help/getting-started-cartocss/), as does [Anya](http://datablick.com/2015/04/17/create-multiple-custom-map-layers-in-mapbox-that-you-can-toggle-on-and-off-in-tableau/), but it really just comes down to this:

    #layer {
      property: value;
    }

Except, if I upload to Mapbox.com after uploading, it’s not really apparent what to do next. **Where’s my stuff?!?**

###MapboxGL and Studio

Here’s what happened. About the same time as Tableau announced the Mapbox integration, Mapbox announced a new platform. The new design environment is called [Studio](https://www.mapbox.com/blog/announcing-mapbox-studio/), and it’s built on a technology called MapboxGL. Zoom based Styles, easy color control, custom fonts, languages, the list goes on and on.

To get there, all you have to do is click on Studio when you log into Mapbox, you’ll see something that looks like this:

![Studio](https://cmtoomey.github.io/img/gl-1449168267-79.gif)

This is the new Studio. You are using [Studio Classic](https://www.mapbox.com/mapbox-studio-classic/#darwin), remember? This means you need to go here to find your stuff.

![Classic](https://cmtoomey.github.io/img/classic-1449168382-58.gif)

So once you’ve done that, follow Kent’s instructions for 9.2 or Anya’s for 9.1 and you are ready to rock! [Don't forget {D!!}]

---

#What if you want the new hotness?

Tableau users expect the latest and greatest, they want it to be easy, and they want it NOW! So I (and Anya and Allan) asked Tableau if it was possible. Here’s the gist of their response.

![ObiWan](https://cmtoomey.github.io/img/obiwan-1449168558-34.gif)

Why? Let’s go back to how Tableau interacts with Mapbox.

![Tiles](https://cmtoomey.github.io/img/screenshot-1449168599-37.png)

To the user, the end result may be a map, but behind the scenes, Classic and GL are based totally different technologies. That means that getting Tableau to understand GL natively would be a "massive engineering project" (courtesy of Kent Marten).

That’s a totally understandable explanation...but there has to be a way to make it work.

###There is

Here’s a style from my Mapbox account (and proof that it wasn’t duped in Classic).

![Demo1](https://cmtoomey.github.io/img/proof1-1449168787-77.gif)

Here it is working in both 9.1

![Demo2](https://cmtoomey.github.io/img/proof2-1449168823-44.gif)

and 9.2.

![Demo3](https://cmtoomey.github.io/img/proof3-1449169157-96.gif)

---

###There you have it

Right now, this is a hack that isn’t available to everyone...but hopefully it will be very soon (maybe it will be supported!).

In the meantime, check out [Anya’s newest post](http://datablick.com/2015/12/03/the-new-fabulous-mapbox-studio-tutorial-with-thoughts-on-making-accessible-maps/) on using Studio. My next post will talk about adapting that design for use in Tableau and I’ll be taking the covers off the GL integration very shortly.

If you want to know more, you can always find me on [Twitter](https://twitter.com/Sock1tToomey)!

Happy Mapboxing!
