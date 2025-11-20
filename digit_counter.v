// digit_counter.v
// Counts how many digits have been entered (0..4) for the current attempt.

module digit_counter (
    input  wire       clk,                     // system clock
    input  wire       sys_reset,              // global reset (from Reset/Restart controller)
    input  wire       restart_pulse,          // restart for this attempt (from KEY0)
    input  wire       increment_counter_pulse,// one-cycle pulse from Entry Handler
    output reg  [2:0] digit_count,            // current count: 0..4
    output wire       full4                   // 1 when digit_count == 4
);

    // full4 is combinational: high when we've reached 4 digits
    assign full4 = (digit_count == 3'd4);

    // Sequential process: update the counter on each clock edge
    always @(posedge clk) begin
        if (sys_reset || restart_pulse) begin
            // On reset or restart, clear the count
            digit_count <= 3'd0;
        end
        else if (increment_counter_pulse) begin
            // Only increment when requested
            if (digit_count < 3'd4)
                digit_count <= digit_count + 3'd1; // 0->1->2->3->4
            else
                digit_count <= 3'd4;               // saturate at 4
        end
        else begin
            // No change
            digit_count <= digit_count;
        end
    end

endmodule
