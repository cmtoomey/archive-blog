---
layout: post
section-type: post
title: Ultimate Mapping Guide Part 3 - Bring Your Own Data
category: Mapping
tags: [ 'mapbox', 'tutorial' ]
---
Welcome to part 3 of the Ultimate Mapping Guide! In case you missed [Craig Bloodworth's](https://twitter.com/craigbloodworth) post on Styling your Mapbox maps, you can catch up on that [here](http://www.theinformationlab.co.uk/2016/02/16/ultimate-mapping-guide-part-2-styling-mapbox-maps/). If you want to start at the very beginning, Part 1 - How Tableau and Mapbox Work Together can be found [here](https://cmtoomey.github.io/maps/2016/02/04/MapboxStudioTableau.html).

---

By themselves, Mapbox maps are great. There's just so much data that comes with Mapbox, you can make all kinds of beautiful designs. I know I'm a huge fan of the Ski map by [Amy Lee Walton](https://www.mapbox.com/blog/ski-mapbox-studio/) - and I don't even ski!

<iframe src="https://api.mapbox.com/styles/v1/mslee/cij1zoclj002y8rkkdjl69psd.html?title=true&access_token=pk.eyJ1IjoibXNsZWUiLCJhIjoiclpiTWV5SSJ9.P_h8r37vD8jpIH1A6i1VRg#6.29/46.977/9.219" width="100%" height="450"></iframe>

All that free data is great, but the question that most Tableau users have when it comes to maps is *"How do I bring my geographic data into Tableau?"*

> Before we go any further, Craig and I have to tip our hats to Zen Master Richard Leeke. In what is probably the [longest thread on the Tableau forums](https://community.tableau.com/thread/116369) at 500 replies, Richard debuts and discusses the original tool for getting geographic data, beyond points with latitude and longitudes, into Tableau. 👍👍 for Richard, we all owe you a debt of gratitude.

As with all things Tableau, answering the "BYOD" question for maps can go a few different ways. I'm going cover as many as I can, focusing on the most common questions, and noting any limitations you might run into.

#### Just as a reminder, any data you bring into Mapbox can be styled and labeled to your heart's content, but Tableau itself cannot interact with that data (yet...)

---

### BYOD for the WIN

I've pulled down the [Designated Media Market](https://github.com/simzou/nielsen-dma) shapefile. In case you were wondering, a DMA is a region defined by Nielsen where the population can receive the same media offerings (aka ads). In the US, DMAs are often used to determine which NFL game you get to watch - as presented by [506 Sports](http://506sports.com/nfl.php?yr=2015&wk=17).

So I have this data - which could be a CSV, KML, SHP, or GeoJSON...so what do I do with it? As Craig so eloquently put it last week, Mapbox does for maps what Tableau does for data...which means all you have to do is drag and drop your data into Studio.

![DragandDrop](https://cmtoomey.github.io/img/DragAndDropData.gif)

That loads your data into your account, but as you'll notice, it doesn't actually show up on the map. To do that, you have to add a Layer to your map.

![LoadLayer](https://cmtoomey.github.io/img/LoadLayer.gif)

Now that we have the data in, we can style it. Styling the entire set of DMAs would be boring, so let's see if there's anything fun we can do with the data. Mapbox lets us inspect our data direct from Studio, just by clicking.

![Inspect](https://cmtoomey.github.io/img/InspectLayer.gif)

It looks like there are a few fields that we might like to use. Cableperc is a measure of Cable TV penetration in that media market. Let's look at that. It would be cool to create a filled map that has a color gradient based on that value...just like Tableau!

![DataDrive](https://cmtoomey.github.io/img/DataDriven.gif)

## Nope

Currently, Mapbox does not support this type of data-driven styling. This means you cannot use data from a specific column to dynamically style the data on the map. I can tell you that this is an open issue on GitHub for the Mapbox team and that a fix is currently in the works...so stay tuned!

So how do you take a single dataset and make it behave differently? Well, first you filter the data to a specific range and then style that. Then duplicate, adjust the filter, adjust the style. All your layer interaction is done through these buttons at the top.

![LayerControl](https://cmtoomey.github.io/img/LayerControl.png)

Let's see all the DMAs with a Cableperc of 25% or less (I renamed the layer to CableLessThan25 to make it easier to remember).

![Filter and Style](https://cmtoomey.github.io/img/FilterandStyle.gif)

Now let's do between 25% and 50%.

![DuplicateFilterandStyle](https://cmtoomey.github.io/img/DuplicateFilterandStyle.gif)

Let's finish it off by showing between 50% and 75%; and then 75% and up.

![DuplicateFinish](https://cmtoomey.github.io/img/DuplicateFinish.gif)

Now that we've got four new layers, we should add a border in between them. We can style multiple layers all at once by SHIFT or CTRL-clicking all the layers we want. Let's but a gray border in around each of the regions so we can see their distinct borders, as well as add some transparency to make the data underneath visible.

![MultilayerStyle](https://cmtoomey.github.io/img/MultiLayerStyle.gif)

It is really that simple. Get some data, drop it in, and style it up.

---

### Wait, what if I don't have any data or my data isn't in a format that Mapbox understands?

Let's say you keep your data in a notebook, separate spreadsheet or something else entirely and want to display it. You can get it into Tableau, but your geographic information doesn't really match accepted boundaries, or the data you need just doesn't exist anywhere in your company or on the internet (yes, it does happen).

How can you generate data on your own? Well, if you can click a mouse, you can build your own data quite easily.

Visit [GeoJson.io](http://geojson.io/#map=2/20.0/0.0) where you can either open your file from your machine or start drawing. The site will start building the GeoJSON you need to drop into Mapbox. It's also a great tool for learning the different types of spatial data you can use and how GeoJSON works...so let's draw a little.

![TypesOfShapes](https://cmtoomey.github.io/img/TypesOfShapes.png)

+ Points are self-explanatory.
+ Lines are a collection of points that do not necessarily close.
+ Polygons are lines that start and end at the same place.
+ Rectangles are a very specific shape - typically used as a bounding box (not all that useful here, except for making cool looking maps).

Remember - these won't be as precise as they could be, it will literally be what you draw.

Let's draw the West Coast region.

Click "Draw a Polygon" and start adding points around the US, and along State borders. You can zoom in and out as much as you want and if you need to pan the map, just click and hold, it won't create a new point.

![WestCoast](https://cmtoomey.github.io/img/GeoJsonIOWestCoast.gif)

You'll notice I added a bad point as I split the country, but I just had to click on "Delete Last Point" and everything was back to normal.

When you are done, on the right-hand side is the GeoJSON for your new shape. Now all we have to do is add a property so that we can filter between East and West. This information lives in the
**{Properties}** array. Add as many as you want, just be sure to enclose the Property and the Value in double-quotes and separate each successive property with a comma. I'll add two properties so you can see how it works.

![GeoJSONprops](https://cmtoomey.github.io/img/GeoJsonProperties.gif)

Rinse and repeat until you have as much data as you need. You can have any combination of points, lines, and polygons and they can overlap as much as you want. Just remember, when you drop them into Studio, you'll have to pick which ones to render. If you want to see all three, you'll have to toggle that here. Each layer can only be one type.

![ShapeType](https://cmtoomey.github.io/img/ShapeType.png)

## New Features Incoming!!

That might be cool, but what if you could do all of that editing without having to leave Mapbox Studio?

Well, this spring, you can. Take a look at editing

![EditGeo](https://i.imgur.com/KF6lJKG.gif)

and publishing

![PublishGeo](https://i.imgur.com/TZqDzxw.gif)

---

## Bonus Round!!

Let's say you are a master at GIS, have one you work with, or just want to take your game to the next level. You don't want to drag and drop every single time he or she gives you more map data. How can you make BYOD automated?

The [Mapbox Upload API](https://www.mapbox.com/developers/api/uploads/) + three lines of code. I've covered the [Upload API before](https://cmtoomey.github.io/mapping/2015/07/02/mapbox1.html), but let's hit the highlights.

When you add a new dataset to Studio, it gets assigned an identifier. When I added the DMAs, it was assigned *cmtoomey.cude689c.* If that data gets updated, I can use that identifier to overwrite the old data with new data. Here's what you need to to.

+ Download and Install [NodeJS](https://nodejs.org/en/)
+ Open your command line and install the mapbox-upload package

    npm install -g mapbox-upload

![Install](https://cmtoomey.github.io/img/NPMInstall.gif)

+ Go to Mapbox.com and create a secret token (sk.xxx) with `uploads:write` scope.
+ Open your CMD line or terminal and type the following

    `SET MapboxUploadToken=sk.xxx` (Windows)

    `EXPORT MapboxUploadToken=sk.xxx` (Mac)

That will set you up to upload whenever you are ready.

When you want to upload your new data, open your CMD or Terminal and type the following

    mapbox-upload [username].[dataset id] /path/to/files

Instead of [username].[dataset id], paste in the ID of the dataset from Studio, so you can overwrite the old data with the new data.

It should look something like this

![Test](https://cmtoomey.github.io/img/upload-1435007395-34.gif)

Just re-run when your data updates and your maps will stay fresh - and don't forget to clear your Tableau MapTile cache!

`C:\Users\your-username\AppData\Local\Tableau\Caching\ExternalCacheV1\MapTiles` (Windows)

`/Users/your-username/Library/Caches/com.Tableau.caching/ExternalCacheV1/MapTiles` (Mac)

---

### Next Episode

By now, you've learned how to make Tableau and Mapbox work together, create and style a new map, and add and style your own data. Next, Craig is going to help you take your design game to the next level. Fonts, patterns, icons, labels, all while keeping your style neat and tidy.
