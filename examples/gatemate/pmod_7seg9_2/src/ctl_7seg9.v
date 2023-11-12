// -------------------------------------------------------
// This module is the driver interface for the 7seg9 PMOD.
//
// Adopted for TM1640 IC protocol from the TM1637 verilog
// example at https://github.com/alangarf/tm1637-verilog.
// -------------------------------------------------------
module ctl_7seg9(
  input wire clk,              // SYSCLK
  input wire rst,              // SYSRESET, reset button
  input wire [71:0] data_pack, // digit data for display
  input wire [2:0] level,      // LED brightness level 0..7
  input wire on,               // display on / off
  output wire tm_clk,          // tm_clk wire
  output wire tm_din,          // tm_din wire
  output wire tm_busy          // tm_busy signal (optional)
);

localparam STEPS = 12;         // 3 cmds, 9-digit data bytes

reg [7:0] command1;
reg [7:0] command2;
reg [7:0] command3;
reg [7:0] instruction_step;
reg tm_latch;
reg [7:0] tm_byte;
reg tm_end;


// unpack the LED segment data from packed array, because
// https://old.reddit.com/r/yosys/comments/44d7v6/arrays_as_inputs_to_modules/
wire [7:0] led_data [0:8];
assign led_data[0] = data_pack[7:0];
assign led_data[1] = data_pack[15:8];
assign led_data[2] = data_pack[23:16];
assign led_data[3] = data_pack[31:24];
assign led_data[4] = data_pack[39:32];
assign led_data[5] = data_pack[47:40];
assign led_data[6] = data_pack[55:48];
assign led_data[7] = data_pack[63:56];
assign led_data[8] = data_pack[71:64];

initial begin
   // -------------------------------------------------
   // Command1 | 0 | 1 | x | x | N | I | x | x | DATA
   // N = Normal (0), I = Addr incr (0), x = N/A (0)
   // -------------------------------------------------
   command1 <= 8'b01000010; // auto-increment addr
   // -------------------------------------------------
   // Command2 | 1 | 1 | x | x | D | C | B | A | ADDR
   // A,B,C,D =  LED adddress in bin (range 0x0..0xF)
   // -------------------------------------------------
   command2 <= 8'b11000000; // start at addr 0x0
   // -------------------------------------------------
   // Command3 | 1 | 0 | x | x | D | U | M | L | CTRL
   // D = Display on/off, U = upper brightness bit,
   // M = mid brightness bit, L = low brightness bit
   // -------------------------------------------------
   command3 <= 8'b10001011; // on, half-brightness
end

tm1640 ic1(clk, rst, tm_latch, tm_byte, tm_end,
             tm_busy, tm_clk, tm_din);

always @(posedge clk) begin
  if (rst) begin
    instruction_step <= 0;
    tm_latch <= 0;
    tm_byte <= 0;
    tm_end <= 0;
  end
  else begin       // start sending instruction sequence
    if (tm_busy == 0 && instruction_step < (STEPS+1)) begin
      case (instruction_step)
        1: begin   // send command1
          tm_byte <= command1;
          tm_end <= 1; tm_latch <= 1;
        end
        2: begin   // send command2
          tm_byte <= command2;
          tm_end <= 0; tm_latch <= 1;
        end
        3: begin   // send display digit-1
          tm_byte <= led_data[0];
          tm_end <= 0; tm_latch <= 1;
        end
        4: begin   // send display digit-2
          tm_byte <= led_data[1];
          tm_end <= 0; tm_latch <= 1;
        end
        5: begin   // send display digit-3
          tm_byte <= led_data[2];
          tm_end <= 0; tm_latch <= 1;
        end
        6: begin   // send display digit-4
          tm_byte <= led_data[3];
          tm_end <= 0; tm_latch <= 1;
        end
        7: begin   // send display digit-5
          tm_byte <= led_data[4];
          tm_end <= 0; tm_latch <= 1;
        end
        8: begin   // send display digit-6
          tm_byte <= led_data[5];
          tm_end <= 0; tm_latch <= 1;
        end
        9: begin   // send display digit-7
          tm_byte <= led_data[6];
          tm_end <= 0; tm_latch <= 1;
        end
        10: begin   // send display digit-8
          tm_byte <= led_data[7];
          tm_end <= 0; tm_latch <= 1;
        end
        11: begin   // send display digit-9
          tm_byte <= led_data[8];
          tm_end <= 0; tm_latch <= 1;
        end
        12: begin   // send command3
          tm_byte <= command3;
          tm_end <= 1; tm_latch <= 1;
        end
      endcase
                    
      instruction_step <= instruction_step + 1;
    end
    else if (tm_busy == 1) begin
      tm_latch <= 0;
    end
  end
end

endmodule
