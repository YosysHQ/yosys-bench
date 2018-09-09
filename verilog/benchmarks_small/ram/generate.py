#!/usr/bin/env python3

## Generate population count of a specified width

import math

def gen_syncram(addrWidth, ioWidth, template):
    with open("syncram_%d_%d.v" % (addrWidth, ioWidth), "w") as f:
        print(template.replace("<w>", str(addrWidth)).replace("<s>", str(ioWidth)), file=f)

with open('syncram.template','rt') as templatefile:
    template = templatefile.read()
    
    for ioWidth in [4,8,12,16]:
        for addrBits in [4,8,9,10,11,12]:
            gen_syncram(addrBits, ioWidth, ''.join(template))
