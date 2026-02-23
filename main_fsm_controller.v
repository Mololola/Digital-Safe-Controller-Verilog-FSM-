// main_fsm_controller.v
// Controls the overall behaviour of the safe: LOCKED → COLLECTING → CHECK → UNLOCKED.
// Designed for ELEC473 Assignment 2 (Luis Guillot Lozano – ID: 201514204)

module main_fsm_controller (
    input  wire clk,
    input  wire sys_reset,        // global synchronous reset
    input  wire restart_pulse,    // restart/lock pulse
    input  wire full4,            // 1 when 4 digits have been entered
    input  wire match_now,        // 1 when entered PIN == stored PIN
	 input wire program_mode,

    output reg  allow_entry,      // enables digit entry pipeline
    output reg  locked_state,     // 1 = locked, 0 = unlocked (for LED handler)
    output reg  unlocked          // 1 in UNLOCKED state (for programming controller)
);

    // FSM state encoding
    localparam S_LOCKED     = 2'd0,
               S_COLLECTING = 2'd1,
               S_CHECK      = 2'd2,
               S_UNLOCKED   = 2'd3;

    reg [1:0] state, next_state;

    //====================================
    // State Register
    //====================================
    always @(posedge clk or posedge sys_reset) begin
        if (sys_reset)
            state <= S_LOCKED;
        else
            state <= next_state;
    end

    //====================================
    // Next-State Logic
    //====================================
    always @* begin
        next_state = state;

        case (state)

            //====================================
            // LOCKED — waiting for restart to start entry
            //====================================
            S_LOCKED: begin
                if (restart_pulse)
                    next_state = S_COLLECTING;
                else
                    next_state = S_LOCKED;
            end

            //====================================
            // COLLECTING — user entering 4 digits
            //====================================
            S_COLLECTING: begin
                if (sys_reset)
                    next_state = S_LOCKED;
                else if (restart_pulse)
                    next_state = S_LOCKED;
                else if (full4)
                    next_state = S_CHECK;
                else
                    next_state = S_COLLECTING;
            end

            //====================================
            // CHECK — evaluate match_now
            // One-cycle evaluation
            //====================================
            S_CHECK: begin
                if (match_now)
                    next_state = S_UNLOCKED;
                else
                    next_state = S_LOCKED;  // incorrect code
            end

            //====================================
            // UNLOCKED — until user locks again
            //====================================
            S_UNLOCKED: begin
                if (sys_reset)
                    next_state = S_LOCKED;
                else if (restart_pulse && !program_mode)
                    next_state = S_LOCKED;
                else
                    next_state = S_UNLOCKED;
            end

            default: next_state = S_LOCKED;
        endcase
    end

    //====================================
    // Output Logic
    //====================================
    always @* begin
        // defaults
        allow_entry   = 1'b0;
        locked_state  = 1'b1; 
        unlocked      = 1'b0;

        case (state)

            S_LOCKED: begin
                allow_entry   = 1'b0;
                locked_state  = 1'b1;
                unlocked      = 1'b0;
            end

            S_COLLECTING: begin
                allow_entry   = 1'b1;   // enable storing digits & incrementing counter
                locked_state  = 1'b1;
                unlocked      = 1'b0;
            end

            S_CHECK: begin
                allow_entry   = 1'b0;
                locked_state  = 1'b1;
                unlocked      = 1'b0;
            end

            S_UNLOCKED: begin
                allow_entry   = program_mode;
                locked_state  = 1'b0;   // safe is now open
                unlocked      = 1'b1;   // programming controller uses this
            end
        endcase
    end

endmodule
