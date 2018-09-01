#!/usr/bin/env python3

## Generate population count of a specified width

import math

def gen_dspmac(opBits, accuBits, template):
    with open("dspmac_%d_%d.v" % (opBits, accuBits), "w") as f:
        print(template.replace("<w>", str(opBits)).replace("<s>", str(accuBits)), file=f)

with open('dspmac.template','rt') as templatefile:
    template = templatefile.read()
    
    for opBits in [8,12,16,20,24]:
        gen_dspmac(opBits, opBits*2+8, ''.join(template))

