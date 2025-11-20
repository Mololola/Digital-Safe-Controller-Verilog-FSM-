// entry_handler.v
// Converts a clean entry_pulse into two one-cycle control pulses:
//  - store_digit_pulse  -> Shift & Display Controller
//  - increment_counter_pulse -> Digit Counter

module entry_handler (
    input  wire clk,                     // system clock
    input  wire sys_reset,              // global synchronous reset
    input  wire enable_entry,           // 1 = entry key is active
    input  wire entry_pulse,            // 1-clock pulse from KEY (debounced)
    output reg  store_digit_pulse,      // 1-clock pulse: store current digit
    output reg  increment_counter_pulse // 1-clock pulse: increment digit counter
);

    always @(posedge clk) begin
        if (sys_reset) begin
            // On reset, outputs are forced low
            store_digit_pulse       <= 1'b0;
            increment_counter_pulse <= 1'b0;
        end
        else if (!enable_entry) begin
            // Entry disabled: ignore any pulses, keep outputs low
            store_digit_pulse       <= 1'b0;
            increment_counter_pulse <= 1'b0;
        end
        else begin
            // Entry enabled: pass through entry_pulse as one-cycle outputs
            if (entry_pulse) begin
                store_digit_pulse       <= 1'b1;
                increment_counter_pulse <= 1'b1;
            end
            else begin
                store_digit_pulse       <= 1'b0;
                increment_counter_pulse <= 1'b0;
            end
        end
    end

endmodule
