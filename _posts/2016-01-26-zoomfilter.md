---
layout: post
section-type: post
title: Bounding Box Filter
category: tutorial
tags: [ 'maps', 'mapbox', 'javascript' ]
---

Have you ever felt like Tableau is missing something? Something simple that would make your analysis and dashboards just a little easier? While I too hold out hope for a truly dynamically-filled parameters, one of the biggest pains I've ever experienced is the lack of a map-move or map-zoom based filter action.

Something like [AirBnB's](https://www.airbnb.com/) rental search. Move or zoom the map, get new results.

![zoom](https://cmtoomey.github.io/img/zoomfilter.gif)

###Why would you want something like this?

While clicking or lassoing a group of marks based on some visual attribute is a very simple and effective interaction, it's usually the second (or third) interaction we've made with data on a map, the first being a pan or a zoom. These two interactions let us explore our data quickly, but also creates a very clear sense of context. I use that last word on purpose - beyond the geophysical bounding of data, context in Tableau implies filtering. Given that panning and zooming are visually filtering data out of our field of view, it isn't a stretch to expect Tableau to provide the means to capture and extend that filter to other views. Otherwise, we're just seeing and not really understanding.

---

###Art of the possible

Let's see what's currently possible with Tableau. I've made a very basic two-pane dashboard, using the Superstore extract. One the left is summary sales and on the right is a map with Country and State in the Level of Detail. I've set the Map to "Use as Filter."

![Filter1](https://cmtoomey.github.io/img/tableauMapFilter1.gif)

You'll notice that moving the map around doesn't change the values, but clicking on a point does. What I'm going for is the ability filter the data as the map moves - it should only show me data about points that are within the bounding box (North/South/East/West as defined by the map worksheet).  

Why isn't this working? Here's a screenshot of the Action Filter being passed to the crosstab.

![ActionFilter1](https://cmtoomey.github.io/img/ActionFilter1.png)

There are no latitude and longitude values being passed into the worksheet, despite them being on the map. Why is this? Firebird.

---

##Tableau Geodata

The key to this problem is the *(generated)* portion of the latitude and longitude we use in the map. Behind the scenes, Tableau is using a set of built-in data connections (.TDS) to query a Firebird database that ships with every copy of Tableau Desktop.

See for yourself - here's the country-level TDS.

<script src="https://gist.github.com/cmtoomey/88c8e02209e4c24fa214.js"></script>

On Mac, these live in the application Package Contents (CTRL-click > Show Package contents) > Contents > install > local > data. On Windows, the path is [Install Drive]:\\Program Files\\Tableau\\(Tableau version)\\local\\data. The data itself is contained within GEOCODING.FDB (If you want to see what's actually in the DB, click [here](https://cmtoomey.github.io/mapping/2015/06/02/nativemapchallenge.html)).

When you make a map in Tableau using *latitude(generated)* or *longitude(generated),* you are sending a query to the local Firebird database and returning the lat and long contained there. Why is this important? If you don't have any field mapped to one of those geographic fields, you won't have access to that data, meaning it can't be used as a Filter or Action.

Let's see an example. Like a rational Tableau user, I'm going to make the latitude(generated) and longitude(generated) as global filters. That's typically a good fix for these types of level-of-detail issues (or at least where I like to start).

![globalfilter](https://cmtoomey.github.io/img/mapglobalfilter.gif)

Since my sales sheet doesn't have any Firebird-based geodata in it, there's no query, no data, and ultimately everything returns null.

But what if I drop Country and State onto Level of Detail? That would fix things, right?

![mapLOD](https://cmtoomey.github.io/img/maplodtest.gif)

As you might expect, you'll get a mark for every Country/State combination. While I'm sure I could solve this with some LOD and Table Calculations, that's a pain, and a solution I'll leave up to [Jonathan Drummey](http://drawingwithnumbers.artisart.org/). I'm not one to complain without attempting a solution, so I posted an idea onto the [Ideas Forum](https://community.tableau.com/ideas/5818). If anything you've read so far makes sense, then please go vote it up.

I had the privilege to attend the Tableau Partner Summit a few weeks ago, so I asked Marc Reuter if there are any plans to include this type of filtering in a future release of Tableau. Here's an approximation of his answer

<iframe src="//giphy.com/embed/ly8G39g1ujpNm" width="375" height="217" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/editingandlayout-ly8G39g1ujpNm">uhh..No</a></p>

Alright, if Tableau doesn't do it, and isn't planning to do it in the near future - I'll just have to build it.

---

##Javascript FTW

Given that Tableau's geodata is a bit of a pain, let's say your data already has lat/long in it (Pro Tip: go download the [Earthquake data from Tableau Public](https://public.tableau.com/s/sites/default/files/media/Resources/Mag6PlusEarthquakes_1900-2013.xlsx)).

<iframe src="//giphy.com/embed/OCu7zWojqFA1W" width="100%" height="500" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/samuel-l-jackson-jurassic-park-hold-onto-your-butts-OCu7zWojqFA1W">Javacript Incoming!!!</a></p>

From this data, I built a viz and posted it to [Tableau Public](https://public.tableau.com/profile/chris.toomey1132#!/vizhome/MapboxTest_0/QuakeDashboard). I just counting earthquakes and showing magnitude over time. I also [built a map](https://www.mapbox.com/mapbox-gl-js/examples/) that plots all 6,000+ earthquakes on a fancy MapboxGL map (meaning I used the default style). Here's what we are going for:

1. Move or Zoom the map
2. Find the NSEW values (aka the "bounding box")
3. Filter the Tableau dashboard to show only the points that in that box

If you haven't done any work with Javascript before - this will be a nice introduction.

First, we need to build a document. I'm going to import all the API content we need, as well as the CSS.

    <!DOCTYPE html>
    <html>

      <head>
        <meta charset='utf-8' />
        <title></title>
        <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
        <link href='https://fonts.googleapis.com/css?family=Roboto:300,500' rel='stylesheet' type='text/css'>
        <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.12.2/mapbox-gl.js'></script>
        <link href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.12.2/mapbox-gl.css' rel='stylesheet'/>
        <script src='https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v0.0.0/mapbox-gl-geocoder.js'></script>
        <link rel='stylesheet' href='https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v0.0.0/mapbox-gl-geocoder.css' type='text/css'/>
        <script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
        <style>
          body {
            margin: 0;
            padding: 0;
          }

          #tableau {
            position: absolute;
            top: 0;
            bottom: 0;
            width: 50%;
            /*background-color: blue*/
          }

          #map {
            position: absolute;
            top: 0;
            bottom: 0;
            width: 50%;
            left: 50%;
            height: 100%
          }

          pre.ui-coordinates {
            position: absolute;
            bottom: 10px;
            right: 10px;
            padding: 5px 10px;
            background: rgba(0, 0, 0, 0.75);
            color: #fff;
            font-size: 10px;
            font-family: 'Roboto', sans-serif;
            font-weight: 300;
            line-height: 18px;
            border-radius: 3px;
            z-index: 1;
          }

          form {
            position: fixed;
            bottom: 5px;
            z-index: 1;
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            font-size: 14px;
          }
        </style>
      </head>
      <body>

        <div id='tableau'></div>
        <div id='map'>
          <pre id='coordinates' class='ui-coordinates'></pre>
          <form id='toggle'>
            <input type="radio" name="Speed" value=0 checked="checked"> REGULAR
            <br>
            <input type="radio" name="Speed" value=1> BEAST MODE
            <br>
          </form>
        </div>
      </body>
    </html>

The page is fully responsive, so it will work on any device ([otherwise Allan Walker will yell at me.](https://twitter.com/AllanWalkerIT))

At the top, we need to load the Tableau Public Javascript API and the MapboxGL Javascript API. Instructions for [Tableau are here](http://onlinehelp.tableau.com/current/api/js_api/en-us/help.htm#JavaScriptAPI/js_api_concepts_get_API.htm) and instructions for [Mapbox are here](https://www.mapbox.com/mapbox-gl-js/examples/).

Now that we have the basics down, we need to load in the Tableau content. I'm sure real JS developers are about to feel a disturbance in the Force, but I'm going to declare a bunch of global variables (values that I can use anywhere in my code). These all go right before the /div tag.

    var lat = '';
    var long = '';
    var north = '';
    var south = '';
    var east = '';
    var west = '';
    var coordinates = document.getElementById('coordinates');
    var n = 1;
    var type = 0;
    var latitude = '';
    var longitude = '';
    var workbook = '';
    var worksheets = '';
    var length = '';

Basically, I'm creating a bunch of empty shells I'll make use of later. If I didn't do this, I'd end up creating the values inside of my Javascript functions, which means they would be walled off and I couldn't pass them to Tableau easily. It might not be the most efficient method, but it works.

Next, I'm going to insert my Tableau viz, using the standard bootstrap code.

    var placeholderDiv = document.getElementById('tableau');
    var url = "https://public.tableau.com/views/MapboxTest_0/QuakeDashboard?:showVizHome=no&:display_spinner=no&:jsdebug=n&:embed=y&:display_overlay=no&:display_static_image=yes&:animate_transition=no"
    var options = {
      hideTabs: true,
      onFirstInteractive: function() {
        // The viz is now ready and can be safely used.
        workbook = viz.getWorkbook();
        active = workbook.getActiveSheet();
        worksheets = active.getWorksheets();
        length = worksheets.length;
        worksheets[2].applyRangeFilterAsync(
          "Latitude", {
            min: south,
            max: north
          }, tableau.FilterUpdateType.REPLACE);
        worksheets[2].applyRangeFilterAsync(
          "Longitude", {
            min: west,
            max: east
          }, tableau.FilterUpdateType.REPLACE);
      }
    };
    var viz = new tableau.Viz(placeholderDiv, url, options);

Most of this is well documented boilerplate, but the piece you should notice is what's living in the **onFirstInteractive** section. This is triggered when the viz is fully loaded and ready to go. Once that happens, I'm going to dig into the viz, pull out the workbook, then the active sheet (which is the dashboard), then count all the sheets that make up the dashboard. Once I've got that, I'm going to take my bounding box (which I'll build next), and apply it as a filter to a specific sheet.

I've got my Tableau content, how about some Mapbox action? I'm going to bring in a map, then pull in some data, get my location via my browser, and add a geocoder.

    mapboxgl.accessToken = 'you thought I would give you my access token, right?';
    var map = new mapboxgl.Map({
      container: 'map', // container id
      style: 'mapbox://styles/mapbox/streets-v8', //stylesheet location
      center: [0, 0], // starting position
      zoom: 3 // starting zoom
    });

    var url = 'https://rawgit.com/cmtoomey/TableauMapboxEarthquake/master/Earthquakes.geojson';
    var source = new mapboxgl.GeoJSONSource({
      data: url
    });

    navigator.geolocation.getCurrentPosition(function(position) {
      console.log(position.coords);
      latitude = position.coords.latitude;
      console.log(latitude);
      longitude = position.coords.longitude;
      console.log(longitude);
      map.flyTo({
        center: [longitude, latitude],
        zoom: 8
      });
    });

    map.addControl(new mapboxgl.Geocoder());

Now that I've got the basics, I'll grab my bounding box when the map is fully loaded. This is similar to Tableau - I can't ask for anything until the content is ready to go. For Tableau, it's onFirstInteractive, for Mapbox it's map.on('load'). Next up is the map.on('styleload'), which means that the style information is ready and this when you can add the earthquake data. To do this, I transformed the Tableau Public XLSX into geojson using [geojson.io](http://geojson.io/) and put it in my GitHub repo.

    map.on('load', function() {
      bounds = map.getBounds();
      north = bounds.getNorth();
      south = bounds.getSouth();
      east = bounds.getEast();
      west = bounds.getWest();
      document.getElementById('coordinates').innerHTML = 'Query Count: ' + n + '<br />North: ' + north + '<br />South: ' + south + '<br />East: ' + east + '<br />West:' + west;
    });

    map.on('style.load', function() {
      map.addSource('quake', source);
      map.addLayer({
        "id": "quake",
        "interactive": "true",
        "source": "quake",
        "type": "circle",
        "paint": {
          "circle-color": "#A5ACAF",
          "circle-radius": "7",
          "circle-opacity": ".85",
          "circle-blur": ".35"
        }
      });
    });

Now you've got a Tableau dashboard and a Mapbox map that can fly to your location and show you data that is relevant to you...but only at the very beginning. What about zooming and moving around, or when you type something into the geocoder?

To do this, we need to add some event listeners that listen for when the map stops moving, or map.on('moveend'). When this happens, we want to grab the bounding box and update our NSEW variables. I've also added a listener for when you click on a point, the map will center on that point (which will trigger another moveend filter).

    map.on('click', function(e) {
      // Use featuresAt to get features within a given radius of the click event
      // Use layer option to avoid getting results from other layers
      map.featuresAt(e.point, {
        layer: 'quake',
        radius: 10,
        includeGeometry: true
      }, function(err, features) {
        if (err) throw err;
        // if there are features within the given radius of the click event,
        // fly to the location of the click event
        if (features.length) {
          // Get coordinates from the symbol and center the map on those coordinates
          map.flyTo({
            center: features[0].geometry.coordinates
          });
        }
      });
    });

    map.on('moveend', function() {
      n = n + 1;
      bounds = map.getBounds();
      north = bounds.getNorth();
      south = bounds.getSouth();
      east = bounds.getEast();
      west = bounds.getWest();
      //This will apply the filter to all the worksheets in the dashboard.
      //even if they aren't "visible"
      for (var i = 0; i < length; i++) {
        worksheets[i].applyRangeFilterAsync(
          "Latitude", {
            min: south,
            max: north
          }, tableau.FilterUpdateType.REPLACE);
        worksheets[i].applyRangeFilterAsync(
          "Longitude", {
            min: west,
            max: east
          }, tableau.FilterUpdateType.REPLACE);
      };
      document.getElementById('coordinates').innerHTML = 'Query Count: ' + n + '<br />North: ' + north + '<br />South: ' + south + '<br />East: ' + east + '<br />West:' + west;
    });

For a little extra credit, I decided to tie a radio button to the dashboard. The idea here is that in "Regular Mode" you can see the higher level aggregates. When you go "Beast Mode," you can look at all the data. It changes the look and feel of the map, so you get a visual cue that things have changed. It's a nice subtle effect. Let's see it in action.

![zoomdemo](https://cmtoomey.github.io/img/zoomfilterdemo.gif)

---

##touchdown!!

Just because Tableau doesn't do something "out of the box," doesn't mean it can't be done - so clone it, fork it, just don't be afraid of it. 

That may seem like a lot of code - but it's mostly boilerplate that I copied and pasted from Tableau and Mapbox documentation. I used Mapbox GL because it was the easiest to use, but you could do the same thing with Mapbox JS, Leaflet, ESRI, and Google Maps. I've posted the entire codebase to [Github](https://github.com/cmtoomey/TableauMapboxEarthquake) and you can play with the demo [here](http://cmtoomey.github.io/TableauMapboxEarthquake/). There's a few other nuggets in there that weren't ready for primetime (meaning they might break Tableau Public :grin:), so feel free to explore.

As always, you can leave your comments below or ping me on Twitter.
