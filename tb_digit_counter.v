// tb_digit_counter.v
// Testbench for digit_counter module.

`timescale 1ns/1ps

module tb_digit_counter;

    // Testbench signals
    reg        clk;
    reg        sys_reset;
    reg        restart_pulse;
    reg        increment_counter_pulse;
    wire [2:0] digit_count;
    wire       full4;

    // Instantiate the Unit Under Test (UUT)
    digit_counter uut (
        .clk                     (clk),
        .sys_reset               (sys_reset),
        .restart_pulse           (restart_pulse),
        .increment_counter_pulse (increment_counter_pulse),
        .digit_count             (digit_count),
        .full4                   (full4)
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
        sys_reset               = 1'b1;
        restart_pulse           = 1'b0;
        increment_counter_pulse = 1'b0;

        // Hold reset for a while
        #60;
        sys_reset = 1'b0;   // release reset

        // -----------------------------
        // Phase 1: count up 0 -> 4
        // -----------------------------
        // Generate 5 increment pulses to show:
        //  0,1,2,3,4 and full4 asserted at 4
        repeat (5) begin
            increment_counter_pulse = 1'b1;
            #20;                         // one clock
            increment_counter_pulse = 1'b0;
            #40;                         // wait a couple of clocks
        end

        // -----------------------------
        // Phase 2: show saturation at 4
        // -----------------------------
        // Even with more pulses, digit_count should stay at 4
        repeat (3) begin
            increment_counter_pulse = 1'b1;
            #20;
            increment_counter_pulse = 1'b0;
            #40;
        end

        // -----------------------------
        // Phase 3: restart_pulse clears to 0
        // -----------------------------
        restart_pulse = 1'b1;
        #20;
        restart_pulse = 1'b0;
        #40;

        // A couple of pulses again after restart
        repeat (3) begin
            increment_counter_pulse = 1'b1;
            #20;
            increment_counter_pulse = 1'b0;
            #40;
        end

        // End simulation
        #100;
        $stop;
    end

endmodule
