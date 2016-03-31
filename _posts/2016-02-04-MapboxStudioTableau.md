---
layout: post
section-type: post
title: Ultimate Mapping Guide Part 1 - How Tableau and Mapbox work together
category: maps
tags: [ 'mapbox', 'tutorial' ]
---

### Chris Toomey and [Craig Bloodworth](https://twitter.com/craigbloodworth) present the ultimate guide to Mapbox in Tableau

This is the first of a 5-part series on using Mapbox and Tableau. As you may know, Craig was the [first to bring Mapbox into Tableau](https://www.mapbox.com/blog/tableau-custom-maps/), and I've extended his work to include uploads and Mapbox Studio integration. With the forthcoming release of Tableau 9.3, which now includes support for both Mapbox Studio Classic and Mapbox GL, we decided to join forces to help you build the best maps ever and make them work smoothly with Tableau.

Here's how it's going to work - we've figured out all the things you need to know, and we'll give them to you in bite-sized pieces. I'll publish here, and Craig will publish [here](http://www.theinformationlab.co.uk/blog/). We will flip flop each post so that we both have the time to write the best content possible for the Tableau and Mapbox communities. When we're done, you'll be fully equipped to take your Tableau and Mapbox skills to the next level.

Here's what we are going to cover:

### Part 1: How Tableau and Mapbox work together

### [Part 2: Styling Mapbox Maps](http://www.theinformationlab.co.uk/2016/02/16/ultimate-mapping-guide-part-2-styling-mapbox-maps/)

### [Part 3: Extend your Map with YOUR data](https://cmtoomey.github.io/mapping/2016/02/22/MapboxStudioTableau3.html)

### [Part 4: Next-Level Styles](http://www.theinformationlab.co.uk/2016/03/31/ultimate-mapping-guide-part-4-next-level-styles/)

### [Part 5: Bringing it all together](https://cmtoomey.github.io/mapping/2016/03/31/MapboxStudioTableau5.html)

Let's get started!

---

Mapbox and Tableau have always played well together, starting with Craig's original TMS hack. Starting with 9.2, Tableau supports Mapbox Studio Classic styles out of the box. 9.3 is adding the ability to use maps built in Mapbox's fancy new Studio. Since Studio is the new hotness, and nobody wants to write CartoCSS, everything we are going to show you will be using Mapbox Studio and Tableau 9.3.

Here's the setup - I'm a huge college football fan, and I want to know where my fellow Dawgs live. That way, I know where I can wear my purple and gold safely. Back in 2014, [The NYTimes Upshot](http://nyti.ms/1CIhun0) published this great map of which ZIP codes love which teams.

![Upshot](https://cmtoomey.github.io/img/nytimesupshot.gif)

That's a pretty cool approach, you basically have "Fan Universes" spread out across the country. Describing them as universes made me think:

1. How far is the center of the Fan Universe from center of their Football Universe (aka THE STADIUM)?
2. How much physical space do these fans occupy?
3. How much do they actually like these teams?

These are great questions for Tableau, so I decided to build my homage to the NYTimes, with a map. The data all came via Alteryx, where I scraped the NYTimes data, added in some Stadium data courtesy of Google, calculated some centerpoints and geographic areas, and created shapes that I could use with Studio. I then built a map in Studio that mimicked what the NYTimes did.

I built out my workbook, plotting the stadium location and the center of the Fan Universes, connected with a line, and a few other metrics. The lines are colored to show the relative size of the Universes. I chose pink to purple because it's a gradient I have from Slalom and it stands out no matter what. But I really want to use my Mapbox Studio Map. How do I do that?

Step 1: Go to Mapbox.com, login, and get the URL.

![Login](https://cmtoomey.github.io/img/MapboxStudioLogin.gif)

Step 2: Back in Tableau, add a Map Service and paste in the URL.

![Paste](https://cmtoomey.github.io/img/MapboxStudioTableau.gif)

### And you are done!

All the fancy style rules you built work perfectly, and I'm loving the new pan and scroll-to-zoom. Feels like a real map.

![GoDawgs](https://cmtoomey.github.io/img/MapboxStudioTableau2.gif)

Let's say you want to change your map, say make the color of the water more blue. Let's make those changes, and see how they affect Tableau.

![Water](https://cmtoomey.github.io/img/MapboxStudioTableauEdit.gif)

Map updated, now what happens in Tableau?

![PostEdit](https://cmtoomey.github.io/img/MapboxStudioTableauPostEdit1.gif)

As you would expect, it starts up just where we left off...but my water is still grey. When I zoom out, its blue again, but it goes back to gray when I zoom in. Why?

### Tile Caching

To explain this, it is important to understand how Tableau and Mapbox play together. This next section is a little technical, so I'll show you how to fix it, and then show you how it all works. Feel free to skip to the end if you like, it won't hurt my feelings.

---

### Tableau Caches everything

This is to help with performance as well as provide some support for interruptions in connectivity. The downside is that for things like maps, it can disrupt or even ruin the experience you are trying to build. The good news is that these are easy to find and clean out.

On Mac, they live here:

    /Users/your-username/Library/Caches/com.Tableau.caching/ExternalCacheV1/MapTiles

On Windows, they live here:

    C:\Users\your-username\AppData\Local\Tableau\Caching\ExternalCacheV1\MapTiles

To fix your goofy tiles, it's as easy as going to that path and deleting the MapTiles folder. Like so:

![Deleted](https://cmtoomey.github.io/img/MapboxStudioTableauClearCache.gif)

If you are interested to know how all this works, read on, otherwise you can skip to the end and play with the workbook I built :grinning:

## How Tableau interacts with Mapbox

You've heard me mention the word tiles before - here and in other posts. The way these maps (Mapbox and Tableau) work are based on a grid 256x256 images stitched together (or 512x512 if you are using @2x). You can see this in the URLs that are requested by Tableau, which follow the general pattern of

    api.mapbox.com/v4/{mapid}/{z}/{x}/{y}.{format}?access_token=<your access token>

Z is for Zoom, X and Y are used to identify the tile, just like using a coordinate system. Each consecutive Zoom level increases the number of Tiles, so Z = 1 is 1 tile, Z = 2 is 2x2, Z = 3 is 4x4, etc. They are numbered consecutively so you (or Tableau) don't have to figure out which tile goes where. They just know.

Courtesy of Wikipedia, [here's the Z-level breakdown](http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames)

![zooms](https://cmtoomey.github.io/img/Zoom Levels.png)

Tableau maintains their own set of tiles, which you see all the time. When you use Mapbox Studio Classic, your styles lead directly to the creation of those tiles, which are stored in the cloud and requested by Tableau. Using Studio is slightly different, because they depend on something called [vector tiles.](https://www.mapbox.com/developers/vector-tiles/) These aren't quite the same, but in order to support those who want their fancy maps AND need them as tiles - Mapbox has built something called GL-API or "fallback." Here's how it works:

1. Tableau (or any other browser) uses the URL to request a map.
2. Mapbox detects whether or not the requestor can support GL-based rendering. If so, you get the fancy map, just like in Studio.
3. If not (and Tableau doesn't...yet), then Mapbox takes the list of layers you have built, flattens them into images, cuts the tiles, and delivers them to you.

All you need to know right now is that if you were to manually zoom your Studio map by 1 level, your map would look exactly like it does in Tableau.

#### Why do you need to care about tiling?

Each zoom level is a separate set of tiles, with their own set of styling rules. You see this as you zoom around the NCAA map. This is why we saw the original grey water tiles until we zoomed out and asked for a new tileset. Tableau had cached the original ones in that location and zoom level, referencing them when we went back to a previously visited location.

Mapbox has changed the way you think about zoom. This has a real impact in how you design and use your maps, beyond having to delete your cache to see the new hotness you just built. You see it in 9.3's default zoom behavior, which is now based on scroll (this was always available, it's just the default now). They want you to feel like you are using a webmap.

How does this work? When you use a Google or Mapbox map, the zooming and restyling is smooth, because they are using fractional zoom levels. You can see this in action in your Studio-based maps (top right-hand corner).

![fractions](https://cmtoomey.github.io/img/MapboxStudioTableauFractionalZoom.gif)

Mapbox is incrementally styling the tiles based on zoom, and Tableau is mimicking that behavior. However, what Tableau is doing is called over-zooming. They allow you to zoom in on a tile, until you cross the Z-level threshold. They aren't calling down anything new until you cross that boundary, just re-aligning the tiles to fit your window (which is defined by the X-Y data you provided). Since Tableau's already got the tiles you are looking at, it's easy to reposition, and the tiles look just as good.

I'll show you this in action, and then tell you why you should care. I'm going to fire up Fiddler, and show you Tableau's tile requests as I zoom in on a map with my mouse. I'll first use Tableau's default map.

![TableauDefault](https://cmtoomey.github.io/img/MapboxStudioTableauTiles1.gif)

Now it may look like it's functioning like a fractional zoom, but it's actually just re-sizing the tiles. I picked an arbitrary call from that massive list:

    /tile/d/mode=named%7Cfrom=tableau5_2_base/mode=named%7Cfrom=tableau5_2_water/mode=named%7Cfrom=tableau5_2_landcover/mode=named%7Cfrom=tableau5_2_water/mode=named%7Cfrom=tableau5_2_admin0_borders/mode=named%7Cfrom=tableau5_2_admin0_labels/mode=named%7Cfrom=tableau5_2_admin1_borders/mode=named%7Cfrom=tableau5_2_admin1_labels/ol/7/24/48.png?apikey=tabmapbeta&size=304 HTTP/1.1

You see the key portion: **ol/7/24/48**, followed by a **&size=304**. After I zoom in by one click of the scroll wheel, here's the request for that same location:

    /tile/d/mode=named%7Cfrom=tableau5_2_base/mode=named%7Cfrom=tableau5_2_water/mode=named%7Cfrom=tableau5_2_landcover/mode=named%7Cfrom=tableau5_2_water/mode=named%7Cfrom=tableau5_2_admin0_borders/mode=named%7Cfrom=tableau5_2_admin0_labels/mode=named%7Cfrom=tableau5_2_admin1_borders/mode=named%7Cfrom=tableau5_2_admin1_labels/ol/7/24/48.png?apikey=tabmapbeta&size=362 HTTP/1.1

The Z/X/Y coordinate is the same - meaning *it's the same tile*, just stretched to fit (or similar).

If we fire up a GL style, this is much easier to see.

![TableauMapboxGL](https://cmtoomey.github.io/img/MapboxStudioTableauTiles2.gif)

When the tile request fires, you see them added to the log, but there is no activity for the intermittent zoom levels, until I cross that Z-threshold. It's clearer at the end of the clip when you see the colors snap in - where there is supposed to be a smooth transition.

Why should you care? Now that you have access to the full power of Mapbox Studio, you'll need to think carefully about how you apply your styling rules. If you are depending on subtle changes showing up in Tableau, you won't see them if they trigger between zoom levels.

For example, ramping, a key feature of Studio, will need to be re-thought for Tableau usage. The same goes for font-sizing, and some quirks around layer visibility (i.e. what is visible at what level). It's not quite apples and oranges - more like green apples and red apples. It just takes a little more thought, but you can still have your pirate maps and all your custom data looking and feeling fresh.

---

### Have no Fear

You don't need to know how the handshake between Tableau and Mapbox works (although it helps). All you need is to want to make awesome maps for your Tableau dashboards. Craig and I are going to help you get around all the quirks of that handshake so that you can build anything that you want.

We'll show you how to build the most beautiful maps possible, add your own data, and check for problems. Keep your eyes peeled for more announcements, and as always, feel free to hit either of us up on Twitter.

Until then, here's the GL-enabled workbook for your to play with.

<script type='text/javascript' src='https://public.tableau.com/javascripts/api/viz_v1.js'></script><div class='tableauPlaceholder' style='width: 944px; height: 769px;'><noscript><a href='#'><img alt='Dashboard 1 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ta&#47;TableauGL&#47;Dashboard1&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz' width='944' height='769' style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='site_root' value='' /><param name='name' value='TableauGL&#47;Dashboard1' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ta&#47;TableauGL&#47;Dashboard1&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='showVizHome' value='no' /><param name='showTabs' value='y' /><param name='bootstrapWhenNotified' value='true' /></object></div>
