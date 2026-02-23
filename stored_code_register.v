// stored_code_register.v
// Holds the valid 4-digit safe PIN.
// Luis Guillot Lozano (ID: 201514204) → Default PIN = 4-2-0-4

module stored_code_register (
    input  wire        clk,            // system clock
    input  wire        sys_reset,      // global synchronous reset
    input  wire        load_new_code,  // 1-cycle pulse to store new PIN
    input  wire [15:0] new_code,       // {d3, d2, d1, d0}
    output reg  [15:0] stored_code     // currently valid PIN
);

    // Default PIN derived from ID (4204)
    localparam [15:0] DEFAULT_CODE = {4'd4, 4'd2, 4'd0, 4'd4};

    always @(posedge clk or posedge sys_reset) begin
        if (sys_reset) begin
            // Load default PIN on global reset
            stored_code <= DEFAULT_CODE;
        end
        else if (load_new_code) begin
            // Update code when programming controller asserts pulse
            stored_code <= new_code;
        end
        else begin
            // Otherwise hold previous value
            stored_code <= stored_code;
        end
    end

endmodule
