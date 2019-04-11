#!/usr/bin/env python3

def gen_mux_index(N,W):
    with open("mux_index_%d_%d.v" % (N,W), "w") as f:
        print("""
module mux_index_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output [W-1:0] o);
assign o = i[s*W+:W];
endmodule
""".format(N,W), file=f)

def gen_mux_case(N,W):
    with open("mux_case_%d_%d.v" % (N,W), "w") as f:
        print("""
module mux_case_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @*
    case (s)""".format(N,W), file=f)
        for i in range( N):
            print("        {0}: o <= i[{0}*W+:W];".format(i), file=f)
        print("""        default: o <= {W{1'bx}};
    endcase
endmodule
""", file=f)

def gen_mux_if(N,W):
    with open("mux_if_%d_%d.v" % (N,W), "w") as f:
        print("""
module mux_if_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @*""".format(N,W), file=f)
        print("    if (s == 0) o <= i[0+:W];", file=f)
        for i in range(1,N):
            print("    else if (s == {0}) o <= i[{0}*W+:W];".format(i), file=f)
        print("    else o <= {W{1'bx}};", file=f)
        print("""
endmodule
""", file=f)


if __name__ == "__main__":
    for N in [2,3,4,5] + [7,8,9] + [15,16,17] + [31,32,33] + [63,64,65] + [127,128,129] + [255,256,257]:
        for W in [1,2,3,4,5,8,16,32]:
            gen_mux_index(N,W)
            gen_mux_case(N,W)
            gen_mux_if(N,W)
