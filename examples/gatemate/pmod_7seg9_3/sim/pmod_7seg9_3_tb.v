`timescale 1ns / 1ps

module pmod_7seg9_3_tb();

    localparam CLK_FREQ = 100_000; 
    localparam CLK_PERIOD = 100; 

    reg clk;
    reg rst;
    wire tm_clk;
    wire tm_din;
    wire debug_led;

    // --- Decoder Variables ---
    reg [7:0] shift_reg = 0;
    integer bit_count = 0;
    reg [7:0] display_mem [0:8]; 
    integer digit_idx = 0;

    pmod_7seg9_3 #(.CLK_FREQ(CLK_FREQ)) uut (
        .clk(clk), .rst(rst),
        .tm_clk(tm_clk), .tm_din(tm_din), .debug_led(debug_led)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // --- Decoder Function ---
    function [7:0] seg_to_char(input [7:0] seg);
        case (seg & 8'h7F)
            8'b0111111: seg_to_char = "0";
            8'b0000110: seg_to_char = "1";
            8'b1011011: seg_to_char = "2";
            8'b1001111: seg_to_char = "3";
            8'b1100110: seg_to_char = "4";
            8'b1101101: seg_to_char = "5";
            8'b1111101: seg_to_char = "6";
            8'b0000111: seg_to_char = "7";
            8'b1111111: seg_to_char = "8";
            8'b1101111: seg_to_char = "9";
            8'b1000000: seg_to_char = "-"; // Middle segment is dash
            8'b0000000: seg_to_char = " ";
            default:    seg_to_char = "?";
        endcase
    endfunction

    // --- TM1640 Sniffer ---
    always @(posedge tm_clk) begin
        // TM1640 is LSB First
        shift_reg <= {tm_din, shift_reg[7:1]};
        
        if (bit_count == 7) begin
            bit_count <= 0;
            // Check for Address Setting Command (0xC0 to 0xC8)
            if ({tm_din, shift_reg[7:1]} >= 8'hC0 && {tm_din, shift_reg[7:1]} <= 8'hC8) begin
                digit_idx <= {tm_din, shift_reg[7:1]} - 8'hC0;
            end 
            // Check for Data (not a command)
            else if ({tm_din, shift_reg[7:1]} < 8'h80 && digit_idx < 9) begin
                display_mem[digit_idx] <= {tm_din, shift_reg[7:1]};
                digit_idx <= digit_idx + 1;
            end
            // Check for Display Control (End of sequence)
            else if ({tm_din, shift_reg[7:1]} >= 8'h80 && {tm_din, shift_reg[7:1]} <= 8'h8F) begin
                $display("[%0t] >> DISPLAY: [%c%c%c%c] %c [%c%c%c%c]", $time,
                    seg_to_char(display_mem[0]), seg_to_char(display_mem[1]),
                    seg_to_char(display_mem[2]), seg_to_char(display_mem[3]),
                    seg_to_char(display_mem[4]), // Middle Dash
                    seg_to_char(display_mem[5]), seg_to_char(display_mem[6]),
                    seg_to_char(display_mem[7]), seg_to_char(display_mem[8])
                );
            end
        end else begin
            bit_count <= bit_count + 1;
        end
    end

    // Reset bit counter on Start condition
    always @(negedge tm_din) if (tm_clk) bit_count <= 0;

    initial begin
        $dumpfile("sim/pmod_7seg9_3_tb.vcd");
        $dumpvars(0, pmod_7seg9_3_tb);
        rst = 0;
        repeat(10) @(posedge clk);
        
        $display("[%0t] SIM: Pressing Start...", $time);
        rst = 1;
        repeat(20) @(posedge clk); 
        rst = 0;

        $monitor("[%0t] Count: L:%d%d%d%d R:%d%d%d%d", $time, 
                 uut.d_th, uut.d_hu, uut.d_te, uut.d_on,
                 uut.u_th, uut.u_hu, uut.u_te, uut.u_on);

        repeat(510000) @(posedge clk);
        $finish;
    end
endmodule
