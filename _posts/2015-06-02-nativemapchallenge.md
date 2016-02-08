---
layout: post
section-type: post
title: Challenge Accepted!
category: Mapping
tags: [ 'maps', 'firebird' ]
---
After Craig Bloodworth’s [fantastic post on native filled maps](http://www.theinformationlab.co.uk/2015/06/01/uk-filled-map-geocoding-pack-for-tableau/), and his announcement of a forthcoming post on using Alteryx to create new shapes, one of my colleagues asked me how it worked and asked me why we hadn’t done something like that already.  Challenge accepted!  2.5 hours later - here’s what I know and what I think about how it might all work.

##What you need to know

All of Tableau’s Geospatial data lives in a Firebird DB (C:\\Program Files\\Tableau\\Tableau ##\\Local\\Data\\Geocoding.fdb).

*Want to see what's in it?*

These instructions are for Windows, but there is an ODBC driver for Mac too. I just didn't test that.

1. Download and install ODBC driver - 32/64 bit
2. Hit Start > ODBC.
3. Create a User DSN (or data source).

![ODBC](https://cmtoomey.github.io/img/odbc-1434653259-43.png)

Configure it like This

![ODBC_Configure](https://cmtoomey.github.io/img/config-1434653298-77.png)

Once that's complete, you can use Tableau/Alteryx/your favorite DB GUI to connect.

Here's what's inside

![Tables](https://cmtoomey.github.io/img/tables-1434653338-94.png)

Everything through CountySynonyms is lookup data about the different geographies for different localization regions (which are contained in the Synonyms tables). [The hierarchies are defined here](http://onlinehelp.tableau.com/current/pro/online/mac/en-us/maps_customgeocode_importfile_builtinhierarchies.html). In your favorite DB tool, join from Country to State on Country.ID=State.ParentID (or similar down a hierarchy) to see this in action. This follows for Synonyms tables as well - their ParentIDs = the ID of their joining table.

Heuristics is the set of rules used to identify fields as geographic - it’s all Regex. Hierarchies has something to do with the 7 hierarchies defined above.

Anything with a LocalData-prefix is where the points and shapes live. They are stored as a [BLOB sub_type_1.](https://www.ibphoenix.com/resources/documents/general/doc_54) This means it’s just text, wrapped with a MULTIPOLYGON tag. It looks like this: MULTIPOLYGON (((LONG(1) LAT(1), LONG(2) LAT(2), etc))).

###How I think it works

#####{Including updates following [Craig's big reveal](http://www.theinformationlab.co.uk/2015/06/05/using-alteryx-to-create-tableau-filled-maps/)}

If you think about the basic features of this type of tool, it has to be doing the following:

1. Generating or ingesting shapes
2. Transforming them into a MULTIPOLYGON string
3. Generating an ID
4. Creating hierarchies
5. Loading into the correct tables

Given these requirements, Craig's tool probably functions something like This

1. Get shapefiles or create polygons via a standard Alteryx process. For instance, I can get all Seattle neighborhood boundaries as a .SHP [here](Get shapefiles or create polygons via a standard Alteryx process. For instance, I can get all Seattle neighborhood boundaries as a .SHP here). {*UPDATE: CHECK*}

2. Parse and order them using the Poly Split tool. This will create each point along the shape, in order.

3. Drop a Select tool and change the remaining Spatial Objects to V_String. This will give you a text field like this: {·"type":·"Point",·"coordinates":·[·Long,·Lat·]·}. For the record - the dots are just spaces.

4. Parse out the coordinates. Craig is probably using RegEx, but that’s some nasty stuff, so I’ll just do it the long way, with some recursive TextToColums.

5. Split on [, then Select tool to remove nasty bits, Split on ].

6. Select tool to isolate coordinates.

7. Trim out any remaining white space with a Formula tool: Trim([Coordinates]).

8. Remove space and replace comma with space by adding a second formula to the tool: Replace([Coordinates],“, ”,“ ”).

9. Auto-field to clean things up.

10. Crosstab module - Group by Label, Header Field = Label, Data Field = Coordinates, set Methodologies to Concatenate

11. You’ll have to get the centroids of the shapes and Join those in. You can calculate those by using a Spatial Info tool, choosing Centroid as X and Y Fields, Selecting out stuff you don’t need, renaming it as Latitude and Longitude, and Joining.

12. Wrap in MULTIPOLYGON with Formula tool = “MULTIPOLYGON (((”+[Geometry]+”)))”.

13. Match headers to Schema - ParentID, Latitude, Longitude, Geometry, MapCode (I don’t know what this does, and it’s late…I just set it to 0).

14. Write out to three Firebird tables using the connection information above. Why 3, you’ll need to have references in all three if you want to have the joins work correctly.

Here's that mocked up in Alteryx

![Alteryx](https://cmtoomey.github.io/img/workflow-1434653476-38.png)

{*UPDATE: He actually treats the shape as JSON and processes it with a MultiRow formula. That is very clever, it basically removes the need for Steps 2 - 10. Steps 11 and 12 match. He gets around 13 and 14 by actually writing out a separate DB, with a new .TDS. He's not editing in place. The JSON parsing is a brilliant technique, I'm going to have to steal that one.*}

Now I’m sure Craig has some very fancy RegEx {*UPDATE: It's all JSON parsing, managed by Alteryx's own modules*} to optimize the parsing, some conditional rules as to whether or not this is part of an existing hierarchy or a new one, represents a new field, or is simply cleaning up/refining, something already in the DB. It probably also has some dynamic string generation hooked to a Dynamic Input {*UPDATE: CONFIRMED*} to select and write out to the correct tables without additional work. All wrapped up in a nice, shiny macro.

I know for certain he’s got an XML {*UPDATE: CONFIRMED*} output as part of it, nobody would write the XML he posted by hand. That’s money right there.

This could all be speculation - when Craig posts his work, we’ll see how close I got. I’m sure he’s got a few tricks up his sleeve! I know I’ll be snagging the tool when it’s done and chasing him down at TC15 to buy him a beer.

{*UPDATE: I got pretty close...that JSON parsing solved a lot of issues*}
