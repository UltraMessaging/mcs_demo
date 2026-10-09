# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

An Ultra Messaging (UM) demo of automatic monitoring with the Monitoring
Collector Service (MCS). `tst.sh` starts an `lbmrd`, the MCS, SRS, a DRO
(`tnwgd`), a persistent Store (`umestored`), a publisher (`umesrc`) and a
subscriber (`umercv`). Every component publishes monitoring data to a
separate monitoring TRD (unicast `lbmrd` resolution, TCP transport), and the
MCS collects it.

These are examples, not production code. They don't follow normal Java/C
conventions (no Gradle/Make, no dependency management, hard-coded jar paths in
shell scripts). Customers are expected to adapt everything to their own
processes, so keep changes in the same simple style.

Load the `um-ref` skill for anything involving UM configuration, the MCS, or
monitoring.

## Two demos

- **Top level** — stock MCS with the `sqlite` connector, launched with the
  `MCS` script from the UM package. Also builds and runs `lbmmon.java`, an
  enhanced copy of the UM example (its SRS support was folded into the
  official UM example as of 6.16). After the run, `tst.sh` dumps the sqlite DB
  to `mcs.out`; `peek.sh` pretty-prints selected records from it.
- **`json_print/`** — same topology, but the MCS uses the user-written
  `JsonPrint` connector from the sibling repo
  https://github.com/UltraMessaging/mcs_json_print (`class:JsonPrint` in
  `json_print/mcs.xml`; output path set in `json_print/mcs.properties`). No
  `lbmmon.java`, no sqlite. `tst.sh` fetches `JsonPrint.java` from GitHub
  (`main`) if it isn't already present, then always compiles `JsonPrint.jar`
  with the `javac` on the PATH, so the jar's class version matches the Java
  that runs the MCS. The `javac` classpath in `tst.sh` hard-codes the same
  versioned MCS jar names as the `java` classpath. The `curl` must run before
  `tst.sh` sources `lbm.sh`: UM's `lib/` ships its own OpenSSL, and with it on
  `LD_LIBRARY_PATH` the system `curl` fails with a symbol lookup error.

The two directories each carry their own full copy of the config files
(`um.xml`, `dro.xml`, `srs.xml`, `store.xml`, `lbmrd.xml`), `umercv.c`, and the
helper headers. A fix to a shared file usually has to be made in both places.

## UM version coupling

- `json_print/` requires the MCS from **UM 6.17 or later**. 6.17 replaced
  Log4j with SLF4J/Logback, and the current `JsonPrint` takes an
  `org.slf4j.Logger` via `setLogger()`, which the MCS calls by reflection.
- The stock `MCS` script hard-codes its classpath, so it can't load a plugin.
  `json_print/tst.sh` therefore runs `java` directly, with a classpath copied
  from `$L/MCS/bin/MCS` plus `./JsonPrint.jar`. When moving to a new UM
  version, re-copy that classpath from the new `MCS` script. Jar names
  embed versions (`UMS_<ver>.jar`, `protobuf-java-<ver>.jar`, etc.).
- The top-level `tst.sh` also hard-codes versioned jar names for building and
  running `lbmmon.java` (from `$L/java` and `$L/MCS/lib`).
- The UM install path is set by `L=` in `lbm.sh`, which each demo directory
  sources. `lbm.sh` is gitignored. Users create it from `lbm.sh.example` and
  add their license key.

## Monitoring context configuration

The automatic-monitoring context (`29west_statistics_context`) inherits the
application's templates before its own `mon_ctx` template is applied. So
`mon_ctx` must be self-contained: it clears any inherited SRS and `lbmrd`
lists with `0.0.0.0:0` entries and re-enables UDP topic resolution before
adding the `lbmrd`. Without this, `umesrc`'s monitoring context resolves via
SRS and never reaches the MCS. `srs.xml` duplicates these settings and must be
kept in sync.

## Running

```sh
cp lbm.sh.example lbm.sh      # edit L= and LBM_LICENSE_INFO
./tst.sh                      # top-level demo, ~1.5 minutes
./peek.sh                     # optional, after tst.sh

cd json_print
cp lbm.sh.example lbm.sh      # edit as above
./tst.sh                      # output JSON goes to tst.json
```

Before a real run, the XML configs need host-specific IP addresses (search for
`10.29`) and multicast groups in `um.xml` (search for `239.101`). The demo
needs a UM license, plus `gcc` to build `umercv`. The top-level demo also needs
`sqlite3`; `json_print/` needs a JDK and `curl`.

There are no automated tests. `output/` holds sample logs from a lab run and
is checked in as reference output.

`bld.sh` only regenerates the markdown tables of contents (via `mdtoc.pl`, if
present). It doesn't build code.

## Git permissions

Claude Code maintains this repository and has permission to `git add`,
`git commit`, and `git push` when appropriate (e.g. after landing a change
the maintainer has approved). Don't amend or force-push published history,
and don't skip hooks.
