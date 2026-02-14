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
// Logic: 
// The 'rst' is set to SW3 and has positive logic.
// - Single press: Toggle Start/Stop immediately.
// - Initial state: STOPPED
// -------------------------------------------------------
module pmod_7seg9_2 #(
    parameter CLK_FREQ = 10_000_000 // 10MHz for GateMate
)(
   input wire clk,
   input wire rst,         // Button SW3
   output wire tm_clk,
   output wire tm_din,
   output wire debug_led
);

reg [2:0] level = 3'd4;  // set LED brightness (0 is min, 7 is max)
wire on = 1'b1;            
reg local_rst = 0;         
wire tm_busy;

// -------------------------------------------------------
// Counter registers (BCD format)
// -------------------------------------------------------
reg [3:0] digit_counter = 0;
reg [3:0] sec_counter = 0;
reg [3:0] tensec_counter = 0;
reg [3:0] min_counter = 0;
reg [3:0] tenmin_counter = 0;
reg [3:0] hour_counter = 0;

reg [23:0] count = 0;      
reg run = 1'b0;         // Initial state set to STOPPED

// -------------------------------------------------------
// LED segment data packed array for Yosys
// -------------------------------------------------------
wire [7:0] led_data [0:8];
wire [71:0] led_data_packed; 
assign led_data_packed = {led_data[8], led_data[7], led_data[6], led_data[5], 
                          led_data[4], led_data[3], led_data[2], led_data[1], led_data[0]};

// -------------------------------------------------------
// Sub-module Instantiations
// -------------------------------------------------------
wire press_edge;
debounce db_inst(clk, rst, press_edge);

//ctl_7seg9 m1(clk, local_rst, led_data_packed, level, on, tm_clk, tm_din, tm_busy);
ctl_7seg9 #(.CLK_FREQ(CLK_FREQ)) m1(
    .clk(clk), 
    .rst(local_rst), 
    .data_pack(led_data_packed), 
    .level(level), 
    .on(on), 
    .tm_clk(tm_clk), 
    .tm_din(tm_din), 
    .tm_busy(tm_busy)
);

// -------------------------------------------------------
// Convert counter values to segment patterns (Fixed widths and indexing)
// -------------------------------------------------------
hexdigit d1({1'b0, hour_counter},   1'b0, led_data[0]);
hexdigit d2(5'd17,                  1'b0, led_data[1]); // "-"
hexdigit d3({1'b0, tenmin_counter}, 1'b0, led_data[2]);
hexdigit d4({1'b0, min_counter},    1'b0, led_data[3]);
hexdigit d5(5'd17,                  1'b0, led_data[4]); // "-"
hexdigit d6({1'b0, tensec_counter}, 1'b0, led_data[5]);
hexdigit d7({1'b0, sec_counter},    1'b0, led_data[6]);
hexdigit d8(5'd17,                  1'b0, led_data[7]); // "-"
hexdigit d9({1'b0, digit_counter},  1'b0, led_data[8]);

// -------------------------------------------------------
// Blink the D1 led of gatemate-e1 at 1Hz as "heartbeat"
// -------------------------------------------------------
assign debug_led = run ? (digit_counter >= 5) : 1'b0;

// -------------------------------------------------------
// Main Control Logic
// -------------------------------------------------------
always @(posedge clk) begin
    local_rst <= 0; 

    // Toggle Run/Stop on button press
    if (press_edge) begin
        run <= ~run;
    end

    // Increment counters if 'run' is active
    if (run) begin
        // (CLK_FREQ / 10) gives 10Hz
        if (count >= (CLK_FREQ / 10) - 1) begin
            count <= 0;
            local_rst <= 1; 
            
            if (digit_counter == 9) begin
                digit_counter <= 0;
                if (sec_counter == 9) begin
                    sec_counter <= 0;
                    if (tensec_counter == 5) begin
                        tensec_counter <= 0;
                        if (min_counter == 9) begin
                            min_counter <= 0;
                            if (tenmin_counter == 5) begin
                                tenmin_counter <= 0;
                                hour_counter <= (hour_counter == 9) ? 0 : hour_counter + 1;
                            end else tenmin_counter <= tenmin_counter + 1;
                        end else min_counter <= min_counter + 1;
                    end else tensec_counter <= tensec_counter + 1;
                end else sec_counter <= sec_counter + 1;
            end else digit_counter <= digit_counter + 1;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule
