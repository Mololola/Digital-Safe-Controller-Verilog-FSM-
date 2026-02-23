// safe_top_luis.v - COMPLETE WORKING VERSION
// Top-level for ELEC473 Assignment 2
// Luis Guillot Lozano – ID: 201514204
//
// FEATURES:
// - Proper button debouncing for reliable hardware operation
// - HEX6 displays current_digit selector (so you can see it change!)
// - All programming mode fixes included

module safe_top_luis (
    input  wire        CLOCK_50,      // DE2 50 MHz clock
    input  wire [3:0]  KEY,           // KEY[0]..KEY[3]
    input  wire [9:0]  SW,            // SW[0]..SW[9]

    output wire [6:0]  HEX6,          // NEW: Shows current digit selector!
    output wire [6:0]  HEX5,
    output wire [6:0]  HEX4,
    output wire [6:0]  HEX3,
    output wire [6:0]  HEX2,

    output wire [9:0]  LEDR,
    output wire [7:0]  LEDG
);

    //===========================================================
    // Button Press Detection with Debouncing
    //===========================================================
	
    wire key0_pressed = ~KEY[0];
    wire key1_pressed = ~KEY[1];
    wire key2_pressed = ~KEY[2];
    wire key3_pressed = ~KEY[3];
	 
    //===========================================================
    // DEBOUNCING: Shorter delay for faster response
    // Using 14-bit counter = ~0.3ms (good balance)
    //===========================================================
	 
    reg [13:0] key0_count, key1_count, key2_count, key3_count;
    reg key0_stable, key1_stable, key2_stable, key3_stable;
    
    // Debounce KEY0
    always @(posedge CLOCK_50) begin
        if (sys_reset) begin
            key0_count <= 14'd0;
            key0_stable <= 1'b0;
        end else begin
            if (key0_pressed == key0_stable) begin
                key0_count <= 14'd0;
            end else begin
                key0_count <= key0_count + 14'd1;
                if (key0_count == 14'd16383) begin
                    key0_stable <= key0_pressed;
                end
            end
        end
    end
    
    // Debounce KEY1
    always @(posedge CLOCK_50) begin
        if (sys_reset) begin
            key1_count <= 14'd0;
            key1_stable <= 1'b0;
        end else begin
            if (key1_pressed == key1_stable) begin
                key1_count <= 14'd0;
            end else begin
                key1_count <= key1_count + 14'd1;
                if (key1_count == 14'd16383) begin
                    key1_stable <= key1_pressed;
                end
            end
        end
    end
    
    // Debounce KEY2
    always @(posedge CLOCK_50) begin
        if (sys_reset) begin
            key2_count <= 14'd0;
            key2_stable <= 1'b0;
        end else begin
            if (key2_pressed == key2_stable) begin
                key2_count <= 14'd0;
            end else begin
                key2_count <= key2_count + 14'd1;
                if (key2_count == 14'd16383) begin
                    key2_stable <= key2_pressed;
                end
            end
        end
    end
    
    // Debounce KEY3
    always @(posedge CLOCK_50) begin
        if (sys_reset) begin
            key3_count <= 14'd0;
            key3_stable <= 1'b0;
        end else begin
            if (key3_pressed == key3_stable) begin
                key3_count <= 14'd0;
            end else begin
                key3_count <= key3_count + 14'd1;
                if (key3_count == 14'd16383) begin
                    key3_stable <= key3_pressed;
                end
            end
        end
    end
	 
    //===========================================================
    // Edge detection on DEBOUNCED signals
    //===========================================================
    reg key1_prev, key2_prev, key3_prev;
    wire key1_pulse, key2_pulse, key3_pulse;
	 
    always @(posedge CLOCK_50) begin
        if (sys_reset) begin
            key1_prev <= 1'b0;
            key2_prev <= 1'b0;
            key3_prev <= 1'b0;
        end 
        else begin
            key1_prev <= key1_stable;
            key2_prev <= key2_stable;
            key3_prev <= key3_stable;
        end
    end
		
    assign key1_pulse = key1_stable & ~key1_prev;
    assign key2_pulse = key2_stable & ~key2_prev;
    assign key3_pulse = key3_stable & ~key3_prev;
	 
    //===========================================================
    // Internal Signals
    //===========================================================
    
    wire sys_reset;
    wire restart_pulse;
    wire allow_entry;
    wire locked_state;
    wire unlocked;
    wire store_digit_pulse;
    wire increment_counter_pulse;
    wire full4;
    wire [2:0] digit_count;
    wire [3:0] current_digit;
    wire [15:0] entered_code;
    wire [15:0] stored_code;
    wire match_now;
    wire program_mode;
    wire load_new_code;

    //===========================================================
    // Assign unused LEDs
    //===========================================================
    assign LEDR[9:7] = 3'b000;
    assign LEDR[5:0] = 6'b000000;
    assign LEDG[5:0] = 6'b000000;
    assign LEDG[7] = 1'b0;

    //===========================================================
    // HEX6: Display current_digit for visual feedback!
    //===========================================================
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
                default: seg7 = 7'b1111111;
            endcase
        end
    endfunction
    
    assign HEX6 = seg7(current_digit);  // Show what digit is selected!

    //===========================================================
    // Module Instantiations
    //===========================================================
    
    reset_restart_controller u_reset_restart (
        .clk          (CLOCK_50),
        .SW6          (SW[6]),
        .KEY0         (key0_stable),
        .sys_reset    (sys_reset),
        .restart_pulse(restart_pulse)
    );

    main_fsm_controller u_main_fsm (
        .clk          (CLOCK_50),
        .sys_reset    (sys_reset),
        .restart_pulse(restart_pulse),
        .full4        (full4),
        .match_now    (match_now),
        .program_mode (program_mode),
        .allow_entry  (allow_entry),
        .locked_state (locked_state),
        .unlocked     (unlocked)
    );

    led_output_handler u_led_handler (
        .sys_reset    (sys_reset),
        .locked_state (locked_state),
        .LEDR6        (LEDR[6]),
        .LEDG6        (LEDG[6])
    );

    digit_selector u_digit_selector (
        .clk          (CLOCK_50),
        .sys_reset    (sys_reset),
        .enable_digit_select(1'b1),  // ALWAYS ENABLED - simplest solution!
        .up_pulse     (key1_pulse),
        .down_pulse   (key3_pulse),
        .current_digit(current_digit)
    );

    entry_handler u_entry_handler (
        .clk                   (CLOCK_50),
        .sys_reset             (sys_reset),
        .enable_entry          (allow_entry | program_mode),  // Enable in both modes!
        .entry_pulse           (key2_pulse),
        .store_digit_pulse     (store_digit_pulse),
        .increment_counter_pulse(increment_counter_pulse)
    );

    digit_counter u_digit_counter (
        .clk                  (CLOCK_50),
        .sys_reset            (sys_reset),
        .restart_pulse        (restart_pulse),
        .increment_counter_pulse(increment_counter_pulse),
        .digit_count          (digit_count),
        .full4                (full4)
    );

    shift_display_controller u_shift_display (
        .clk               (CLOCK_50),
        .sys_reset         (sys_reset),
        .restart_pulse     (restart_pulse),
        .store_digit_pulse (store_digit_pulse),
        .digit_count       (digit_count),
        .current_digit     (current_digit),
        .entered_code      (entered_code),
        .HEX5              (HEX5),
        .HEX4              (HEX4),
        .HEX3              (HEX3),
        .HEX2              (HEX2)
    );

    stored_code_register u_stored_code (
        .clk           (CLOCK_50),
        .sys_reset     (sys_reset),
        .load_new_code (load_new_code),
        .new_code      (entered_code),
        .stored_code   (stored_code)
    );

    comparator u_comparator (
        .entered_code (entered_code),
        .stored_code  (stored_code),
        .match_now    (match_now)
    );

    mode_programming_controller u_mode_prog (
        .clk           (CLOCK_50),
        .sys_reset     (sys_reset),
        .unlocked      (unlocked),
        .SW7           (SW[7]),
        .full4         (full4),
        .program_mode  (program_mode),
        .load_new_code (load_new_code)
    );

endmodule

