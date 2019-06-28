from math import log2, ceil

def gen_mux_index(N,W):
    with open("mux_index_%d_%d.v" % (N,W), "w") as f:
        print("""
(* top *)
module mux_index_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output [W-1:0] o);
assign o = i[s*W+:W];
endmodule
""".format(N,W), file=f)

def gen_mux_case(N,W):
    with open("mux_case_%d_%d.v" % (N,W), "w") as f:
        print("""
(* top *)
module mux_case_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @*
    case (s)""".format(N,W), file=f)
        for i in range( N):
            print("        {0}: o <= i[{0}*W+:W];".format(i), file=f)
        print("""        default: o <= {W{1'bx}};
    endcase
endmodule
""", file=f)

def gen_mux_if_unbal(N,W):
    with open("mux_if_unbal_%d_%d.v" % (N,W), "w") as f:
        print("""
(* top *)
module mux_if_unbal_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @*""".format(N,W), file=f)
        print("    if (s == 0) o <= i[0*W+:W];", file=f)
        for i in range(1,N):
            print("    else if (s == {0}) o <= i[{0}*W+:W];".format(i), file=f)
        print("    else o <= {W{1'bx}};", file=f)
        print("""
endmodule
""", file=f)

def _gen_mux_if_bal_rec(f, N, depth):
    indent = ' ' * depth
    if len(N) == 1:
        print("    {0}o <= i[{1}*W+:W];".format(indent, N[0]), file=f)
    else:
        print("    {0}if (s[{1}] == 1'b0)".format(indent, depth), file=f)
        i = ceil(log2(len(N))) - 1
        _gen_mux_if_bal_rec(f, N[:2**i], depth+1)
        if N[2**i:] != [None]*len(N[2**i:]):
            print("    {0}else".format(indent), file=f)
            _gen_mux_if_bal_rec(f, N[2**i:], depth+1)

def gen_mux_if_bal(N,W):
    with open("mux_if_bal_%d_%d.v" % (N,W), "w") as f:
        print("""
(* top *)
module mux_if_bal_{0}_{1} #(parameter N={0}, parameter W={1}) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @* begin""".format(N,W), file=f)
        pad = (2 ** int(ceil(log2(N)))) - N
        print("    o <= {{W{{1'bx}}}};", file=f)
        _gen_mux_if_bal_rec(f, list(range(N)) + [None]*pad, 0)
        print("""end
endmodule
""", file=f)
