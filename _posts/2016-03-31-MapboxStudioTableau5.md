---
layout: post
section-type: post
title: Ultimate Mapping Guide Part 5 - Bringing it all together
category: Mapping
tags: [ 'mapbox', 'tutorial' ]
---

Welcome to the fifth and final installment of the Ultimate Mapping Guide. [Craig Bloodworth](https://twitter.com/craigbloodworth) and I hope you have found it helpful and are now ready to show the world some amazing work! This installment will focus on everything that happens once you have made your awesome [Mapbox](https://www.mapbox.com) map and are ready to put it in production with Tableau. 

If you have a map, but want to take the design and styling to the next level, be sure to read Craig's [most recent post](http://www.theinformationlab.co.uk/2016/03/31/ultimate-mapping-guide-part-4-next-level-styles/) before continuing. 

Home stretch - here we go!!!

---

Let's do the first thing first - your map is beautiful, has been approved by everyone and now you want to see it in Tableau. Now with 9.3, you can use it out of the box (no TMS hacking anymore!). Go through the same process of Map, Background Maps, Map Services, Add Mapbox Map and you will be presented with a fancy new box. 

![newbox](https://www.mapbox.com/help/img/3rdparty/tableau-5.png)

All you need to do is paste in the Style URL from Mapbox Studio and Tableau will take care of the rest. Where might you find the Style URL? Right here:

![styleurl](https://cmtoomey.github.io/img/FindMapboxButton.gif)

Give your style a name and that's it. You can add as many of these maps as you want, just like your Classic Styles. However, unlike Classic, you can't toggle the layers of your map on and off (more on that in a bit). 

### But what if it something doesn't look quite right? 

Perhaps something like this? 

![clipping](https://cmtoomey.github.io/img/Clipping.png)

You notice that the first letter of Michigan, Kentucky, and Florida State is chopped off a little. This is called clipping, and it can sometimes happen when a label crosses a tile boundary. 

What's a tile? Well, let's go back to [Part 1](https://cmtoomey.github.io/maps/2016/02/04/MapboxStudioTableau.html). Both Tableau and Mapbox see the world through little boxes that measure 512px x 512 px. All those layers, colors, and styling rules (like ramping) are taken into account at every zoom level and then flattened into an image that you can see on a map. That is a map tile. 

The lowest level of zoom contains the world on a single tile. Every zoom level you go up splits the the tile into quarters, creating a grid that is 2^Zoom on a side. Now you have a bunch of tiles that need to be assembled on a map, and to make this easy, the map geniuses devised a grid system: Z/X/Y. Starting with Zoom/0/0 you go up until you reach 2^Zoom - 1 and then you go to the next row. 

**Example**

+ Zoom level three is 8 x 8 tiles
+ The first row starts at 3/0/0 and goes 3/7/0
+ The second starts at 3/0/1 and goes to 3/7/1

It's much easier to see for yourself, so Mapbox built in a Debug menu so you can actually look at the tiles and their boundaries. 

![tiles](https://cmtoomey.github.io/img/DebugTiles.gif)

Let's see if this is actually the issue for this particular map. 

![tiletest](https://cmtoomey.github.io/img/DebugTilesClips.gif)

There it is, the labels just barely cross over into another tile. If you look around you'll probably see that this happens in a few other plans (or doesn't). As of right now, Mapbox is aware of the tile clipping issue, and there is a fix underway. In the meantime, now that you know where the problem is, you can email [Support](mailto:help@mapbox.com), give them the style ID and the tiles and they can help you with a fix. 

---

## Let's talk about editing

You've got your map, but now you want to make some changes: adjust the colors a little bit, add some more data, change a few labels. You publish your updates and the something like this happens. 

![update](https://cmtoomey.github.io/img/StyleWontUpdate.gif)

This will be (if it isn't already) the number one issue people will have with Mapbox and Tableau. What's happening is that Tableau caches the tiles it requests from the map server. It does this to keep you from burning through your map view limit, and also to provide some limited offline capability. 

Remember those handy map tile coordinates I just mentioned? That's how Tableau knows what's new and what to ask for. If it doesn't have a tile with that coordinate, it will ask for a new one. That's why you see the old tiles (with blue) around the United States and new tiles (the green) around Asia. 

![oldandnew](https://cmtoomey.github.io/img/GreenAndBlue.png)

To fix this, you have to clear Tableau's cache. To do that go here and delete the MapTiles folder. 

**Windows**

    C:\Users\your-username\AppData\Local\Tableau\Caching\ExternalCacheV1\MapTiles

**Mac**

    username/Library/Caches/com.Tableau.caching/ExternalCacheV1/MapTiles

> Now a word of warning: Mapbox does a little bit of caching too, to help get your tiles quickly and cheaply (so they can continue to provide all that good stuff in a free plan). That cache is like a timebomb, it expires every so often. Right now the timer is set to 5 mins. This means that if you update a style, clear your cache, and then request new tiles you might get an old one and have to start over. The good news is that I've asked Mapbox to lower that timer, and we are working with Tableau to figure out a better experience around their cache - so stay tuned. 

### what about labels?

Clipping aside, you can run into issues with labels being too close, or not appearing at all. Something like you see on the left, but what you want is on the right. 

![crowded](https://c2.staticflickr.com/2/1564/26067701156_3a19878b96_o.png)

The good news here is that Mapbox just turned on a new feature for **all new maps** that will make labeling even easier. It's called compositing and I'll let you read about it [here](https://www.mapbox.com/blog/better-label-placement-in-mapbox-studio/). If you have an exiting style, you'll have to turn this feature on in the Debug menu. 

But what if your labels just aren't showing up where you want them to? Maybe they are blanking out or something else is taking their place? 

This happens when labels collide. Similar to how Tableau won't show (by default) overlapping marks, Mapbox wants to keep your map looking sweet. To do this, they compute a tiny box around each label and compare boxes to ones close by. If they collide, one label will win. How can you tell if there is going to be a "label fight?" Back to the Debug menu!!

![collision](http://cmtoomey.github.io/img/DebugTilesCollision.gif) 

As you move around you'll see green boxes and red boxes. If it's red, that means there is a collision and that label won't be shown. Determining which label wins is actually a complex process, you can read all about it [here](https://www.mapbox.com/blog/label-collisions/) if you like. The best first step is to simply bump the labels up the layer order (remember the Painter's Algorithm?). This will give those labels more weight in the collision equation. I'll let [Matt Irwin](https://www.mapbox.com/blog/labels-on-top/) show you how easy it is: 

![top](https://i.imgur.com/Nan5Goe.gif)

Perfect labels! 

---

## Testing 

If you follow all of Craig and I's instructions, you'll have spent a lot of time building an amazing map. Wouldn't it be great if you could preview how it will look before you put it in Tableau? That way, if something isn't right, you can fix it on the spot without dealing with Tableau's cache. 

Mapbox doesn't have a "Preview as Tiles" button anywhere (at least not one I could find), so I built a [small web app](http://cmtoomey.github.io/MapboxTableauTesting/) to do it for you. All you have to do is copy the same Style URL you need for Tableau and it will take care of the rest. It looks like this:

![testing](https://cmtoomey.github.io/img/StyleTest.gif)

