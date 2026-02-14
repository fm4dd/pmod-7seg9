// -------------------------------------------------------
// pmod_7seg9_3: Dual Up/Down 1Hz Counter
//
// Description:
// ------------
// This program displays a dual 4-digit counter.
// Left side: Counts DOWN from 0000 -> 9999 -> 9998...
// Right side: Counts UP from 0000 -> 0001 -> 0002...
// Middle (5th digit): Static dash "-".
// Heartbeat on debug_led.
// The SW3 button mapped as 'rst' toggles Start/Stop.
// -------------------------------------------------------
module pmod_7seg9_3 #(
    parameter CLK_FREQ = 10_000_000
)(
   input wire clk,
   input wire rst,         // Button SW3
   output wire tm_clk,
   output wire tm_din,
   output wire debug_led
);

reg [2:0] level = 3'd4;    
wire on = 1'b1;            
reg local_rst = 0;         
wire tm_busy;

// --- BCD Counter Registers (All start at 0) ---
reg [3:0] d_th=0, d_hu=0, d_te=0, d_on=0; 
reg [3:0] u_th=0, u_hu=0, u_te=0, u_on=0; 

reg [31:0] count = 0;      
reg run = 1'b0;            
reg blink_state = 0;       

// --- Wiring ---
wire [7:0] led_data [0:8];
wire [71:0] led_data_packed; 
wire press_edge;

// --- Sub-module Instantiations ---
debounce db_inst(clk, rst, press_edge);

// Packaging for TM1640
assign led_data_packed = {led_data[8], led_data[7], led_data[6], led_data[5], 
                          led_data[4], led_data[3], led_data[2], led_data[1], led_data[0]};

ctl_7seg9 #(.CLK_FREQ(CLK_FREQ)) m1(clk, local_rst, led_data_packed, level, on, tm_clk, tm_din, tm_busy);

// Convert BCD to segments (Fixed indices [0-8])
hexdigit h1({1'b0, d_th}, 1'b0, led_data[0]); // Left Down
hexdigit h2({1'b0, d_hu}, 1'b0, led_data[1]);
hexdigit h3({1'b0, d_te}, 1'b0, led_data[2]);
hexdigit h4({1'b0, d_on}, 1'b0, led_data[3]);
hexdigit h5(5'd17,        1'b0, led_data[4]); // Middle Dash
hexdigit h6({1'b0, u_th}, 1'b0, led_data[5]); // Right Up
hexdigit h7({1'b0, u_hu}, 1'b0, led_data[6]);
hexdigit h8({1'b0, u_te}, 1'b0, led_data[7]);
hexdigit h9({1'b0, u_on}, 1'b0, led_data[8]);

// --- Heartbeat LED Logic ---
assign debug_led = run ? blink_state : 1'b0;

// --- Main Control Logic ---
always @(posedge clk) begin
    local_rst <= 0; 

    if (press_edge) run <= ~run;

    if (run) begin
        if (count >= (CLK_FREQ - 1)) begin
            count <= 0;
            local_rst <= 1; 
            
            // --- UP COUNTER (Right) ---
            if (u_on == 9) begin
                u_on <= 0;
                if (u_te == 9) begin
                    u_te <= 0;
                    if (u_hu == 9) begin
                        u_hu <= 0;
                        u_th <= (u_th == 9) ? 0 : u_th + 1;
                    end else u_hu <= u_hu + 1;
                end else u_te <= u_te + 1;
            end else u_on <= u_on + 1;

            // --- DOWN COUNTER (Left) ---
            if (d_on == 0) begin
                d_on <= 9;
                if (d_te == 0) begin
                    d_te <= 9;
                    if (d_hu == 0) begin
                        d_hu <= 9;
                        if (d_th == 0) d_th <= 9;
                        else d_th <= d_th - 1;
                    end else d_hu <= d_hu - 1;
                end else d_te <= d_te - 1;
            end else d_on <= d_on - 1;

        end else begin
            count <= count + 1;
            // Generate 1Hz heartbeat
            if (count == (CLK_FREQ / 2)) blink_state <= 1;
            if (count == 0) blink_state <= 0;
        end
    end
end

endmodule
