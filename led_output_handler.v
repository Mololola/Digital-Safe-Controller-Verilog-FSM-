// led_output_handler.v
// Drives LEDR6 (red) and LEDG6 (green) according to lock status.
// Used in ELEC473 Assignment 2 (Luis Guillot Lozano – ID: 201514204)

module led_output_handler (
    input  wire sys_reset,     // global system reset -- forces locked indication
    input  wire locked_state,  // 1 = locked, 0 = unlocked (from Main FSM)
    output reg  LEDR6,         // red LED: ON when locked
    output reg  LEDG6          // green LED: ON when unlocked
);

    always @* begin
        if (sys_reset) begin
            // Force locked output on reset
            LEDR6 = 1'b1;
            LEDG6 = 1'b0;
        end
        else if (locked_state) begin
            // Locked: red ON, green OFF
            LEDR6 = 1'b1;
            LEDG6 = 1'b0;
        end
        else begin
            // Unlocked: red OFF, green ON
            LEDR6 = 1'b0;
            LEDG6 = 1'b1;
        end
    end

endmodule
