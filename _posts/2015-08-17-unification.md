---
layout: post
section-type: post
title: The Unification Round
category: Javascript
tags: [ 'api', 'xml', 'javascript' ]
---
![Ali](https://cmtoomey.github.io/img/unify-1437615845-32.gif)

### Tableau Javascript & REST API together at last!
---


For quite some time, Tableau has had a [Javascript API](http://onlinehelp.tableau.com/current/api/js_api/en-us/help.htm#JavaScriptAPI/js_api.htm), which let you embed your vizzes into websites and apps. If you were especially nerdy, you could go even further do full-blown integration between Tableau and anything that speaks JS ([Allan Walker](http://allanwalkerit.tumblr.com/) and [Jeffrey Shaffer](http://www.dataplusscience.com/insights.html) - I’m looking at you!).

In Tableau 8.2, the REST API was introduced. This library was meant give you external control over Tableau Server - what is typically referred to “programmatic access.” You could always create/edit/query/delete sites, groups, projects, and users, but it wasn’t until Tableau v9 that REST’s feature set was actually useful. Now you can upload workbooks, query/update data connections, and manage permissions(!).

Of the two, the JSAPI has always been the more popular child. Tableau provides [7 training videos](http://www.tableau.com/learn/tutorials/on-demand/javascript-api-intro-and-embed), while REST only gets one. There’s even a [whole site focused on making the JSAPI more accessible](http://padawandojo.tumblr.com/post/118909494969/tableau-js-api-101). Personal opinion, it’s probably because the JSAPI focuses on the viz themselves, while REST is squarely in the domain of Server Admins.

### So What's the Big Deal?
Having APIs is great - but most people are a bit stand-offish when it comes to code. I get it, it’s intimidating - you have to be ok with things not working exactly how you learned them in training, and it is nearly impossible to keep up with technology...especially web technology.

There is a clear value proposition to both: *You can put Tableau anywhere and manage it on the fly*. That’s no small feat.

#### But how, exactly, do you do that?
The JSAPI is straightforward - it’s Javascript. Google [“Javascript Training”](http://lmgtfy.com/?q=javascript+training) and there are pages and pages of options - most at a fairly low cost (including free). Tableau’s training is actually a great introduction, and it includes some basic HTML instruction.

The REST API on the other hand - that’s a different technical beast all together. It requires an understanding of how HTTP requests actually work - which means you need to understand the plumbing of the Internet. That’s easy, right? If you watch the Tableau video on REST (narrated by the great Michael Kovner), or watch the [TC14 session](https://tc14.tableau.com/schedule/content/932) on Tableau APIs, there is a lot going on. Kovner and Christopher use something called [NodeJS](https://nodejs.org/en/) to do all their work. Great - another thing you have to learn (not that you shouldn't, Node is awesome).

But what if you just want to have some basic functionality in a webpage to see Tableau Server content (like which viz are available to a specific user) and then use that information to embed it into your app? And not learn anything more than basic, vanilla Javascript? Is it possible to unify the APIs?

### YES
In boxing, where there is a World Boxing Association, a World Boxing Council, an International Boxing Federation, and a World Boxing Organization that all have a World Champion - and when they unify the titles (like when Mayweather and Pacquiao fought), everything is nice and tidy.

Here, we have two true APIs that touch Tableau’s services. We natively want to use them together. We want to unify them into one Tableau API.

---

# Done
![Snippet](https://cmtoomey.github.io/img/screenshot-1437677334-9.png)

What is this? It is a package you can download for Atom (that’s an IDE - that thing I told you to get in one of my very first posts). What it does is normalizes every major REST API function into a series of keystrokes - resulting in clean Javascript, with a nice jQuery wrapper.

There’s a pattern - start with **tr** (for Tableau REST) + **[activity]** (like Query) + **[target]** (like Groups). The output is formatted Javascript, complete with declared variables and documentation. It even makes suggestions to help you find what you are looking for.

I know that sounds a little abstract - so here’s an example:
![First](https://cmtoomey.github.io/img/login-1437682910-39.gif)

The example above is how you want to start any use of the REST API - logging in. Once you do that, you get two key pieces of data: the **AUTH** token, and a **SITEID**. If you use any other examples, like below, you can just use auth and siteid globally (in fact, I did it for you).

![createsite](https://cmtoomey.github.io/img/createsite-1437683087-62.gif)

I’ve done my best to document what you need to put into each call and what comes back - that way you can either capture that data and use it elsewhere, or move on.
In the GitHub Repo and the Atom Package site, I’ve included some documentation about how to do this (it’s also commented into the login snippet). Play around with it - I promise you’ll get the hang of it.

### Unification - Complete!
![Belt](https://cmtoomey.github.io/img/belt-1437686868-82.gif)

---

## Where did this come from?

So we’ve got the ability to write all the Tableau API calls in one language. That may be useful and all, but more useful might be how this all came about. Knowing the process might just unlock some other really cool Tableau things for you.

First - [go download Postman](https://www.getpostman.com/). That’s the key to everything. Once you have that, you need the [REST API Collection](https://github.com/TableauExamples/Tableau_Postman). That GitHub repo will have the instructions you need to get things up and running.

When you are ready, launch Postman. You’ll see the Collections tab on the left, click it and pick a function. That will populate your UI with everything you need - but you aren’t going to make the actual REST call. Instead, you want to click on the **<>** icon on the right hand side. This is the **MAGIC BUTTON**. Watch!

![Magic](https://cmtoomey.github.io/img/postman-1437687957-60.gif)

What just happened? Postman builds API calls - and the MAGIC BUTTON allows you to format and export the code into any language you like. That includes Javascript. Like so.

![Magic2](https://cmtoomey.github.io/img/js-1437688049-14.gif)

Now we have a pre-formatted code snippet. That button on the right is COPY. I selected jQuery AJAX because it’s the easiest to use (way easier than XHR - which is really raw JS). Now all you have to do is paste that code into your application and you are done.

---

### Example - How to be cool like John Oliver
I love John Oliver - I think he’s got the best 30m on television. Period (Sorry GoT). I’m sure you remember his section on net neutrality? You don’t?!?
<iframe width="100%" height="315" src="https://www.youtube.com/embed/fpbOEoRrHyU" frameborder="0" allowfullscreen></iframe>

I say that’s a pretty important topic - but let’s say you want to get some FCC data, [where would you even start](http://lmgtfy.com/?q=FCC+Data)? If you use the FCC’s databases, you’ll be frustrated in a big hurry. Zip Files, XML downloads (really?), and 1990s-era interfaces. BUT - they do have some fantastic data made available as APIs. For example:

+ [Stations](https://stations.fcc.gov/developer/)
+ [Consumer Broadband Test](https://www.fcc.gov/general/consumer-broadband-test-api-0)
+ [Spectrum Licenses](https://www.fcc.gov/general/license-view-api)

The FCC’s [entire document library](https://www.fcc.gov/general/fcc-content-api) is also available via API, but that’s a little extreme right now. Let’s just say you want to see all the licenses that Verizon has purchased.

![Verizon](https://cmtoomey.github.io/img/fcc-1438035732-80.gif)

In less then 15s, we went from finding a data source, testing it, and getting the code we need. But how do we get the data out and into Tableau?

**The Tableau Web Data Connector!** - that code snippet you just created is an essential piece of the puzzle. Here’s a selected bit from their documentation.

![Connect](https://cmtoomey.github.io/img/dataconnect-1438036015-45.png)

That box in red should look familiar. It’s almost the exact same thing as what POSTMAN lets you copy out.
<pre><code data-trim class="javascript">
//Tableau's stuff is here
$.ajax({
  url: XXX,
  datatype: json/xml/whatever,
  success: function(data){
  //do stuff
  }
})

//POSTMAN
var settings = {
  “async”: true,
  “crossDomain”: true,
  “url”: “http://data.fcc.gov/api/license-view/basicSearch/getLicenses?searchValue=Verizon%20Wireless&format=jsonp&jsonCallback=%3F”,
  “method”: “GET”,
  “headers”: {}
  }
//.done is the EXACT SAME THING as success: function(data)
$.ajax(settings).done(function (response) {
  console.log(response);
  //do stuff
  }
);
</code></pre>

That means you can use the POSTMAN method to fast-track your own web connectors - just find the datasource you want, drop it’s API string into POSTMAN, and paste that into your connector. All that’s left is to parse the output into an Extract (which Tableau has handily documented for you in the WDC SDK). That’s pretty cool, right?!?

---

### Let's talk about CORS

Ugh - I hate to do this, but it’s important. When you make a request from a data provider you are essentially asking them to let an unknown entity (you) **GET** (the HTTP action) data from their servers. There are other HTTP actions: **PUT, POST, DELETE** - which are far more impactful (because they do exactly what they say they do).

Would you want to let just anyone do that to your machine? Of course not. That’s called [Cross-Origin Resource Sharing or CORS](http://databoss.starschema.net/the-big-cors-debate-tableau-server-and-external-ajax-calls/). It’s very important to understand conceptually, and also know that it’s a gigantic pain in the butt for Tableau.

To enable the flow of data across the internets - most providers require you to use an API key to generate trust and validate identity. Tableau doesn’t do that. If the machine you are on (or making requests from) doesn’t share the same domain as your Tableau machine, you initiate a CORS request. GET (or query-type) requests aren’t a major issue, but if you want to start making changes, like adding sites and users, things get interesting.

Without getting too far into the weeds, what you need to know is that when you send out a perfectly formatted REST call for anything other than a GET (or query), that call can actually changed in preflight (that's a technical term - don't worry about it). It's altered into something called an OPTIONS request - which basically asks Tableau, "Hey, is this sort of thing OK?"

A normally configured server would have a setting that says, OPTIONS = cleared to proceed, which would then allow the REST call to send it’s real payload (what you wanted in the first place). Tableau doesn’t do that - and Tableau Server’s configuration makes it very difficult to do so. Believe me, I tried...and tried...and failed.

In the context of this discussion, Tableau Server is just an [Apache Web Server](http://httpd.apache.org/). There are pages and pages of discussion on how to enable CORS on Apache. I tried them all - no dice. The customizations that Tableau has done to the Apache configuration file (and more importantly, how it interacts with the Java Spring framework that Server is built on) has resulted in a rule set that conflicts with those standard header changes. Not to speculate too much, but given the drastic overhaul of v9, it wouldn't surprise me if there are some additional areas of conflict between Apache and the other frameworks built into Server ( I didn’t write it, so I can’t fix it - at least not without inadvertently breaking something).

So - if you have Tableau Server sharing a domain with all your stuff, great. If you don’t - go here and vote this up. They don’t need to enable it directly, but some documentation would be nice.

So - if you have Tableau Server sharing a domain with all your stuff, great. If you don’t - [go here and vote this up](https://community.tableau.com/ideas/2644). They don’t need to enable it directly, but some documentation would be nice.

#### Counterpoint to using the Web Data Connector or Apache HTTPD folder

Today, T[amas Foldi published an awesome article](http://databoss.starschema.net/the-big-cors-debate-tableau-server-and-external-ajax-calls/) on how use Tableau’s new Web Data Connector function to get around CORS. Essentially, you tell Server to host your code, thereby making all your API calls same-origin. It’s a great hack - but it only solves one problem, and obfuscates the one we should be talking about.

You could always your own HTML/JS/CSS from Tableau’s Apache HTTPD folder. If you understand the routing, you can basically extend the Server URL to point to your own application. You’d have to maintain that with every upgrade, but it could be done.

Migrating to the WDC method does effectively make this supported(!), since (or I’m assuming) a Server backup will capture items in the data connector folder.

However, if you take this method to a logical endpoint, it actually creates more work.

+ First, you could write a single monolithic page that returns all the REST content for you - which limits your application flexibility.
+ Second, you could write a bunch of custom web applications that do everything you need, specific to each application's needs. BUT - that means more maintenance.
+ Third, regardless of your choice, you would have to write a client-side parser to capture all that content and then use it. That's not hard, but it's still more work.
+ Fourth, you are essentially duplicating the functionality of the current REST API, just transforming its output from XML to DOM-based HTML.
+ Fifth, if it all lives in web data connectors, you are exposing admin data to people who don't need to see it.

Tamas is right about CORS being a **GREAT DEBATE**. Getting data out of Tableau’s services is important, it opens up a whole new way of thinking about how Tableau can interact with the modern Internet. But it’s harder than it needs to be. CORS has been [discussed since 2005](http://www.w3.org/TR/cors/), and if you have an API, you better have a CORS strategy. Tableau doesn’t, and they need to get one.

Workarounds like the Apache or WDC are great - but they don’t actually solve the problem. We can all help by being more like Tamas, Allan Walker, Jeffrey Shaffer, and everyone else doing things with Tableau’s JS. Find places where Tableau doesn’t work like it should, and then tell Tableau that it needs to be fixed. You should always hack around it, but don’t lose sight of solving the actual problem.

### Regardless of CORS - don’t be intimidated by the APIs any more
They are awesome and useful. Go get Atom, download the package and #buildtheawesome. Let me know @Sock1tToomey if you have any questions or I can help in any way.

Otherwise,
<iframe src="//giphy.com/embed/e93BVmjVPfvlm" width="100%" height="192" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/hbo-john-oliver-last-week-tonight-e93BVmjVPfvlm">via GIPHY</a></p>
