// -------------------------------------------------------
// Simplified Debounce Module
// -------------------------------------------------------
module debounce(
    input  wire clk,
    input  wire in,
    output reg  press_edge
);
    localparam CNT_20MS = 200_000;    
    reg [17:0] stable_cnt = 0;
    reg button_sync_0, button_sync_1;
    reg button_stable = 0;
    reg button_prev = 0;

    always @(posedge clk) begin
        button_sync_0 <= in;
        button_sync_1 <= button_sync_0;

        if (button_sync_1 == button_stable) begin
            stable_cnt <= 0;
        end else begin
            stable_cnt <= stable_cnt + 1;
            if (stable_cnt >= CNT_20MS) begin
                button_stable <= button_sync_1;
                stable_cnt <= 0;
            end
        end

        press_edge <= 0;
        button_prev <= button_stable;

        if (button_stable && !button_prev) begin
            press_edge <= 1;
        end
    end
endmodule
