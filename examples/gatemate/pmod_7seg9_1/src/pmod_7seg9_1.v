// -------------------------------------------------------
// This program turns on the display and shows "123456789"
//
// Adopted for TM1640 IC protocol from the TM1637 verilog
// example at https://github.com/alangarf/tm1637-verilog.
// -------------------------------------------------------
module pmod_7seg9_1 #(
    parameter SYSTEM_CLK = 10_000_000, // Gatemate E1 10Mhz clock
    parameter BRIGHTNESS = 4           // Default brightness (Range: 0-7)
)(
    input  clk,
    output tm_clk,
    output tm_din
);

    reg rst = 1;
    reg [7:0] instruction_step;
    reg tm_latch;
    reg [7:0] tm_byte;
    reg tm_end;
    wire tm_busy; 

    // Instantiate the tm1640 driver
    tm1640 #(
        .CLK_FREQ(SYSTEM_CLK)
    ) disp ( 
        .clk(clk), 
        .rst(rst), 
        .data_latch(tm_latch), 
        .data_in(tm_byte), 
        .data_stop_bit(tm_end),
        .busy(tm_busy), 
        .tm_clk(tm_clk), 
        .tm_din(tm_din) 
    );

    always @(posedge clk) begin
        if (rst) begin // rst runs only once at start time
            instruction_step <= 0;
            tm_latch <= 0;
            tm_byte <= 0;
            tm_end <= 0;
            rst <= 0;
        end
        else begin // start sending the list of instructions
            if (tm_busy == 0 && instruction_step < 13) begin
                case (instruction_step)
                    1: begin // Command 1: Data setting
                        // -------------------------------------------------
                        // Command1 | 0 | 1 | x | x | N | I | x | x | DATA
                        // N = Normal (0), I = Addr incr (0), x = N/A (0)
                        // -------------------------------------------------
                        tm_byte <= 8'b01000000; 
                        tm_end <= 1;
                        tm_latch <= 1;
                    end
                    2: begin // Command 2: Set LED Address 00H
                        // -------------------------------------------------
                        // Command2 | 1 | 1 | x | x | D | C | B | A | ADDR
                        // A,B,C,D =  LED adddress in bin (range 0x0..0xF)
                        // -------------------------------------------------
                        tm_byte <= 8'b11000000;
                        tm_end <= 0; 
                        tm_latch <= 1;
                    end
                        // -------------------------------------------------
                        // Steps 3-11: Send the LED data for the digits 1-9.
                        // The data bytes define which of the 7-segment LED
                        // segments should light up to display the numbers.
                        // tm_end=low indicates another data byte afterward
                        // -------------- 7-seg assignment ----------------
                        //                            a
                        //       e╶┐┌╴d              ────
                        //      f╶┐││┌╴c          f │    │
                        //     g╶┐││││┌╴b           │  g │ b
                        //   dp╶┐││││││┌╴a    ❯❯     ────
                        //   8'b00000000          e │    │
                        //                          │    │ c
                        //                           ────
                        //                             d   o dp
                        // -------------------------------------------------
                    3:  begin tm_byte <= 8'b00000110; tm_end <= 0; tm_latch <= 1; end // 1
                    4:  begin tm_byte <= 8'b01011011; tm_end <= 0; tm_latch <= 1; end // 2
                    5:  begin tm_byte <= 8'b01001111; tm_end <= 0; tm_latch <= 1; end // 3
                    6:  begin tm_byte <= 8'b01100110; tm_end <= 0; tm_latch <= 1; end // 4
                    7:  begin tm_byte <= 8'b01101101; tm_end <= 0; tm_latch <= 1; end // 5
                    8:  begin tm_byte <= 8'b01111100; tm_end <= 0; tm_latch <= 1; end // 6
                    9:  begin tm_byte <= 8'b00000111; tm_end <= 0; tm_latch <= 1; end // 7
                    10: begin tm_byte <= 8'b01111111; tm_end <= 0; tm_latch <= 1; end // 8
                    11: begin 
                        tm_byte <= 8'b01101111;                                       // 9
                        // -------------------------------------------------
                        // tm_end=high lets the driver pull clock and data lines high
                        // (STOP signal). This is needed after a burst of data before
                        // TM1640 will accept the "Display Control" command below.
                        // -------------------------------------------------
                        tm_end <= 1;
                        tm_latch <= 1; 
                    end
                    12: begin
                        // -------------------------------------------------
                        // Command3 | 1 | 0 | x | x | D | U | M | L | CTRL
                        // D = Display on/off, U = upper brightness bit,
                        // M = mid brightness bit, L = low brightness bit
                        // -------------------------------------------------
                        // Command 3: Display control
                        // Format: [1000][Display On/Off][3-bit Brightness]
                        // 1000_1xxx turns display ON.
                        tm_byte <= {4'b1000, 1'b1, BRIGHTNESS[2:0]};
                        tm_end <= 1;
                        tm_latch <= 1;
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
