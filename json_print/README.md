# mcs_demo/json_print
A modification to the base "mcs_demo" repo that
uses the "JsonPrint.jar" module from
https://github.com/UltraMessaging/mcs_json_print

# Table of contents

<!-- mdtoc-start -->
&bull; [mcs_demo/json_print](#mcs_demojson_print)  
&bull; [Table of contents](#table-of-contents)  
&bull; [COPYRIGHT AND LICENSE](#copyright-and-license)  
&bull; [REPOSITORY](#repository)  
&bull; [INTRODUCTION](#introduction)  
&bull; [DEMO](#demo)  
<!-- TOC created by '../mdtoc/mdtoc.pl ./json_print/README.md' (see https://github.com/fordsfords/mdtoc) -->
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

The https://github.com/UltraMessaging/mcs_json_print repository
contains an MCS plugin module, "JsonPrint.jsr", that replaces the sqlite database
in the MCS.

This directory demonstrate's its use.

The demo is largely the same as the main "mcs_demo",
with the following differences:
* The "lbmmon.java" program is not demonstrated.
* The "sqlite" database is not used. In its place is the "JsonPrint.jar" module.
* Due to limitations in the "MCS" command script provided with UM version 6.15,
it cannot be used to start the MCS process when a user-written plugin is used.
Instead, the proper Java command is inserted directly in "tst.sh" to run it.
* The "mcs.xml" file is modified to use the "JsonPrint.jar" module instead of sqlite.
* The "mcs.properties" file is modified to set the output file used by the "JsonPrint.jar" module.

# DEMO

1. Clone or download the repository at https://github.com/UltraMessaging/mcs_demo
2. cd to json_print
3. Copy the file "lbm.sh.example" to "lbm.sh" and modify per your environment.
I.e. insert your license key and set your file paths.
4. Edit all xml files and update IP addresses (search for "10.29").
In particular, set the multicast groups per your network in "um.xml" (search for "239.101").
5. Enter:
````
./tst.sh
````

This should take about one and a half minutes to run,
and should print a series of progress messages,
including PIDs of asyncronous processes.

The "tst.json" file will contain the raw JSON records;
difficult for humans to read, but easy for software tools to process.
Note that the timestamps are in the form of [Unix time](https://en.wikipedia.org/wiki/Unix_time),
the number of seconds since 00:00:00 UTC on 1 January 1970, excluding leap seconds.

See the [main Readme](../Readme.md) for general information on the demo.
