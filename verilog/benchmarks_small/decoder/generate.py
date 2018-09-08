#!/usr/bin/env python3

## Simple decoders

def gen_decode(n, t):
    if t == 0: body = "assign dout = din[sel];"
    if t == 1: body = "assign dout = din >> sel;"
    if t == 2: body = "wire [<n>-1:0] p = din << sel; assign dout = p[<n>-1];"
    with open("decode_%d_%d.v" % (n, t), "w") as f:
        s = 1
        while 2**s < n:
            s += 1
        print("""
module decode_<n>_<t> (input [<s>-1:0] sel, input [<n>-1:0] din, output dout);
  <body>
endmodule
""".replace("<body>", body).replace("<n>", str(n)).replace("<t>", str(t)).replace("<s>", str(s)), file=f)

for n in [1, 2, 3, 4, 5, 6, 7, 8, 10, 15, 24, 32, 55, 64]:
    for t in range(3):
        gen_decode(n, t)


## Set/Clear bit

def gen_setclr(n, t, v):
    if t == 0: body = "dout[sel] = <v>;"
    if t == 1 and v == 0: body = "dout = dout & ~(1 << sel);"
    if t == 1 and v == 1: body = "dout = dout |  (1 << sel);"
    with open("%s_%d_%d.v" % ("set" if v else "clr", n, t), "w") as f:
        s = 1
        while 2**s < n:
            s += 1
        print("""
module <setclr>_<n>_<t> (input [<s>-1:0] sel, input [<n>-1:0] din, output reg [<n>-1:0] dout);
  always @* begin dout = din; <body> end
endmodule
""".replace("<body>", body).replace("<setclr>", "set" if v else "clr").replace("<n>", str(n)) \
   .replace("<t>", str(t)).replace("<s>", str(s)).replace("<v>", str(v)), file=f)

for n in [1, 2, 3, 4, 5, 6, 7, 8, 10, 15, 24, 32, 55, 64]:
    for t in range(2):
        for v in range(2):
            gen_setclr(n, t, v)

