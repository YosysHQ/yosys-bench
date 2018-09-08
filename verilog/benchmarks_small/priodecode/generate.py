#!/usr/bin/env python3

## Priority decoders

import math

def gen_priodecoder(nBits):
    with open("priodecoder_%d.v" % (nBits), "w") as f:
        print("""
module priodecoder_<n> (input [<n>-1:0] din, output [<n>-1:0] dout);
  assign dout = din & (~din-1);
endmodule
""".replace("<n>", str(nBits)), file=f)

for nBits in range(2,16+1):
    gen_priodecoder(nBits)
