---
layout: post
section-type: post
title: Let's automate all the things!
category: automation
tags: [ 'server', 'hack' ]
---
## First things first - nothing you read here is supported!!

### Try at your own risk - here be dragons

<iframe src="//giphy.com/embed/Wen3tZFsGA1hu" width="100%" height="350" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="http://giphy.com/gifs/dragon-gif-fantasy-gifs-Wen3tZFsGA1hu">You've been warned!!!</a></p>

---

### credit where credit is due

This blog post is based on work I did while I was at Slalom and is part of a much larger effort you will be hearing about in the very near future. Many thanks to Slalom for supporting the research and not thinking I was a crazy person (or at least putting up with the crazy). I've been sitting on this documentation for about a year now, but then I saw this on my twitter feed this morning.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I&#39;m about to document how to reconfigure <a href="https://twitter.com/tableau">@tableau</a> server without outage. Yes, new config options or a complete worker without restart</p>&mdash; Tamas Foldi (@tfoldi) <a href="https://twitter.com/tfoldi/status/718419568474091520">April 8, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I talked with Tamas about what he was working on, and this post is a good complement to what he has or will be releasing. He'll be getting into the nitty gritty about configuring Tableau services. He's got the how, I've got the what.

So...what sort of things can you configure in Tableau Server? If you read the documentation, this is the official list:

<iframe src="https://onlinehelp.tableau.com/current/server/en-us/tabadmin.htm" width="105%" height="450" allowtransparency="true" style="background: #FFFFFF;"></iframe>

Except that's not the real list. I'm here to tell you that any option you can select in **Configure Tableau Server** you can set.

Anything in any of these tabs
![Allthethings](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/c7d17823-94ff-4c5c-9e71-75c4d34cf3bc/Screen%2520Shot%25202015-08-27%2520at%25203.52.06%2520PM.png)

And these things too
![allthethings2](http://kbcdn.tableausoftware.com/images/DownloadingProducts_RegisterFieldsDialog.png)

# You can do it all!

Everything you are about to see is tested and validated - but there are some parts of that process I can't talk about. This documentation is good for every version of Tableau Server through 9.3. Through the rest of the blog, I'll show you how to configure each setting, as well as any other things you need to know in order to make it all work.

---

This project was borne out my frustration with setting up, installing, and administering Tableau Server. So much waiting and clicking and waiting some more. I wished I could make Tableau do whatever I want via the command line (no Powershell spoofing of keystrokes allowed).

Like what, you ask? You know that [sentence in the Server Admin guide](https://onlinehelp.tableau.com/current/server/en-us/config_general.htm) that says

> *Select whether to use Active Directory to authenticate users on the server. Select Use Local Authentication to create users and assign passwords using Tableau Server's built-in user management system. You cannot switch between Active Directory and Local Authentication later.*

I'm calling BS. With this method, you can switch on the fly if you want, no uninstalling necessary. Do what you want.

What about adding or reconfiguring workers on the fly - or an automated HA setup? *Yeah, you can do that too!*

+ Automated Key activation/deactivation? - *check*
+ Update all services on all boxes? - *check*
+ Adjust SSL/SAML providers? - *check*
+ Dynamic Parameters? - *not gonna happen*
+ Tableau + DevOps? - *You better believe it!*

So, how did I figure all this out?

![mattdamon](https://cmtoomey.github.io/img/martian.gif)

---

### Tableau Server Configuration: The basics

Before we can configure Server, we have to deal with two more pieces of configuration data. First is your registration, which are all the details you have to enter when you activate your license key. This is stored in the Registry:  `HKLM\Software\tableau\registration\data`

> For those of you who aren't familiar with the [Windows Registry](https://en.wikipedia.org/wiki/Windows_Registry), it's a small database that stores settings. HKLM refers to settings on your Local Machine (HKEY Local Machine = HKLM).

To edit the registry, you have to execute the following command

    reg add HKLM\\Software\\tableau\\registration\\data /v [value] /d [data] /f [force overwrite]

Below is the list of `values` that you'll need to update to complete the "Registration" process:

+ city
+ company
+ country
+ department
+ email
+ first_name
+ industry
+ last_name
+ phone
+ state
+ title
+ zip

You may remember that Industry and Department are both drop downs - so here are the lists for those menus

#### Industry

![industry](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/1a101a40-f262-44a5-85db-eed20b2ab7a9/Screen%2520Shot%25202015-09-18%2520at%25201.42.12%2520PM.png)

#### Departments

+ Accounting/Finance
+ Engineering/Development
+ General Mgmt/Administration
+ Human Resources
+ Legal
+ Marketing
+ Operations
+ Channel
+ Product Management
+ Purchasing/Merchandising
+ Sales
+ Science
+ Support/Service
+ Other

The second is activating your License. There was an old KB article for doing this, but `tabadmin` has you covered

    tabadmin activate --key [which is your license key]

You can deactivate a key by switching `deactivate` for `activate.`

---

### Tableau server configuration - the process

Now that we are done with license and registration, it's important to understand how Tableau actually does its configuration work. Understanding this process was the key to extracting all this wonderful documentation.

To do this, I used [Process Monitor](https://technet.microsoft.com/en-us/sysinternals/processmonitor), which is a close cousin to [Paul Banoub's](https://vizninja.com/2016/03/03/a-tableau-server-admin-toolkit/) favorite tools Process Explorer and Perfmon. Both come out of the [Sysnternals](https://technet.microsoft.com/en-us/sysinternals/bb842062) suite, which you should go get because it's free and awesome.

#### The YML files

All of Tableau's configuration details are stored in two files.

+ tabsvc.yml - `C:\ProgramData\Tableau\Tableau Server\config`. Tabsvc records the non-default settings for Tableau and is a great place to see what has been changed on y our box.
+ workgroup.yml - `C:\ProgramData\Tableau\Tableau Server\data\tabsvc\config`. This is the motherlode, and contains all the settings for everything. **DO NOT EDIT THIS FILE DIRECTLY, EVER!!!**

When you open Configure Tableau Server, you'll see the following:

+ A default YML file: `temp_default_opts.yml`
+ A changed YML file: `temp_current_opts.yml`

If you watch the folder when you open "Configure Tableau Server," you'll see the file appear like a rare Pokemon. You can double-click it to open and save somewhere else.

These are what they seem - defaults and your current options. Then you make some changes, and hit OK. In the same folder as the other two YML files, you'll see another rare appearance: `temp_validate_opts.yml`.

<script src="https://gist.github.com/cmtoomey/18f05201eb6a16af80c2775e39fd62c3.js"></script>

You may notice that the RunAs User password is in cleartext. Don't worry, this is the only time you'll see that value appear anywhere. It's not hanging around somewhere - well it is, but it's salted and encrypted. It's safe.

Tableau then validates the options you selected, rewrites the YML, installs tabsvc and then you are ready to go.

---

### Tableau Server Configuration - the settings

Here it is. I'll go screen by screen and document each setting. Some things changed between 9.1, 9.2, and 9.3, and I'll highlight those as I go. The basis for this script is the following:

    tabadmin stop
    **tabadmin set key value**
    tabadmin configure
    tabadmin install --password
    tabadmin start

---

### General

![General](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/c7d17823-94ff-4c5c-9e71-75c4d34cf3bc/Screen%2520Shot%25202015-08-27%2520at%25203.52.06%2520PM.png)

#### Server Run As User

+ **Username:** service.runas.username "DOMAIN\\User"
+ **Password:** service.runas.password

> Note about Run As User Password. Depending on which version of Tableau you are using, you may have to try it two different ways. The initial research was performed on Tableau 9.2. For that process, it was necessary to use the `tabadmin install --password` method. For 9.3, if you run `tabadmin set service.runas.password` and then do `tabadmin configure,` it works the same way, AND you shouldn't see the password in cleartext anywhere.

#### User Authentication

+ wgserver.authenticate local/activedirectory/saml/openid

#### Active Directory

+ **Domain:** wgserver.domain.fqdn
+ **Nickname:** wgserver.domain.nickname
+ **Enable Automatic Login:** wgserver.sspi.ntlm true/false

#### Gateway

+ **Port Number:** worker.gateway.port ##
+ **Open Port in Windows Firewall:** install.firewall.gatewayhole true/false
+ **Include Sample Data: install.component.samples:** you can only set this at initial setup (but its install.component.samples true/false)

---

### Data Connections

![Connections](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/73c6469d-3f82-4024-9778-b8599318f095/Screen%2520Shot%25202015-08-27%2520at%25204.14.28%2520PM.png)

#### Caching

+ **Refresh Less Often:** vizqlserver.data_refresh (this is default, so you shouldn't need to change back to this. If you don't want the other ones, just leave this alone)
+ **Balanced:** vizqlserver.data_refresh ##
+ **More Often:** vizqlserver.data_refresh 0

#### Initial SQL

+ vizqlserver.initialsql.disabled true/false

---

### Servers

This is where you learn how to automatically setup and connect your workers. This means that you can auto-deploy, configure, or reconfigure workers. I'll show you how to change the configuration, push the configuration, and adjust workers so that they are pointing at the Primary.

*Your workers will need to be on the same domain for them to communicate successfully!*

![Servers](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/ccee160c-7b55-4209-b585-2f378dfb1c72/Screen%2520Shot%25202015-08-27%2520at%25204.32.53%2520PM.png)

#### Primary Adjustments - worker0

Unlike the UI, your changes here will just be applied, you may not get an error or warning if you misconfigure (like forget to add a Data Engine or File Store somewhere).

+ **VizQL:** worker0.vizqlserver.procs #
+ **Application Server:** worker0.vizportal.procs #
+ **Background Server:** worker0.backgrounder.procs #
+ **Cache Server:** worker0.cacheserver.procs #
+ **Data Server:** worker0.dataserver.procs #
+ **Data Engine:** worker0.dataengine.procs #
+ **File Store:** worker0.filestore.enabled true/false
+ **Repository:** pgsql0.host Machine Name of Primary
+ **Search and Browse:** worker0.searchserver.procs 1
+ **Gateway:** worker0.gateway.enabled true/false

#### workers - worker1 -> workerN

+ **Add a Worker:** worker.hosts "Primary, IP1, IP2"
+ workerN.XXX.procs [just replace worker0 with workerN]
+ **If you want to run a repository on another host:** pgsql1.host IP address of worker
+ **If you have more than one pgsql repository:** pgsql.preferred_host MACHINE NAME

To make sure the Primary and Workers can talk to each other, you need to modify the service on each of the Workers to listen for the primary.

    net stop "Tableau Administrative Server"
    sc config tabadmsvc binpath= "C:\\Program Files\\Tableau\\Tableau Server\\worker\\admin\\tabadmsvc.exe start --primary IP Address of Primary"
    net start "Tableau Administrative Server"

Now that they can communicate, you need to push that configuration out to them. You due this by running `tabadmin prep workers.`

---

### Alerts and Subscriptions

There's a little bit of UI drift between 9.2 and 9.3, so I'll do my best to document the changes. The commands are the same across, but there is an extra tab and a few extra settings available in 9.3.

This is 9.2

![92 Alerts](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/5e8c8b5d-3607-4600-9715-c056255a5df2/Screen%2520Shot%25202015-08-27%2520at%25205.54.34%2520PM.png)


This is 9.3

![93alerts](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/2d037cea-5420-4fe9-83e0-1ffced0df935/Screen%2520Shot%25202016-03-07%2520at%25202.53.24%2520PM.png)

The SMTP information in 9.2 has moved to **SMTP Setup** in 9.3 to make room for **Disk Space Monitoring.**

#### SMTP Setup

+ **Send email alerts for server health:** svcmonitor.notification.smtp.enabled true/false
+ **Enable email subscriptions:** subscriptions.enabled true/false

+ **SMTP:** svcmonitor.notification.smtp.server smtp address
+ **Username:** svcmonitor.notification.smtp.send_account username
+ **Port:** svcmonitor.notification.smtp.port ##
+ **Password:** svcmonitor.notification.smtp.password password
+ **Enable TLS?:** svcmonitor.notification.smtp.ssl_enabled true/false
+ **Send email from:** svcmonitor.notification.smtp.from_address email
+ **Send email to:** svcmonitor.notification.smtp.target_addresses email
+ **Tableau Server URL:** svcmonitor.notification.smtp.canonical_url TABLEAU SERVER URL

#### Disk Space Monitoring (9.3 Add-on)

+ **Record disk space usage information:** storage.monitoring.record_history_enabled true
+ **Send alerts when unused drive space drops:** storage.monitoring.email_enabled false
+ **Warning threshold:** storage.monitoring.warning_percent 20
+ **Critical threshold:** storage.monitoring.critical_percent 10
+ **Send email alert every:** storage.monitoring.email_interval_min 60

---

### SSL

For SSL to work correctly, you need to put (or push) your certificates into a specific folder. The path is `[Drive Letter]:\Program Files\Tableau\Tableau Server\SSL`

![SSL](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/12af7821-72ad-43e1-9689-2260fae241ba/Screen%2520Shot%25202015-08-27%2520at%25205.59.50%2520PM.png)

#### External Webserver SSL

FQP = Fully Qualified Path from above

+ **SSL Enabled:** ssl.enabled true/false
+ **SSL Certificate File:** ssl.cert.file [FQP to .crt]
+ **SSL Certificate Key File:** ssl.key.file [FQP to .key]
+ **SSL Certificate Chain File:** ssl.chain.file [FQP to chain .crt]
+ **Mutual SSL and automatic login:** ssl.client_certificate_login.required true
+ **SSL CA certificate file:** ssl.cacert.file [FQP to .crt]

#### Internal Repository Database ssl

+ **Required for all Connections:** pgsql.ssl.enabled true && pgsql.ssl.required true
+ **Off:** pgsql.ssl.enabled false
+ **Optional for direct user connections:** pgsql.ssl.enabled true

---

### SAML

This section and the next one cannot be fully automated without intervention. Both require a user to run external configuration scripts or functions. For SAML, you can mock up the correct information with a dummy file and do your work ahead of time.

Like SSL, you'll need a specific file path for placing your XML and certs. This path is `[Drive Letter]:\Program Files\Tableau\Tableau Server\SAML`

![SAML](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/6839137c-b1fb-486b-8714-555875cf6481/Screen%2520Shot%25202015-08-27%2520at%25207.37.08%2520PM.png)

+ Use SAML for single sign-on: wgserver.authentication.login saml
+ Tableau Server return URL: wgserver.saml.returnurl protocol/url:port

> This will declare the following configuration settings *wgserver.saml.protocol http/https,* *wgserver.saml.port port #,* *wgserver.saml.domain url*

+ **SAML entity ID:** wgserver.saml.entity id
+ **SAML Certificate File:** wgserver.saml.cert.file [FQP to .crt]
+ **SAML Key File:** wgserver.saml.key.file [FQP to .key]
+ **SAML IdP metadatafile:** wgserver.saml.idpmetadata.file [FQP to .xml]

Normally, you would need Tableau to export the metadata file for registration with your identity provider. However, you can generate it yourself, because it's basically a template. It looks like this:

![XML](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/f9da3b70-5d11-4664-96a5-d97754ac7259/Screen%2520Shot%25202015-08-28%2520at%25206.03.02%2520AM.png)

There is one part of the XML you will have to fill out on your own (or at least do some parsing) - the Certificate. It's in the section

    <md:KeyDescriptor use="encryption">
      <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:X509Data>
          <ds:X509Certificate></ds:X509Certificate>
        </ds:X509Data>
      </ds:KeyInfo>
    </md:KeyDescriptor>

In the ```X509Certificate``` goes your actual certificate, which you can extract by opening up your ```.crt``` and pasting it between ```<ds:X509Certificate></ds:X509Certificate>```.

Here is what it looks like:

![CRT](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/4fe5048f-9d59-4741-b703-0b4f5567432d/Screen%2520Shot%25202015-08-28%2520at%25206.12.19%2520AM.png)

Since you can extract that data out, this means you could automate the creation of the XML needed to bind Tableau to your IDP.

**Be warned, if your using non-standard claims, like email instead of username, you will have to adjust this through tabadmin set wgserver.saml.idpattribute.username.**

---

### Kerberos

![kerberos](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/96e98aa2-a422-47a3-ae54-9e6ab91f534f/Screen%2520Shot%25202015-08-28%2520at%25206.22.20%2520AM.png)

It is possible to automatically configure Tableau to use Kerberos, but be warned, you have to do some upfront. Kerberos is a subset of the Active Directory authentication function, and enabling it requires you to run a configuration script to create a `.keytab` file. Once you have this folder, you tell Tableau where it lives and it handles the rest.

A few extra notes

+ The Run As User account (the Tableau Server service account) must be an AD domain account. Local accounts, including NTAUTHORITY\NetworkService will not work.
+ The Run As User account must be in the same domain as the database services that will be delegated.
+ Constrained delegation: The Run As User account must be granted access to the target database Service Principal Names (SPNs).
+ Data Source authentication: If you plan to use Kerberos to authenticate to Microsoft SQL Server or MSAS databases, or with delegation for Single sign-on (SSO) to Cloudera Impala, enable the Run AS User account to act as part of the operating system. For more information, see Enable Run As User to Act as the Operating System.
+ External Load Balancer/Proxy Server: If you are going to use Tableau Server with Kerberos in an environment that has external load balancers (ELBs) or proxy server, you need to set these up before you configure Kerberos in the Tableau Server Configuration utility. See Add a Load Balancer and Configure Tableau to Work with a Proxy Server for more information.

Here's a shot of the batch script you have to run to start the process, and I've reproduced the basics below.

![batch](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/f5fe8f79-8fb6-4e17-8bce-d9fbbea37316/Screen%2520Shot%25202015-08-28%2520at%25206.30.55%2520AM.png)

    @echo off
    setlocal EnableDelayedExpansion
    set /p adpass="Enter password for the Tableau Server Run As User (used in generating the keytab)"
    set adpass=!adpass:"=/"!
    echo Creating SPNs...
    setspn -s HTTP/DOMAIN DOMAIN\username
    setspn -s HTTP/DOMAIN DOMAIN\username
    echo Creating Keytab files in %CD%\keytabs
    mkdir keytabs
    ktpass /princ HTTP/DOMAIN /pass !adpass! /ptype
    KR85_NT_Principal /out keytabs\kerberos.keytab

Once this file has been run, you have this file `kerberos.keytab`. You have to have this *before* you can configure Kerberos on Tableau Server. then you point Tableau to the file by running the config command.  

If that doesn't intimidate you, here's the two commands:

+ **Enable Kerberos:** wgserver.kerberos.enabled true/false

There is no ```tabadmin set``` command for the keytab. Instead, you have to use a *very undocumented* command.

```tabadmin publishkeytab "PATH\TO\KEYTAB\file.keytab"```

---

### SAP HANA

![HANA](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/d9a910ad-f448-43c0-8fcb-674a7047d4da/Screen%2520Shot%25202015-08-28%2520at%25206.02.07%2520PM.png)

This tab is used to configure SSO for SAP's super-fast HANA database. Like Kerberos, there is a lot of external work involved to make this happen. Since this isn't a post about how to configure HANA, I'll let you go read the docs.

#### General settings

+ **Use SAML to enable single sign-on for SAP HANA:** wgserver.sap_hana_sso.enabled true
+ **SAML Certificate File and SAML Key File:** tabadmin publishhanassofiles --certificate "C:\Program Files\Tableau\Tableau Server\SAML\test.crt" --key "C:\Program Files\Tableau\Tableau Server\SAML\test.der"

```tabadmin publishhanassofiles``` does the heavy lifting for you by altering two lines in ```workgroup.yml```

+ wgserver.sap_hana_sso.saml.cert.file.name hana_cert.pem
+ wgserver.sap_hana_sso.saml.key.file.name hana_pkey_pkcs8.der

#### Username Format: wgserver.sap_hana_sso.username.format

+ **Username only:** username
+ **Domain name and username:** domain_and_username
+ **email:** email

#### Username case: wgserver.sap_hana_sso.username.case

+ **Preserve Case:** preserve
+ **Uppercase:** upper
+ **Lowercase:** lower

---

### OpenID

One of the new additions to Tableau 9.3 is the ability to use an OpenID provider (Google and Yahoo being the big fish in that pond) for your authentication and identity provision. In short, it's another type of SAML.

You'll need to collect a few things from your provider to complete this section, and this will depend on your provider. OpenID only works with local authentication. Depending on your provider (like if you use Google), [you may have to use a full email address](https://onlinehelp.tableau.com/current/server/en-us/openid_auth.htm).

Make sure your IdP is prepared to accept requests from Tableau Server. You'll need to get the Client ID, Client Secret (token), and configuration URL. This is very similar to the SAML setup from before, just a little simpler.

![openid](https://mammothhq.s3.amazonaws.com/boards/134972/attachments/672f02b7-4992-493e-bd50-cd55abbb8852/Screen%2520Shot%25202016-03-07%2520at%25203.04.25%2520PM.png)

+ **Use OpenID Connect for SSO:** wgserver.authentication.login openid
+ **Provider client ID:** vizportal.openid.client_id
+ **Provider client secret:** vizportal.openid.client_secret
+ **Provider configuration URL:** vizportal.openid.config_url
+ **Tableau Server external URL:** MACHINE NAME

The last section will generate the URL to bind your Tableau Server to your IdP. To generate it, it takes the following form:

    http(s)://EXTERNALURL/vizportal/api/web/v1/auth/openIdLogin

---

### Tableau 10 Features

Now that Tableau 10 is released (or about to be - depending on when you read this), I've updated the section below with some tabadmin commands that you can use to configure Tableau Server to your heart's desire.
The good news is that the standard configuration window hasn't changed. All those features are exactly as they were in 9.3 (with the exception of SAML, which gets a fancy drop-down instead of a check-box).

+ **Desktop License Reporting:** tabadmin set features.DesktopReporting true
+ **Email Notification of Extract Failure:** tabadmin set backgrounder.send_email_on_refresh_failure false

**BONUS FEATURE**

For those who don't know, [Paul Banoub](https://twitter.com/paulbanoub) is the Tableau Server Master. He recently [posted](https://community.tableau.com/thread/155429) about how to launch Lync sessions from within Tableau workbooks. This is a great collaboration feature that everyone should use. You can read it yourself, but here's the Tableau Server commands that make it work.

+ tabadmin set vizqlserver.url_scheme_whitelist sip
+ tabadmin set vizqlserver.url_scheme_whitelist im

If you are adventurous, you can substitute Lync (which uses the **im** protocol), for the one Slack uses.

+ tabadmin set vizqlserver.url_scheme_whitelist slack

In your URL action, you want to use the following syntax

```
slack://channel?id=[ChannelID]&team=[teamID] - this will launch you into a #channel in the Slack app
slack://user?id=[userID]&team=[teamID] - this will open the user profile for whoever you want to chat with in the Slack app
```
Due to Slack's webapp restrictions, you can't actually launch the web version inside a workbook. You can open it in a separate window though, like so:

```
https://slackteamname.slack.com/messages/@user
```

How do you get the ChannelID, UserID, and TeamID?

1. Get your [API token](https://api.slack.com/docs/oauth-test-tokens)
2. Query your [team's info](https://api.slack.com/methods/team.info/test)
3. Query your [channels' info](https://api.slack.com/methods/channels.list)
4. Query your [user's info](https://api.slack.com/methods/users.list)

You can user Slack's interface or Postman. If you want to export the list and post it somewhere for other's to use, I'd recommend Postman. 

---

## So...what now?

Now you know everything there is to know about Tableau Server configuration. What can you do with it?

You should absolutely put [tabadmin on your path](https://cmtoomey.github.io/automation/2015/10/07/tabadminpath.html). That will make everything much simpler and you won't have to type ```cd Program Files\blah\blah\bin``` ever again. Once you've done that, you can adopt as much **DevOps** as you would like.

> In other words, you can dynamically deploy, modify, scale up, scale out, and upgrade on-the-fly with little to no downtime. AND when [Tamas](http://databoss.starschema.net/) gets around to documenting his dark magic, you'll probably be rid of downtime for good.

Let's start with the easy (and free stuff).

### Beginner

Do you use Windows? Of course you do, you are a Tableau user! Did you know you can use Powershell to remotely access and run scripts? No?

It's a built-in feature that lets you write (and schedule) Powershell modules directly from your machine to run on your Tableau Server. You'll need Admin rights to the Server box - but once you have that, follow [these steps](http://www.howtogeek.com/117192/how-to-run-powershell-commands-on-remote-computers/) and get to automating!

### Advanced

Since everything Tableau Server-related can be run via Powershell, now we can start getting a bit crazy. If you are on AWS, you can use a brand-new feature called [Run Command](https://aws.amazon.com/ec2/run-command/). This is a feature for **all** AWS Windows instances that lets you send commands remotely (think SSH or remote Powershell) without having to log into the box. Ever.

The first way to do this is to access your AWS Console

![AWS Console](https://media.amazonwebservices.com/blog/2015/run_command_commands_1.png)

Once you are there, you can run a command by selecting ```AWS-RunPowerShellScript``` and typing in your script.

![RunPS](https://media.amazonwebservices.com/blog/2015/run_command_run_command_1.png)

All your activities are logged and you can use the console to check progress and outputs. Read more [here](https://aws.amazon.com/blogs/aws/new-ec2-run-command-remote-instance-management-at-scale/)

---

If you like **Run Command** but want a bit more automation, AWS supports that too (to the surprise of nobody)!

1. Make sure you have [Python](https://www.python.org/) installed.
2. Open your command line and type ```pip install aws-shell```
3. Start and configure your terminal

```
$ aws-shell
aws> configure
AWS Access Key ID [None]: your-access-key-id
AWS Secret Access Key [None]: your-secret-access-key
Default region name [None]: region-to-use (e.g us-west-2, us-west-1, etc).
Default output format [None]:
aws>
```

From your terminal, you use run command by invoking the [ssm](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/walkthrough-cli.html) syntax. Documents are written in JSON and can be created beforehand or will accept Powershell scripts as an input via a parameter.

Let's say you want to get the status of the Tableau Server before doing anything. You would open your aws-shell and type this:

    ssm send-command --instance-ids [LIST YOUR INSTANCE IDS] --document-name AWS-RunPowerShellScript ---Parameter @{'commands'=@('tabadmin status')}

The aws-shell will provide you with autocomplete help along the way.

![awsautocomplete](https://camo.githubusercontent.com/08dc8752b3927b66f9a5237205efaa8e88aacb6c/68747470733a2f2f6177732d646576656c6f7065722d626c6f672d6d656469612e73332d75732d776573742d322e616d617a6f6e6177732e636f6d2f636c692f53757065722d4368617267652d596f75722d4157532d436f6d6d616e642d4c696e652d457870657269656e63652d776974682d6177732d7368656c6c2f6177732d7368656c6c2d66696e616c2e676966)

If you want to give it a try [follow these instructions.](http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/walkthrough-powershell.html#d0e57081)

You can create your own documents to run on some schedule, or create them on the fly.

### Jedi

The AWS automation is great, but that's still a lot of work. What if there was a way to create templates, tests, and schedules and let it run all by itself? You want to be agile and have your infrastructure respond to your needs. You want infrastructure as code, so you can automate everything in a controlled environment.

This is the DevOps dream - and now it is possible for Tableau. Pick your platform, here's how to make it work.

<a href="https://www.chef.io/"><img src="http://s3.amazonaws.com/opscode-corpsite/assets/121/pic-chef-logo.png" height="346" width="340"></a>

Use the [**powershell_script**](https://docs.chef.io/resource_powershell_script.html) resource to execute Powershell scripts on any system controlled by your Chef Server.

<a href="https://puppet.com/"><img src="https://cmtoomey.github.io/img/Puppet-Logo-Amber-White-sm.png" height="198" width="560"></a>

Use the [**powershell module**](https://forge.puppet.com/puppetlabs/powershell) for executing Powershell commands.

<a href="http://saltstack.com/"><img src="http://saltstack.com/wp-content/uploads/2014/12/saltStack_horizontal_dark_800x251.png" height="141" width="400"></a>

Use the [**salt.modules.cmdmod**](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.cmdmod.html) with ```shell='powershell'```

<a href="https://www.packer.io/intro/"><img src="https://img.stackshare.io/service/967/packer.png" height="240" width="240"></a>

Use the [**PowerShell Packer**](https://www.packer.io/docs/provisioners/powershell.html) to run Powershell scripts on Windows machines. It will look something like this

```
{
  "type": "powershell",
  "inline": ["command"]
}
```

This works as part of the broader [HashiCorp platform](https://www.hashicorp.com/index.html#tools) for building and managing infrastructure. You can use their tools to deploy across any environment you want, and in any combination!

<a href="https://www.ansible.com/"><img src="https://www.ansible.com/hs-fs/hubfs/-2015-template-assets/images/retina-icons/ANSI_logotype_web_white2x.png?t=1462475795640&width=428"></a>

This one is a little more [complicated.](http://docs.ansible.com/ansible/intro_windows.html) Ansible's method is based on PowerShell remoting, via Python. To run these scripts, you can create them in advance (much like AWS), or use a syntax like so

```
- name: raw module
  hosts: Windows
  tasks:
    - name: do stuff
    raw: type your commands here
```

---

There you have it. Everything you ever wanted to know about how Tableau Server configuration works, how to automate it, and some cool things you can do. The content in this post is current through Tableau 9.3 and will be updated once Tableau 10 hits Beta 4.

As always, thanks for reading and let me know if you have any questions!
