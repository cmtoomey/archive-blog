---
layout: post
section-type: post
title: React + Tableau = Future
category: Category
tags: [ 'javascript', 'tutorial' ]
---

<iframe src="https://giphy.com/embed/3oEjHZKRgiZXYmVVbq" width="480" height="473" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/3oEjHZKRgiZXYmVVbq">via GIPHY</a></p>

It's been a while since my last blog post - between work, holidays, conferences, and presenting at Tableau SKO it's been a busy couple of months. Since TC16, there really hasn't been anything I've felt compelled to write about...until this happened.

![D3Tweets](https://cmtoomey.github.io/img/d3twitter.gif)

I know that many Tableau enthusiasts start exploring D3 because it offers a level of flexibility and customization that is difficult to achieve in Tableau. But the root of Rody's D3 expedition isn't about custom data viz, it's about integration. It's about consuming Tableau in places other than Server or in a native Tableau app.

> ## At some point, the normal Tableau ecosystem, just isn't enough. At some point, we want to build bigger and better things. Applications that are simultaneously fast, beautiful, insightful, and modern. 

I'm a firm believer in letting tool do what they were designed to do. Tableau is great for exploring data and generating insights. It's not that great at delivering an app-like experience. Trying to put any UX on it can be an exercise in tedium and frustration. The amount of work that Robert Rouse put into the [hamburger menu concept is extraordinary, and simultaneously ludicrous.](https://www.interworks.com/blog/rrouse/2016/01/04/creating-collapsing-menu-container-tableau) Modern UI libraries have already solved these problems, so we should let them do this sort of thing, right? Let Tableau focus on the data experience. 

This is something I've been working on in my day job at Zillow (You can see if for yourself in my [Plotcon talk](https://www.youtube.com/watch?v=9hQbEZ2fz80)), and I'd like to teach you how you can do it too.

# It's time to learn React

![React](https://cmtoomey.github.io/img/React.png)

---

# So, What is React?

Everything you are about to see is Javascript, but don't worry, this is not like any Javascript you've worked with before. *This JS makes sense.* I believe that if you've spent any timein Tableau at all, you already know how to think in React (the code part will come with practice).

In short, [React is a way to build User Interfaces.](https://facebook.github.io/react/) I'm not going to go into too many details about how it all works, there are enough tutorials out there. Here is what you need to know: 

+ You *compose* your interface with components - one on top of the other, nesting them where necessary. 
+ A component is a piece of code that *declares* how that small piece of the interface should work, and how it interacts with the rest of the components.
+ Data flows in one direction, within and through component families. 
+ It's fast - it only renders the things that need to change.
+ You can build web, mobile web, and native apps with it.
+ There's a huge Open Source community to speed things along - functions, libraries, pre-built components - the React community is just as helpful (even more so in some cases) as the Tableau community.

> *Think of React like Ikea furniture: you build the sections independently, hook them together and suddenly you have a beautiful bookshelf. The only difference here is that you can re-use those components in other bookshelves.*

---

## Thinking in React

React is a framework, but it's also a way of thinking about design. Tableau works the same way - you build worksheets to solve specific problems, compose them into dashboards, and then bind it all together with data and actions. Do it enough and you start thinking in Tableau. 

If you've never written any code before, there will be a little bit of a learning curve. Don't worry, React is straightforward, because it requires you to be explicit about what each thing does. This makes it easier to focus on function rather than syntax, keeping you in the flow. 

So what are we going to build? I thought that since we all have to present our work at some point, and I'm really tired of the *Why can't we have Tableau in PowerPoint* complaint, I'd teach you how to build a beautiful presentation that has Tableau embedded in it. To add a little bit on top, we'll also use Tableau to populate some D3 charts. 

The library we are going to use is one of my new favorite tools. It's called [Spectacle](https://formidable.com/open-source/spectacle/). It's like RevealJS, but way more awesome. When we're done, you'll know how React works and have a great toolkit for presenting things **the way you want them presented.** Here's the [finished product.](https://cmtoomey.github.io/TableauReact/#/) You may want to open the link for the full-screen version. 

<iframe src="https://cmtoomey.github.io/TableauReact/#/" width="800" height="450" frameBorder="0"></iframe>

---

### Step 1: Basics

To get started, you need two things. [Git](https://git-scm.com/) and [Node](https://nodejs.org/en/). Git will allow you to clone the Spectacle Boilerplate, and Node will allow you to install the packages you need to make this whole thing work (and run the demo server). Install those first.

### Step 2: Cloning

To get started, open up your command line and run 

`git clone https://github.com/FormidableLabs/spectacle-boilerplate`

This will bring down the template we will start from. Next step, navigate into the spectacle-boilerplate directory and run `npm install`. This will install all the packages you'll need build and test your fancy presentation. 

Once it's done, run `npm start`. This will build a demo version of your work and start a temporary webserver so you can watch your work unfold. As you make changes and save, Spectacle will hot-reload the content (no more refreshing)!

You also need to run these commands to make sure you have everything else you need.

```bash
npm install -S tableau-react
npm install -S tableau-api
npm install -S react-youtube
```

This syntax says "go get package A and (S)ave it to my current project. Once it's installed, you can import it (which you will see below).

## Step 3: Understand the skeleton

At the top, the first thing you see is an import statement - this brings in all the features you need for your component. In this case, we are bringing in core React, another component called Vacation, and the tableau-react and react-youtube libraries. 

```jsx
import React from "react";
import Vacation from "./Vacation.js";
import Tableau from "tableau-react";
import YouTube from 'react-youtube'
```

From there we have some boilerplate, and setting up the theme variables. Why do this? You want to keep your code DRY (**Don't Repeat Yourself**) - this way you can make changes in one place, and update them everywhere. Here we are setting our color palette and fonts (courtesy of Google). 

```jsx 
const theme = createTheme(
  {
    primary: "white",
    secondary: "#1F2022",
    tertiary: "#03A9FC",
    quartenary: "#CECECE"
  },
  {
    primary: "Montserrat",
    secondary: "Helvetica"
  }
);
```

Now whenever we need to reference a color we can use a syntax like `bgColor='primary'`.

Finally, we have the React Component itself. This is boilerplate syntax that you see, what you should pay attention to is what occurs in the `return()` statement. This is what your component looks like. 

This syntax looks like HTML, but's it's actually something different. It's called **JSX**, and it allows you to write HTML-like code, but include Javascript. Let's look at a sample:

```jsx
<Deck transition={['zoom','slide']} transitionDuration={500} theme={theme}>
    <Slide transition={['zoom']} bgColor='quartenary'>
        <Heading size={1} caps lineHeight={1} textColor="secondary">
            Using React and Tableau Together
        </Heading>
    </Slide>
</Deck>
```

The first thing to remember is this:

> Inside your `return()` statement, you must deliver a single code block. This means that you need to wrap all components up in a top-level `<div>` or similar. 

In our case, our entire presentation is wrapped up in a `<Deck>` tag. Then we layer our `<Slide>` together, and inside is each Slide can be whatever we want. If we look back up at our import statement, we bring in different portions of the Spectacle library, which all represent a component. 

```jsx
// Import Spectacle Core tags
import {
  BlockQuote,
  Cite,
  Deck,
  Heading,
  ListItem,
  CodePane,
  Appear,
  List,
  Quote,
  Slide,
  Text
} from "spectacle";
```

There are more to use, these are just the ones I'm using in this example. You can find the complete list on the [Spectacle docs](https://formidable.com/open-source/spectacle/docs/).

## Step 4: Props

You may have noticed that I've skipped over something obvious. Let's go back and look at a previous example. 

```jsx
<Deck transition={['zoom','slide']} transitionDuration={500} theme={theme}>
    <Slide transition={['zoom']} bgColor='quartenary'>
```

In between each tag are a number of attributes. These are called **props** and they describe how your component is going to function. For example, setting the `transition` prop tells us the  default slide transition. Then we override it on the individual slides. 

Props are set within each component, and can be anything you want to make your component function the way you want. For Spectacle, the Formidable team has set a number of global props (like `bgColor`), and some specific ones for each component (`transition`). You set your props inside each component, and then specify your values when you actually use them. 

## Step 5: Add some Tableau 

You can scaffold out your presentation however you like, and you can see my source code at [Github](https://github.com/cmtoomey/TableauReact/tree/master/presentation). The next step is to add in our first Tableau component. 

Thanks to the work of [coopermaruyama](https://github.com/coopermaruyama/tableau-react), we have a pre-baked Tableau component. All it takes is a `url` prop. 

```jsx
<Slide bgColor="quartenary">
    <Tableau url="https://public.tableau.com/views/Marvel_0/WheelswithinWheels?:embed=y&:display_count=yes" />
</Slide>
```

Cooper has some really nice props you can leverage:
+ Options (height, width, hideTabs)
+ Filters
+ Parameters

Unforunately, positioning the viz isn't one of them. If you don't like how the viz looks, you can wrap it in a `<div>` tag and adjust it with inline styling (think CSS inside your component), or we can re-write the component to make it do what we want, where we want it. 

## Step 6: Scratch Baking

If we open up Cooper's component, we'll see that it has a dependency on something called `tableau-api`. This is a npm module that makes it possible to access the Javascript API and embed our Tableau content into our component. The original tableau-api was written by a gentleman named [Ilya Boyandin](https://github.com/ilyabo/tableau-api), but to use it, it required you to explicitly link yourself to his Github repository (which is what Cooper did).

In addition, the library references an out-of-date version of the API. I've since forked his work, updated it to the current API version, published it as a true NPM module, and am working with Tableau to accept it into their own repository (more on this in a moment). 

What does this mean? It means you can `npm install -S tableau-api` and then `import tableau-api` to build your own Tableau component. We'll use Cooper's as a skeleton, and build a component from scratch. This new one will do two things:

1. Have better position on the page
2. Pull data out via the `getData()` function.

Let's deconstruct Cooper's component and rebuild it.

![Component](https://cmtoomey.github.io/img/TableauComponent.png)

Here we have something similar looking to our Slide Deck, with one change. We've added a function called `initTableau()` that loads the viz. This next part is a little tricky, so hang tight.

We first need to `render()` the div where Tableau is going to live. To do that, we are going to declare how we want it to be styled with the following style prop. We need to wrap it in another set of `{}` to pick it up, because style requires an object. 

`{position: "absolute",left: -275,top: -375}`

This is a clunky way to move it around (just like a floating container in Tableau) - but it works. 

Once the `<div>` has rendered, then we call `initTableau()` in something called `componentDidMount`. This is a React-lifecycle method. Right now, all you need to know is that the React lifecycle is just like the Tableau order of operations - there is a distinct set of steps to actually render your page. `Render` is always followed by `componentDidMount` and that is when we want to insert Tableau, because otherwise the `<div>` won't exist for it to bind to. There are a bunch of them, but this is the only one you need to know for now. 

Now we have a perfectly placed Tableau viz. But what else can we do? We can put whatever we want in the initTableau function - so let's hack it up a little bit!

## Step 7: Integration

To help Rody, let's get a little fancy and reviz some of the data in our Tableau workbook with D3. To do this, we are going to use a library called [Victory.](http://formidable.com/open-source/victory/) Victory is D3, but packaged in a way that plays well with React. 

Run `npm install -S victory` and add the following to your custom Tableau component

```jsx
import { VictoryLabel, VictoryLine, VictoryChart, VictoryAxis, VictoryTheme, VictoryTooltip} from 'victory';
```

This will give us the components we need to build our D3 charts and add animation. 

We need to get a little into the weeds now, so buckle up. We are going to add a new lifecycle method, called `constructor`. This gives us the ability to set something called state. [State in React](https://facebook.github.io/react/docs/state-and-lifecycle.html) is data that changes over time - it is private and fully controlled by the component. For now, think of it as something we want to store and consume in our component. 

Victory requires it's data to be in an object - so we will set victory state to `{}` and we also need a title for our chart, so we will set that too using the `constructor` lifecycle function. This is the very first thing that happens when you load your component.

```jsx
constructor(props) {
    super(props);
    this.state  = {victoryData: {}, viz:{}, label:"12 month home value forecast"};
}
```

Now we are going to adjust our `initTableau()` function to get the variables we need and call `getData()`.

```jsx
onFirstInteractive: () => {
    const sheet = viz.getWorkbook().getActiveSheet().getWorksheets().get("Table");
    const options = {
        ignoreAliases: false,
        ignoreSelection: false,
        includeAllColumns: false
    };
    sheet.getUnderlyingDataAsync(options).then((t) => {
        const tableauData = t.getData();
        let data = [];
        const pointCount = tableauData.length; 
        for(let a = 0; a < pointCount; a++ ) {
            data = data.concat({
                x: tableauData[a][0].value,
                y: Math.round(tableauData[a][3].value,2)
            })
        };
        this.setState({
            victoryData: data
        });
    })
}
let viz = new tableau.Viz(this.container, vizUrl, options);
        this.setState({
            viz:viz
        })
}
```
This is normal Tableau Javascript - except that we are going to stash it in state for use by Victory. We are also storing our viz variable, so that we can do more after the initial render. I'm sure some React devs out there are yelling at me right now, but this works, so I'm sticking to it.

Now we add our composed Victory Chart like this:

![Victory](https://cmtoomey.github.io/img/Victory.png)

We have an outer `<div>` to meet our single output requirements, the original `<div>` for Tableau, and another `<div>` to manage the position of our chart. Once we've composed our chart, we feed it data from state like this:

```jsx
<VictoryLine data={this.state.victoryData}/>
```

That will give us an animated bar chart. Let's make that button update the data and call it a day.

## Step 8: Dat button

You may notice the function `getMoreData()` in my component. This function re-runs `getData()` and changes state with the new data. The beauty of React is that if state changes, it re-renders. All we have to do is trigger the state change. How do we do that? With a button prop!

```jsx
<button onClick={this.getMoreData.bind(this)}/>
```
Just like regular `onClick` functionality, this tells React that when I click this button, run this function. The `.bind(this)` piece is just to make sure React knows which function to call. 

Now when we click the button, we re-run `getData()`, update state, and because we've specified an animation prop in Victory, we'll get a smooth transition between the two!

# Congratulations! You've written your first React component

---

Now that you've completed this task - you can go out and make a bunch of awesome things. React plays well on native apps too, so feel free to venture into the world of mobile. You next step should be to get the fabulous [Create React App](https://github.com/facebookincubator/create-react-app).

One thing to note for now - tableau-api isn't licensed correctly. Whenever you build anything in Open Source, please make sure you apply a license to it so others can use it! Ben Lower at Tableau is working on getting tableau-api into their own repository, with the proper license in place(since it is their IP and both mine and Ilya's repositories are just building on their code). Open Source is great because we can all share and build on each other's work, but we all have to make sure we follow the rules that enable that sharing. 

I hope you're inspired to go build your own React apps now - with or without Tableau! Victory is great, but there are a number of other D3-React libraries to play with too. There's also a bunch of UI libraries so you don't have to build buttons and forms from scratch. So find what you like best and get to coding!
