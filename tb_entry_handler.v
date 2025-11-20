// tb_entry_handler.v
// Testbench for entry_handler module.

`timescale 1ns/1ps

module tb_entry_handler;

    // Testbench signals
    reg  clk;
    reg  sys_reset;
    reg  enable_entry;
    reg  entry_pulse;
    wire store_digit_pulse;
    wire increment_counter_pulse;

    // Instantiate the Unit Under Test (UUT)
    entry_handler uut (
        .clk                    (clk),
        .sys_reset              (sys_reset),
        .enable_entry           (enable_entry),
        .entry_pulse            (entry_pulse),
        .store_digit_pulse      (store_digit_pulse),
        .increment_counter_pulse(increment_counter_pulse)
    );

    // -------------------------
    // 1) Clock generation: 20 ns period (50 MHz)
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
        sys_reset   = 1'b1;
        enable_entry = 1'b0;
        entry_pulse  = 1'b0;

        // Hold reset for a while (100 ns)
        #100;
        sys_reset = 1'b0;     // release reset

        // -----------------------------
        // Phase 1: entry disabled
        // -----------------------------
        // Send a couple of entry pulses while enable_entry = 0
        // Outputs should stay LOW the whole time.
        repeat (2) begin
            entry_pulse = 1'b1;
            #20;                 // one clock period
            entry_pulse = 1'b0;
            #40;                 // wait two more clocks
        end

        // -----------------------------
        // Phase 2: enable entry
        // -----------------------------
        enable_entry = 1'b1;
        #40;

        // Now generate a few valid entry pulses:
        // Each pulse should produce one-cycle store & increment pulses.
        repeat (4) begin
            entry_pulse = 1'b1;
            #20;
            entry_pulse = 1'b0;
            #40;
        end

        // -----------------------------
        // Phase 3: disable again
        // -----------------------------
        enable_entry = 1'b0;
        #40;

        // Try another pulse while disabled: outputs must be 0 again
        entry_pulse = 1'b1;
        #20;
        entry_pulse = 1'b0;
        #40;

        // End simulation
        #100;
        $stop;
    end

endmodule
