# mcs_demo
A set of Ultra Messaging configuration files and a test script
to demonstrate setting up UM automatic monitoring using
the Monitoring Collector Service (MCS).
Also contains an updated version of the "lbmmon.java" example app.

# Table of contents

<!-- mdtoc-start -->
&bull; [mcs_demo](#mcs_demo)  
&bull; [Table of contents](#table-of-contents)  
&bull; [COPYRIGHT AND LICENSE](#copyright-and-license)  
&bull; [REPOSITORY](#repository)  
&bull; [INTRODUCTION](#introduction)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Prerequisits](#prerequisits)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Configuration Goals](#configuration-goals)  
&bull; [Demo Architecture](#demo-architecture)  
&bull; [Demo Files](#demo-files)  
&bull; [Run the Demo](#run-the-demo)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Sqlite Database](#sqlite-database)  
&bull; [Output Files](#output-files)  
&bull; [Lbmmon.java Output](#lbmmonjava-output)  
&bull; [Important Stats Fields](#important-stats-fields)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Context Stats](#context-stats)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Source Stats](#source-stats)  
&nbsp;&nbsp;&nbsp;&nbsp;&bull; [Receiver Stats](#receiver-stats)  
<!-- TOC created by '../mdtoc/mdtoc.pl README.md' (see https://github.com/fordsfords/mdtoc) -->
<!-- mdtoc-end -->

# COPYRIGHT AND LICENSE

All of the documentation and software included in this and any
other Informatica Ultra Messaging GitHub repository
Copyright (C) Informatica, 2022. All rights reserved.

Permission is granted to licensees to use
or alter this software for any purpose, including commercial applications,
according to the terms laid out in the Software License Agreement.

This source code example is provided by Informatica for educational
and evaluation purposes only.

THE SOFTWARE IS PROVIDED "AS IS" AND INFORMATICA DISCLAIMS ALL WARRANTIES
EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF
NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
PURPOSE.  INFORMATICA DOES NOT WARRANT THAT USE OF THE SOFTWARE WILL BE
UNINTERRUPTED OR ERROR-FREE.  INFORMATICA SHALL NOT, UNDER ANY CIRCUMSTANCES,
BE LIABLE TO LICENSEE FOR LOST PROFITS, CONSEQUENTIAL, INCIDENTAL, SPECIAL OR
INDIRECT DAMAGES ARISING OUT OF OR RELATED TO THIS AGREEMENT OR THE
TRANSACTIONS CONTEMPLATED HEREUNDER, EVEN IF INFORMATICA HAS BEEN APPRISED OF
THE LIKELIHOOD OF SUCH DAMAGES.

# REPOSITORY

See https://github.com/UltraMessaging/mcs_demo for code and documentation.

# INTRODUCTION

Informatica recommends that Ultra Messaging users enable the
automatic monitoring feature in their UM-based applications and most
UM daemons (Store, DRO, etc.).

This repository has a script and configuration files to demonstrate
UM's automatic monitoring capability using the Monitoring Collector
Service (MCS).
The script is designed to provide all the types of monitoring data
from UM services and pub/sub applications.

This repository also contains two enhancements to existing UM
exmaple applications:
* lbmmon.java - enhanced to understand SRS monitoring data.
* umercv.c - enhanced to enable the use of a UM event queue.

Finally, there is another demo under the sub-directory [json_print](json_print/)
that uses a user-written plug-in instead of the "sqlite" database.

## Prerequisits

You must have the following:
* Linux 64-bit system (reasonably recent).
* UMP or UMQ version 6.15 or beyond.
* DRO 6.15 or beyond.
* Java JDK 9 or beyond.
* sqlite (reasonably recent).
* Optional: python (to run "peek.sh").

(Running this demo manually on Windows is reasonably straight-forward,
but beyond the scope of this demo.)

## Configuration Goals

* Put monitoring data on a separate Topic Resolution Domain (TRD) from
production data.
* For the monitoring TRD, use unicast UDP with the "lbmrd" for topic resolution.
This is to make it easier to run on an administrative network.
* For the monitoring data, use the TCP protocol.
This is to make it easier to run on an administrative network.
* Route monitoring packets to a different network interface than
the production data.
For example, use the administrative network.
This eliminates contention for network resources.
Note that in this demo, multicast is not used for monitoring.
* Disable the monitoring context's MIM and request ports.
This minimizes the use of host resources.

# Demo Architecture

# Demo Files

* tst.sh - Shell script to run the demo.
* um.xml - UM library configuration file for the application messaging TRDs.
This XML-format file contains UM configuration for the main messaging
components (publisher, subscriber, Store, DRO).
* srs.xml - Configuration file for Stateful Resolution Service (SRS),
used to provide TCP-based topic resolution for one of the application
messaging TRDs.
* lbmrd.xml - Configuration file for LBM Resolver Daemon (lbmrd),
used to provide unicast topic resolution for the monitoring data TRD.
* dro.xml - Configuration file for Dynamic Routing Option (DRO).
The DRO routes messages between the two application messaging TRDs.
* lbm.sh.example - Model file for creating "lbm.sh" file.
Provides environment and license key.
* lbmmon.java - Updated example application for collecting
and printing monitoring data.
* mcs.xml - Configuration file for Monitoring Collector Service (MCS).
* mcs.properties - Additional configuration for MCS.
* store.xml - Configuration file for persistent Store.

# Run the Demo

1. Ensure your test system has the [prereqisits](#prerequisits).
1. Clone or download the repository at https://github.com/UltraMessaging/mcs_demo
1. Copy the file "lbm.sh.example" to "lbm.sh" and modify per your environment.
I.e. insert your license key and set your file paths.
1. Edit all xml files and update IP addresses (search for "10.29").
In particular, set the multicast groups per your network in "um.xml" (search for "239.101").
1. Enter:
````
./tst.sh
````

This should take about one and a half minutes to run,
and should print a series of progress messages,
including PIDs of asyncronous processes.

The "mcs.out" file will contain the raw JSON records in a non-pretty format;
difficult for humans to read, but easy for software tools to process.
Note that the timestamps are in the form of [Unix time](https://en.wikipedia.org/wiki/Unix_time),
the number of seconds since 00:00:00 UTC on 1 January 1970, excluding leap seconds.

The "lbmmon.log" file will contain an easier to read form.

One significant difference between the two files:
mcs.out's records are grouped into four sections by record type -
library stats, Store stats, DRO stats, and SRS stats -
with chronological ordering within each section.
In contrast, lbmmon.log's records are intermingled by type,
in chronological order across record types.

## Sqlite Database

The sqlite database is initially created by tst.sh using the
sqlite3 script contained in the UM package in the file "MCS/bin/ummon_db.sql".
As of UM version 6.15, here is its content:
````
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE umsmonmsg(message json);
CREATE TABLE umpmonmsg(message json);
CREATE TABLE dromonmsg(message json);
CREATE TABLE srsmonmsg(message json);
COMMIT;
````

The mcs.out records are written by tst.sh using the following
sqlite3 commands:
````
select * from umsmonmsg;
select * from umpmonmsg;
select * from dromonmsg;
select * from srsmonmsg;
````

# Output Files

The "output" directory has a sample of the output from running the demo
in the Ultra Messaging lab.

# Lbmmon.java Output

The "lbmmon.java" program prints statistics in human-readable form.
However, if you write your own monitoring collector program,
you will probably want to access the statistics individually.
See [displayString.md](displayString.md) to see the field methods
associated with each human-readable output line.

# Important Stats Fields

Most of these fields are cumulative.
E.g. from one sample to the next,
the value will show the total value of the stat since the object
(context, source transport session, receiver transport session) was created.
So, for example, if you want the topic resolution datagrams received in
datagrams per second,
you'll need to take two samples and subtract,
and then divide by the time difference between them.

The stats listed below are only the "most" important;
there are others that might be of interest to you.
For example,
[send_blocked](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#a092960998a64a6e810381e5770da7dac) or
[send_would_block](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#a7c7d7bca55193f5e400f63bc1f86b8da).
We recommend you browse the available stats to see what interests you.

Also, we always recommend that you record and store ALL statistics,
not just the ones that interest you.
It sometimes happens that, while investigating a problme,
the UM Support team will ask about a stat that the user weren't interested in;
if they didn't save it, Support will have trouble diagnosing their problem.

## [Context Stats](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html)

* [tr_dgrams_sent](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#af81b4e84e386bd78281c6ae10311bb88) -
Get an idea of how many datagrams/sec the context is generating for topic resolution.
* [tr_dgrams_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#ac098444f61f7b93a1291187f7b7b099c) -
Get an idea of how many datagrams/sec the entire network is generating for topic resolution.
* [tr_dgrams_dropped_ver](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#a4af77dcdede237ff289bf1085f4d9030),
[tr_dgrams_dropped_type](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#a9477e4a48c6cceabea9450e0f85276da),
[tr_dgrams_dropped_malformed](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#aaba67cae496b93572e2455a25776babe) -
If any of these are non-zero, alert the operator.
* [tr_rcv_unresolved_topics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#accf9ebc73f241bc2c7f0043e75d89d2c) -
This should be zero during normal operation. Non-zero means that one or more receivers have not discovered sources.
* [fragments_lost](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#ad80f9f30910a7468de9863238cdf126d) -
Approximately the number of datagrams that should have been received but were lost.
If this number grows by more than a few per hour, the operator should be alerted.
* [fragments_unrecoverably_lost](https://ultramessaging.github.io/currdoc/doc/API/structlbm__context__stats__t__stct.html#a368bb93a5038b98e6e59b62c34a3d5b4) -
Approximately the number of unrecoverable loss events delivered to the application.
If this number is greater than zero, the operator should be alerted.

## [Source Stats](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__t__stct.html)

* [type](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__t__stct.html#a9f9aef06b06d3432b1b7ba10583413ce) -
Transport type for this record.
* [source](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__t__stct.html#aac9bc9a4d1f84c3cdc7dd83521b3ff70) -
The "source string" for this transport session. This should be recorded.

A publishing application will send a separate source statistics sample for each
outgoing transport session it has created.
The structure of the sample depends on the transport type (TCP, LBT-RM, LBT-RU, etc).

[TCP source statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__tcp__t__stct.html):

* [num_clients](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__tcp__t__stct.html#afdbea18ebdc5f2370f617ed561e1caef) -
Number of receivers connected at the time the sample was taken.

[LBT-RM source statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtrm__t__stct.html):

* [msgs_sent](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtrm__t__stct.html#afdb40daed5c3da97e44b495649d063be) -
Get an idea of how many datagrams/sec the transport session is generating for user messages (aggregates all topics on the transport session).
* [naks_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtrm__t__stct.html#a363c5c9c4b5a44e1eced9ad7a2892473) -
Number of individual NAKs received (not NAK packets).
If this number grows by more than a few per hour, the operator should be alerted.

[LBT-RU source statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtru__t__stct.html):

* [msgs_sent](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtru__t__stct.html#a33977a0a14846929f481fa61b10a45fe) -
Get an idea of how many datagrams/sec the transport session is generating for user messages (aggregates all topics on the transport session).
* [naks_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtru__t__stct.html#a9833ac2f8d6a9e6708a6848b641a6a4c) -
Number of individual NAKs received (not NAK packets).
If this number grows by more than a few per hour, the operator should be alerted.
* [num_clients](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtru__t__stct.html#af77f17b77c54450902654a0482dcd8f9) -
Number of receivers connected at the time the sample was taken.

[LBT-IPC source statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtipc__t__stct.html):

* [msgs_sent](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtipc__t__stct.html#aa71c033adada3522adc4ee6fdcee7502) -
Get an idea of how many datagrams/sec the transport session is generating for user messages (aggregates all topics on the transport session).
* [num_clients](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtipc__t__stct.html#a4cab35a71697d41cd9884878ece220ae) -
Number of receivers connected at the time the sample was taken.

[LBT-SMX source statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtsmx__t__stct.html):

* [msgs_sent](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtsmx__t__stct.html#aa5a75358d3fa9f713bbf231dd8b9bc3d) -
Get an idea of how many datagrams/sec the transport session is generating for user messages (aggregates all topics on the transport session).
* [num_clients](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__lbtsmx__t__stct.html#a23f7ba1e7a44b9223ef29f8bdfe0c570) -
Number of receivers connected at the time the sample was taken.

## [Receiver Stats](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__t__stct.html)

* [type](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__t__stct.html#a3111b4af23afc72ffb71b3794b4a0835) -
Transport type for this record.
* [source](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__t__stct.html#ac333fa92e503d7d399c0a7e4fe0a07c3) -
The "source string" for this transport session. This should be recorded.

A subscribing application will send a separate receiver statistics sample for each
incoming transport session it has joined.
The structure of the sample depends on the transport type (TCP, LBT-RM, LBT-RU, etc).

[TCP receiver statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__src__transport__stats__tcp__t__stct.html):

* [lbm_msgs_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__tcp__t__stct.html#a811cb200997a8c9a82629a8e07d978b7) -
Get an idea of how many datagrams/sec the transport session is receiving for user messages (aggregates all topics on the transport session).
* [lbm_msgs_no_topic_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__tcp__t__stct.html#abc3f6d30390080f692d039313413f3cb) -
Messages the receiver discarded because it was for a topic that is not subscribed.
If this value is a significant percentage of lbm_msgs_rcved then the operator should be alerted.

[LBT-RM receiver statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html):

* [lbm_msgs_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#a9c6f317be17cafd8678ac556217657cd) -
Get an idea of how many datagrams/sec the transport session is receiving for user messages (aggregates all topics on the transport session).
* [lost](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#ac0a27c8589c7062ba030e5a4dfc041f3) -
Number of datagrams that should have been received but were lost.
If this number grows by more than a few per hour, the operator should be alerted.
* [unrecovered_txw](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#a677ea15bc8a2621f13a774a1a2514899) -
Number of datagrams that were lost and could not be recovered because the source's transmission window wasn't large enough.
If this number is greater than zero, the operator should be alerted.
* [unrecovered_tmo](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#aec81f344ce20a3485bbf2f5a65b5c61e) -
Number of datagrams that were lost and could not be recovered because it took too long.
If this number is greater than zero, the operator should be alerted.
* [lbm_msgs_no_topic_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#a62c19c1a782919ff9ef69cc72ff0a853) -
Messages the receiver discarded because it was for a topic that is not subscribed.
If this value is a significant percentage of lbm_msgs_rcved then the operator should be alerted.
* [dgrams_dropped_size](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#a1c209454ba9fe6b52f903021b14d1e9c),
[dgrams_dropped_type](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#acad07e2da34793dbaf3dac991f0d997a),
[dgrams_dropped_version](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#af2fe38df948b4166b599fb7e58bdf027),
[dgrams_dropped_hdr](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#a8df967fc7b7c8a0a864709c07a1772aa),
[dgrams_dropped_other](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtrm__t__stct.html#add62b45ed2e496c7856cdabfcbd56d1f) -
If any of these are non-zero, alert the operator.

[LBT-RU receiver statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html):

* [lbm_msgs_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a5c2054b4aa164bf7619b97f955f00d54) -
Get an idea of how many datagrams/sec the transport session is receiving for user messages (aggregates all topics on the transport session).
* [lost](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a9717bf76222b09c31cbc3d48d79860f3) -
Number of datagrams that should have been received but were lost.
If this number grows by more than a few per hour, the operator should be alerted.
* [unrecovered_txw](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#aa549f88cacfa672176746a6643c37a2f) -
Number of datagrams that were lost and could not be recovered because the source's transmission window wasn't large enough.
If this number is greater than zero, the operator should be alerted.
* [unrecovered_tmo](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a9c6f09ca548af94cc5e0c83257ec3a5f) -
Number of datagrams that were lost and could not be recovered because it took too long.
If this number is greater than zero, the operator should be alerted.
* [lbm_msgs_no_topic_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a83c799da110d0f2036111dd7de4fce56) -
Messages the receiver discarded because it was for a topic that is not subscribed.
If this value is a significant percentage of lbm_msgs_rcved then the operator should be alerted.
* [dgrams_dropped_size](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a2cb0c80324a1b038de32baae0367bedf),
[dgrams_dropped_type](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#ab14a9ed18d2f4c52f22d1e3a200ebc5b),
[dgrams_dropped_version](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a3bc35b655534753f990b1ac3d1bf434d),
[dgrams_dropped_hdr](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#afd3d754cff49f6f9317c1a5e82e7d5e9),
[dgrams_dropped_sid](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a3e01c4f5f70e0b7b94d8787308c0367c),
[dgrams_dropped_other](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtru__t__stct.html#a19058480206858399c4820c799ebd35d) -
If any of these are non-zero, alert the operator.

[LBT-IPC receiver statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtipc__t__stct.html):

* [lbm_msgs_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtipc__t__stct.html#a57eb8d53386d3ba41f9edaccfd2ffa76) -
Get an idea of how many datagrams/sec the transport session is receiving for user messages (aggregates all topics on the transport session).
* [lbm_msgs_no_topic_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtipc__t__stct.html#a553ed8203a547d1749bfe69a75264e38) -
Messages the receiver discarded because it was for a topic that is not subscribed.
If this value is a significant percentage of lbm_msgs_rcved then the operator should be alerted.

[LBT-SMX receiver statistics](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtsmx__t__stct.html):

* [lbm_msgs_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtsmx__t__stct.html#acbe5de43d70aa5aefd3fdff79d473202) -
Get an idea of how many datagrams/sec the transport session is receiving for user messages (aggregates all topics on the transport session).
* [lbm_msgs_no_topic_rcved](https://ultramessaging.github.io/currdoc/doc/API/structlbm__rcv__transport__stats__lbtsmx__t__stct.html#af2d4d5893e40b28bdfaa0c2e32ecd532) -
Messages the receiver discarded because it was for a topic that is not subscribed.
If this value is a significant percentage of lbm_msgs_rcved then the operator should be alerted.

