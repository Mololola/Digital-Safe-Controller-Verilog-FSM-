# Digital-Safe-Controller-Verilog-FSM-

📌 Project Overview

This project presents the complete design, implementation, simulation, and hardware validation of a four-digit electronic safe controller developed using Verilog HDL and the ASM (Algorithmic State Machine) design methodology.

The system was implemented and tested on the Altera DE2 FPGA development board using Quartus II (v13.0-SP1). The safe allows a user to enter a four-digit PIN, verify access, and reprogram the stored PIN when unlocked.

The design follows a fully synchronous architecture and demonstrates structured top-down digital system development.

🎯 Objectives

Apply the ASM design methodology to a real digital system

Develop a modular, synthesizable Verilog design

Implement and validate the design on FPGA hardware

Demonstrate safe unlocking and controlled programming mode

Ensure robustness against asynchronous button inputs

🏗 System Architecture

The system is divided into two main subsystems:

1️⃣ Control Subsystem

Reset & Restart Controller

Main FSM Controller

Programming Mode Controller

LED Output Handler

2️⃣ Datapath Subsystem

Digit Selector

Entry Handler

Digit Counter

Shift Display Controller

Stored Code Register

Comparator

All modules are fully synchronous and operate using the DE2 50 MHz system clock.

🔄 System Operation
🔒 Locked State

On power-up or reset, the safe is locked

Red LED (LEDR6) is ON

Default PIN = 4204

🔢 Code Entry

KEY1 → Increment digit

KEY3 → Decrement digit

KEY2 → Confirm digit

Displays shift left as digits are entered

✅ Correct Code

If the entered code matches the stored code

Green LED (LEDG6) turns ON

Red LED turns OFF

⚙ Programming Mode

While unlocked, SW7 enables programming mode

User enters a new 4-digit code

Stored PIN updates only after full valid entry

Reset restores default ID-based PIN

🧠 Design Methodology

The system was developed using a structured top-down design approach:

Architectural decomposition

Block diagram design

ASM chart development for each module

Module-level Verilog implementation

Individual simulation validation

Full-system simulation

FPGA hardware validation

All state transitions are synchronous and triggered on the rising edge of CLOCK_50.

🧪 Verification

The system was validated through:

Module-level functional simulations

Full-system simulation (unlock, programming, re-lock tests)

Hardware testing on the DE2 board

Test cases include:

Correct code unlock

Incorrect code rejection

Programming mode update

Post-programming verification

Reset restoration

Debounce robustness

Simulation waveforms demonstrate correct FSM transitions, comparator assertions, and LED behaviour.

🛠 Tools Used

Quartus II v13.0-SP1

Verilog HDL

ModelSim (functional simulation)

Altera DE2 Development Board

📂 Repository Structure
/src
  safe_top_luis.v
  reset_restart_controller.v
  main_fsm_controller.v
  digit_selector.v
  entry_handler.v
  digit_counter.v
  shift_display_controller.v
  stored_code_register.v
  comparator.v
  mode_programming_controller.v
  led_output_handler.v

/simulation
  full_system_simulation.vwf

/docs
  Report.pdf
🧩 Key Design Features

Fully synchronous architecture

Debounced push-button inputs

One-cycle pulse generation

Modular and scalable structure

Deterministic FSM behaviour

Hardware-validated implementation

📚 Learning Outcomes Demonstrated

This project demonstrates:

Digital system design using ASM methodology

Structured Verilog HDL development

FPGA synthesis and implementation

Integration of control and datapath architectures

Robust handling of asynchronous inputs

🚀 Potential Improvements

Future extensions could include:

Configurable PIN length

Lockout after repeated failed attempts

Timeout-based auto-relock

Parameterised design for scalability

Enhanced security mechanisms

📄 License

This repository is submitted as part of ELEC473 coursework at the University of Liverpool.
Educational use only.
