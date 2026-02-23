// comparator.v
// Compares the 4-digit entered code with the stored PIN.
// Output 'match_now' is 1 when they are exactly equal.

module comparator (
    input  wire [15:0] entered_code, // {d3, d2, d1, d0} from datapath
    input  wire [15:0] stored_code,  // {d3, d2, d1, d0} from stored_code_register
    output wire        match_now     // 1 if equal, 0 otherwise
);

    // Combinational equality comparison
    assign match_now = (entered_code == stored_code);

endmodule
