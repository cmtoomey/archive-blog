---
layout: post
section-type: post
title: Ultimate Mapping Guide Part 5 - Bringing it all together
category: Mapping
tags: [ 'mapbox', 'tutorial' ]
---

Welcome to the fifth and final installment of the Ultimate Mapping Guide. [Craig Bloodworth](https://twitter.com/craigbloodworth) and I hope you have found it helpful and are now ready to show the world some amazing work! This installment will focus on everything that happens once you have made your awesome [Mapbox](https://www.mapbox.com) map and are ready to put it in production with Tableau. 

If you have a map, but want to take the design and styling to the next level, be sure to read Craig's [most recent post](http://www.theinformationlab.co.uk/2016/03/31/ultimate-mapping-guide-part-4-next-level-styles/) before continuing. 

Home stretch - here we go!!!

---

Let's do the first thing first - your map is beautiful, has been approved by everyone and now you want to see it in Tableau. Now with 9.3, you can use it out of the box (no TMS hacking anymore!). Go through the same process of Map, Background Maps, Map Services, Add Mapbox Map and you will be presented with a fancy new box. 

![newbox](https://www.mapbox.com/help/img/3rdparty/tableau-5.png)

All you need to do is paste in the Style URL from Mapbox Studio and Tableau will take care of the rest. Where might you find the Style URL? Right here:

![styleurl](https://cmtoomey.github.io/img/FindMapboxButton.gif)

Give your style a name and that's it. You can add as many of these maps as you want, just like your Classic Styles. However, unlike Classic, you can't toggle the layers of your map on and off (more on that in a bit). 

### But what if it something doesn't look quite right? 

Perhaps something like this? 

![clipping](https://cmtoomey.github.io/img/Clipping.png)



