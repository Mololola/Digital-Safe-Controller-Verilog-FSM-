// shift_display_controller.v
// Stores the four digits currently entered and drives HEX5..HEX2.
// Also provides a 16-bit bus "entered_code" = {d3,d2,d1,d0}.

module shift_display_controller (
    input  wire       clk,               // system clock
    input  wire       sys_reset,         // global reset
    input  wire       restart_pulse,     // restart this attempt (KEY0 pulse)
    input  wire       store_digit_pulse, // one-cycle pulse: store current digit
    input  wire [2:0] digit_count,       // 0..3 -> which position to update
    input  wire [3:0] current_digit,     // digit from digit_selector (0..9)

    output wire [15:0] entered_code,     // {d3,d2,d1,d0} for comparator/etc.

    output reg  [6:0] HEX5,              // 7-seg outputs (assumed active-low)
    output reg  [6:0] HEX4,
    output reg  [6:0] HEX3,
    output reg  [6:0] HEX2
);

    // internal digit registers (4 bits each)
    reg [3:0] d3, d2, d1, d0;

    // pack digits into a 16-bit bus
    assign entered_code = {d3, d2, d1, d0};

    // ===========================
    // 1) STORE / CLEAR DIGITS
    // ===========================
    always @(posedge clk) begin
        if (sys_reset || restart_pulse) begin
            // clear all digits on reset or restart
            d3 <= 4'd0;
            d2 <= 4'd0;
            d1 <= 4'd0;
            d0 <= 4'd0;
        end
        else if (store_digit_pulse) begin
            // store current_digit into position selected by digit_count
            case (digit_count)
                3'd0: d3 <= current_digit; // first digit entered -> most significant
                3'd1: d2 <= current_digit;
                3'd2: d1 <= current_digit;
                3'd3: d0 <= current_digit; // fourth digit entered -> least significant
                default: ;                // ignore other values
            endcase
        end
        // else hold previous values
    end

    // ===========================
    // 2) 7-SEGMENT ENCODER
    // ===========================
    // helper task: convert a 4-bit digit to a 7-seg pattern (active-low)
    // segment order: {g,f,e,d,c,b,a}
    function [6:0] seg7;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: seg7 = 7'b1000000;
                4'd1: seg7 = 7'b1111001;
                4'd2: seg7 = 7'b0100100;
                4'd3: seg7 = 7'b0110000;
                4'd4: seg7 = 7'b0011001;
                4'd5: seg7 = 7'b0010010;
                4'd6: seg7 = 7'b0000010;
                4'd7: seg7 = 7'b1111000;
                4'd8: seg7 = 7'b0000000;
                4'd9: seg7 = 7'b0010000;
                default: seg7 = 7'b1111111; // blank
            endcase
        end
    endfunction

    // drive HEX displays continuously from the digit registers
    always @* begin
        HEX5 = seg7(d3);
        HEX4 = seg7(d2);
        HEX3 = seg7(d1);
        HEX2 = seg7(d0);
    end

endmodule
