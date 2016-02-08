---
layout: post
section-type: post
title: What's Next for Tableau
category: TC15
tags: [ 'conference', 'speculation' ]
---
<iframe src="//giphy.com/embed/62PhBbUHyNAUE" width="100%" height="400" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/the-west-wing-cj-cregg-62PhBbUHyNAUE"></a></p>

On September 8th, Leland Wilkinson published an [update to his now 7-year old prediction](http://www.tableau.com/about/blog/2015/8/future-analytics-analyst-will-remain-central-43427) about the (then) forthcoming presence of IBM’s Watson in the analytics space. In that post, Wilkinson makes reference to a document, written by Jim Thomas of Pacific Northwest National Laboratory, that gave birth to the term “Visual Analytics.”  Wilkinson’s post is interesting in it’s own right, but it is the document, titled Illuminating the Path: The Research and Development Agenda for Visual Analytics, that is the inspiration for this post. [You can read it for yourself](http://vis.pnnl.gov/pdf/RD_Agenda_VisualAnalytics.pdf).

### That's an odd source of inspiration...
In my previous life, I was a Scientist at [PNNL](http://www.pnnl.gov/). I focused primarily on analysis related to international nuclear safeguards, nuclear security, export controls, and international nuclear energy markets. Saving the world, one research paper at a time. They also invented some really cool stuff:

+ The compact disc.
+ Vitrification of nuclear waste.
+ Acoustic holograpy.
+ Portable blood irradiator.
+ Key Contributors to the Intergovernmental Panel on Climate Change.
+ Millimeter Wave - the tech behind airport body scanners.
+ IN-SPIRE - platform for visual analysis of high-volume textual data (this was also the partner technology in the famous Tableau bird-strike demo).

While I wasn’t the first user, I was responsible to re-starting and building Tableau @ PNNL. I say “re-start” because PNNL has been involved with Tableau since version 3.0 (that’s earlier than you can download from the Alternate Download site), and has been an international leader in defining and executing Data Visualization research agenda.

### But why should you care about *Illuminating the Path?*

First, there is no larger force for innovation than the U.S. government. That may sound counter-intuitive, but like it or not, entire business categories have been and are still defined by the USG’s operational challenges and purchasing priorities.

For example, in the analytics space, the challenges faced by the USG-supported scientific, defense, and intelligence communities dwarf those faced by the commercial sector. With traditional methods (i.e. Congressionally-funded) no longer able to keep up with current events, the Central Intelligence Agency established a venture capital fund, [IN-Q-TEL](https://www.iqt.org/), to leverage the private sector to solve its problems.

![IQT](https://cmtoomey.github.io/img/iqt-1442288202-97.jpg)

The USG has an analytics problem years before it hits the commercial sector, at the highest level of complexity one can think of, with the largest possible outcomes.

For example, two of the most common and important problems, counter-terrorism and signals intelligence analysis, are fundamentally based in social network analysis and natural language processing. The prime difference is that it was the CIA’s problem since Windows.

IN-Q-TEL takes those problems helps create some of the most advanced capabilities in the market. Like what?

+ Palantir
+ Paxata
+ Spotfire
+ MongoDB
+ Socrata
+ Platfora
+ D-Wave
+ Cloudera
+ MemSQL
+ Delphix

It is precisely this mechanism (except with DoD taking the place of IN-Q-TEL) that gave birth to Tableau. It happens elsewhere too - basic science investments are targeted at specific USG needs.
For example, many High Performance Computing initiatives ([now at exascale](http://readwrite.com/2011/02/21/obama_budget_includes_126_million_for_exascale_com)) in the U.S. are targeted at research and modeling for the purposes of maintaining the nuclear arsenal.

![Scale](https://cmtoomey.github.io/img/sierralarge1-1442287398-3.jpg)

Second, on the eve of TC15, with Tableau fast-approaching v10, being reminded of this document presented an excellent opportunity to reflect on Tableau’s current state and where it needs to go to fulfill the vision of helping people See and Understand their Data.

Throughout this post, you might see (#). This is a reference to a page/pages in Illuminating the Path in case you want to look it up. References FTW.

---

## The Grand Analytic Challenge

Modern data is multi-dimensional, dynamic, incomplete, inconsistent, potentially deceptive, and increasing in velocity. Decision-making in this environment requires individuals to perform analyses that are collaborative, accurate, and impactful while being easily understood by a variety of audiences. No problem right? Just do good analysis, predict everybody’s questions beforehand, and make this incredibly complex problem set consumable in one Powerpoint slide and 2 paragraphs.

We need to do more, faster. If we are wrong, we need to be wrong, faster. If we are right, we need to move the next problem, faster.

Tableau is often used to accelerate reporting, but that’s a waste of what Tableau was designed to do. What do I mean by that? **Reporting is not analysis**. If you are going to spend time with data, make it meaningful, don’t just report numbers. Give them context, talk about something interesting, make a difference. In addition to making your work more impactful, good analysis lets you do things like this:

<iframe src="//giphy.com/embed/WXtccLGTLB1NS" width="100%" height="316" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/ad-wants-kmart-WXtccLGTLB1NS"></a></p>

### But how? What is "analysis?"

At it’s most basic, analysis is sense-making loop (24-27). There is no one answer, only understanding and decisions.

![Sense](https://cmtoomey.github.io/img/screenshot-1442928681-94.png)

This plays into the well-known concept of flow. Questions lead to activities, which lead to more questions, until you have a product and hopefully a decision.

With me so far? For this to work only two things matter.

### Visual Representation (Seeing) and User Interactions (Understand)

See what I did there?

### Visual Representation

The ability to see is a function of two things: Scale and Encoding.

---

### Scale

Scale is the ability to perform a lossless render of N points without being constrained by display media (24-27). In English, Visual Analytics at scale means that the visualization must be able to render any number of points on any display, while not losing any of its legibility.

Tableau and VizQL can certainly render millions of points. It achieves this through its core operations, but also through the efficiencies of the query and render pipeline, which are both aggregation dependent. This is where things like parallel and fused queries come into play, but...Tableau also cheats when it comes to a certain viz types with respect to higher mark counts (more on that in a second).

We can consider these renderings to be lossless because a) the core viz rendering doesn’t change based on a different display and b) Tableau presents the user with options to peer into the data with its own UI.

However, Tableau still hasn’t figured out how to manage multiple consumption models - meaning mobile and responsive design. In Illuminating the Path there is a use case related to first responders. The data these individuals need to consume saves lives - if the visualization cannot adapt in its entirety, then it isn’t usable and people get hurt.

Sure, Tableau has “Automatic” dashboard sizes, and worksheets can “Fill Entire View,” but deploying those hammers your cache and requires knowledge of jQuery and CSS-media queries to make work as intended. See [here](https://community.tableau.com/thread/126204) or [here](https://public.tableau.com/s/blog/2014/11/making-responsive-tableau-dashboards) or [here](https://community.tableau.com/ideas/2836).

If you read [Kelly Martin’s blog](http://vizcandy.blogspot.ca/) (and you should), she makes a valiant effort to solve this challenge. Her method for viz on mobile is workable, but it doesn’t actually resolve the problem at hand. It requires a dashboard variant for every major device type or family.

# NO

![response](https://cmtoomey.github.io/img/screenshot-1443102991-73.png)

## We need one dashboard, consumable everywhere, all the time.

[Content should drive how the layout adjusts to the container.](https://developers.google.com/web/fundamentals/design-and-ui/responsive/fundamentals/how-to-choose-breakpoints?hl=en) When that happens, everything should be just as readable as it was in the initial configuration. I should be able to build my content, exactly how I want, and then compose it’s behavior.  I should never need to know which device, just that it might be on that type of device.

> ### Recommendation 1: Tableau should include native support for webfonts, em-based sizing, and SVG.

Before we do anything, non-viz content needs the ability to scale. We know that stretching a bar chart will change the size of the bars but labels, titles, axes and images do not scale. Fix that first. [**Update: Post TC15 - all of these are still an issue** 0/1]

Second, we need to replace (or at least augment) the dashboard authoring environment. [Nelson Davis has put together a fantastic example of how to make Actions more intuitive.](http://thevizioneer.blogspot.com/2015/10/i-dream-of-tableau.html) Here’s a sample of what he’s dreamt up.

![Nelson](https://cmtoomey.github.io/img/nelxon-1443715229-22.png)

But that’s just the first step. To really achieve this vision, we need a UI composer. One that combines the visual ease-of-use Tableau is known for with the power of HTML, CSS, and JS. Code should never be a pre-requisite, but a user should always be able to get under the hood and edit line-by-line.

> ### Recommendation 2: Tableau should build (or acquire) a next generation dashboard design interface. It should allows users to define visual behaviors without relying on HTML or CSS knowledge, while also providing code-level editing when needed.

In short, we need Tableau to be more like [Macaw](http://scarlet.macaw.co/).

![Macaw](https://cmtoomey.github.io/img/screenshot-1443103741-58.png)

Many “newer” BI tools are moving in the direction of true responsiveness, especially Salesforce Analytics Cloud and Domo, but nobody has a UI composer. Tableau should be the first. It has always been a flexible tool, but if they can’t solve the responsive problem, it’s going to get left behind. [**Update: During the TC15 Keynote, Tableau announced a Device-specific Dashboard concept. It's a huge step in the right direction.** 1/2]

---

### Encoding

How do we make data make sense?

This is a more complex concept, but it comes down to how information is represented  (69). For a tool to meet the encoding requirement, it must be flexible enough to easily create visualizations that are:

+ **Appropriate** Neither more more less information than needed for the task at hand
+ **Natural** Properties of the representation closely match the information being represented. New metaphors are only useful for representing information when it matches the underlying analytic method.
+ **Matching** Match the task(s) performed by the user – and are suggestive of the appropriate level of action.
+ **Congruent** Structure and content should correspond to the desired mental representation. Represent the important concepts in the domain of interest
+ **Apprehensible** Visualization should be readily and accurately perceived.

Tableau supports all of this now - it can represent data in almost any way, allowing users to transform data into forms that highlight commonalities or outliers (69), with users able to set tolerances on what defines that tendency (88). The works of [Noah Salvaterra](http://datablick.com/blog/), [Chris DeMartini](http://www.jumpplot.com/), and [Jeffrey Shaffer](http://www.dataplusscience.com/insights.html) have gone a long way to showing how to adapt the row/column model to charts based on flow and circular concepts.

While many of these diagram types require math and specialized data structures, there is one glaring exception that remains difficult for Tableau to manage - the relationship view or network graph (92).

Why is this important? Most human (i.e. qualitative) problems are based on relationships between actors and other entities. It is difficult to describe these complex, many-to-many relationships in a traditional relational model. There’s an entire family of data formats (i.e. RDF and OWL) and a query language (SPARQL) dedicated to storing and querying these data. Even basic ontologies are too complex for a relational model.

Further complicating the issue, Tableau’s design choices around points, lines, and paths requires a very specific, redundant, and non-intuitive data structure based on an arbitrary coordinate system. This reliance on coordinates means Tableau can build a directed graph (as physical place is pre-determined). This is not a true network representation because layout should be a function of the entities’ interconnectedness.

**Why is this so difficult?** XML.

Tableau is fundamentally XML-based, meaning its core controls are structured around a hierarchical or tree-based concept. This aligns well with the problem of analyzing relational data, but it also means that non-hierarchical relationships result in some sort of Cartesian join. Networks are hard to express via this tree-based structure simply because they are, by definition, not hierarchical.

There is some good news: the data problem has been solved by [Facebook](https://facebook.github.io/react/blog/2015/05/01/graphql-introduction.html) and [Netflix](https://netflix.github.io/falcor/documentation/jsongraph.html).

<iframe width="100%" height="315" src="https://www.youtube.com/embed/hOE6nVVr14c" frameborder="0" allowfullscreen></iframe>

In addition, there are families of NoSQL databases that store data in a graph format. Typically there is typically a relationship between ANSI SQL and their native query structure. Tableau has started down this path with the MongoDB connector, but this isn’t enough.

> ### Recommendation 3: Tableau should expand on the MongoDB connector and the Web-Data Connector method to include native connectivity to graph databases like Titan and Neo4j.

Bad News: simply translating SQL into something that Neo4J or Titan can understand won’t solve the problem. It will make that data more accessible but not without substantial user pain. [Just look at how difficult it is to connect Apache Drill to Tableau](https://drill.apache.org/docs/using-apache-drill-with-tableau-9-desktop/). No thanks.

Tableau needs a different method - but lucky for us, they already built it: **The Web Data Connector**. If you watch the video on Falcor, the most important thing you’ll see is the creation and population of a dynamic JSON-based graph from a database. The WDC was built to query and parse JSON into a form that Tableau can consume. Since Falcor’s JSON is a graph, Tableau now has a frame of reference for displaying it.

The only remaining problem is generating the initial graph...but Tableau has that solved too. The initial graph needs to understand the relationship between entities and their aggregate measures. Tableau already collects this metadata in the creation of an initial data connection, and stores it in the TDE column-store. Since Tableau intuitively knows how to do all necessary steps, they just need to direct resources towards building a Falcor Model every time you connect to a DB.

> ### Recommendation 4: Tableau should develop a back-end integration between Tableau Data Connectors, the Tableau Data Engine, Falcor, and the Web Data Connector.

Falcor will come back in a bit, in the User Interaction portion...which starts right here!

[**Update: No progress on graphDB connections or new backend processes** 1/4]

---

### User Interactions
Everything in Tableau starts by connecting to data...so that’s where I will start too.

Something Tableau needs to do better is to make it easier to connect to data. Yes, the data source list is expansive, but I shouldn’t have to download a driver to make it work. If I don’t have it, Tableau should fetch it for me and ask me to install it.

Now that I can connect to data, let’s talk about that experience. Access to data implies a few things: access data tables/views inside a single database; and data across multiple sources. But is it possible to couple this data together quickly and easily (94)? **No.**

### Will it Blend?

To do meaningful analysis, you often need data from multiple sources. If you need to cross data sources or DB instances, blending is a fantastic option. But what about data that resides in the same DB, but isn’t necessarily in the reporting database (perhaps it is in some sort of sandbox area)? Right now, Tableau forces you to blend that data.

![Federate](https://cmtoomey.github.io/img/screenshot-1443564118-48.png)

It appears that the definition of a database is only within a single dataset or schema...so I have to blend data that lives in the same DB. If Tableau can connect to a DB, a user should be able to access ANY DATA in the DB natively. But how?

Alteryx has solved this problem with their In-DB workflow tools. You connect into the DB and do your work inside, and then stream out a finished product. Not only is this a brilliantly elegant concept, it’s fast too! [Check it out](https://3danim8.wordpress.com/2015/05/13/the-brilliance-of-alteryx-in-database-processing/).

<iframe width="100%" height="315" src="https://www.youtube.com/embed/GGkEd3KoMj0" frameborder="0" allowfullscreen></iframe>

While awesome by itself, an In-DB capability isn’t enough. Users need to be able to flow in between analysis and data processing seamlessly. Remember the advanced visualization concepts I mentioned earlier? They require very specific data structures. If I want to build a chord diagram, I should be able to make that decision, flow my data into a new construct, and build; regardless of underlying data source (that includes TDEs too).

I know Tableau likes to build things themselves, and they’ve done well so far...but it is time to grow up. Spend some capital and jump the line.

> ### Recommendation 5: Acquire Alteryx and build an integrated data management and reporting platform.

[**Update: During the TC15 Keynote Tableau announced the forthcoming ability to run federated queries.** 2/5]

---

### Maps

Early in this missive, I mentioned that Tableau cheats to get some of its performance. Maps is where it is most prominent. How so?

Tableau maps aren’t actually maps. They are pictures of geography with points plotted on them. When Tableau says you can plot millions of points on a map, that’s really not what you are doing. You are simply putting a bunch of points on a blank coordinate system and then displaying a picture in the background.

If you tried to plot a million points on a web map, it will crash. No modern browser can handle that amount of data, you have to abstract it into a [heatmap](https://github.com/Leaflet/Leaflet.heat) or be able to leverage GL-based rendering. Neither of which Tableau can do...yet.

![pushpin](https://cmtoomey.github.io/img/screenshot-1443565171-68.png)
This is the Tableau map equivalent.

Further complicating matters is Tableau’s choice of mapping stack. If you have read any of [Craig Bloodworth’s posts on custom shapes](http://www.theinformationlab.co.uk/2015/06/05/using-alteryx-to-create-tableau-filled-maps/), you have a sense of how creaky Tableau’s maps actually are. There is a large local DB (based on Firebird) that manages all the shapes and points.

This means I’m at the mercy of Tableau’s developers to include or update shapes, add locations, or add something less common or even custom. Having edited Tableau’s Firebird directly, I can tell you it is a huge pain to manage. There has to be a better way.

There is: **Mapbox, specifically their new GL-based platform**. You’ve heard about this platform if you went to TC14 last year, or have followed the work of Anya A’Hearn. However, these techniques only make for prettier pictures in the background. What if I want to include things like radial distances for nearest neighbor analyses, or want to create sets based on geographic information? Not currently possible with Tableau, totally possible with Mapbox. How?

First off, Mapbox is based on Open Street Map, the whole thing, [right out of the gate](https://www.mapbox.com/blog/whats-in-a-mapbox-studio-style/).

![Xray](https://cmtoomey.github.io/img/xray-1443565870-26.gif)

Why is that important? You can use that data to define visual behavior in their upcoming Studio release, but more importantly, you can query it directly with the [Surface API](https://www.mapbox.com/developers/api/surface/). Query = access.

That’s fun, what else is there?

+ [**Distances - check.**](https://www.mapbox.com/developers/api/distance/)
+ [**Directions - check**](https://www.mapbox.com/developers/api/directions/)
+ [**Geooding - check**](https://www.mapbox.com/developers/api/geocoding/)

Those are all great for plotting, querying, and comparing; but what about some nitty-gritty analysis? Mapbox has that too, it’s called [Turf](http://turfjs.org/). Fast, in-browser GIS. It can take all the data and run calculations on it. A simple example - you have a bunch of points and you want to know how close, on average, they all are. Turf can do that.

That’s all well and good, but can they play nice together? Yes: Tableau Desktop and Server is all Javascript and AJAX, so is Mapbox.

> ### Recommendation 6: Tableau should replace it’s mapping infrastructure with a full Mapbox GL integration.

For this to work, Tableau will need to a) allow for the transformation of it’s structured data into GeoJSON and b) create a new class of calculation focusing on geographic functions. The good news, GeoJSON isn’t that far from XML/JSON and Mapbox is a well-documented platform. Eventually we might get something like this, but instead of buttons we can use filters, parameters, and actions:

![QT](https://cmtoomey.github.io/img/mapboxqt-1443566801-76.gif)

[**Update: During the TC15 Keynote Tableau announced Mapbox integration for background maps. GL-based styles are now possible, not supported. No API or Turf integration announced or planned...yet.** 3/6]

---

### Production

Beyond the technical capability to do work is the actual doing. The part where an analyst works their craft.

If you are doing any type of analysis, there are two important components to consider. First, tracing your steps - this is typically referred to as auditing and/or version control. Tableau has no notion of how to accomplish this; saving Rev1/2/3 doesn’t count. The steps you take aren’t recorded in a formal, accessible way. If you go back and then forward again, any progress from that fork are lost.

Without documentation, it is impossible to understand what steps were taken or, more importantly reproduce those steps. Reproducibility permits alternate lines of questioning and deeper reasoning by individuals with different experiences and backgrounds (61). Peer Review and Reproduction is the core of all good analytic work.
Is there a model we can look to for this? Yes. [Palantir](https://www.palantir.com/2013/05/how-palantir-gotham-enables-effective-audit-log-analysis/) (remember them?) records all analytic activity all the time. This record can then be analyzed within the tool itself or shared out to external collaborators.

> ### Recommendation 7: Tableau should expose an immutable activity log, in a form that Tableau can consume.

The second component is collaboration. If you have a log, people can see your work and build from there. Everyone contributes, answers are better, the process is more efficient. Logging is necessary, but not sufficient, to the collaborative process.

So how to collaborate? If we assume Tableau is able to expose the log, that might be used to “fast-forward” someone else’s work. But there is a better way, a technology that enables both logging and collaboration. **Git.**

In a previous post, I detailed how Git and Tableau work together. In practice (with the Seattle Tableau Use Group), I found it isn’t quite as efficient as I might like. Tableau is constantly writing new lines of XML and re-writing old ones. It also stores certain information in ways that artificially increase the possibility of code conflicts.

But, Tableau can always change how the XML is read and written. It’s their platform.

> ### Recommendation 8: Tableau should add native integration with Git - or any version control system.

This solves a few problems all at once. It gives you true version control, and if you save the log simultaneously, it obviates the need for auto-save. As long as you can commit changes seamlessly, anyone can follow your work, audit it, reproduce it, and expand upon it.

[**Update: During the TC15 Keynote Tableau announced Server-based version control. You can go back to previous versions or into more recent ones...no logging improvements though.** 4/8]

---

### Consumption

There is nothing more frustrating than building a great dashboard, only to be foiled by how Server renders it and allows people to consume it.

After much thought, I’ve come to the conclusion that Server **is not and should not be how Tableau content is consumed**. It’s designed around content management, not content consumption. Tableau 9 made some spectacular upgrades in the front-end, but it is still a weird experience to find and interact with Tableau content.

Making this more difficult is the Tableau community’s continued hesitance to embrace HTML and JS. I understand, it is difficult to break into, but the community is cutting themselves off from a massively useful resource. Therefore, Tableau needs to make it easier for users to build custom consumption environments that natively interact with Tableau’s APIs.

> ### Recommendation 9: The next generation of Tableau Server should be based on Polymer and Web Components that have built-in integrations with the REST and JS APIs.

Polymer is a Google-developed library that makes it easy to build modern web applications. How easy? It is essentially Legos for the web. Want a slider? Drop in a slider. Want animation, one line of code. Want hovers and shadows? Polymer comes pre-built with Material Design, Google’s best practices for web-based UI. It is also responsive out-of-the-box; infinitely skinnable; and easy to extend. Build what you need, drop it in, and you are good to go.

<iframe width="100%" height="315" src="https://www.youtube.com/embed/jVn8tlnwAEs" frameborder="0" allowfullscreen></iframe>

There might be a lot of code and technical terms in there...but don’t be scared. If Tableau embraces Polymer and Web Components, creating a Tableau interface might be as simple as this:

<iframe width="100%" height="315" src="https://www.youtube.com/embed/67FjSemJ7uQ" frameborder="0" allowfullscreen></iframe>

What else can this approach solve? Dynamic parameters. A web-based interface solves that, right now. With Falcor + Polymer, you can drop in a drop-down or slider element, hook it to the JSONG model, and dynamically filter to your heart’s content. Since Falcor is always in-sync with your DBs, so are your parameters.

What about advanced dashboards? If REST is pre-built, you could have a flyout menu that shows you what you have access to, just drag and drop. Event listeners included. Like this

![Polymer](https://cmtoomey.github.io/img/polymer-1443717929-69.gif)

It should be that simple. No code, just build and deploy exactly how you want.

[**Update: No progress on this front, although Slalom did announce VizOS, which is a huge step in the right direction.** 4/9]

---

## That’s it.

Looking back on the origin of Tableau is instructive for what should be next. It should be easier to get to data, structure it, analyze it, collaborate, and publish.

Dynamic parameters are a solved problem, Falcor + HTML + JSAPI. I can do a hands-free deployment and a zero-downtime upgrade of Server, so Administration is a solved problem. We can already make any chart we want.

The mission now, as it was then, is about empowering people with their data. Make advanced analysis easier, enable the user to work how they want by giving them the most advanced, elegant platform possible, and let them build.

Thank you Tableau, for building such a great product already. It’s time to make it better, and now you know how.

# You are welcome

![Zen](https://cmtoomey.github.io/img/fut-1443570810-1.png)

# You know where to find me
