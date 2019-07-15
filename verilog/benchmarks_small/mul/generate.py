#!/usr/bin/env python3

ARange = [4,8,16,24,25]
BRange = [2,4,8,16,18]

# https://stackoverflow.com/a/1482316
from itertools import chain, combinations
def powerset(iterable):
    "powerset([1,2,3]) --> () (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)"
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

for A in ARange:
    for B in BRange:
        for R in map(lambda i:''.join(i), powerset("ABP")):
            with open("mul_%d_%d_%s.v" % (A,B,R), "w") as f:
                print("""
(* top *)
module mul_{0}_{1}_{2} #(parameter AW={0}, parameter BW={1}, AREG={3}, BREG={4}, OREG={5}) (input clk, input [AW-1:0] A, input [BW-1:0] B, output reg [AW+BW-1:0] o);
reg [AW-1:0] Ar;
reg [BW-1:0] Br;
generate
    if (AREG)
        always @(posedge clk) Ar <= A;
    else
        always @* Ar <= A;
    if (BREG)
        always @(posedge clk) Br <= B;
    else
        always @* Br <= B;
    if (OREG)
        always @(posedge clk) o <= A *B;
    else
        always @* o <= A * B;
endgenerate
endmodule""".format(A,B,R,'1' if 'A' in R else '0', '1' if 'B' in R else '0', '1' if 'O' in R else '0'), file=f)
            with open("mul_%d_%d_%s.v" % (B,A,R), "w") as f:
                print("""
(* top *)
module mul_{0}_{1}_{2} #(parameter AW={0}, parameter BW={1}, AREG={3}, BREG={4}, OREG={5}) (input clk, input [AW-1:0] A, input [BW-1:0] B, output reg [AW+BW-1:0] o);
reg [AW-1:0] Ar;
reg [BW-1:0] Br;
generate
    if (AREG)
        always @(posedge clk) Ar <= A;
    else
        always @* Ar <= A;
    if (BREG)
        always @(posedge clk) Br <= B;
    else
        always @* Br <= B;
    if (OREG)
        always @(posedge clk) o <= A *B;
    else
        always @* o <= A * B;
endgenerate
endmodule""".format(B,A,R,'1' if 'B' in R else '0', '1' if 'A' in R else '0', '1' if 'O' in R else '0'), file=f)
