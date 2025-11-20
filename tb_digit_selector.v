// tb_digit_selector.v
// Testbench for digit_selector module.

`timescale 1ns/1ps

module tb_digit_selector;

    // Testbench signals
    reg        clk;
    reg        sys_reset;
    reg        enable_digit_select;
    reg        up_pulse;
    reg        down_pulse;
    wire [3:0] current_digit;

    // Instantiate the module under test (UUT)
    digit_selector uut (
        .clk                 (clk),
        .sys_reset           (sys_reset),
        .enable_digit_select (enable_digit_select),
        .up_pulse            (up_pulse),
        .down_pulse          (down_pulse),
        .current_digit       (current_digit)
    );

    // -------------------------
    // Clock generation: 20 ns period (50 MHz)
    // -------------------------
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;   // toggle every 10 ns
    end

    // -------------------------
    // Stimulus
    // -------------------------
    initial begin
        // Initial values
        sys_reset           = 1'b1;
        enable_digit_select = 1'b0;
        up_pulse            = 1'b0;
        down_pulse          = 1'b0;

        // Hold reset for a few cycles
        #50;
        sys_reset = 1'b0;     // release reset

        // Enable digit selection
        enable_digit_select = 1'b1;

        // ---- Test 1: count up from 0 to 9 and wrap ----
        repeat (10) begin
            // Generate a one-clock up_pulse
            up_pulse = 1'b1;
            #20;             // one clock period
            up_pulse = 1'b0;
            #20;             // wait another clock
        end

        // ---- Test 2: count down a few steps ----
        repeat (5) begin
            down_pulse = 1'b1;
            #20;
            down_pulse = 1'b0;
            #20;
        end

        // ---- Test 3: disable selection and show that pulses do nothing ----
        enable_digit_select = 1'b0;

        // Try some pulses while disabled
        up_pulse = 1'b1;  #20;  up_pulse = 1'b0;  #20;
        down_pulse = 1'b1; #20; down_pulse = 1'b0; #20;

        // Finish simulation
        #100;
        $stop;
    end

endmodule
