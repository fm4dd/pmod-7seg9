// -------------------------------------------------------
// pmod_7seg9_2: counter demo program for the 7seg9 PMOD
//
// Description:
// ------------
// This program creates a timer counter on the display.
// The last 9th digit counts one tenth of a second. 
// The 7th and 6th digit count seconds from 0..59.
// The 4th and 3rd digit count the minutes from 0..59,
// and the 1st digit shows the hour count from 0..9.
//
// The display looks like this:
//                                 "0-12-44-7"
//                                  h-mm-ss-t
//
// 'rst' is set to FIRE1 (BTN_F1 = R1) and has pos. logic,
// but is not used. The timing is for IceBreaker clk 12MHz
// -------------------------------------------------------
module pmod_7seg9_2(
   input wire clk,
   input wire rst,
   output wire tm_clk,
   output wire tm_din
);

reg tm_busy;
reg [2:0] level;
initial level = 3'd4;    // display brightness 4 (0..7)
reg on;
reg local_rst;

// -------------------------------------------------------
// create LED segment data packed array, because yosys can't
// handle 2-dimensional port assignments from system verilog.
// https://old.reddit.com/r/yosys/comments/44d7v6/arrays_as_inputs_to_modules/
// -------------------------------------------------------
wire [7:0] led_data [0:9];   // LED segment data, 9-digits
wire [71:0] led_data_packed; // 1-dim array for port handover
assign led_data_packed[7:0]   = led_data[0];
assign led_data_packed[15:8]  = led_data[1];
assign led_data_packed[23:16] = led_data[2];
assign led_data_packed[31:24] = led_data[3];
assign led_data_packed[39:32] = led_data[4];
assign led_data_packed[47:40] = led_data[5];
assign led_data_packed[55:48] = led_data[6];
assign led_data_packed[63:56] = led_data[7];
assign led_data_packed[71:64] = led_data[8];

ctl_7seg9 m1(clk, local_rst, led_data_packed, level, on, tm_clk, tm_din, tm_busy);

// -------------------------------------------------------
// Convert number data to LED segment patterns
// -------------------------------------------------------
hexdigit d9(data[0], 0, led_data[0]);
hexdigit d2(data[1], 0, led_data[1]);
hexdigit d3(data[2], 0, led_data[2]);
hexdigit d4(data[3], 0, led_data[3]);
hexdigit d5(data[4], 0, led_data[4]);
hexdigit d6(data[5], 0, led_data[5]);
hexdigit d7(data[6], 0, led_data[6]);
hexdigit d8(data[7], 0, led_data[7]);
hexdigit d1(data[8], 0, led_data[8]);

// -------------------------------------------------------
// create 10Hz clock
// -------------------------------------------------------
reg [23:0] count = 24'd0;
reg clk_10hz = 1'b0;

always @(posedge clk)
begin
   count <= count + 1;
   if(count == 24'd599999)
   begin
      count   <= 0;
      clk_10hz <= ~clk_10hz;
      local_rst <= 1;
   end
   if(local_rst == 1) local_rst <= 0;
end

// -------------------------------------------------------
// create time counter display logic
// -------------------------------------------------------
reg [3:0] digit_counter;
reg [3:0] sec_counter;
reg [3:0] tensec_counter;
reg [3:0] min_counter;
reg [3:0] tenmin_counter;
reg [3:0] hour_counter;

initial begin
  digit_counter   = 4'd0;
  sec_counter     = 4'd0;
  tensec_counter  = 4'd0;
  min_counter     = 4'd0;
  tenmin_counter  = 4'd0;
  hour_counter    = 4'd0;
end

always @(posedge clk_10hz) begin
   if(digit_counter == 9) begin
      digit_counter = 0;
      if(sec_counter == 9) begin
         sec_counter = 0;
         if(tensec_counter == 5) begin
            tensec_counter = 0;
            if(min_counter == 9) begin
               min_counter = 0;
               if(tenmin_counter == 5) begin
                  tenmin_counter = 0;
                  if(hour_counter == 9) hour_counter = 0;
                  else hour_counter = hour_counter + 1;
               end
               else tenmin_counter = tenmin_counter + 1;
            end
            else min_counter = min_counter + 1;
         end
         else tensec_counter = tensec_counter + 1;
      end
      else sec_counter = sec_counter + 1;
   end
   else digit_counter = digit_counter + 1;
end

wire [4:0] data [0:8];          // data to show on digits
assign data[0] = hour_counter;  // set digit-1 as hours
assign data[1] = 5'd17;         // set digit-2 as 17 = "-"
assign data[2] = tenmin_counter;// set digit-3 as ten mins
assign data[3] = min_counter;   // set digit-4 as minutes
assign data[4] = 5'd17;         // set digit-5 as 17 = "-"
assign data[5] = tensec_counter;// set digit-6 as ten secs
assign data[6] = sec_counter;   // set digit-7 as seconds
assign data[7] = 5'd17;         // set digit-8 as 17 = "-"
assign data[8] = digit_counter; // set digit-9 as tenth of s

endmodule
