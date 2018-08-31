#!/usr/bin/env python3

## Generate population count of a specified width

import math

def gen_popcount(nBits):
    obits = int(math.ceil(math.log2(nBits)))    # calculate output bits
    with open("popcount_%d.v" % (nBits), "w") as f:
        body = "din[0]"
        for I in range(1, nBits):
            body = body + " + din[" + str(I) + "]"
        body = body + ";"
        print("""
module popcount_<n> (input [<n>-1:0] din, output [<b>-1:0] dout);
  assign dout = <body>
endmodule
""".replace("<body>", body).replace("<n>", str(nBits)).replace("<b>", str(obits)), file=f)

for nBits in [2,3,4,5,6,7,8,16,32,64]:
    gen_popcount(nBits)
