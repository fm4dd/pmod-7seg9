// -------------------------------------------------------
// This module is the driver interface for the 7seg9 PMOD.
//
// Return-to-Idle logic allows repeating updates triggered
// by the top-level 10Hz reset pulse.
// -------------------------------------------------------
module ctl_7seg9 #(
    parameter CLK_FREQ = 10_000_000
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [71:0] data_pack,
    input  wire [2:0]  level,
    input  wire        on,
    output wire        tm_clk,
    output wire        tm_din,
    output wire        tm_busy
);

    reg [7:0] instruction_step;
    reg [7:0] tm_byte;
    reg       tm_latch, tm_end;
    wire      drv_busy;

    // -------------------------------------------------------
    // Unpack segment data (Digit 1 is at index 0)
    // -------------------------------------------------------
    wire [7:0] led_data [0:8];
    assign led_data[0] = data_pack[7:0];   assign led_data[1] = data_pack[15:8];
    assign led_data[2] = data_pack[23:16];  assign led_data[3] = data_pack[31:24];
    assign led_data[4] = data_pack[39:32];  assign led_data[5] = data_pack[47:40];
    assign led_data[6] = data_pack[55:48];  assign led_data[7] = data_pack[63:56];
    assign led_data[8] = data_pack[71:64];

    tm1640 #(.CLK_FREQ(CLK_FREQ)) ic1 (
        .clk(clk), .rst(rst), 
        .data_latch(tm_latch), .data_in(tm_byte), .data_stop_bit(tm_end),
        .busy(drv_busy), .tm_clk(tm_clk), .tm_din(tm_din)
    );

    always @(posedge clk) begin
        if (rst) begin
            instruction_step <= 1; // Start sequence on rst pulse
            tm_latch <= 0;
        end else begin
            tm_latch <= 0; // Pulse latch only 1 cycle

            if (!drv_busy && !tm_latch && instruction_step != 0) begin
                case (instruction_step)
                    // 1. Data Setting (Auto-increment mode)
                    1: begin tm_byte <= 8'b01000000; tm_end <= 1; tm_latch <= 1; end
                    
                    // 2. Address Setting (Start 00H)
                    2: begin tm_byte <= 8'b11000000; tm_end <= 0; tm_latch <= 1; end
                    
                    // 3-11. Data Stream (9 Digits)
                    3,4,5,6,7,8,9,10: begin 
                        tm_byte <= led_data[instruction_step-3]; 
                        tm_end <= 0; tm_latch <= 1; 
                    end
                    11: begin 
                        tm_byte <= led_data[8]; 
                        tm_end <= 1; tm_latch <= 1; // STOP after last data byte
                    end

                    // 12. Display Control (ON + Brightness)
                    12: begin 
                        tm_byte <= {4'b1000, on, level}; 
                        tm_end <= 1; tm_latch <= 1; 
                    end
                endcase

                if (instruction_step == 12) instruction_step <= 0;
                else instruction_step <= instruction_step + 1;
            end
        end
    end
    assign tm_busy = (instruction_step != 0 || drv_busy);
endmodule
