

# Traffic Light Controller using Verilog (FSM Based)

## Overview

This project implements a **Traffic Light Controller using Verilog HDL** based on a **Finite State Machine (FSM)**.

The controller manages traffic signals at an intersection between:

* **Highway Road (HW)**
* **Farm Road (FM)**

The highway is the **default priority road**, and the farm road signal changes only when a **vehicle is detected by a sensor**.

The design ensures proper **traffic sequencing, timing control, and safe transitions** between signals using hardware timers implemented in Verilog.

---

# Design Objective

The objective of this project is to design a **digital traffic signal controller** that:

* Gives **default priority to highway traffic**
* Detects vehicles on the **farm road using a sensor**
* Changes signal states in a **safe and timed sequence**
* Uses **Finite State Machine (FSM)** logic
* Implements **timers for signal delays**

---

# System Architecture

The system consists of the following components:

* Finite State Machine (FSM)
* Vehicle Sensor
* Timing Counters
* Traffic Signal Output Logic

Inputs control the **state transitions**, and counters generate **timing delays for yellow and green signals**.

---

# Inputs and Outputs

## Inputs

| Signal   | Description                  |
| -------- | ---------------------------- |
| `clk`    | System clock                 |
| `reset`  | Asynchronous reset signal    |
| `sensor` | Detects vehicle on farm road |

---

## Outputs

| Signal          | Description              |
| --------------- | ------------------------ |
| `light_HW[2:0]` | Highway traffic lights   |
| `light_FM[2:0]` | Farm road traffic lights |

Signal Encoding:

| Value    | Meaning |
| -------- | ------- |
| `3'b100` | Green   |
| `3'b010` | Yellow  |
| `3'b001` | Red     |

---

# Finite State Machine (FSM)

The traffic controller operates using **four states**.

| State       | Highway | Farm Road | Description                 |
| ----------- | ------- | --------- | --------------------------- |
| `HGRN_FRED` | Green   | Red       | Default state               |
| `HYEL_FRED` | Yellow  | Red       | Highway preparing to stop   |
| `HRED_FGRN` | Red     | Green     | Farm road traffic allowed   |
| `HRED_FYEL` | Red     | Yellow    | Farm road preparing to stop |

---

# State Transition Diagram

Traffic flow follows this sequence:

```
Highway Green / Farm Red
        │
        │ (Vehicle detected)
        ▼
Highway Yellow / Farm Red
        │
        ▼
Highway Red / Farm Green
        │
        ▼
Highway Red / Farm Yellow
        │
        ▼
Back to Highway Green / Farm Red
```

---

# Timing Implementation

The controller uses **internal counters** to generate delays.

## Yellow Signal Delay

Two yellow phases are implemented:

* Highway yellow → **3 seconds**
* Farm road yellow → **3 seconds**

Counters used:

* `count_3s1`
* `count_3s2`

---

## Green Signal Delay (Farm Road)

Farm road green signal duration:

```
10 seconds
```

Counter used:

```
count_10s
```

---

# Verilog Design Features

The design includes the following digital design concepts:

### 1️⃣ Finite State Machine (FSM)

Two registers used:

```
present_state
next_state
```

State transitions occur on:

```
posedge clk
```

---

### 2️⃣ Sequential Logic

State register implemented using:

```
always @(posedge clk or negedge reset)
```

---

### 3️⃣ Combinational Logic

Next state logic implemented using:

```
always @(*)
```

---

### 4️⃣ Timer Counters

Three timers implemented:

| Counter     | Function             |
| ----------- | -------------------- |
| `count_3s1` | Highway yellow delay |
| `count_3s2` | Farm yellow delay    |
| `count_10s` | Farm green duration  |

---

# Testbench

A Verilog **testbench** is implemented to verify the design.

### Testbench Features

* Clock generation
* Reset initialization
* Vehicle sensor simulation
* Observation of full traffic cycle

Clock generation:

```
always #1 clk = ~clk;
```

Test scenarios include:

1. Default highway priority
2. Vehicle arrival at farm road
3. Full traffic cycle verification
4. Multiple vehicle detection events

---

# Simulation Workflow

Steps used to simulate the design:

1. Write RTL in **Verilog**
2. Create **testbench**
3. Compile using simulation tool
4. Run simulation
5. Observe waveform outputs

---

# Tools Used

* **Verilog HDL**
* **Vivado / ModelSim (Simulation)**
* Digital Design Concepts
* Finite State Machine (FSM)

---

# Applications

Traffic light controllers are widely used in:

* Smart traffic management systems
* Automated intersections
* Embedded systems
* FPGA-based control systems
* Intelligent transportation systems

---

# Repository Structure

```
Traffic-Light-Controller
│
├── traffic_light_controller.v
├── tb_traffic_light_controller.v
└── README.md
```

---

# Key Learning Outcomes

Through this project, the following concepts were explored:

* Finite State Machine design
* Sequential vs combinational logic
* Digital timers using counters
* Verilog RTL coding
* Testbench development
* Simulation-based verification

---

# Conclusion

This project demonstrates the implementation of a **Traffic Light Controller using Verilog HDL** based on a **Finite State Machine architecture**. The design efficiently manages traffic flow by giving **priority to highway traffic while responding dynamically to farm road vehicle detection**.

The project highlights the practical application of **digital logic design, timing control, and FSM implementation in hardware systems**.

---
