---
layout: post
section-type: post
title: Tableau Public and the Attribution Problem
category: community
tags: [ 'Public', 'Community' ]
---

If you haven't been on #TableauTwitter recently, you might have missed the dust-up. Here's the short version:

+ On July 24, 2017, [Andy Kriebel](https://twitter.com/VizWizBI) published the following viz on Tableau Public

![Drought](https://cmtoomey.github.io/img/DroughtViz.png)
Source: [Tableau Public](https://public.tableau.com/profile/andy.kriebel#!/vizhome/USDroughtMonitor/DroughtMonitor)

+ On August 7, Andy found that an individual had posted that same viz to their profile and asked Tableau Public to take it down.
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Looks like this dude stole my viz &amp; is passing it off as their own! Wtf! <a href="https://twitter.com/tableaupublic">@tableaupublic</a> can you take it down please? <a href="https://t.co/BHgenj1VWM">https://t.co/BHgenj1VWM</a></p>&mdash; Andy Kriebel (@VizWizBI) <a href="https://twitter.com/VizWizBI/status/894629812131827712">August 7, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

+ This escalated into a vigorous discussion about (mis)appropriation of content on Tableau Public. It shifted into crazy town with the following posts on LinkedIn and Twitter

![LinkedIn](https://cmtoomey.github.io/img/LinkedIn.png)

![TwitterTimeline](https://cmtoomey.github.io/img/TwitterTimeline.gif)

**Let me start by saying that I understand Andy's anger. Andy (and the rest of the Tableau Community) work hard to build and share excellent data viz on Tableau Public and Prasad plagiarized that work (temporarily).**

### But it was also an honest mistake

Tableau Public is an open community. You might not have noticed it in the Twitter feed, but Mike Moore cited [Tableau's TOS](https://www.tableau.com/tos) in the conversation. Let's highlight the piece that matters:

![TOS](https://cmtoomey.github.io/img/TOS.png)
Source: [Tableau](https://www.tableau.com/tos), *highlighting my own*

What Prasad did was not ok, but under the letter of the law, he was completely within his rights to download the work and republish it. There's no IP here, no copyright, no trademark, so there's no possibility of theft. Technically, this is *plagiarism*, and attribution should have been provided...but per Tableau's own **TOS** that isn't required.

# and that is the problem we should be talking about

---

One of my favorite shows of all time is **The West Wing**. There is a scene from one season where Sam Seaborn (WH Speechwriter) makes the following statement

<iframe src="https://giphy.com/embed/dH1whrj1hTNfy" width="358" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/the-west-wing-rob-lowe-sam-seaborn-dH1whrj1hTNfy">via GIPHY</a></p>

In an open community, from music to software to data viz, it happens. Some of it is benign, such as borrowing calculations or Javascript methods. Some of it is less so, such as making slight modifications to other people's work and claiming "inspiration" (Vanilla Ice, I'm looking at you).

I'll be the first to admit that I'm guilty of not attributing images appropriately in this blog, and we see the same discussion pop up every month or so related to individual Tableau Public. I will also borrow techniques and designs from other people's work and use them where appropriate.

We want to collaborate, get feedback, and be inspired which is why we participate in the community. But we first need to acknowledge that as of right now, if we publish something (and make it available for download), then *any user has the right to download it, perhaps tweak it, and republish it*. 

> ### We also need to acknowledge that we all need be better about giving credit where it's due.

Let me be clear - I'm not talking about techniques or calculation methods, or clever hacks in Tableau. The product is ever changing, and there is so much history at this point that expecting callouts or a *h/t* for everything would be sheer tedium and unproductive. We already have the bar chart police, we don't need people harassing others for not attributing techniques that have worked their way into the collective consciousness. In those cases, if you get inspired by someone, just flip them a *h/t* or say thank you on Twitter.

What we **should** be concerned about it true plagiarism: wholesale appropriation of content without attribution. In this context, Prasad plagiarized directly from Andy. He admitted it when confronted, and took the content down. *That is what is supposed to happen.*

In all honesty, that is the easy example. Despite the furor, everything was fairly cut and dried. Instead, let's look at a slightly more complicated example. 

---

On July 20, 2017 the Information Lab published the following: [Visualize your Financial Data](http://www.theinformationlab.ie/2017/07/20/visualize-financial-data/), in which they discuss some better methods to visualize financial information, based on work by Andy Kriebel.

They link directly to his blog and lift the majority of its content into theirs, as they are wont to do, since Andy works for them. If we follow the links and look at his original post [blog](http://www.vizwiz.com/2017/07/profit-loss-statement.html), we see this viz 

![NewOne](https://cmtoomey.github.io/img/NewFinance.png)
[Source](http://www.vizwiz.com/2017/07/profit-loss-statement.html): July, 2017

That post, and viz, build on a [previous post](http://www.vizwiz.com/2017/07/income-statement.html) with the following viz: 

![Original](https://cmtoomey.github.io/img/OriginalFinance.png)
[Source](http://www.vizwiz.com/2017/07/income-statement.html): July, 2017

In that first post, his only reference to the original author of the design, [Lindsay Poulter](https://twitter.com/datavizlinds) appears in bottom third of the text. In Andy's original and subsequent post, he makes and describes a number of design changes that he feels fits his purpose better, including the addition of a mobile layout. Is that attribution? Sort of, Andy mentions Lindsay by name and links to her Public profile. 

Is it sufficient? I'm torn. Let's take a look at Lindsay's original viz.

![Transit](https://cmtoomey.github.io/img/TransitViz.png)
[Source](https://public.tableau.com/profile/lindsey.poulter8872#!/vizhome/MetroVitalSigns/Dashboard), December 18, 2106

In both designs, we have a card motif, with one key metric per card. These are built around a bullet chart and an embedded sparkline. There are additional filters in Andy's viz, but that's likely due to additional dimensionality in the the data and the specific use case he designed it for. The color palette is virtually identical. Lindsay uses a legend, while Andy uses sub-titles to communicate the color scheme. In his updated viz, he added a previous-month BAN and a KPI to his design, but overall it's still largely the same as Lindsay's original.

This brings up a complicated question. Is it ok to use a design wholesale, but call it your own if the underlying data is different, if you tweaked some parts of the design (such as borders or gridlines), or that you inserted some additional content? I think the majority of people would say, "*Yes, because that's the way the community works.*" I've used Tableau Public workbooks this way, it's the tried-and-true way to actually learn Tableau. 

What makes things complicated is that, the second post doesn't provide attribution at all. A link back to the original blog doesn't *feel* sufficient here. Why? When the Information Lab picked up and reposted Andy's second blog, their post presents the second iteration as wholly unique. This indirectly attributes the underlying design directly to Andy, so we are now three steps away from the original author, the majority of whose design is present in the work. 

Why does this matter? I'm willing to bet that traffic to Andy's blog and that of Information Lab is much larger than that of Lindsay's profile. That means that the majority of eyeballs on this work are being shown (or at the very least given the impression) that Andy is the original creator of this design, and that's not fair to Lindsay. I won't say it's plagiarism, but it does feel very Vanilla Ice-y.

<iframe src="https://giphy.com/embed/6T2pCmyeqDWgg" width="480" height="359" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/80s-vanilla-ice-baby-6T2pCmyeqDWgg">via GIPHY</a></p>

Let's bring this back to the Drought viz that started this whole thing. What if Prasad had downloaded this viz, and simply swapped out Andy's data for his own before uploading with no other changes? Is that ok? What if he never blogged about it, and didn't use Twitter, how would he give credit? Would he even have to? 

Before you answer, remember that if you post something to Public, it's free to use by anyone, **any way they want.** Judging by Andy's response and veiled threat to blacklist Prasad if he didn't take it down, my guess is that he would not be happy with this hypothetical example. But we can't have it both ways. Vanilla Ice eventually had to pay royalties...you sample people's work, you give credit. **Period.** And I think that's the standard we want. *Simple and persistent attribution.*

---

I bring up these examples because it reveals that Tableau Public, as a platform, and as a community, is missing something. Let's stop talking about the fact that these things are happening, and focus on how we might actually fix it.

We should begin by reminding outselves that Tableau Public is an open platform, and content posted there is *technically* public domain. However, as Andy points out, things have changed since Tableau Public began and a personal profile has also become many individuals' CV. It's how they present themselves to the data viz world. 

SO let me state the problem clearly: 

> How do we ensure that we, as a community, can continue to grow, share, and innovate, while also acknowledging the hard work of others and creating a better space for discussion and debate?

Let's examine some communities who are successful at this: 

[Behance](https://www.behance.net/), a community whose entire purpose is to allow individuals to share and discover creative work. Behance is governed by their [Community Guidelines](https://www.behance.net/misc/community) which are summarized bellow:

+ Only upload your own work (at least the publicly viewable portions)
+ Respect Intellectual Property Rights: 

> Don't present other people's work as your own or **overstate your own role** *[emphasis mine]* in creating something.

Since Tableau Public is an inherently creative platform, I think Behance's Guidelines are instructive. The core tenets around creative work are good first principles...but don't solve everything. Why not? With Tableau Public, there is no IP involved. Further complicating matters is that one of the hallmarks of the community is downloading, learning, and innovating on others' work. Is there an example for providing both an open creative forum that makes collaboration and attribution simple? 

Robert Crocker, take it away:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Git handles accreditation with forks (not these 🍴) Tableau could do the same, no?</p>&mdash; Robert Crocker (@robcrock) <a href="https://twitter.com/robcrock/status/894632056860196864">August 7, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

If you don't know GitHub, here's the basics: whenever you publish something to your GitHub Account, anyone can fork it into their own account for testing and extension. When they do that, their repository links back to the original. What does that look like in practie? Well, this blog is forked from a design by [Panos Sakkos](https://github.com/panossakkos/personal-jekyll-theme). If you visit my repo for this blog, you'll see this:

![Forking](https://cmtoomey.github.io/img/Forking.png)

It's always possible to go back to the original source, and as long as that content is licensed appropriately, anybody can do the same. Cloning/downloading directly is still possible, but forking is the fastest way to build on the work of others. 

Personally, I think that this methodology is something that Public should adopt. Licensing is already covered by the TOS, we just need a more direct method to link for inspiration/adaptation purposes. Something like this:

+ Treat a profile like a GitHub account
+ Continue to allow people to Favorite/Follow work
+ If they want to extend it, they can copy it into their own account, but always provide attribution by default.
+ You must have an account to download work, and downloads should be tracked. You already need an account to use Tableau Public in any meaningful way, so this doesn't feel like that much of a stretch. 

I've already asked Ben Jones about changes like this, and his response was positive and predictable.  Tableau welcomes the feedback, but they obviously won't make promises related to the product. 

So it's up to us to create ideas and push for change. But what can we do in the meantime? How can we come together as a community and take an active role in building the platform we want? 

## A formal code of conduct 

The Terms of Service aren't sufficient. The [Tableau Community Etiquette](https://community.tableau.com/docs/DOC-1315) is outdated. [Tableau even started down this road at one point](https://www.tableau.com/about/blog/2012/02/guest-post-code-ethics-data-visualization-16052), but seems to have lost it's way to date. Ethics are a great place to start, but not sufficient to resolve the problem of creative control and attribution. 

### So what would this look like? What standard should we set for ourselves?

Let us start by acknowledging that the Tableau Public community is an incredible creative force. Through the platform that Ben Jones and his team have built, efforts like Makeover Monday (courtesy of Andys Kriebel and Cotgreave and Eva Murray), and Chloe Tseng + Brit Cava's work on [Viz for Social Good](https://www.vizforsocialgood.com/) and [She Talks Data](https://www.shetalksdata.com/about/) we see an explosion of excellent work doing good.

We want the community to be open and supportive, but we also want to protect the hard work of others. We don't want the viz police, and we don't want Tableau to be involved outside of enforcement in the most egregious circumstances. We need to actively invest in growing the community as a whole so that this work can continue. We can do it, but we have to do it together. 

Generally speaking, what does something like this look like? Starting with Behance and the OSS community, there is a lot of inspiration to be had. 

+ The [Open Code of Conduct](http://todogroup.org/opencodeofconduct/)
+ The [Contributor Covenant](http://contributor-covenant.org/version/1/2/0/)
+ The [Citizen Code of Conduct](http://citizencodeofconduct.org/). 

Ideally, all users of Public would be bound by this agreement when they establish an account, just as the users of 

+ [Mapbox](https://blog.mapbox.com/our-code-of-conduct-for-open-source-2b3a81c00c80)
+ [GitHub](https://github.com/blog/2039-adopting-the-open-code-of-conduct) 
+ [Python](https://www.python.org/community/diversity/) 

already are when they use the respective software

## So here is my proposal

1. Ben Jones: host a discussion/webinar on the current state of Tableau Public, the state of the community, and the current state of thought on how to enable the Public Community moving forward.
2. I've created a draft [Code of Conduct](https://github.com/cmtoomey/policies) for us to start talking about. It's pretty boilerplate, but the most important addition is that we want to preserve the free use of viz for learning and iteration, while making attribution simple and persistent. Want to make changes? Fork it, submit a pull request. I'll happily collaborate with anyone. 
3. I've also created an [Idea](https://community.tableau.com/ideas/7792), so that we can bring this to Tableau's attention. If you think this is valuable, then vote it up. Or comment with new ideas/changes. 
4. At TC this year, let's have a session/meetup with the Public team and talk about the community and platform we want.
