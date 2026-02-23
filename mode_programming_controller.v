// mode_programming_controller.v
// Controls normal vs programming mode and generates load_new_code pulse.
// Only allows code programming when the safe is unlocked and SW7 = 1.

module mode_programming_controller (
    input  wire clk,           // system clock
    input  wire sys_reset,     // global synchronous reset
    input  wire unlocked,      // 1 when safe is unlocked (from Main FSM)
    input  wire SW7,           // mode switch: 1 = programming requested
    input  wire full4,         // 1 when 4 digits have been entered

    output reg  program_mode,  // 1 = programming mode active
    output reg  load_new_code  // 1-clock pulse: write new code
);

    // State encoding
    localparam S_NORMAL_MODE     = 2'd0,
               S_PROGRAMMING     = 2'd1,
               S_LOAD_PULSE      = 2'd2;

    reg [1:0] state, next_state;

    //===========================
    // 1) State register
    //===========================
    always @(posedge clk or posedge sys_reset) begin
        if (sys_reset) begin
            state <= S_NORMAL_MODE;
        end
        else begin
            state <= next_state;
        end
    end

    //===========================
    // 2) Next-state logic
    //===========================
    always @* begin
        next_state = state;

        case (state)
            // Normal operation: no programming
            S_NORMAL_MODE: begin
                if (sys_reset) begin
                    next_state = S_NORMAL_MODE;
                end
                else if (unlocked && SW7) begin
                    // Safe is unlocked and user requests programming
                    next_state = S_PROGRAMMING;
                end
                else begin
                    next_state = S_NORMAL_MODE;
                end
            end

            // Programming mode: entering new PIN
            S_PROGRAMMING: begin
                if (sys_reset) begin
                    next_state = S_NORMAL_MODE;
                end
                else if (!unlocked) begin
                    // Safe no longer unlocked → back to normal
                    next_state = S_NORMAL_MODE;
                end
                else if (!SW7) begin
                    // User turned off programming switch
                    next_state = S_NORMAL_MODE;
                end
                else if (full4) begin
                    // 4 digits entered → generate load pulse
                    next_state = S_LOAD_PULSE;
                end
                else begin
                    next_state = S_PROGRAMMING;
                end
            end

            // One-clock pulse to update stored code
            S_LOAD_PULSE: begin
                // After generating pulse, stay in programming mode
                next_state = S_PROGRAMMING;
            end

            default: next_state = S_NORMAL_MODE;
        endcase
    end

    //===========================
    // 3) Output logic
    //===========================
    always @(posedge clk) begin
        // default outputs
        program_mode  <= 1'b0;
        load_new_code <= 1'b0;

        case (state)
            S_NORMAL_MODE: begin
                // both outputs remain 0
                program_mode  <= 1'b0;
                load_new_code <= 1'b0;
            end

            S_PROGRAMMING: begin
                // programming enabled, but no write yet
                program_mode  <= 1'b1;
                load_new_code <= 1'b0;
            end

            S_LOAD_PULSE: begin
                // still in programming, and assert 1-cycle write pulse
                program_mode  <= 1'b1;
                load_new_code <= 1'b1;
            end

            default: begin
                program_mode  <= 1'b0;
                load_new_code <= 1'b0;
            end
        endcase
    end

endmodule
