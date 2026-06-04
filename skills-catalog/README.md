# Skills Catalog

The skills catalog organizes agent skills into groups. Each group is a directory containing one or more skills (each with a `SKILL.md` and `manifest.yaml`).

## Skills

<!-- BEGIN SKILLS -->
### MATLAB Core (`matlab-core`)

Create, debug, test, review, and manage MATLAB code and installations

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-create-live-script` | Create plain-text MATLAB Live Scripts with rich text, LaTeX equations, and inline figures. |
| `matlab-debugging` | Diagnose MATLAB errors and unexpected behavior. |
| `matlab-install-products` | Install MathWorks products from the command line using MATLAB Package Manager (mpm). |
| `matlab-list-products` | Show all installed MATLAB products and support packages for a given MATLAB installation folder. |
| `matlab-review-code` | Review MATLAB code for quality, performance, maintainability, and adherence to MathWorks coding standards. |
| `matlab-testing` | Generate and run MATLAB unit tests using the matlab.unittest framework. |

### MATLAB App Building (`matlab-app-building`)

Build MATLAB apps programmatically using UI components, layouts, callbacks, and web integration

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-build-app` | Build MATLAB apps programmatically using uifigure, uigridlayout, UI components, callbacks, and uihtml for web integration. |

### MATLAB Data Import and Analysis (`matlab-data-import-and-analysis`)

Analyze tabular data in MATLAB using tables, timetables, filtering, aggregation, and time-series operations

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-data` | Analyze tabular data in MATLAB using tables, timetables, filtering, aggregation, and time-series operations. |

### MATLAB Programming (`matlab-programming`)

Write robust MATLAB functions with validated inputs

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-validate-function-arguments` | Validate MATLAB function inputs using arguments block. |

### MATLAB Software Development (`matlab-software-development`)

Modernize legacy code, optimize performance and memory, document and create toolboxes, create projects, and develop build plans

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-dependencies` | Analyze toolbox dependencies. |
| `matlab-assess-toolbox` | Assess toolbox readiness for packaging. Validates help text, tests, coverage, code issues, dependencies, and function signatures. |
| `matlab-build-toolbox` | Build a MATLAB toolbox package with build tool. |
| `matlab-create-buildfile` | Generate a buildfile.m for preparing and packaging a toolbox. |
| `matlab-create-project` | Create a MATLAB project from an existing folder of code. |
| `matlab-define-toolbox-api` | Define toolbox scope and public API from a folder of code. |
| `matlab-document-toolbox` | Generate toolbox documentation including README, examples, and functionSignatures.json. |
| `matlab-exclude-files` | Generate a toolbox.ignore file to exclude files from packaging. |
| `matlab-modernize-code` | Modernize deprecated MATLAB functions and patterns. |
| `matlab-optimize-memory` | Find and fix memory bottlenecks in MATLAB code using a structured measure-profile-optimize-verify workflow. |
| `matlab-optimize-performance` | Optimize performance of MATLAB code. |
| `matlab-publish-toolbox` | Version-stamp and publish a MATLAB toolbox package. |
| `matlab-write-performance-tests` | Write MATLAB performance tests using the matlab.perftest.TestCase framework. |

### AI and Statistics (`ai-and-statistics`)

Deep Learning Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-train-network` | Train, evaluate, and deploy neural networks using the recommended APIs. Migrate legacy neural network training code to modern replacements. |

### Automotive (`automotive`)

Automated Driving Toolbox, RoadRunner, and RoadRunner Scene Builder

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-driving-data-importer` | Import recorded driving sensor data (GPS, camera, lidar, actor tracks) into scenariobuilder.* objects and synchronize, crop, offset, and normalize timestamps before scenario building. |
| `matlab-scenario-builder` | Build driving scenes, scenarios, road surfaces, and 3D assets from recorded sensor data and export to RoadRunner, drivingScenario, OpenSCENARIO, OpenDRIVE, OpenCRG, or Unreal Engine. |
| `roadrunner-asset-mapping` | Generate RoadRunner asset path lookup tables for map format conversions in MATLAB. |
| `roadrunner-convert-lanelet2-to-rrhd` | Convert Lanelet2 maps (.osm) to RoadRunner HD Map (.rrhd) format using MATLAB. |
| `roadrunner-import-scene` | Connect to RoadRunner and import HD Map or OpenDRIVE files into a new scene using MATLAB. |
| `roadrunner-rrhd-authoring` | Build RoadRunner HD Map entities in MATLAB — lanes, boundaries, markings, junctions, signs, signals, barriers, parking. |

### Computational Biology (`computational-biology`)

SimBiology

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-build-simbiology-model` | Build SimBiology models from scratch, modify existing ones, and generate diagram layouts. |
| `matlab-fit-simbiology-model` | Fit SimBiology model parameters to data. |
| `matlab-simulate-simbiology-model` | Run simulations, sweep parameters, explore what-if scenarios, and perform sensitivity analysis on SimBiology models. |

### Image Processing and Computer Vision (`image-processing-and-computer-vision`)

Image Processing Toolbox and Computer Vision Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-display-image` | Display images and annotations for image processing, computer vision, and visual inspection. |
| `matlab-display-volume` | Display 3-D image volumes, medical image volumes, surface meshes, and annotations for 3-D image processing. |
| `matlab-ocr` | Build OCR pipelines in MATLAB using the ocr() function. |
| `matlab-process-large-images` | Process large images using blockedImage. |

### Parallel Computing (`parallel-computing`)

Parallel Computing Toolbox and MATLAB Parallel Server

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-discover-clusters` | Discover parallel computing clusters and manage cluster profiles. |
| `matlab-setup-gpu` | Detect and validate GPU availability for MATLAB GPU computing. |
| `matlab-setup-worker-state` | Set up worker environment and per-worker state for parallel pools. |
| `matlab-use-thread-pool` | Speed up local parallel computing by using thread-based parallel pool. |

### Radar (`radar`)

Phased Array System Toolbox, Sensor Fusion and Tracking Toolbox, and Mapping Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-design-radar-waveform` | Design and analyze radar and sonar waveforms using Phased Array System Toolbox. |
| `matlab-import-tracking-data` | Import ground truth trajectory data for use with Sensor Fusion and Tracking Toolbox. |

### Reporting and Database Access (`reporting-and-database-access`)

Database Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-connect-databricks-jdbc` | Connect MATLAB to Databricks using JDBC drivers via Database Toolbox. |
| `matlab-map-database-objects` | Generate MATLAB Object Relational Mapping (ORM) code using Database Toolbox. |
| `matlab-read-database` | Read data from relational databases using MATLAB Database Toolbox. |
| `matlab-use-duckdb` | Use DuckDB for in-memory analytics and direct SQL queries on CSV, Parquet, and JSON files from MATLAB. |
| `matlab-write-database` | Write data to relational databases and perform database operations from MATLAB. |

### RF and Mixed Signal (`rf-and-mixed-signal`)

Antenna Toolbox, RF Toolbox, RF PCB Toolbox, and SerDes Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-em` | Compute S-parameters, insertion loss, fields, and currents for RF PCB performance validation. |
| `matlab-analyze-installed-antenna` | Analyze antennas installed on electrically large conducting platforms such as vehicles and aircraft. |
| `matlab-analyze-pcb-pdn` | Analyze PDN DC voltage and current distribution, IR drop, and design rule checking on PCB layouts. |
| `matlab-analyze-rcs` | Compute and visualize monostatic and bistatic radar cross section of antennas and platforms. |
| `matlab-analyze-rf-amplifier` | Analyze RF amplifier stability, power gain, and matching using RF Toolbox. |
| `matlab-analyze-rf-budget` | Perform RF system cascade budget analysis using rfbudget in RF Toolbox. |
| `matlab-analyze-rf-mixer` | Analyze mixer spurious products and intermodulation using the mixerIMT object in RF Toolbox. |
| `matlab-analyze-rf-propagation` | Analyze RF propagation and plan wireless sites using coverage maps, ray tracing, and path loss models. |
| `matlab-assemble-pcb-layout` | Build custom PCB structures with pcbComponent, shapes, Boolean operations, feeds, and multi-layer stackups. |
| `matlab-compose-rf-circuit` | Compose general-purpose RF circuits from R/L/C elements, amplifiers, modulators, mixers, nport S-parameter blocks, and other RF elements using RF Toolbox. |
| `matlab-convert-network-parameters` | Convert between network parameter types (S, Z, Y, ABCD, T, H, G) and compute mixed-mode (differential/common) S-parameters using RF Toolbox. |
| `matlab-create-ai-antenna` | Explore antenna design space and reconstruct 3D radiation patterns using AI surrogate models. |
| `matlab-create-custom-antenna` | Build custom antennas from geometric primitives using Antenna Toolbox customAntenna. |
| `matlab-create-measured-antenna` | Create measuredAntenna objects from simulated or measured data for site planning and satellite links. |
| `matlab-create-rfbudget-elements` | Create and configure all rfbudget-compatible element objects -- active (amplifier, modulator, rfelement, nport, rffilter, rfantenna, attenuator, phaseshift) and passive (seriesRLC, shuntRLC, lcladder, txline*) -- for use in rfbudget cascade analysis and circuit composition. |
| `matlab-deembed-rf-cascade` | Cascade and de-embed S-parameter networks using RF Toolbox. |
| `matlab-design-antenna` | Design and analyze antennas at a target frequency using MATLAB Antenna Toolbox. |
| `matlab-design-antenna-matching-network` | Design impedance matching networks for antennas using RF Toolbox matchingnetwork. |
| `matlab-design-array` | Design and analyze finite and infinite antenna arrays with beam steering, tapering, and scan impedance. |
| `matlab-design-matching-network` | Design impedance matching networks using the matchingnetwork object and Matching Network Designer app in RF Toolbox. |
| `matlab-design-pcb-antenna` | Design multi-layer PCB antennas with custom metal patterns, feeds, and Gerber export using pcbStack. |
| `matlab-design-pcb-coupler` | Design Wilkinson, branchline, ratrace, and directional couplers, corporate dividers, and Rotman lenses. |
| `matlab-design-pcb-filter` | Design bandpass, lowpass, and bandstop RF filters using hairpin, coupled-line, combline, stub, and SIW topologies. |
| `matlab-design-pcb-passive` | Design spiral inductors, interdigital capacitors, baluns, resonators, and phase shifters for RF circuits. |
| `matlab-design-pcb-txline` | Design microstrip, stripline, CPW, and differential pair transmission lines with impedance control and crosstalk analysis. |
| `matlab-design-reflectarray` | Design reflectarray antennas and reconfigurable intelligent surfaces with phase-controlled unit cells. |
| `matlab-design-reflector-antenna` | Design and analyze parabolic, Cassegrain, Gregorian, and corner reflector antennas. |
| `matlab-estimate-sar` | Estimate Specific Absorption Rate from antennas near or inside biological tissue. |
| `matlab-export-session-script` | Export conversation MATLAB code to a clean, runnable .m script. |
| `matlab-fit-rational-model` | Fit S-parameters to rational function models and compute time-domain responses using RF Toolbox. |
| `matlab-integrate-pcb-circuit` | Cascade PCB components, add lumped elements, and export Touchstone files for multi-component RF circuits. |
| `matlab-manage-pcb-material` | Define dielectric substrates, metal conductors, multi-layer stackups, and loss models for RF PCB simulation. |
| `matlab-manage-sparameters` | Load, inspect, visualize, and export S-parameters using RF Toolbox. |
| `matlab-model-serdes-systems` | Model, simulate, and optimize Serializer/Deserializer (SerDes) systems — serial and parallel links — using MATLAB SerDes Toolbox. |
| `matlab-model-si-channel` | Model signal integrity channels from measured S-parameter blocks, lossy transmission lines, and lumped parasitics using RF Toolbox circuit composition. |
| `matlab-model-via` | Model vias with pads, antipads, and ground return vias for high-speed PCB layer transitions. |
| `matlab-optimize-antenna` | Optimize antenna and array designs using SADEA and TR-SADEA surrogate-assisted algorithms. |
| `matlab-optimize-pcb-design` | Optimize RF PCB component dimensions for bandwidth, return loss, or area using patternsearch and surrogateopt. |
| `matlab-process-rf-baseband` | Process complex baseband RF signals using rf.Amplifier, rf.Mixer, rf.Filter, and rf.Sparameter System Objects. |
| `matlab-read-pcb-layout` | Import Gerber, ODB++, and Allegro .brd files and inspect nets, layers, shapes, and stackups. |
| `matlab-simulate-rf-system` | Perform high-accuracy time-domain RF system simulation using the rfsystem System Object in RF Toolbox. |
| `matlab-write-pcb-layout` | Export pcbComponent designs to Gerber files for PCB manufacturing. |

### Robotics and Autonomous Systems (`robotics-and-autonomous-systems`)

Navigation Toolbox and UAV Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-compute-gnss-position` | Computes multi-constellation Global Positioning System (GPS) or Global Navigation Satellite System (GNSS) positions from RINEX v3 data using rinexread, gnssmeasurements, receiverposition, and gnssoptions. |
| `matlab-connect-mavlink` | Establish MAVLink connections between MATLAB and PX4 or ArduPilot flight controllers. |
| `matlab-create-uav-scenario` | Create and simulate UAV scenarios with terrain, buildings, sensor-equipped platforms, and 3D visualization. |
| `matlab-fuse-inertial-sensors` | Analyzes sensor configurations and creates inertial fusion filters in MATLAB Navigation Toolbox. |

### Signal Processing (`signal-processing`)

Signal Processing Toolbox, DSP System Toolbox, Wavelet Toolbox, and DSP HDL Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-analyze-signal-cwt` | Analyze signals using the Continuous Wavelet Transform. |
| `matlab-configure-scope-object` | Configure properties of scope-related Simulink blocks or MATLAB objects |
| `matlab-design-adaptive-filter` | Design and implement adaptive filters using System objects. |
| `matlab-design-digital-filter` | Design and validate digital filters in MATLAB. |
| `matlab-dsphdl-ddc-design` | Design HDL-optimized Digital Down Converters using dsphdl System objects. |
| `matlab-prepare-signal-data` | Build signalDatastore pipelines for ML training -- labels, stratified splits, framing, parallel reads, and trainnet hand-off. |

### Test and Measurement (`test-and-measurement`)

Data Acquisition Toolbox and Industrial Communication Toolbox

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-call-nidaqmx` | Translate NI-DAQmx C functions into correct calldaqlib MATLAB calls. |
| `matlab-connect-opcua-client` | Create OPC UA client connections and inspect security certificates. |
| `matlab-discover-opcua-servers` | Discover OPC UA servers using opcuaserverinfo and the OPC UA Local Discovery Service (LDS). |

### Wireless Communications (`wireless-communications`)

Communications Toolbox, 5G Toolbox, WLAN Toolbox, Bluetooth Toolbox, Satellite Communications Toolbox, Wireless Network Toolbox, and Wireless Testbench

| Skill | What it teaches your agent |
|-------|---------------------------|
| `matlab-add-awgn` | Add Additive White Gaussian Noise (AWGN) noise and convert between SNR, Eb/No, Es/No, and per-subcarrier SNR for communications simulations. |
| `matlab-generate-5g-waveform` | Generate 3GPP-compliant 5G NR downlink and uplink baseband waveforms. |
| `matlab-generate-ble-waveform` | Generate and analyze Bluetooth Low Energy PHY waveforms. |
| `matlab-generate-gnss-waveform` | Generate GNSS baseband waveforms (GPS, Galileo, NavIC) with physically realistic or user-specified channel impairments using the Satellite Communications Toolbox. |
| `matlab-generate-wlan-waveform` | Generate standard-compliant IEEE 802.11 WLAN waveforms. |
| `matlab-set-up-usrp-radio` | Set up and verify NI USRP radios for use with Wireless Testbench. |
| `matlab-simulate-bluetooth-network` | Simulate Bluetooth system-level networks including BLE, Classic BR/EDR, and LE Audio. |
| `matlab-simulate-wireless-network` | Set up and run wireless network simulations using wirelessNetworkSimulator. |

## Legacy

The following skill groups are not recommended for most users.

| Skill Group | Description | Recommended Alternative |
|-------------|-------------|-------------------------|
| **Toolkit** (`toolkit`) | Skill-based installer for the MATLAB Agentic Toolkit | [MATLAB-based installer](../README.md#install-the-matlab-agentic-toolkit) |

<!-- END SKILLS -->

## How Skills Are Installed

For details on how these skills are installed, see
[Install the MATLAB Agentic Toolkit](../README.md#install-the-matlab-agentic-toolkit)

----

Copyright 2026 The MathWorks, Inc.

----
