# mcs_demo
A set of Ultra Messaging configuration files and a test script
to demonstrate setting up UM automatic monitoring.

# Table of contents

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

## Demo Architecture

## Demo Files

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
