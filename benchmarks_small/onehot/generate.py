#!/usr/bin/env python3

## Generate one-hot to binary and binary to one-hot decoders

import math

def gen_bin2onehot(nBits):
    obits = int(math.pow(2,nBits))    # calculate output bits
    with open("bin2onehot_%d.v" % (nBits), "w") as f:
        print("""
module bin2onehot_<n> (input [<n>-1:0] din, output reg [<b>-1:0] dout);
  always @(din) begin
    dout = 0;
    dout[din] = 1'b1;
  end
endmodule
""".replace("<n>", str(nBits)).replace("<b>", str(obits)), file=f)


def gen_onehot2bin(nBits):
    obits = int(math.ceil(math.log2(nBits)))    # calculate output bits
    with open("onehot2bin_%d.v" % (nBits), "w") as f:
        print("""
module onehot2bin_<n> (input [<n>-1:0] din, output reg [<b>-1:0] dout);
  always @(din) begin
    dout = 0;
    case(din)
""".replace("<n>", str(nBits)).replace("<b>", str(obits)), file=f)
        ## emit switch case data..
        for I in range(0, nBits):
            print("""      <n>'d<t> : dout = <b>'d<i>;""".replace("<t>", str(int(math.pow(2,I)))).replace("<i>", str(I)).replace("<b>", str(obits)).replace("<n>", str(nBits)), file=f)
        print("""
      default: ;
    endcase
  end
endmodule""", file=f)
        

for nBits in [1,2,3,4,5,6,7,8]:
    gen_bin2onehot(nBits)

for nBits in [1,2,3,4,5,6,7,8,16,32,64]:
    gen_onehot2bin(nBits)
