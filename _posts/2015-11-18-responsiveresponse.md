---
layout: post
section-type: post
title: Responsive Response
category: Responsive
tags: [ 'design', 'javascript', 'api', 'tutorial' ]
---

## Here's how I feel when someone asks me if Tableau can be responsive.

<div class="titleheader">
  <img src="https://cmtoomey.github.io/img/solo-1447867501-75.gif" alt="..." />
  <div class="titletitle">
    <h3>Sure...</h3>
  </div>
</div>

---

If you were one of the 10,000 people who went to TableauCon2015, you saw Tableau unveil something called “Device-specific Dashboards.”

![DSD](https://cmtoomey.github.io/img/devicespeci-1447867661-87.jpg)

This is Tableau stepping (very slowly) into the realm of what is known as **Responsive Design**.

### What is **Responsive Design?**

If we consult the [all-mighty oracle](https://en.wikipedia.org/wiki/Responsive_web_design):   

>**Responsive web design** (RWD) is an approach to [web design](https://en.wikipedia.org/wiki/Web_design) aimed at crafting sites to provide an optimal viewing and interaction experience—easy reading and navigation with a minimum of resizing, panning, and scrolling—across a wide range of devices (from desktop computer monitors to mobile phones).

Ok - but so what? Why am I writing about this now, when it’s been a month since TC15? Well, this morning (11.18.2015) Allan Walker (Zen Master and principal architect behind VizOS) posted a method for [creating responsive Tableau Dashboards](http://allanwalkerit.tumblr.com/).

That generated a valid question from his fellow Zen Master Andy Kriebel.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/AllanWalkerIT">@AllanWalkerIT</a> Nice tip! Question for you: how does this differ from setting the dashboard size to automatic?</p>&mdash; Andy Kriebel (@VizWizBI) <a href="https://twitter.com/VizWizBI/status/666994593011859460">November 18, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

That got me thinking - why should people care about Responsive Design, and what’s the easiest way for them to utilize it?

### Why should you care?

You cannot predict or control how your users will interact with your content. Desktops, laptops, high pixel-density displays, smartphones, tablets - so many screens! Just how many - Kelly Martin has the answer.

![response](https://cmtoomey.github.io/img/screenshot-1443102991-73.png)

You should care about HOW your users will consume your content. If it doesn’t look good on their device of choice then they won’t care about it at all. Here’s some Responsiveness in action - courtesy of Tableau Public.

![Responsive1](https://cmtoomey.github.io/img/responsivene-1447870219-37.gif)

#### How to do Responsive Design in tableau

Until DSD arrives, you have a few options. As I mentioned at the top, DSD is Tableau toeing into the Responsive Design world. It's a great first step, but it will require you to pre-specify the devices you want your users to consume your work on. That's backwards. It lacks the fluidity of true Responsive Design - but I'll take what I can get.

Responsive Design also requires layout changes and font-resizing - which DSD can handle ([@Ajenstat said so](https://twitter.com/Ajenstat)) - but the current version of Tableau can’t do that yet.

---

### Tableau Out-of-the-box: Automatic/Ranged Dashboard Sizes

Alright [Andy Kriebel](https://twitter.com/VizWizBI) - this part is for you. When you publish a dashboard using an Automatic Size, this is what you get in Public/Server.

Here’s my dashboard - set to Automatic. It will resize in Desktop.

![Start1](https://cmtoomey.github.io/img/screenshot-1447870364-85.png)

Here’s what happens in Public when I resize my screen.

![Start2](https://cmtoomey.github.io/img/currenttabl-1447870546-35.gif)

This is probably because Tableau Public wants to keep some sort of standardization around allowable screen sizes. That makes sense. Let’s try it in a custom HTML element (a div) and see what happens.

First we need a webpage that looks responsive.

    <!DOCTYPE html>
    <html>

      <head>
        <meta charset="utf-8">
        <title>Tableau test</title>
        <style>
          #tableau {
            background-color: blue;
            padding: 0px;
            height: 95vh;
            width: 100%;
          }
        </style>
      </head>

      <body>
        <div id="tableau">
        </div>
      </body>

    </html>

Here’s what that produces:

![start3](https://cmtoomey.github.io/img/sampleresiz-1447874196-15.gif)

The blue box is always visible - and fills the screen. Exactly how we want Tableau to behave. So let’s Javascript it in, so our code looks like this:

    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="utf-8">
      <title>Tableau test</title>
      <script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
      <style>
        #tableau {
          background-color: blue;
          padding: 0px;
          height: 95vh;
          width: 100%;
        }
      </style>
    </head>

    <body>
      <div id="tableau">
      </div>
      <script type="text/javascript">
        var placeholderDiv = document.getElementById("tableau");
        var url = "https://public.tableau.com/views/ResponsiveDashboards/Dashboard1?:embed=y&:display_count=yes&:showTabs=y";
        var options = {
          hideTabs: true,
          onFirstInteractive: function() {
            // The viz is now ready and can be safely used.
          }
        };
        var viz = new tableau.Viz(placeholderDiv, url, options);
      </script>
    </body>

    </html>

That update produces this:

![start4](https://cmtoomey.github.io/img/tableauresi-1447872080-32.gif)

That’s it - no additional code required. Here's how to keep it simple:

+ Your <div> needs to scale with screen size
+ Your Tableau content needs to be set to Automatic.

You don’t need to set height and width in your CSS - if your dashboard is set to automatic and you don’t include those two settings, [Tableau will default to published settings](http://onlinehelp.tableau.com/current/api/js_api/en-us/help.htm#JavaScriptAPI/js_api_whats_new.htm#code_changes).

#### 9.2 makes this so easy

In the 9.2 update to the Javascript API, Tableau has (thankfully) embedded a VIZ_RESIZE event listener. What this means is that when you change the size of your window, Tableau detects it, gets the new size, and double checks against the size of your viz. If they don’t match (and you haven’t specified a size) then Tableau will resize it for you (you can’t do DSD without this feature).

What this means is a) you don’t need any jQuery or other event listeners to get properly sized vizzes in webpages. Tableau does that all for you; and b) we just removed two lines from your code and/or the need to do a find/replace if you were using [Allan’s method](http://allanwalkerit.tumblr.com/).

[This Interworks method](https://www.interworks.com/blog/daustin/2015/11/12/creating-responsive-embedded-tableau-dashboards) and [this Tableau Community method](https://community.tableau.com/message/358175?et=watches.email.thread#358175): you don’t need that much code, Tableau is now doing all that for you.

---

### The Elephant in the Room

Everything I’ve shown above is great if you only have one worksheet, or a dashboard with LOTS of white space. But what about a dashboard, specifically one with lots of well-designed actions and well-placed Quick Filters, Parameters and Text Objects?

Let’s see what that looks like - everything is tiled (no floating objects) and set to Fit Entire View.

![dashboards](https://cmtoomey.github.io/img/dashboards-1447874903-89.gif)

Not great - but everything retains the original ratios. Squished, maybe, but still serviceable.

What about floating? When you publish to Server/Public, it’s largely the same experience.

![floating](https://cmtoomey.github.io/img/floatingin-1447875195-4.gif)

Still serviceable - everything is still a bit squished though. There are ways to get alternate configurations, so your content looks great on any device - even without DSD.

The first way: **CSS**. [Dwight Horley](https://public.tableau.com/s/blog/2014/11/making-responsive-tableau-dashboards) gives an excellent tutorial on how this all worksThese are CSS-based values, utilizing breakpoints and media-queries (like a tab-stop for a screen size) to determine which parts of the HTML to show. The CSS detects the screen size and then pulls up the version you want to show.

Here’s what that looks like:

![media-queries](https://cmtoomey.github.io/img/mediaquery-1447875758-76.gif)

Downside: You can see that the formatting gets a little packed at mobile size. This is a long-standing gripe I have with Tableau - no webfonts or em-sizing. If I’m going to design a dashboard, I’d like to not click 1000+ plus times to set every single font size for every single device. **THEY SHOULD SCALE ON THEIR OWN**.

More importantly, while this is a cool method, you aren’t actually seeing one dashboard. It’s three, all scripted in at the same time, and the code is dynamically hiding the elements. That means that unless everything is Global, it won’t save my work - easy fix, but it’s still extra work.

The second way: **Javascript**. As part of the wonderful “You Did WHAT with Tableau’s APIs?” [Russel Christopher](http://russellchristopher.me/youdidwhat/responsive.html) built a similar responsive model. Here it is:

![javascript](https://cmtoomey.github.io/img/js-1447876113-57.gif)

Russell is also using 4 sheets, each associated with a MinWidth. jQuery detects the width of the screen, and when it is resized, it checks against the table and does a sheet swap to the right one.

    { sheetName: "PC Dash", sheetUrl: "PCDash", minWidth: 1250 },
                    { sheetName: "iPad Landscape Dash", sheetUrl: "iPadLandscapeDash", minWidth: 980 },
                    { sheetName: "iPad Portrait Dash", sheetUrl: "iPadPortraitDash", minWidth: 700 },
                    { sheetName: "iPhone Dash", sheetUrl: "iPhoneDash", minWidth: 0 }

       // This function loops through your table and returns the first sheet that fits in the current width.
                function getSheet(width) {
                    for (var i = 0; i < sheetTable.length; i++) {
                        if (width >= sheetTable[i].minWidth) {
                            return sheetTable[i];
                        }
                    }
                    return sheetTable[sheetTable.length - 1]; // just in case none of the minWidth values work
                }

                // This function is called by jQuery when the window is ready for use.
                $(function () { initializeViz(); });

                // This function adds the viz to the div named tableauViz, selecting the sheet that fits the current width.
                function initializeViz() {
                    var placeholderDiv = document.getElementById("tableauViz");
                    currentSheet = getSheet($(window).width());
                    var options = {
                        width: placeholderDiv.offsetWidth,
                        height: $(window).height(),
                        hideTabs: true,
                        hideToolbar: true,
                        onFirstInteractive: function () {
                            workbook = viz.getWorkbook();
                        }
                    };
                    viz = new tableauSoftware.Viz(placeholderDiv, workbookUrl + currentSheet.sheetUrl, options);
                }

                // This function is called when the window resizes.  It changes sheets if needed.
                $(window).resize(function () {
                    viz.setFrameSize($(window).width(), $(window).height());
                    var newSheet = getSheet($(window).width());
                    if (newSheet.sheetName !== currentSheet.sheetName) {
                        currentSheet = newSheet;
                        workbook.activateSheetAsync(currentSheet.sheetName)
                            .otherwise(function(err) {
                                console.log(err);
                            });
                    }
                });

Very clever - but I still need four sheets, and some code.

Method three: **only use worksheets and assemble a “dashboard” independently**. I don’t have a working example of this - because it’s a bit crazy. You get full control of size and placement. You don’t have to worry about Quick Filters or Parameter boxes since you can use HTML UI elements for that.

But you can’t do actions...well you can, but I wouldn’t recommend rebuilding Tableau Dashboard actions in Javascript. Don’t do it.

---

### So what now?

Hopefully you have a better understanding of a) what Responsive Design is and b) how you can and will be able to do it in the future.

DSD will be a nice upgrade since it will let you specify a device type and rearrange your dashboard. You’ll have to manually pick every type of formatting, but at least you won’t have to have four versions of the same thing. I will be interested to see how this interacts with the JS API.

Ideally, I’d like to have the ability to define my own breakpoints. Scalable dashboard design is very tied to the dashboard itself, and Tableau already does a decent job with keeping things where the need to be and scaled appropriately. If I could scale it up and down and set breakpoints **when I need to**, rather than being constrained to the list of devices Tableau currently supports, and then re-arrange my viz, Tableau can handle the intermediate sizing.

I think DSD is well intentioned, but it might be more trouble for the user than it’s worth...and for the love, can we please have scalable fonts and native access to Google Fonts and TypeKit? **Bring your own font for the win!**

## PLEASE?

![Chewie](https://cmtoomey.github.io/img/giphy-1447877362-44.gif)

---

### Update

Within 5m of this post, Allan Walker emails me and mentiones that the method I described above won’t really work if you have to use the embed code instead of Javascript. So if you are using a Sharepoint webpart or something where you don’t have code-level access, things might be a little bit different.

That’s a great point - but then I got to thinking, what if I stripped out the height/width specs in the embed code...does Tableau behave the same way? It’s not any more efficient than Allan’s method...but it’s a great thought experiment.

Let's embed into an HTML document where I render it to a specific size.

    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="utf-8">
      <title></title>
    </head>

    <body>
      <script type='text/javascript' src='https://public.tableau.com/javascripts/api/viz_v1.js'></script>
      <div class='tableauPlaceholder' style='width: 982px; height: 742px;'>
        <noscript>
          <a href='#'>
            <img alt='Dashboard 1 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Re&#47;ResponsiveDashboards&#47;Dashboard1&#47;1_rss.png' style='border: none' />
          </a>
        </noscript>
        <object class='tableauViz' width='982' height='742' style='display:none;'>
          <param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' />
          <param name='site_root' value='' />
          <param name='name' value='ResponsiveDashboards&#47;Dashboard1' />
          <param name='tabs' value='no' />
          <param name='toolbar' value='yes' />
          <param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Re&#47;ResponsiveDashboards&#47;Dashboard1&#47;1.png' />
          <param name='animate_transition' value='yes' />
          <param name='display_static_image' value='yes' />
          <param name='display_spinner' value='yes' />
          <param name='display_overlay' value='yes' />
          <param name='display_count' value='yes' />
          <param name='showVizHome' value='no' />
          <param name='showTabs' value='y' />
          <param name='bootstrapWhenNotified' value='true' />
        </object>
      </div>
    </body>
    </html>

That renders a specific size - like so:

![Update1](https://cmtoomey.github.io/img/embedtest-1447884061-86.gif)

Non-responsive, as intended.

Now, let’s approximate the Sharepoint embed process - as documented [here](http://onlinehelp.tableau.com/current/server/en-us/embed_ex_SP.htm).

We have two size options: fixed or dynamic. I think for this purpose, the size we pick really doesn’t matter because Sharepoint will be managing the size. If it’s fixed, you would be building a fixed dashboard anyways. So let’s pick an arbitrary size: 500x500. We then need to remove the explicit Tableau sizing and see what happens.

    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="utf-8">
      <title></title>
    </head>

    <body>
      <script type='text/javascript' src='https://public.tableau.com/javascripts/api/viz_v1.js'></script>
      <div class='tableauPlaceholder' style='width: 500px; height: 500px;'>
        <noscript>
          <a href='#'>
            <img alt='Dashboard 1 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Re&#47;ResponsiveDashboards&#47;Dashboard1&#47;1_rss.png' style='border: none' />
          </a>
        </noscript>
        <!-- Styling removed from here -->
        <object class='tableauViz' style='display:none;'>
          <param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' />
          <param name='site_root' value='' />
          <param name='name' value='ResponsiveDashboards&#47;Dashboard1' />
          <param name='tabs' value='no' />
          <param name='toolbar' value='yes' />
          <param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Re&#47;ResponsiveDashboards&#47;Dashboard1&#47;1.png' />
          <param name='animate_transition' value='yes' />
          <param name='display_static_image' value='yes' />
          <param name='display_spinner' value='yes' />
          <param name='display_overlay' value='yes' />
          <param name='display_count' value='yes' />
          <param name='showVizHome' value='no' />
          <param name='showTabs' value='y' />
          <param name='bootstrapWhenNotified' value='true' />
        </object>
      </div>
    </body>

    </html>

![Update2](https://cmtoomey.github.io/img/embedtest1-1447884527-91.gif)

This is interesting - you can see the 500x500 source div, but the embed API: https://public.tableau.com/javascripts/api/viz_v1.js doesn’t have the same behavior as the JS API. That’s because it’s primary role is to assemble the correct URL with height/width - it needs explicit styling [see below], which means responsiveness will require event listeners to detect the size of the div.

*The source for the <script> tag is the URL for the Tableau Server JavaScript file, viz_v1.js. The JavaScript file handles assembling the full URL of the view that’s displayed for your users.*

I haven’t had to embed Tableau in Sharepoint via a WebPart, but I’m assuming it works similar to this process. If the WebPart is just an abstraction of the JS API, then the “Adjust Height/Width to fit zone” should work responsively, otherwise not so much. My guess is that it’s working off of Viz_V1.JS.

As always - Allan is one step ahead. The good news is that Responsive Tableau is possible and easy. You don’t have to be afraid of code because there isn’t any - Tableau provides everything out of the box for you.

+ Set size to "Automatic"
+ Click Share, copy the embed and make Allan’s changes
+ Go [here](http://onlinehelp.tableau.com/current/api/js_api/en-us/help.htm#JavaScriptAPI/js_api_concepts_initializing.htm%3FTocPath%3DConcepts%7C_____2), copy the "Bootstrapping" code and delete Height and Width

Ok - now that’s settled - go build some amazing things.

![Hyperspeed](https://cmtoomey.github.io/img/go-1447885648-80.gif)
