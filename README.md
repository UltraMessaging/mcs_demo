# mcs_demo
A set of Ultra Messaging configuration files and a test script
to demonstrate setting up UM automatic monitoring.

# Table of contents

# Table of contents

- [mcs_demo](#mcs_demo)
- [Table of contents](#table-of-contents)
- [COPYRIGHT AND LICENSE](#copyright-and-license)
- [REPOSITORY](#repository)
- [INTRODUCTION](#introduction)
  - [Prerequisits](#prerequisits)
  - [Configuration Goals](#configuration-goals)
- [Demo Architecture](#demo-architecture)
- [Demo Files](#demo-files)
- [Run the Demo](#run-the-demo)
  - [Sqlite Database](#sqlite-database)

<sup>(table of contents from https://luciopaiva.com/markdown-toc/)</sup>

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

## Prerequisits

You must have the following installed on a Linux 64-bit system:
* UMP or UMQ version 6.15 or beyond.
* Java JDK 9 or beyond.
* sqlite (recent version).

(Running this demo on Windows is straight-forward,
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
* mon.cfg - UM library configuration file for the monitoring data TRD.
This flat-format file contains UM configuation for the main messaging
components to send their monitoring data to the MCS and the Java lbmmon
example app.
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

Note: the mon.cfg must be a separate configuation file in the
flat file format.
This is because the components do not uniformely identify their
monitoring contexts such that the "um.xml" can configure them,
so the monitor_transport_opts "config" option must be used,
which expects a "flat" file format.

# Run the Demo

1. Ensure your test system has the [prereqisits](#prerequisits).
1. Clone or download the repository at https://github.com/UltraMessaging/mcs_demo
1. Copy the file "lbm.sh.example" to "lbm.sh" and modify per your environment.
I.e. insert your license key and set your file paths.
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
