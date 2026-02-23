// reset_restart_controller.v
// Generates clean, one-clock-wide sys_reset and restart_pulse
// from SW6 (system reset) and KEY0 (restart/lock).

module reset_restart_controller (
    input  wire clk,        // system clock
    input  wire SW6,        // system reset switch (active-high)
    input  wire KEY0,       // restart/lock push-button (active-high)

    output reg  sys_reset,      // 1-clock global reset pulse
    output reg  restart_pulse   // 1-clock restart/lock pulse
);

    // Simple state encoding
    localparam S_IDLE            = 3'd0,
               S_SYS_RESET_PULSE = 3'd1,
               S_WAIT_SW6_REL    = 3'd2,
               S_RESTART_PULSE   = 3'd3,
               S_WAIT_KEY0_REL   = 3'd4;

    reg [2:0] state, next_state;

    // =========================
    // 1) State register
    // =========================
	 
	 
    always @(posedge clk or posedge SW6) begin
        if (SW6)
            state <= S_SYS_RESET_PULSE;
        else
            state <= next_state;
    end

    // =========================
    // 2) Next-state logic
    // =========================
    always @* begin
        // default: stay where we are
        next_state = state;

        case (state)
            S_IDLE: begin
                if (SW6)        next_state = S_SYS_RESET_PULSE;
                else if (KEY0)  next_state = S_RESTART_PULSE;
                else            next_state = S_IDLE;
            end

            // Generate one-cycle sys_reset pulse
            S_SYS_RESET_PULSE: begin
                next_state = S_WAIT_SW6_REL;
            end

            // Wait until SW6 is released
            S_WAIT_SW6_REL: begin
                if (!SW6)
                    next_state = S_IDLE;
                else
                    next_state = S_WAIT_SW6_REL;
            end

            // Generate one-cycle restart pulse
            S_RESTART_PULSE: begin
                next_state = S_WAIT_KEY0_REL;
            end

            // Wait until KEY0 is released
            S_WAIT_KEY0_REL: begin
                if (!KEY0)
                    next_state = S_IDLE;
                else
                    next_state = S_WAIT_KEY0_REL;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // =========================
    // 3) Output logic
    // =========================
    always @(posedge clk) begin
        // default outputs
        sys_reset     <= 1'b0;
        restart_pulse <= 1'b0;

        case (state)
            S_SYS_RESET_PULSE: begin
                sys_reset <= 1'b1;          // 1-clock global reset
            end

            S_RESTART_PULSE: begin
                restart_pulse <= 1'b1;      // 1-clock restart pulse
            end

            default: begin
                // both outputs already 0
            end
        endcase
    end

endmodule
