# Digital-Safe-Controller-Verilog-FSM-

A fully synchronous 4-digit FPGA safe implemented in Verilog using a top-down modular design.
📘 Overview

This repository contains the full implementation of a 4-digit safe controller developed for ELEC473 Assignment 1.
The design is fully synchronous, modular, and implemented entirely in Verilog. All behaviour is formally specified using ASM charts, then simulated and verified using Quartus II waveform (.vwf) simulation.

The safe accepts user input through push-buttons, stores and displays digits, compares user attempts against a stored code, and supports a programming mode for updating the code when unlocked.

This project demonstrates:

Top-down digital system design

FSM-based control

One-cycle pulse generation

Seven-segment display control

Modular FPGA development

Hardware verification through simulation

🧱 System Architecture

The system consists of ten fully modular hardware units:

Control Modules

Reset/Restart Controller – Generates synchronous reset and restart pulses

Entry Handler – Converts ENTER presses into one-cycle store/increment pulses

Digit Counter – Counts confirmed digits (0–4)

Programming Controller – Manages code programming mode

Main FSM – Overall operation: LOCKED, COLLECTING, CHECK, UNLOCKED

Datapath Modules

Digit Selector – Up/down digit selection

Shift & Display Controller – Stores digits & updates HEX displays

Stored Code Register – Holds the programmed 4-digit code

Comparator – Compares entered versus stored code

LED Handler – Controls locked/unlocked status LEDs

A full architectural diagram is included inside the PDF report.

▶️ How to Run the Simulation
1. Open the Quartus II Project

Load the project or create a new one and add all Verilog files from /Verilog.

2. Set the Desired Top-Level Module

For example:

Assignments → Settings → General → Top-level entity  


Choose:

digit_selector

entry_handler

digit_counter

shift_display_controller

or any other module you wish to simulate.

3. Open the Corresponding .vwf File

Located in /Simulation.

Each file already contains:

Clock definition (20 ns period)

Input stimulus (up/down pulses, entry pulses, resets, etc.)

Relevant observed output signals

4. Run Functional Simulation
Simulation → Run Functional Simulation


Waveforms will update automatically.

5. Inspect Outputs

Confirm:

Correct pulse generation

Digit increments/decrements

Correct HEX updates

Proper resets & saturation

Code comparison behaviour

📄 Features Implemented

✔ Fully synchronous Verilog design

✔ Top-down architecture

✔ FSM-driven control

✔ One-cycle pulses for all event-based behaviour

✔ Seven-segment display decoding

✔ All modules independently tested

✔ Simulation waveforms provided

✔ Complete assignment-ready documentation
