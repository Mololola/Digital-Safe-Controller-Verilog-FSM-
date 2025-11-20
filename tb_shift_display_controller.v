// tb_shift_display_controller.v
// Testbench for shift_display_controller module.

`timescale 1ns/1ps

module tb_shift_display_controller;

    // Testbench signals
    reg        clk;
    reg        sys_reset;
    reg        restart_pulse;
    reg        store_digit_pulse;
    reg  [2:0] digit_count;
    reg  [3:0] current_digit;

    wire [15:0] entered_code;
    wire [6:0]  HEX5;
    wire [6:0]  HEX4;
    wire [6:0]  HEX3;
    wire [6:0]  HEX2;

    // Instantiate the Unit Under Test (UUT)
    shift_display_controller uut (
        .clk               (clk),
        .sys_reset         (sys_reset),
        .restart_pulse     (restart_pulse),
        .store_digit_pulse (store_digit_pulse),
        .digit_count       (digit_count),
        .current_digit     (current_digit),
        .entered_code      (entered_code),
        .HEX5              (HEX5),
        .HEX4              (HEX4),
        .HEX3              (HEX3),
        .HEX2              (HEX2)
    );

    // -------------------------
    // 1) Clock generation: 20 ns period
    // -------------------------
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;   // toggle every 10 ns
    end

    // -------------------------
    // 2) Stimulus
    // -------------------------
    initial begin
        // Initial values
        sys_reset         = 1'b1;
        restart_pulse     = 1'b0;
        store_digit_pulse = 1'b0;
        digit_count       = 3'd0;
        current_digit     = 4'd0;

        // Hold reset
        #60;
        sys_reset = 1'b0;   // release reset

        // =============================
        // Phase 1: store four digits
        // d3 = 1, d2 = 2, d1 = 3, d0 = 4
        // =============================

        // Store first digit -> d3 (digit_count = 0)
        current_digit = 4'd1;
        digit_count   = 3'd0;
        store_one_pulse();

        // Store second digit -> d2 (digit_count = 1)
        current_digit = 4'd2;
        digit_count   = 3'd1;
        store_one_pulse();

        // Store third digit -> d1 (digit_count = 2)
        current_digit = 4'd3;
        digit_count   = 3'd2;
        store_one_pulse();

        // Store fourth digit -> d0 (digit_count = 3)
        current_digit = 4'd4;
        digit_count   = 3'd3;
        store_one_pulse();

        // Wait a bit to observe entered_code and HEX outputs
        #200;

        // =============================
        // Phase 2: restart_pulse clears all digits
        // =============================
        restart_pulse = 1'b1;
        #20;
        restart_pulse = 1'b0;

        // Wait to see digits cleared to 0
        #200;

        // =============================
        // Phase 3: store another pattern
        // Example: d3=9, d2=8, d1=7, d0=6
        // =============================

        current_digit = 4'd9; digit_count = 3'd0; store_one_pulse();
        current_digit = 4'd8; digit_count = 3'd1; store_one_pulse();
        current_digit = 4'd7; digit_count = 3'd2; store_one_pulse();
        current_digit = 4'd6; digit_count = 3'd3; store_one_pulse();

        #200;

        // End simulation
        #100;
        $stop;
    end

    // -------------------------
    // Task: generate a single store_digit_pulse of one clock
    // -------------------------
    task store_one_pulse;
    begin
        store_digit_pulse = 1'b1;
        #20;                     // one clock period
        store_digit_pulse = 1'b0;
        #40;                     // small gap before next operation
    end
    endtask

endmodule
