---
layout: post
section-type: post
title: What is Tableau, really?
category: Basics
tags: [ 'XML', 'NeedToKnow']
---

Before I write any more works, do me a favor: forget all the marketing, jargon, and Kool-Aid and think critically about the question in the title of the post.

## Ready? Here's my answer

### Tableau is a tool for writing queries and rendering results.

Take a moment and think about that statement- Tableau Desktop (the tool itself) is, at it's core, a rendering engine (and a fantastic one at that). *Why should you care about that?* You should care because that means that you no longer have to consider Tableau as the solution to all your data problems. Stop thinking that you need to have every single piece of data in your viz or your dashboard, with a corresponding control mechanism, for it to be effective. Only then can you stop asking the question, "How do I get Tableau to do X?" and start asking, "How can I use Tableau to achieve Y?"

*Feel better?* No? Let's fix that by showing just how easy it is to bend Tableau to your will.

## XML for the win
At it's heart, Tableau may be a rendering agent, but it's lifeblood is [Extensible Markup Language](https://en.wikipedia.org/wiki/XML) or XML. Here's a list of all the Tableau components (that I know of) that are written in or depend on XML:
+ VizQL
+ Tableau Workbooks
+ Tableau Preference Files
+ Tableau Color Palettes
+ Tableau Mapping Sources

Aside from VizQL (which probably looks something like [this](https://vega.github.io/vega-lite/vega-lite-schema.json) just in an XML-based structure), you can easily view any of the other items in any IDE (thin Brackets, Notepad ++, or even Notepad).

Don’t be intimidated by the many many lines of “code” you see. XML is meant to be human readable, for this exact reason - letting users peek under the hood and get their hands dirty.

It's one thing to open the XML, it's another thing to be explain the hierarchy. To help with this, I created a marked-up version of a TWB [here](https://gist.github.com/cmtoomey/96342ba07dd5cba6ecc6). Check it out and you will have a much better understanding of how a workbook is organized based on how you build your worksheets and dashboards (it is missing one section, Thumbnails - but that really isn’t all that interesting anyways).

## Why so much attention to XML? I can do everything I need to in Desktop.
Programattic Access, son!

In other words, because Tableau is built on a logical structure that is largely predictable, we can automate certain tasks. What kind of tasks?

**Styling**: Formatting in Tableau sucks.  It doesn’t perform consistently, and there are lots of different ways to do it…which makes maintenance nearly impossible.  Anya A'Hearn wrote this [excellent tutorial](http://datablick.com/2015/04/24/give-that-tableau-workbook-a-makeover-with-find-and-replace-gone-wild/). Read it, try it, tell her thank you.

**Automated Templated Workbooks**: Extending Anya's basic concept - if we have certain styles `<style>content</style>` then we can use those to copy and paste our way to a single, branded, consistently styled workbook. No more wasted time with extra clicking.*

How would we achieve such a thing? There isn’t a single great way to do this…yet.  Matt Francis has an excellent method [here](http://wannabedatarockstar.blogspot.co.uk/2013/06/create-default-tableau-template.html).  You basically create a single worksheet and dashboard, set formatting through menus, and then duplicate away (after saving as Read-Only).  Again, if you like it, tell him thanks!

I would do something a little different - I want to make a template, informed by a style guide (I’m thinking enterprise automation), but then be able to apply it to any workbook I’ve created or will create.

First step - build a worksheet, apply standard styling - font + size, background colors, alignment, borders, lines. Using the Format Menu (not Right-Click > Format) I made the worksheet you see below. It’s got pretty much everything turned on and looks awful on purpose. Then I saved it.

It’s important to note that because we are talking about consistency, start with globally accepted styles: fonts, font sizes and formatting, background colors, grids, tooltips, alignment.

The best part: those just so happen to be what you can change in the Format Menu.  If you don’t know what to change them to, simply Google your company + Style guide or just ask someone in Marketing.

![StyleGuide1](https://cmtoomey.github.io/img/StyleGuide1.png)

After I saved the workbook, I opened it up in my IDE and found [this](https://gist.github.com/cmtoomey/68729fc80cb8898ec98b) in my XML, between the `<style></style>` for the sheet.

Once you have that template, you can open up any workbook(s) that you want to style up, find (CTRL-F) `<style></style>` and replace with the XML you generated from your template. Remember the style tags, otherwise you’ll replace anything with the word “style” in your TWB.

Better yet, you can follow the sage advice of Allan Walker and just do **ONE** workbook with *everything* in it, do one find/replace and you are done.

Or if you really are feeling brave - you can write a script that does something like this (FYI - I don’t know your environment, what type of sources you use, operating system, etc…but you can hand the basics to a dev and they can script it).

+ Get the workbook: (tabcmd or CURL would work great here)
+ Open your IDE: START IDE.exe filepath\\twb(x) (you might need to unpackage the file first)
+ Using Python or Powershell, parse the XML Tree
+ Find the worksheet `<style></style>` tags and replace them with yours
+ Write out to a TWB (or overwrite)
+ Publish using tabcmd Workbook.twb -n “Name” –db-username “jsmith” –db-password “p@ssw0rd”

**Replace Data Sources**: I know what you are thinking - *“Replace Data Sources?!? NOOOOOO!”* This is an example that comes from my colleagues Clark Stevens and Justin Emerick.  It’s pretty fancy and awesome.

Let’s say you have Database A as your primary connection for your workbook. Now let’s say the company swaps over to a new technology and wants to migrate Tableau over. This is my typical response to the migration question.

<iframe src="//giphy.com/embed/3oEduZr3O04BtJNWSs" width="75%" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/no-floyd-mayweather-manny-pacquiao-3oEduZr3O04BtJNWSs">NOPE via GIPHY</a></p>

If the columns map identically - you can simply Find/Replace the data source in Tableau’s XML (and you know where that is!). If they don’t then you can do lots of Find/Replace…or not.    

Instead, publish that data source to Server and never look back. Why? Consolidation allows you to push more changes more rapidly.

Now that you’ve published that data source, we only have one set of edits to make. However, we still need to deal with the fallout of the DB migration…most likely column names (CamelCase, I curse you!). As I mentioned before, you can’t just do a Replace Data Source in the UI or simply edit the connection string(s). Well, you can, but Tableau WILL break and you’ll have to go through and make a bunch of formula edits and formatting changes to make it all right.

XML to the rescue! We really only need to fix the core columns, because everything we previously built was based on their presence and formatting. Here’s what you need to do - Gather your old skool DB column names and their corresponding new skool DB column names.  Put them in Excel. Then use this formula method, and copy down:

![ColumnRemapping](https://cmtoomey.github.io/img/columnremap.png)

The formula in the last column will give you all the XML you need.  Now you need to put it somewhere. Download the datasource from Tableau Server (a .tds - what do you know, that’s XML too), open it and paste in that XML you created in Excel.  It will look something like [this](https://gist.github.com/cmtoomey/dcfdebf5011655d6f991).

Then save, republish, overwrite, and **BOOM**, all workbooks connected to that will be instantly migrated.  Better yet, you can automate that too!

That was a really long post - but remember, this is all about knowing your tool, what it is, and what it can do. Tableau is just XML, and now you know how to see and understand what is going on under the hood.  That means you can bend Tableau Desktop to your will.
