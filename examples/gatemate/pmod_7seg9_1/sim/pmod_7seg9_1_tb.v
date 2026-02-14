`timescale 1ns / 1ps

module pmod_7seg9_1_tb;

    parameter SYSTEM_CLK = 10_000_000;
    parameter BRIGHTNESS = 4;
    parameter CLK_PERIOD = 100; 

    reg clk;
    wire tm_clk;
    wire tm_din;

    // Instantiate UUT
    pmod_7seg9_1 #(
        .SYSTEM_CLK(SYSTEM_CLK),
        .BRIGHTNESS(BRIGHTNESS)
    ) uut (
        .clk(clk),
        .tm_clk(tm_clk),
        .tm_din(tm_din)
    );

    // Clock generator
    always #(CLK_PERIOD/2) clk = ~clk;

    // --- LOGIC TO MONITOR COMMANDS AND DIGITS ---
    // This block triggers every time instruction_step changes
    always @(uut.instruction_step) begin
        case (uut.instruction_step)
            0:  $display("[%t] RESET: Initializing...", $time);
            1:  $display("[%t] SENDING: Command 1 (Data Setting 0x40)", $time);
            2:  $display("[%t] SENDING: Command 2 (Set Address 0xC0)", $time);
            3:  $display("[%t] SENDING: Digit 1 Data", $time);
            4:  $display("[%t] SENDING: Digit 2 Data", $time);
            5:  $display("[%t] SENDING: Digit 3 Data", $time);
            6:  $display("[%t] SENDING: Digit 4 Data", $time);
            7:  $display("[%t] SENDING: Digit 5 Data", $time);
            8:  $display("[%t] SENDING: Digit 6 Data", $time);
            9:  $display("[%t] SENDING: Digit 7 Data", $time);
            10: $display("[%t] SENDING: Digit 8 Data", $time);
            11: $display("[%t] SENDING: Digit 9 Data (Burst End)", $time);
            12: $display("[%t] SENDING: Command 3 (Brightness: %0d)", $time, BRIGHTNESS);
            13: $display("[%t] DONE: All instructions sent.", $time);
        endcase
    end

    // Monitor the driver state (optional, shows the low-level FSM)
    always @(uut.disp.cur_state) begin
        if (uut.disp.cur_state == 4'h3) // S_START
            $display("    --> Driver: Starting New Byte (0x%h)", uut.tm_byte);
        if (uut.disp.cur_state == 4'h8) // S_STOP
            $display("    --> Driver: Sending STOP bit");
    end

    initial begin
        clk = 0;
        $display("Starting TM1640 Top Module Simulation...");
        
        // Wait for the sequence to complete
        // We wait roughly 3ms to be safe given the 500kHz refresh rate
        #3000000; 

        $display("Simulation complete.");
        $finish;
    end

    initial begin
        $dumpfile("sim/pmod_7seg9_1_tb.vcd");
        $dumpvars(0, pmod_7seg9_1_tb);
    end

endmodule
