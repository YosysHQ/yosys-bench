#!/usr/bin/env python3

## Generate a+b+c+d .. with inputs all the same width

import math

## extend the port given by the string 'word' by 'bits' zero bits
def extend(word, bits):
    return "{<b>'d0, <word>}".replace("<b>",str(bits)).replace("<word>", word);

def gen_adder(nInputs, nWidth):
    bits = int(math.ceil(math.log2(nInputs)))
    with open("addertree_%d_%d.v" % (nInputs, nWidth), "w") as f:
        body = extend("din[" + str(nWidth-1) + ":0]",bits)
        for I in range(2, nInputs+1):
            body = body + " + " + extend("din[" + str(nWidth*I-1) + ":" + str(nWidth*(I-1)) + "]", bits)
        body = body + ";"
        print("""
module addertree_<n>_<w> (input [<t>-1:0] din, output [<w>-1:0] dout);
  assign dout = <body>
endmodule
""".replace("<body>", body).replace("<n>", str(nInputs)).replace("<w>", str(nWidth)).replace("<t>", str(nWidth*nInputs)), file=f)

for nInputs in [3, 4, 5, 6, 7, 8]:
    for nWidth in [4, 5, 6, 7, 8]:
        gen_adder(nInputs, nWidth)
