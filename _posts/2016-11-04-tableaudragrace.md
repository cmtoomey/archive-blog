---
layout: post
section-type: post
title: The Tableau Drag Race Results
category: Speed
tags: [ 'database', 'performance','tc16' ]
---

A few months ago, I started testing Tableau on big data. This ["drag race"](https://cmtoomey.github.io/speed/2016/07/28/speedrun.html) put Tableau on top of some of the fastest and most popular databases on the market today. The challenge was simple: **can these systems provide interactive query speeds at scale?** I believe that aggregation only causes more work - if you need to drill beyond the level of aggregation, that means someone like me gets a message on Slack and then you have to wait 2-3 days for me to write a query and build a table. If the data is clean, I should be able to query it with some platform and have those queries be fast. By fast, I mean at or around 30 seconds.

Only then can we have the democratic concept of data Tableau loves to talk about. It's easy when your row count is 1-5 million, or maybe even 10s or 100s of millions. But what about a billion, or 10s of billions? At that scale, we see true humnan behavior, we can make true inference, and affect real change. If that data is backed by a platform that facilitates interactivity, then we can have more data-driven conversations and maybe change the world (or just pick a better fantasy football team).

That's what we set out to do. Here's the results.

---

# How big is big?

Let's talk about data scale for a minute. There has been a lot of chatter in the Twittersphere (at least in my feed) about Redshift vs Big Query

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Fact or Fiction: Google BigQuery Outperforms Amazon Redshift as an Enterprise Data Warehouse? <a href="https://twitter.com/hashtag/AWS?src=hash">#AWS</a> /by <a href="https://twitter.com/jrhunt">@jrhunt</a> <a href="https://t.co/AVpNqX8FQQ">https://t.co/AVpNqX8FQQ</a></p>&mdash; Werner Vogels (@Werner) <a href="https://twitter.com/Werner/status/791451539630096384">October 27, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

and newcomer MapD's GPU system breaking all kinds of records

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Scanning 147 billion rows of <a href="https://twitter.com/hashtag/data?src=hash">#data</a> per second: Groundbreaking benchmark from <a href="https://twitter.com/hashtag/IBMCloud?src=hash">#IBMCloud</a>, <a href="https://twitter.com/MapD">@MapD</a> and <a href="https://twitter.com/bitfusionio">@bitfusionio</a>. <a href="https://t.co/vC3xQJ0FS2">https://t.co/vC3xQJ0FS2</a> <a href="https://t.co/p9vNYwqo1t">pic.twitter.com/p9vNYwqo1t</a></p>&mdash; IBM Cloud (@IBMcloud) <a href="https://twitter.com/IBMcloud/status/785857514684440577">October 11, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

First off, while TCP benchmarks are great, they shouldn't be taken as gospel. Your platform might just be really good at taking a test, instead of doing things in real life. 

> *Anyone who was a PC gamer in the late 90s/early 2000s will surely remember the 3dMark/Futuremark competition between Nvidia and ATI. Just like Volkswagen was "optmizing" their diesel cars for emissions tests, [card manufacturers were "optimizing" their cards and drivers for benchmark tests](http://www.geek.com/games/futuremark-confirms-nvidia-is-cheating-in-benchmark-553361/). It's just like teaching to the test in school.*

Second, while MapD's results are amazing, 1.2 billion records is barely table stakes these days. A company with any sort of web traffic will blow by that in a day. Their 40B row performance, while getting extreme read rates, [is based on replicating the same small dataset 312 times.](https://www.mapd.com/blog/2016/10/10/blowing-past-the-billion-row-benchmark/) That's not production data or even a production use case. It's just a lot of data. 

Don't get me wrong - those are amazing results and I'm not suggesting that anyone was optimizing or cherry-picking. With numbers like that, both platforms are worthy of consideration...but don't buy the hype. Test it for yourself, use your data.

This test, and its results are all based on real-world workloads. Like the rest of the benchmarks you see in the world - take it with a huge grain of salt. This is our data, our queries, and a Tableau test cooked up by myself. Our intent was to hammer these DBs, and we did. If these results intrigue you, give them a shot yourself, and I'm always happy to chat about the experience.

### Ready? 

---

Let's revisit the setup.

**Data:** Internal Zillow clickstream
**Volume:** 10TB compressed GZIP, approximately 75B rows, 250 columns (you read that right, 75 billion records)
**Vendors:** Redshift, Snowflake, MemSQL, Big Query, Presto, Jethro

Tests:
+ How fast does data load? 
+ How much additional compression can we get?
+ Production query speed
+ Tableau query speed

Metrics: 
+ Load: time to complete
+ Compression: percent less space over GZIP (if GZIP was 10TB, and 8TB in the DB, that's 20% improvement)
+ Queries: Percent improvement over Production
+ Tableau: Time to complete 

---

# And the winner is...Big MemFlake!

![Salt](https://media.giphy.com/media/xT5LMAP0NDQqhSljUc/giphy.gif)

Let's look at the results, shall we?

--- 

## Loading Data

![Load Performance](https://cmtoomey.github.io/img/LoadPerformance.png)

Snowflake crushes the competition, and it's not even close. They were able to average almost a billion rows per minute. Granted, this was running on a 3XL node (which ain't cheap), but that's freaking fast. Dare I say 

![Ludicrous](https://media.giphy.com/media/A3khUbNbI820o/giphy.gif)

But wait a minute, Chris. What about Presto? Their numbers far better than Snowflake's numbers - what's up with that? Well, that comes down to a difference in technology. Presto (like most modern Hadoop technologies running on AWS' EMR) doesn't actually need you to *load* data. All you have to do is put data into S3 (with some logical partitioning structure - like day), register the data as an **EXTERNAL TABLE** in Hive and it can be queried. The time reported here is the time it took to register that table and build the partitions for querying. What are these partitions you ask? Well, read about them [here](https://www.tutorialspoint.com/hive/hive_partitioning.htm).

Second place in the load category goes to Redshift with almost 170m records a minute. Not bad, but after seeing Snowflake's results, I was a bit disappointed. Why? One of the advantages of Redshift is it's tight integration with S3. I would expect that these private APIs would give it some advantage over other vendors - especially since we were writing data to SSDs. But if we consider that Snowflake is really just doing S3-to-S3 transfers and not writing to physical disk, we realize that it's an apples-to-oranges comparison. 

This takes us to pricing. Snowflake on-demand prices are $2/credit, with each node type doubling in credit usage. A 3XL consumes 128 credits per hour, which comes out to $256/hour. A little arithmetic ```$2/hour * 1.46 hours * 128 = $187.``` Redshift's costs range from $4.8/node-hour On-Demand to all the way down to $1.502/node-hour with a three-year commitment. Let's do the same math: ```$4.8 * 20 nodes * 7.2 hours = $619 retail OR $1.502 * 20 nodes * 7.2 hours = $216.```

### Snowflake <wins></wins>. And it isn't even close.  

Let me touch on the other vendors a little. MemSQL came in third, primarily because they don't have the same type of S3 API access that Redshift has. In our testing, the machines hit an S3 bottleneck and we had to adjust the load strategy. However, what you should know is that MemSQL is designed around streaming architectures. It can handle batch workloads just fine, but it excels at streaming (which wasn't a use case for us). It can natively (as in with a CREATE PIPELINE statement or the click of a "Streamliner" button) connect to Kafka/Kinesis stream or a Spark cluster and stream data in. 

More importantly, where it most other systems stream these types of data into rows (which MemSQL can do too), MemSQL supports streaming data into a column-store. **Out of the box.** That's crazy-pants. Think about that - streams lend themselves to individual row inserts very well, but as we all know column-store architectures are much more efficient for analytic queries (I mean, TDEs are portable column-stores). Anyone who's waited for Tableau to build a TDE knows how long this can take - but MemSQL can do those same steps with STREAMING DATA. Streaming is the future, and MemSQL has it on lock. 

Jethro - in this test they look super slow. However, you need to remember that the fundamental architecture of Jethro is the INDEX. No, not the one Master Chief was chasing after...

![Index](http://vignette2.wikia.nocookie.net/halo/images/5/56/Indexretrieve.jpg/revision/latest?cb=20131207203805)

Jethro indexes every column and every update to each column in order to perform queries. It knows where every combination of data is at all times. Where other technologies are built around table scans, they only query data they need. This is a paradigm shift in query concepts - and they are the only ones that do it. Our data was so large that this number isn't unexpected.

Google was a slightly different scenario. Our data already lived in BQ, but in a raw form. The processed version was in our S3 buckets, and it wasn't worth the effort to set up the permissions to copy from our account to the test account. Google built a processing pipeline to bring our data back into Big Query that was slightly different than the regular way data gets piped into Big Query. Their processing times are not reflective of actual use cases, so you can expect faster load speeds than what you see here.

### Standings 

1. Snowflake
2. Redshift
3. MemSQL
4. Google
5. Jethro
6. Presto (CREATE EXTERNAL TABLE is kinda cheating here)

---

## Compression

We load the data, but what about compression? With big data, compression is key for column-stores because if the columns are compressed you don't have to load as much into memory, making it faster to process. Further, if your query starts a shuffle, compression means you pay a smaller I/O penalty, making the query faster. For memory-bound systems like Presto and MemSQL, compression is king, you simply can't load 100s of GBs into memory and expect a query to finish all the time. 

![Compression](https://cmtoomey.github.io/img/DataCompression.png)

Again, Snowflake destroys the competition. On average, the data they loaded in was 66% smaller than its raw form. I could talk about their micro-partitioning method, but I won't bore you. Suffice to say, it's a breakthrough method. MemSQL comes in second with some excellent string-encoding, and Redshift brings up the rear. One thing to note is that with Snowflake, I run a COPY command and that's it. The other systems, you have to specify different column encodings. Snowflake isn't only the fastest so-far, it's also the easiest to use. 

Google things about storage slightly differently. They uncompress the data to make it available for querying. That means that our data went from 10TB to around 100TB. Normally, that would be a major problem, but Big Query isn't built like other systems. Again, I could tell you all about Dremel and Colossus and Jupiter, but nobody wants to read technical papers on a blog (and you've got a lot of text so far). Suffice to say, it's for a reason, so don't get too caught up with that 1000%.

Similarly for Jethro, they operate on a different architecture and I don't want people to be biased. Their indices were huge (372% of original), but those are built for their query engine so that's totally ok. I do have to rank them accordingly, though. 

### Standings so far

1. Snowflake (1.0 Average)
2. Redshift (1.5 Average - tie goes to incumbent)
2. MemSQL (1.5 Average)
4. Presto (5 Average)
4. Google (5 Average)
4. Jethro (5 Average)

---

## Query Speeds

We all know that speed kills. When in doubt, the fastest system wins. How did these databases perform when we ran queries that are in production at Zillow. Here's some context around them, named after their authors:

+ Alan - lots of REGEX and aggregation, with a UNION (Standard: 30 minutes )
+ Oleg - Conditional binning with COUNT DISTINCT over a specific time window (Standard: 6 minutes)
+ Heiden - Create Tables, Regex, many joins -> Funnel analysis (Standard: 180 minutes)
+ Tom - temp table with lots of unions (Standard: 30 minutes)

![Query Results](https://cmtoomey.github.io/img/QueryPerformance.png)

Here the tables turn. Google destroys all. Their average improvement was 93% - this means that our longest running query ran in 5.4 minutes! Like Snowflake, Google has a NoOps mentality - just put your data in and query it. No tuning, indexing, or extra work. I should caveat this by saying that, at time of testing, Google hadn't made their ANSI SQL capability available yet, so these queries had to be slightly re-written to into BQL (Big Query Language). Typically, BQL gets dinged (most recently by AWS in the TPC-DS benchmark) for not being ANSI compliant, having weird syntax, and just not being friendly to regular SQL folk. 

We've rewritten some of these queries since then, and run them on Redshift (production, not our test rig). Performance doesn't improve significantly, so you know what, I don't care that they were rewritten. I'll take the speed and 175 minutes of my day back, thank you very much. 

Coming in second is MemSQL. It's a close second, only 1% behind Google. These queries had to be re-written significantly to account for MemSQL's in-memory limitations, but the proof is in the pudding. They are fast, and I've been assured by their Product Team that even more improvement is possible (our data volume ran afoul of their query optimizer).

Redshift comes in third. More hardware = better results. It's that simple, but not great.

Coming in fourth is Snowflake. And this brings us to an interesting point - for Snowflake, we ran the same query on different sized infrastructure to see how queries performed. We also ran all four queries simultaneously to better understand how resource contention works. The number you see is the average of those values (we did the same contention test on Redshift too). The good news is that **Snowflake scales linearly.** It's a straight line, not almost, an actual line. If a query took 10m on a Large, it was 5 on XL and 2.5 on 2XL, with a much smaller incremental cost than Redshift.

What do I mean by that? To go from 2XL to 3XL, it costs me an extra $128/hour and I don't have to provision hardware or copy data. On Redshift, I have to buy new nodes at fairly high cost - plus the time spent transferring data. 

If we look at the fastest query speeds we tested between the two:

![RedshiftSnowflake](https://cmtoomey.github.io/img/RedshiftSnowflake.png)

Snowflake is faster in two, slower in one. They average to nearly the same but 2-1 means Snowflake wins. 

Jethro and Presto suffered from insufficient node sizes and lack of data compression, respectively. Queries on both platforms failed. On Presto, you have to use a slightly different file format (either Parquet or ORC) to get any type of performance. Our data wasn't in this format, but we are seeing significant file compression and query performance improvements in testing. Tableau will have an issue with some of the array-type fields in both formats, but I know they are working on it :).

### Standings so far

1. Snowflake (1.7 Average)
2. MemSQL (2.3 Average)
3. Redshift (3.0 Average)
4. Google (3.7 Average)
5. Presto (4.7 Average)
6. Jethro (5.7 Average)

---

## Tableau Performance

Here's the big one - it's all well and good to write a query in SQL, but what about interactive analysis? The gold standard is 10s (but at this volume that's simply crazy talk, right?), with an acceptable threshold of 30s. Why 30s? When you consume data via Tableau, it's an app, and what app would you wait 30s for? **Answer: None**

There were 6 individual tests, each comprised of multiple steps. I measured completion time at each step and ranked across them all. The short version is that no one vendor dominated the others. One would excel in one test and stink at anothe. I thought Tableau would be a great equalizing factor since it issues similar queries to each DB - but what I learned (I think) is that while Tableau's queries work on all these systems, they aren't fully optimized for how they operate...yet.

Let me give you two examples

1. Query - when you connect to a DB, Tableau shows "Getting Metadata." Behind the scenes, this query looks like 
``` Select * from DB JOIN foo ON BAR limit 0```
This kicks off a full table scan in most column-store DBs. In MemSQL for example, this took 11m and pegged the machine the entire time. It would have been much simpler to issue ```DESCRIBE TABLE foo``` instead. 

2. UX - Let's say you wanted to create a set of users. If that column has high cardinality (uniqueness), because Tableau runs a ```SELECT DISTINCT``` on that column, you have to wait for that to complete before you can do anything. Making this worse is that Tableau does some goofy UI thing where it has to load all those values into the interface BEFORE it will show you the SET UI. If you have millions or billions of items, you may as well go home. However, if you hit CANCEL during this operation, you still get the UI. The underlying idea behind SETS in Tableau is to create rules that make groups. Just show the CONDITION or TOP interface, don't bother with the list of items (or lazy load them in the background).

Most of the tests were pretty simple: SUM or COUNT DISTINCT, add a time dimension, drill down, filter, put something in CONTEXT or CREATE SET, Add a calculated filter. 

Since these are pretty normal operations, I decided to build a hammer. Instead of a Table Calculation for Period over Period, I wrote a series of calculations that calculate this in-DB, at any level of granularity. Here's how it works

1. Create a Metric
2. Calculate Month: ```MONTH([DATE])```
3. Find the Max Unit of time: ```{ FIXED :MAX([Month])}```
4. Find the Max unit of time -1 (Previous Month): ```{ FIXED : max(IIF([Month]<[Max Month],[Month],null))}```
5. Get Metric per unit of time: ```SUM({ FIXED [Uniquevisitorid],[Month]: [Hits per Visit]})```
6. Get the Average of that Metric per unit of time: ```{ FIXED [Month]:AVG([1. Monthly Visitor Behavior])}```
7. Get the value from the Max unit of time: ```if [Month]=[Max Month] then [2. Average Monthly Behavior] END```
8. Get the value from the Max unit of time - 1: ```if [Month]=[Max Month -1] then [2. Average Monthly Behavior] END```
9. Create KPI: ```(AVG([3. Max Month Behavior])-AVG([4. Month-1 Behavior])) / AVG([4. Month-1 Behavior])```

Thats a lot of work, but it's basically an IN-DB Table Calc. 

> Presto and Jethro failed out on these tests, so they'll share last place. 

Now the results: Looking across all tests 

![racing](https://cmtoomey.github.io/img/TableauRacing.png)

To make it an easier comparison, I ranked them by performance (higher is better in this case)

1. Google (2.07)
2. Redshift (2.04)
3. MemSQL (1.5)
4. Snowflake (1.4)

If we look at the number of tests where they were able to be completed in under 30s,

+ Google: 2
+ MemSQL: 0
+ Redshift: 8
+ Snowflake: 5

> Caveat: During testing, Big Query had not implemented support for Standard SQL, and Tableau had to compose queries in BQL. This has been fixed as of 10.1, so these results are not representative of the current state of tech. 

Again, Google wins in query speed. Let's talk total results.

---

If we simply take a golf score of the results, here's how things shake out.

1. Snowflake (2.3)
2. MemSQL (2.5)
3. Redshift (2.8)
4. Google (3.0)
5. Presto (4.8)
6. Jethro (5.5)

Snowflake wins, right? As my favorite people ever, Lee Corso would say:

![Corso](http://www.quickmeme.com/img/ae/ae4c3b06e04de74b8bf0c472eaf6d79e0314280b5e7aa22c2486af79f1c4d9b2.jpg)

While Snowflake is the easiest DB I've ever used, these results overweight a factor that is starting to matter less and less: Storage and Load. On the storage side, [Snowflake announced](https://www.snowflake.net/blog/powerful-easy-use-data-warehouse-now-affordable) that everybody gets $30/TB storage. That's basically cost, so why should they get a bonus for a feature that doesn't actually affect the bottom line? Google and Redshift also have really deep discounts on storage, so compression is now saving pennies rather than dollars (I know a lot of pennies add up, but still).

All four vendors have solutions (of varying complexity) for playing with streaming architectures, and that's the future, so check that box. 

That leaves us with query speeds - as always, speed kills. If we weight Tableau + Query @ 75%, Load @ 20%, and Compression @ 5%, then the results shake out like this:

1. Google
2. MemSQL
3. Snowflake
4. Redshift
5. Presto
6. Jethro

So there you have it - if you want the BEST combination of storage, ease of use and performance, Snowflake wins. They outperform both the incumbent (Redshift) and their closest competitor in the NoOps space (Google), and are the easiest platform to get started with. Separated compute and storeage in the cloud is the future, and Snowflake is leading the way.

If query performance is what you want, Google wins hands-down. They too have a NoOps mentality, and their speed is unmatched. MemSQL is a very close second and support streaming architectures out of the box. Both systems' query speeds are close to interactive scale, and they are only just starting their enterprise journeys.

Where does that leave Redshift? Honestly, I can't recommend it. While it plays extremely well with the rest of AWS, it simply isn't flexible enough or fast enough for the the speed we need at the scale we have. Neither Google or Snowflake have a concurrency problem (Google's architecture protects against it and Snowflake auto-scales up and down beautifully while with Redshift you have to manually build and maintain queues). 

What about Presto? Facebook and Netflix and AirBnb and Pinterest use it to query petabytes of data. Why did it fail here? File formats and Tableau's weird queries. Our data wasn't compressed or formatted correctly to get good query performance. Even with 24 R3.8XL nodes, memory is a precious resource, so compression and column-friendly formats are essential (we tested with GZIP CSVs). 

Tableau's interaction with Presto appears to be a bit wonky. Most Presto queries require the use of a partition key - an indicator to Presto to help it only scan data it needs, rather than scan it all and filter. Partitions show up as columns in Tableau's UI, but users need to be made aware of them, so they set Data Source or Quick Filters appropriately...otherwise you run the risk of query failure. 

Second, despite what appears to be a ```SELECT SUM(Sales), Country from Table Group by 2``` query, Tableau often appends a HAVING clause to its queries to assist with results. At this scale, and with memory-bound systems, more work > more memory > higher liklihood of failure. Tableau needs to clean up it's query pipeline for big data (and Presto needs to allow queries execution to spill to disk, but that's another story).

---

# Summary

With the world exploding in data, you all need a platform you can depend on. It needs to be fast, easy, and economic. Nobody has time to tune and manage databases any more - we just want the data and want to query it fast. After spending many months with massive data, Tableau, and a bunch of databases, I can recommend only three.

1. Google Big Query: Fast, fast, fast.
2. Snowflake: It's the most complete platform out there right now.
3. MemSQL: A bit more work to setup and operate, but you'll be glad you did.

Tableau plays nicely with all of them, but there is a lot of work to be done with HOW it plays well. I know most of the world uses SQL Server, MySQL, and Excel...but Big Data is here and every second of work matters. 

If you have any questions about our testing or the platforms themselves, you can find me in Austin or on Twitter.

Thanks for Reading!