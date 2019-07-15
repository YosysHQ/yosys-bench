#!/usr/bin/env python3

ARange = [4,8,16,24,25]
BRange = [2,4,8,16,18]

for A in ARange:
    for B in BRange:
        with open("mul_%d_%d.v" % (A,B), "w") as f:
            print("""
(* top *)
module mul_{0}_{1} #(parameter A={0}, parameter B={1}) (input [A-1:0] i, input [B-1:0] s, output [A+B-1:0] o);
assign o = A * B;
endmodule
""".format(A,B), file=f)
        print(A,B)
        B,A = A,B
        print(A,B)
        with open("mul_%d_%d.v" % (A,B), "w") as f:
            print("""
(* top *)
module mul_{0}_{1} #(parameter A={0}, parameter B={1}) (input [A-1:0] i, input [B-1:0] s, output [A+B-1:0] o);
assign o = A * B;
endmodule
""".format(A,B), file=f)
