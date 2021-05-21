module  \$_DFF_P_ (input D, C, output Q);
    (* is_ff *) TRELLIS_SLICE #(
        .GSR("DISABLED"),
        .CEMUX("1"),
        .CLKMUX("CLK"),
        .LSRMUX("LSR"),
        .REG0_REGSET("RESET"),
        .REG0_SD("0"),
    )  _TECHMAP_REPLACE_ (
        .CLK(C),
        .LSR(1'b0),
        .M0(D),
        .Q0(Q)
    );
endmodule

module \$lut (A, Y);
    parameter WIDTH = 0;
    parameter LUT = 0;

    (* force_downto *)
    input [WIDTH-1:0] A;
    output Y;

    wire [3:0] A_EXT = A;

    TRELLIS_SLICE #(
        .LUT0_INITVAL(LUT)
    ) _TECHMAP_REPLACE_ (
        .A0(A_EXT[0]),
        .B0(A_EXT[1]),
        .C0(A_EXT[2]),
        .D0(A_EXT[3]),
        .F0(Y)
    );
endmodule
