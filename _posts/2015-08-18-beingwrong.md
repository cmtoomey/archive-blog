---
layout: post
section-type: post
title: Being the Best Kind of Wrong
category: javascript
tags: ['api', 'xml', 'javascript']
---

I woke up this morning to the largest amount of Twitter activity I have ever seen. New followers, retweets, and a blog post with my name on it!

At the outset, let me say that I hate being wrong. **I hate it**. But in this case, this is the best kind of wrong. The kind where you have an actual debate, learn something new, and actually solve a really gnarly problem.

# Tamas, I stand corrected

--------------------------------------------------------------------------------

I have never heard of a CORS proxy - but after testing it out, it's so simple that I wish I had thought of it.

## Let's see it in action
[I'm going to use Tamas' methods](http://databoss.starschema.net/cors-proxying-without-server-headers-in-response-to-chris-toomey/), as written, and see how it works for someone doing it for the first time. I also come from a security background, although not the same kind that Tamas' does. We trust, but verify, so here's my on-the-fly experience with the method.
- You need **Tableau 9.1** - it won't work without the WDC
- Copy and import the server-side HTML file - tabadmin import_webdataconnector

![Import](https://cmtoomey.github.io/img/import-1439913164-100.gif)

![Open](https://cmtoomey.github.io/img/corstest-1439913335-70.gif)
- Client side test: Copy and paste Tamas' HTML as-is, adjusting for my Tableau Server's IP address. No dice.

![Corstest1](https://cmtoomey.github.io/img/corstest1-1439915537-8.gif)

The iframe is working correctly, and matches the original code from Tamas. However, the code on the left is pasted from his post this morning. You can see the page on the right, with no return from the button press. I thought it might be how I'm interacting with the page - so I tried it from a local folder, just opening up Chrome; Live Preview from within Atom; and a Python SimpleHTTPServer.

I also checked firewall rules on my Tableau machine to make sure I was allowing everything in.

I'm thinking that the issue is posting the content to the iframe itself. This is a new technique for me...so I'm a little stumped.

Here's my WDC Code compared against his

![Comp](https://cmtoomey.github.io/img/comp-1439917108-9.gif)

Now here's my client-side code

![comp2](https://cmtoomey.github.io/img/comp2-1439917158-23.gif)

I posted it to [GitHub](https://github.com/cmtoomey/WDCTest) - so I could ask Tamas' himself...and hope he replies.

## UPDATE: FIXED!!
So Tamas and I had a conversation and we got it working. As described.

First - on the WDC page, I had to comment out the event origin filter. This is intended to limit who or what machines can actually make the AJAX call. I was excluding myself from making the REST calls.

Second - on the HTML test, I had to do the same. I was testing from a local machine, and that means that it doesn't have a domain origin. That caused the check to fail, so I turned it off. All I had to do was change this: **event.source.postMessage(strData,"*")**. That allowed everything to go through.

Tamas had this to add (IP is the location of the Tableau box):

> _If you put index.html to a web server as [http://52.10.92.91:8080/index.html](http://52.10.92.91:8080/index.html) it would work flawlessly with your original version_

Tamas' original method returns the Tableau XML as a string. You should re-convert it back to XML in order to get the Tableau content you need/want. Here's how you do that (or how I did it):

<pre><code data-trim class="javascript">    
function receiveMessage(event) {
    //commented this out
      //if (event.origin !== "http://52.10.92.91")
      //return;
    //set the return data to a variable
      data = (event.data);
    //parse that data back into XML
      response = jQuery.parseXML(data);
    //just like Snippets, get the tag you want
      response1 = response.getElementsByTagName('credentials')[0];
    //get the attribute you want
      response2 = response1.getAttribute('token');
    //log it out to check
      console.log(response2);
      $("#cors-test").append("received: " + event.data);
    }

</code></pre>

Here's what that looks like in the real world:
![proxy](https://cmtoomey.github.io/img/test1-1439922295-92.gif)

###That's some good old-fashioned mischief
