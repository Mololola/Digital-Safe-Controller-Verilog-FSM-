// digit_selector.v
// Up/Down "wheel" for selecting a single decimal digit (0..9).

module digit_selector (
    input  wire       clk,                  // system clock
    input  wire       sys_reset,           // global synchronous reset
    input  wire       enable_digit_select, // 1 = allow Up/Down to change the digit
    input  wire       up_pulse,            // 1-clock pulse: increment request
    input  wire       down_pulse,          // 1-clock pulse: decrement request
    output reg  [3:0] current_digit        // selected digit: 0..9
);

    // Sequential logic: update current_digit on each rising edge
    always @(posedge clk) begin
        if (sys_reset) begin
            // Reset digit to 0 on system reset
            current_digit <= 4'd0;
        end
        else if (enable_digit_select) begin
            // Only respond to pulses when enabled

            // Case 1: Up pressed (and Down not pressed)
            if (up_pulse && !down_pulse) begin
                if (current_digit == 4'd9)
                    current_digit <= 4'd0;      // wrap 9 -> 0
                else
                    current_digit <= current_digit + 4'd1;
            end

            // Case 2: Down pressed (and Up not pressed)
            else if (down_pulse && !up_pulse) begin
                if (current_digit == 4'd0)
                    current_digit <= 4'd9;      // wrap 0 -> 9
                else
                    current_digit <= current_digit - 4'd1;
            end

            // Case 3: no pulse or both pressed -> hold value
            else begin
                current_digit <= current_digit;
            end
        end
        else begin
            // Not enabled: hold the digit
            current_digit <= current_digit;
        end
    end

endmodule
