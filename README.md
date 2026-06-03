# VLSI_Tasks

*COMPANY*:CODTECH IT SOLUTIONS

*NAME*:GETTA NAVYA

*INTERN ID*:COD08111

*DOMAIN*:VLSI

*DURATION*:4 WEEKS

*MENTOR*:NEELA SANTHOSH

##This project collection shows practical FPGA-based VLSI designs written in Verilog and built with Xilinx Vivado. The set includes four key modules: an Arithmetic Logic Unit (ALU), parameterized RAM blocks, a simple pipelined processor, and a Finite Impulse Response (FIR) filter. Each module is written to be understandable, reusable, and testable. I used Verilog tasks throughout to keep the code clean and to avoid repeating the same logic in many places.
The ALU performs common arithmetic and logic functions: add, subtract, bitwise AND/OR/XOR, shifts, and comparisons. I split the ALU work into small pieces so each part is easy to read. Verilog tasks are used for repeated actions such as preparing inputs (for example sign extension) and computing flags (zero, carry, overflow). Because these repeated actions are in tasks, if I need to change how a flag is calculated, I change it once in the task and all operations use the update immediately. This makes the ALU easier to extend and debug.
The RAM blocks are written so you can change data width and memory depth with parameters. I included single-port and dual-port versions depending on the need. Tasks are used to handle common memory operations: masked writes (writing some bytes but not others), synchronous read behavior, and initializing memory from a file for tests. Using tasks here keeps the memory control logic tidy and helps the testbench set up memory contents quickly and repeatably.
The pipelined processor shows a simple five-stage pipeline: fetch, decode, execute, memory, and write-back. It demonstrates basic pipeline ideas like holding data in stage registers, forwarding to avoid hazards, and inserting stalls or bubbles when needed. Tasks simplify repeated control actions: instruction decoding, control-signal setup, and standard sequences for flushing or stalling the pipeline. Because these control routines are in tasks, each pipeline stage stays focused on its job, which makes testing and understanding the processor much easier.
The FIR filter implements a digital signal processing block using multiply-accumulate (MAC) operations. You can change the number of taps and the bit precision with parameters. Tasks are used to load coefficients, run the MAC loop, scale results for fixed-point numbers, and handle saturation (preventing overflow). Tasks make it simple to test different filter lengths and precision choices without rewriting the core logic.
All modules include testbenches written in Verilog. Testbenches use tasks to generate input patterns, run sequences of operations, and check outputs automatically. This makes testing repeatable, helps find bugs fast, and speeds up verification. I used Vivado for simulation, linting, synthesis, and implementation. After verifying functionality in simulation, I ran synthesis and place-and-route in Vivado to check timing and resource usage for the chosen Xilinx FPGA target.In short, these projects are practical examples of how to build clear, modular FPGA designs using Verilog and Vivado. The use of tasks reduces duplicated code and improves maintainability. The ALU, RAM, pipelined CPU, and FIR filter together demonstrate common VLSI building blocks and show how to organize a real design flow: write RTL, test with task-driven testbenches, synthesize, and implement on Xilinx FPGAs.##

#OUTPUT

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/463fcce0-da9b-49ae-8581-c379da7ce373" />
