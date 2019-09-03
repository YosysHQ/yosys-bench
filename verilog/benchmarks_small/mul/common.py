

def rtl_mul(name, AW, BW, AREG, BREG, PREG, Asigned, Bsigned, CEA, CEB, CEP):
    return """(* top *)
module {0} #(parameter AW={1}, BW={2}, AREG={3}, BREG={4}, PREG={5}) (input clk, CEA, CEB, CEP, input {6}[AW-1:0] A, input {7}[BW-1:0] B, output reg {8}[AW+BW-1:0] P);
reg {6}[AW-1:0] Ar;
reg {7}[BW-1:0] Br;
generate
    if (AREG) begin
        always @(posedge clk) if ({9}) Ar <= A;
    end
    else
        always @* Ar <= A;
    if (BREG) begin
        always @(posedge clk) if ({10}) Br <= B;
    end
    else
        always @* Br <= B;
    if (PREG) begin
        always @(posedge clk) if ({11}) P <= Ar * Br;
    end
    else
        always @* P <= Ar * Br;
endgenerate
endmodule""".format(name, AW, BW, 
                    '1' if AREG else '0', '1' if BREG else '0', '1' if PREG else '0',
                    'signed ' if Asigned else '', 'signed ' if Bsigned else '', 'signed ' if Asigned and Bsigned else '',
                    'CEA' if CEA else '1', 'CEB' if CEB else '1', 'CEP' if CEP else '1')

# https://stackoverflow.com/a/1482316
from itertools import chain, combinations
def powerset(iterable):
    "powerset([1,2,3]) --> () (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)"
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))

def gen_mul(ARange, BRange):
    for A in ARange:
        for B in BRange:
            for R in map(lambda i:''.join(i), powerset("ABP")): # Register existence
                for E in map(lambda i:''.join(i), powerset("")): # Enable
                    with open("mul_%s_%s_%s_%s.v" % (A,B,R,E), "w") as f:
                        print(rtl_mul('mul_%s_%s_%s_%s' % (A,B,R,E),    # name
                                      A.rstrip('s'), B.rstrip('s'),     # [AB]W
                                      'A' in R, 'B' in R, 'P' in R,     # [ABP]REG
                                      's' in A, 's' in B,               # [AB]_signed
                                      'A' in E, 'B' in E, 'P' in E,     # CE[ABP]
                                      ), file=f)
                    if A != B:
                        with open("mul_%s_%s_%s_%s.v" % (B,A,R,E), "w") as f:
                            print(rtl_mul('mul_%s_%s_%s_%s' % (B,A,R,E),    # name
                                          B.rstrip('s'), A.rstrip('s'),     # [AB]W
                                          'B' in R, 'A' in R, 'P' in R,     # [ABP]REG
                                          's' in B, 's' in A,               # [AB]_signed
                                          'B' in E, 'A' in E, 'P' in E,     # CE[ABP]
                                          ), file=f)
