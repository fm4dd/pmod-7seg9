module tm1640(
   input wire clk,
   input wire rst,
   input wire data_latch,
   input [7:0] data_in,
   input wire data_stop_bit,
   output reg busy,
   output reg tm_clk,
   output reg tm_din,
);

    reg [7:0] write_byte;
    reg [2:0] write_bit_count;
    reg write_stop_bit;

    reg [3:0] cur_state;
    reg [3:0] next_state;

    reg [9:0] wait_count;
    localparam [9:0] wait_time = 256; // at 12MHz that's about 47uS

    localparam [3:0]
        S_IDLE      = 4'h0,
        S_WAIT      = 4'h1,
        S_WAIT1     = 4'h2,
        S_START     = 4'h3,
        S_WRITE     = 4'h4,
        S_WRITE1    = 4'h5,
        S_WRITE2    = 4'h6,
        S_WRITE3    = 4'h7,
        S_STOP      = 4'h8,
        S_STOP1     = 4'h9;

    always @(posedge clk) begin
        if (rst) begin
            tm_clk <= 1;           // lines pulled high
            tm_din <= 1;
            cur_state <= S_IDLE;   // set up FSM
            next_state <= S_IDLE;
            wait_count <= 0;
            write_bit_count <= 0;
            busy <= 0;             // reset busy flag
        end
        else begin
            if (data_latch) begin  // data has been latch
                cur_state <= S_START;
                write_byte <= data_in;
                write_stop_bit <= data_stop_bit;
                busy <= 1;
            end
            else begin
                case (cur_state)
                    S_IDLE: begin
                        // idle waiting for a latch
                        tm_clk <= 1;
                        tm_din <= 1;
                        busy <= 0;
                    end

                    S_WAIT: begin
                        // setting up for a wait
                        wait_count <= 0;
                        cur_state <= S_WAIT1;
                    end

                    S_WAIT1: begin
                        // watching the counter till our wait is over
                        wait_count <= wait_count + 1;
                        if (wait_count == wait_time)
                            cur_state <= next_state;
                    end

                    S_START: begin
                        busy <= 1;
                        tm_din <= 0; // send start, wait, and go to write
                        cur_state <= S_WAIT;
                        next_state <= S_WRITE;
                    end

                    S_WRITE: begin
                        write_bit_count <= 0;
                        tm_clk <= 0;          // tick the clock
                        cur_state <= S_WAIT;
                        next_state <= S_WRITE1;
                    end

                    S_WRITE1:begin
                        busy <= 1;
                        // 1 to drive bus to low
                        // 0 to HiZ the bus and let pull up do the work
                        tm_din <= write_byte[write_bit_count]; // writes a bit
                        cur_state <= S_WAIT;
                        next_state <= S_WRITE2;
                    end

                    S_WRITE2: begin
                        tm_clk <= 1;         // tock the clock
                        cur_state <= S_WAIT;
                        next_state <= S_WRITE3;
                    end

                    S_WRITE3: begin
                        tm_clk <= 0;  // tick the clock
                        // advance the bit counter
                        if (write_bit_count != 7) begin
                            write_bit_count <= write_bit_count + 1;
                            cur_state <= S_WRITE1;
                        end
                        else begin
                            if(write_stop_bit) begin
                               tm_din <= 0;  // take DIN signal down
                               cur_state <= S_WAIT;
                               next_state <= S_STOP;
                            end
                            else begin
                               write_bit_count <= 0;
                               write_byte <= data_in;
                               write_stop_bit <= data_stop_bit;
                               busy <= 0;
                               cur_state <= S_WRITE1;
                            end
                        end
                    end

                    S_STOP: begin
                        tm_clk <= 1;         // tick the clock
                        cur_state <= S_WAIT;
                        next_state <= S_STOP1;
                    end

                    S_STOP1: begin
                        tm_din <= 1;         // DIN UP is signal for end
                        cur_state <= S_WAIT;
                        next_state <= S_IDLE;
                    end

                    default: begin
                        cur_state <= S_IDLE;
                    end
                endcase
            end
        end
    end
endmodule
