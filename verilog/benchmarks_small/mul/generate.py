#!/usr/bin/env python3

ARange = [4,8,16,24,25]
BRange = [2,4,8,16,18]

for A in ARange:
    for B in BRange:
        with open("mul_%d_%d.v" % (A,B), "w") as f:
            print("""
(* top *)
module mul_{0}_{1} #(parameter AW={0}, parameter BW={1}) (input [AW-1:0] A, input [BW-1:0] B, output [AW+BW-1:0] o);
assign o = A * B;
endmodule
""".format(A,B), file=f)
        with open("mul_%d_%d.v" % (B,A), "w") as f:
            print("""
(* top *)
module mul_{0}_{1} #(parameter AW={0}, parameter BW={1}) (input [AW-1:0] A, input [BW-1:0] B, output [AW+BW-1:0] o);
assign o = A * B;
endmodule
""".format(B,A), file=f)
