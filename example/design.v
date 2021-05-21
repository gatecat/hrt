module top(input clk, input btn, output [7:0] led);

    reg [7:0] counter;

    reg do_count;

    debounce_repeat db_i (.clk(clk), .d(!btn), .q(do_count));

    always @(posedge clk)
        if (do_count)
`ifdef MODIFY
            counter <= counter - 1'b1;
`else
            counter <= counter + 1'b1;
`endif

    assign led = ~counter;

endmodule

module twoff #(parameter N = 1) (
    input clk,
    input [N-1:0] d,
    output reg [N-1:0] q
);
    reg [N-1:0] d2;
    always @(posedge clk) begin
        d2 <= d;
        q <= d2;
    end
endmodule

module debounce_repeat #(parameter DEBOUNCE_COUNT = 15, REPEAT_COUNT = 25) (
    input clk,
    input d,
    output reg q
);
    wire di;
    twoff #(1) d_sync(.clk(clk), .d(d), .q(di));
    reg [DEBOUNCE_COUNT-1:0] holdoff_ctr = 0;
    reg [REPEAT_COUNT-1:0] repeat_ctr = 0;

    always @(posedge clk) begin
        if (di) begin
            holdoff_ctr <= {DEBOUNCE_COUNT{1'b1}};
            repeat_ctr <= repeat_ctr + 1'b1;
        end else begin
            if (|holdoff_ctr) begin
                holdoff_ctr <= holdoff_ctr - 1'b1;
            end else begin
                repeat_ctr <= 1'b0;
            end
        end
        q <= !(|repeat_ctr) && di;
    end
endmodule
