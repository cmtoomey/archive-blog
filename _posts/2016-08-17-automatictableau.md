---
layout: post
section-type: post
title: How-to Automatic Size in Tableau
category: Category
tags: [ 'tag1', 'tag2' ]
---

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/genedenny">@genedenny</a> <a href="https://twitter.com/RodyZakovich">@RodyZakovich</a> <a href="https://twitter.com/paulhardman">@paulhardman</a> well, you should never ever set a dashboard to automatic</p>&mdash; Andy Kriebel (@VizWizBI) <a href="https://twitter.com/VizWizBI/status/765887363432214529">August 17, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

# Yes, you can (and should) use Automatic Dashboard Sizing

Sure, fixed dashboards are the easiest and most predictable.

Sure, you can use the new Device Designer to create a new dashboard structure for *every device ever*.

But what about Automatic Sizing? Isn't that basically the same thing as the Device Designer? Doesn't that make Tableau responsive? If that's true, why don't more people use it?

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/AllanWalkerIT">@allanwalkerit</a> nope! Never ever! Why take the risk that it’ll look like crap?</p>&mdash; Andy Kriebel (@VizWizBI) <a href="https://twitter.com/VizWizBI/status/765939664465301506">August 17, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Andy makes a valid point - Automatic is much trickier to use. You have to have a sense of layout and how certain viz types will physically compress, and testing it is much harder. Let's not forget that there are more screen types than you can shake a stick at, so chances are you won't think of them all.

## That doesn't mean you shouldn't do it.

An automatically-sized dashboard, when properly designed, can look great on huge screens as well as small ones.

Let's not forget, building responsive applications (which is basically what Automatic Sizing and Device Designer are intended to help with) isn't easy. There's work to be done regardless, it's just a matter of where you want to put your effort.

+ Device Designer lets you **target specific devices and re-arrange**, but you trade flexibility for certainty.
+ Automatic **works everywhere** is much easier, but requires more testing and iteration.

> Pick what's best for the job, your skills, and where you want to spend your time.

If your use case calls for it, and your viz types are appropriate, use it. Don't do anything simply because you have to, or someone says you should never do that.

---

## So, why all the talk about Automatic Sizing dashboards?

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Sock1tToomey">@Sock1tToomey</a> <a href="https://twitter.com/AllanWalkerIT">@AllanWalkerIT</a> show me a dashboard that works perfectly using auto on every size screen and I&#39;ll agree you&#39;re right.</p>&mdash; Andy Kriebel (@VizWizBI) <a href="https://twitter.com/VizWizBI/status/765957914368540672">August 17, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

# OK - here you go

![Proof](https://cmtoomey.github.io/img/Automatic.gif)

My screen at work is a giant Dell monitor - 16:9, resolution 1920x1080, physical size is 23 inches diagonally.

That testing you see is in Chrome Dev Tools' Device Toolbar. Open Chrome, F12, CTRL-Shift-M. It lets you examine a webpage from any size - responsive down to mobile.

Don't believe me, try it yourself. Source is [here](https://public.tableau.com/profile/chris.toomey1132#!/vizhome/AutomaticExample/AutomaticDashboard)
