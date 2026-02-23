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

    reg entry_prev;

always @(posedge clk or posedge sys_reset) begin
    if (sys_reset) begin
        entry_prev <= 1'b0;
        store_digit_pulse <= 1'b0;
        increment_counter_pulse <= 1'b0;
    end else begin
        // rising edge detect on entry_pulse
        store_digit_pulse <= (enable_entry && entry_pulse && !entry_prev);
        increment_counter_pulse <= (enable_entry && entry_pulse && !entry_prev);
        entry_prev <= entry_pulse;
    end
end


endmodule
