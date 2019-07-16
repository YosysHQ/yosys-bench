#!/usr/bin/env python3

ARange = [4,8,16,24,25]
BRange = [2,4,8,16,18]
rtl = """(* top *)
module mul_{0}_{1}_{2}_{3} #(parameter AW={0}, BW={1}, AREG={4}, BREG={5}, PREG={6}) (input clk, CEA, CEB, CEP, input [AW-1:0] A, input [BW-1:0] B, output reg [AW+BW-1:0] P);
reg [AW-1:0] Ar;
reg [BW-1:0] Br;
generate
    if (AREG) begin
        always @(posedge clk) if ({7}) Ar <= A;
    end
    else
        always @* Ar <= A;
    if (BREG) begin
        always @(posedge clk) if ({8}) Br <= B;
    end
    else
        always @* Br <= B;
    if (PREG) begin
        always @(posedge clk) if ({9}) P <= Ar * Br;
    end
    else
        always @* P <= Ar * Br;
endgenerate
endmodule"""

# https://stackoverflow.com/a/1482316
from itertools import chain, combinations
def powerset(iterable):
    "powerset([1,2,3]) --> () (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)"
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

for A in ARange:
    for B in BRange:
        for R in map(lambda i:''.join(i), powerset("ABP")): # Register existence
            for E in map(lambda i:''.join(i), powerset(R)): # Enable
                with open("mul_%d_%d_%s_%s.v" % (A,B,R,E), "w") as f:
                    print(rtl.format(A,B,R,E,'1' if 'A' in R else '0', '1' if 'B' in R else '0', '1' if 'P' in R else '0',
                        'CEA' if 'A' in E else '1', 'CEB' if 'B' in E else '1', 'CEP' if 'P' in E else '1'), file=f)
                if A != B:
                   with open("mul_%d_%d_%s_%s.v" % (B,A,R,E), "w") as f:
                        print(rtl.format(B,A,R,E,'1' if 'B' in R else '0', '1' if 'A' in R else '0', '1' if 'P' in R else '0',
                            'CEA' if 'B' in E else '1', 'CEB' if 'A' in E else '1', 'CEP' if 'P' in E else '1'), file=f)
