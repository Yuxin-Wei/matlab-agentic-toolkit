# Skills Catalog

The skills catalog organizes agent skills into groups. Each group is a directory containing one or more skills (each with a `SKILL.md` and `manifest.yaml`).

## Skills

<!-- BEGIN SKILLS -->
### Automotive (`automotive`)

Automotive skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `roadrunner-asset-mapping` | RoadRunner asset path lookup tables for map format conversions in MATLAB. |
| `roadrunner-convert-lanelet2-to-rrhd` | Convert Lanelet2 maps (.osm) to RoadRunner HD Map (.rrhd) format using MATLAB. |
| `roadrunner-import-scene` | Connect to RoadRunner and import HD Map or OpenDRIVE files into a new scene using MATLAB. |
| `roadrunner-rrhd-authoring` | Build RoadRunner HD Map entities in MATLAB — lanes, boundaries, markings, junctions, signs, signals, barriers, parking. |

### Computational Biology (`computational-biology`)

Computational biology skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-build-simbiology-model` | Build, modify, and diagram SimBiology models — API reference, helper functions, and layout patterns. |
| `matlab-simulate-simbiology-model` | Simulate SimBiology models — ODE, stochastic (SSA), scenarios, and sensitivity analysis. |

### Image Processing and Computer Vision (`image-processing-and-computer-vision`)

Image processing and computer vision skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-display-image` | Display images and annotations for image processing, computer vision, and visual inspection. |
| `matlab-display-volume` | Display 3-D image volumes, medical image volumes, surface meshes, and annotations for 3-D image processing. |
| `matlab-ocr` | Build OCR pipelines in MATLAB using the ocr() function. |

### MATLAB App Building (`matlab-app-building`)

MATLAB app building skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-build-app` | Build MATLAB apps programmatically using uifigure, uigridlayout, UI components, callbacks, and uihtml for web integration. |

### MATLAB Core (`matlab-core`)

Foundational MATLAB skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-create-live-script` | Create plain-text MATLAB Live Scripts (.m files) with rich text formatting, LaTeX equations, section breaks, and inline figures. |
| `matlab-debugging` | Diagnose MATLAB errors and unexpected behavior. |
| `matlab-install-products` | Deterministic workflow to download MATLAB Package Manager (mpm) and install MathWorks products from the OS command line with consistent, repeatable behavior. |
| `matlab-list-products` | Show all installed MATLAB products and support packages for a given MATLAB installation folder. |
| `matlab-review-code` | Review MATLAB code for quality, performance, maintainability, and adherence to MathWorks coding standards. |
| `matlab-testing` | Generate and run MATLAB unit tests using matlab.unittest and matlab.uitest. |

### MATLAB Data Import and Analysis (`matlab-data-import-and-analysis`)

Core MATLAB data import and analysis skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-data` | Analyze tabular data using MATLAB. |

### MATLAB Software Development (`matlab-software-development`)

MATLAB software development skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-modernize-code` | Modernize deprecated MATLAB functions and patterns. |
| `matlab-optimize-performance` | Optimize performance of MATLAB code. |
| `matlab-write-performance-tests` | Write MATLAB performance tests using the matlab.perftest.TestCase framework. |

### Reporting and Database Access (`reporting-and-database-access`)

Reporting and database access skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-connect-databricks-jdbc` | Connects MATLAB to Databricks using JDBC drivers via Database Toolbox. |
| `matlab-map-database-objects` | Generates MATLAB Object Relational Mapping (ORM) code using Database Toolbox. |
| `matlab-read-database` | Reads data from relational databases using MATLAB Database Toolbox pushdown capabilities. |
| `matlab-use-duckdb` | Generates MATLAB code for DuckDB database operations using Database Toolbox. |
| `matlab-write-database` | Writes data from MATLAB to relational databases and performs database operations. |

### RF and Mixed Signal (`rf-and-mixed-signal`)

RF and mixed-signal skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-em` | S-parameters, insertion loss, fields, currents, mesh control, and solver selection for RF PCB performance validation. |
| `matlab-analyze-pcb-pdn` | PDN DC voltage/current analysis, IR drop, design rule checking, and multi-net batch analysis on imported PCB layouts. |
| `matlab-analyze-rf-amplifier` | Analyze RF amplifier stability, power gain, and matching using RF Toolbox. |
| `matlab-analyze-rf-budget` | Perform RF system cascade budget analysis using rfbudget in RF Toolbox. |
| `matlab-analyze-rf-mixer` | Analyze mixer spurious products and intermodulation using the mixerIMT object in RF Toolbox. |
| `matlab-assemble-pcb-layout` | Build custom PCB structures with pcbComponent, shapes, Boolean ops, feeds, and multi-layer stackups for non-catalog geometries. |
| `matlab-compose-rf-circuit` | Compose general-purpose RF circuits from R/L/C elements, amplifiers, modulators, mixers, nport S-parameter blocks, and other RF elements using RF Toolbox. |
| `matlab-convert-network-parameters` | Convert between network parameter types (S, Z, Y, ABCD, T, H, G) and compute mixed-mode (differential/common) S-parameters using RF Toolbox. |
| `matlab-create-rfbudget-elements` | Create and configure all rfbudget-compatible element objects -- active (amplifier, modulator, rfelement, nport, rffilter, rfantenna, attenuator, phaseshift) and passive (seriesRLC, shuntRLC, lcladder, txline*) -- for use in rfbudget cascade analysis and circuit composition. |
| `matlab-deembed-rf-cascade` | Cascade and de-embed S-parameter networks using RF Toolbox. |
| `matlab-design-matching-network` | Design impedance matching networks using the matchingnetwork object and Matching Network Designer app in RF Toolbox. |
| `matlab-design-pcb-coupler` | Wilkinson, branchline, ratrace, directional couplers, corporate dividers, Rotman lenses for power splitting and beam-forming. |
| `matlab-design-pcb-filter` | Bandpass, lowpass, bandstop filter design — hairpin, coupled-line, combline, stub, SIW for frequency selection and harmonic rejection. |
| `matlab-design-pcb-passive` | Spiral inductors, interdigital capacitors, baluns, resonators, phase shifters for impedance matching, DC blocking, and bias tees. |
| `matlab-design-pcb-txline` | Microstrip, stripline, CPW, differential pairs, and crosstalk analysis for impedance-controlled PCB interconnects. |
| `matlab-export-session-script` | Export conversation MATLAB code to a clean, runnable .m script. |
| `matlab-fit-rational-model` | Fit S-parameters to rational function models and compute time-domain responses using RF Toolbox. |
| `matlab-integrate-pcb-circuit` | Cascade PCB components, add lumped elements, export Touchstone, and bridge to eye diagram or antenna array workflows. |
| `matlab-manage-pcb-material` | Dielectric substrates, metal conductors, multi-layer stackups, and loss models (FR4, Rogers, Teflon) for RF PCB simulation. |
| `matlab-manage-sparameters` | Load, inspect, visualize, and export S-parameters using RF Toolbox. |
| `matlab-model-serdes-systems` | Model, simulate, and optimize Serializer/Deserializer (SerDes) systems — serial and parallel links — using MATLAB SerDes Toolbox. |
| `matlab-model-si-channel` | Model signal integrity channels from measured S-parameter blocks, lossy transmission lines, and lumped parasitics using RF Toolbox circuit composition. |
| `matlab-model-via` | Via modeling: pads, antipads, ground return vias, GRV placement, and signal integrity for high-speed layer transitions. |
| `matlab-optimize-pcb-design` | Optimize RF PCB dimensions for bandwidth, return loss, or area via patternsearch and surrogateopt with constraints. |
| `matlab-process-rf-baseband` | Process complex baseband RF signals using standalone System Objects in RF Toolbox: rf.Amplifier, rf.Mixer, rf.Filter, rf.Sparameter, and rf.PAmemory. |
| `matlab-read-pcb-layout` | Import Gerber, ODB++, Allegro .brd, .mcm files for PCB boards and IC packages. |
| `matlab-simulate-rf-system` | Perform high-accuracy time-domain RF system simulation using the rfsystem System Object in RF Toolbox. |
| `matlab-write-pcb-layout` | Export pcbComponent designs to Gerber files with RF connectors and fab service formatting for PCB manufacturing. |

### Robotics and Autonomous Systems (`robotics-and-autonomous-systems`)

Robotics and autonomous systems skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-compute-gnss-position` | Computes multi-constellation Global Positioning System (GPS) or Global Navigation Satellite System (GNSS) positions from RINEX v3 data using rinexread, gnssmeasurements, receiverposition, and gnssoptions. |
| `matlab-fuse-inertial-sensors` | Analyzes sensor configurations and creates inertial fusion filters in MATLAB Navigation Toolbox. |

### Signal Processing (`signal-processing`)

Signal processing skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-design-digital-filter` | Design and validate digital filters in MATLAB. |

### Test and Measurement (`test-and-measurement`)

Test and measurement skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-discover-opcua-servers` | Discover OPC UA servers using opcuaserverinfo and the OPC UA Local Discovery Service (LDS). |

### Toolkit (`toolkit`)

Setup and management for the MATLAB Agentic Toolkit.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-agentic-toolkit-setup` | Install and configure the MATLAB Agentic Toolkit — detect MATLAB, install the MCP server, register with your AI coding agent, and verify the environment. |

### Wireless Communications (`wireless-communications`)

Wireless communications skills for AI coding agents.

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-add-awgn` | Add Additive White Gaussian Noise (AWGN) noise and convert between SNR, Eb/No, Es/No, and per-subcarrier SNR for communications simulations. |
| `matlab-generate-5g-waveform` | Generate 3GPP-compliant 5G NR downlink and uplink baseband waveforms. |
| `matlab-generate-gnss-waveform` | Generate GNSS baseband waveforms (GPS, Galileo, NavIC) with physically realistic or user-specified channel impairments using the Satellite Communications Toolbox. |

<!-- END SKILLS -->

## How Skills Are Installed

Skills are not auto-discovered from this catalog. Each agent platform has a manifest file (in the repo root) that explicitly scopes which skill groups are included. See the [README](../README.md) for per-agent installation instructions.

----

Copyright 2026 The MathWorks, Inc.

----
