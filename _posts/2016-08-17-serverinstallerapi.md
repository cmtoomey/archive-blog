---
layout: post
section-type: post
title: Tableau Server Installer API
category: Automation
tags: [ 'api', 'automation' ]
---

For those of you who work with Server in the enterprise, you want any edge you can get in deploying, testing, and maintaining Server. At present, the state of the art in Server administration is represented by 

+ [Zen Master Mike Roberts](https://camsoe.com/) who has developed a series of Powershell scripts for monitoring and re-configuring Server.
+ [Craig Bloodworth](https://github.com/TheInformationLab/Tableau-Server-Auto-Upgrader/blob/master/UpgradeTableau.ps1) who developed a Powershell script to check, download, and install Server upgrades.
+ [Tamas Foldi](http://databoss.starschema.net/reconfiguring-tableau-server-without-restart-the-basics-part1/) who taught us all how to recofigure most of Server without a restart. 

Craig's work was actually the inspiration for this announcement. If you haven't heard, or don't work with Server much, Tableau 10.1 comes with the ability to deploy in unattended mode. This means that you can specify any configuration (Local Auth or AD, processes, SAML) through the commandline and perform your install/upgrade without having to be physically on the box. Tableau has always supported a silent mode via the ```/SILENT & /VERYSILENT``` switches (check out Craig's Powershell script and you'll see it), but this is a different beast. This is full configuration, DevOps style and a much needed win for the enterprise.

As I was testing this feature, I felt something was missing. I had no reliable way to figure out which version of Tableau Server was available for installation and then automatically download it. Craig's solution relies on a JSON file ```https://downloads.tableau.com/esdalt/esdalt.json``` that powers the Alternate Downloads site. That was a great find, but I was worried about depending on Tableau's web developers for something that powers my enterprise - that JSON could go away at anytime. What I needed was an API that I could query for versions (like [GitHub](https://developer.github.com/v3/repos/releases/), match me up with an installer file, and then download it. This API needed to tell me version number, and give me a download location while playing nice with any programming language and requiring minimal code from start to finish. 

So on Saturday, I built it. 

### Tableau Server Version API v.01

```https://4xppv7irje.execute-api.us-west-2.amazonaws.com/prod```

It accepts two switches: ```/server``` and ```/worker.``` The first points to versions and installers for Server Primary, while the other points to Server Workers. The output of the API is a JSON string that shows you the version number (#.#.# formatted), and then gives you S3 bucket and object key if you want to go download it. The buckets are publicly available, so yes, you can try it for yourself. 

All you need to do is install the AWS CLI (or SDK for your favorite language) and you are ready to go. 

Here's a sample of the API output

<pre><code data-trim class="json">
{
  "Count": 4,
  "Items": [
    {
      "versionid": {
        "S": "9.3.0"
      },
      "bucket": {
        "S": "tableauserverprimary"
      },
      "key": {
        "S": "TableauServer930.exe"
      }
    },
    {
      "versionid": {
        "S": "9.3.1"
      },
      "bucket": {
        "S": "tableauserverprimary"
      },
      "key": {
        "S": "TableauServer931.exe"
      }
    },
    {
      "versionid": {
        "S": "9.3.4"
      },
      "bucket": {
        "S": "tableauserverprimary"
      },
      "key": {
        "S": "TableauServer934.exe"
      }
    },
    {
      "versionid": {
        "S": "9.3.3"
      },
      "bucket": {
        "S": "tableauserverprimary"
      },
      "key": {
        "S": "TableauServer933.exe"
      }
    }
  ],
  "ScannedCount": 4
}
</code></pre>

You can take that response and find all the version numbers by using something like the following (they aren't sortable right now because the back-end query doesn't allow for sorting, yet).

<pre><code data-trim class="javascript">
//Get the number of items
var number = response.count;
var versions = [];
for (i = 0; i < number; i++) { 
    versions.push(response.Items[i].versionid;
}
</code></pre>

Search that array and match that against your installed version - captured via the ```buildversion.txt``` file that lives in your Server Directory. 

Once you know which one you want, you can combine the other two items together to build an S3 GET request, like so:

<pre><code data-trim class="bash">
bucket = response.Items[N].bucket.S
key = response.Items[N].key.S

s3 cp 's3://'+bucket+'/'+key 'Some local path on your machine'
</code></pre>

**Fun Fact:** If you deploy your Tableau environment on AWS, you already have this installed on your machines. This is a public API, so no other authentication required. 

Run that script & boom, a hands-free Tableau Server install!

Read on if you want to know how it all works...otherwise, fire up the API and get to automating!

---

## How it works

Initially, I was going to use GitHub, as they have an API for releases. You build a repository, tag the commit, and publish. This gives your repository a nice website to show the most recent release, finding previous releases, or querying for the release you want. Server Installers are > 1GB in size, so you can't host more than one installer without paying. Plus, you need to install Git on your machine, and there's no easy way to do that. 

I moved on to AWS CodeCommit, another hosted Git repository. They had no file size limitation, but it wasn't possible to download the version you want. 

I went back to basics - put the installers on S3. You can list items in the bucket, but you have to know the bucket beforehand. Also, the raw S3 JSON output isn't very readable. I took inspiration from this [AWS Big Data Blog post](https://aws.amazon.com/blogs/big-data/building-and-maintaining-an-amazon-s3-metadata-index-without-servers/). Whenever a new version is ready, it should automatically write that data to DynamoDB:

![Dynamo](https://dmhnzl5mp9mj6.cloudfront.net/bigdata_awsblog/images/S3_image1.PNG)

<script src="https://gist.github.com/cmtoomey/8e690aa1b6a003385d822d3c42b0d1ae.js"></script>

I chose Dynamo because I can use it's NoSQL tables as the backend of an API, by connecting it to the [AWS API Gateway](https://aws.amazon.com/blogs/compute/using-amazon-api-gateway-as-a-proxy-for-dynamodb/). It's also surprisingly easy to use. 

Here's the API definition (in Swagger format, which you can import directly into your own AWS environment). The API is CORS-enabled, so the ony way you can't use it is if you choose not to.

<script src="https://gist.github.com/cmtoomey/00ccaf0fc45261168db40d87b2e7b08a.js"></script>

Since the Lambda function auto-updates the DynamoDB table, and the API Gateway is directly connected to the same table, the API is always up-to-date.

I mentioned cost when it came to GitHub - how much does this whole thing cost?

+ S3 Storage: $.60/month for storage -> basically free for downloads (unless you people go crazy)
+ DynamoDB: Basically free
+ API Gateway: Basically Free

For less than $1/month, I'm happy to provide this service...so query and download to your heart's content. 

Source Code [here](https://github.com/cmtoomey/TableauServerVersionAPI) - if you want more features or functions, submit a PR.