#!/usr/bin/env python3

## Generate various synchronous RAM types with 2^<w> addresses and <s> bit data path.

import math

# generic synchronous RAM
def gen_syncram(addrWidth, ioWidth, template):
    with open("syncram_%d_%d.v" % (addrWidth, ioWidth), "w") as f:
        print(template.replace("<w>", str(addrWidth)).replace("<s>", str(ioWidth)), file=f)

# generic synchronous RAM with transparent write-through
def gen_syncram_tw(addrWidth, ioWidth, template):
    with open("syncram_tw_%d_%d.v" % (addrWidth, ioWidth), "w") as f:
        print(template.replace("<w>", str(addrWidth)).replace("<s>", str(ioWidth)), file=f)

# generic single-write/single-read synchronous RAM
def gen_dualportsyncram(addrWidth, ioWidth, template):
    with open("dualport_syncram_%d_%d.v" % (addrWidth, ioWidth), "w") as f:
        print(template.replace("<w>", str(addrWidth)).replace("<s>", str(ioWidth)), file=f)



with open('syncram.template','rt') as templatefile:
    template = templatefile.read()
    
    for ioWidth in [4,8,12,16]:
        for addrBits in [4,8,9,10,11,12]:
            gen_syncram(addrBits, ioWidth, ''.join(template))

with open('syncram_tw.template','rt') as templatefile:
    template = templatefile.read()
    
    for ioWidth in [4,8,12,16]:
        for addrBits in [4,8,9,10,11,12]:
            gen_syncram_tw(addrBits, ioWidth, ''.join(template))

with open('dualport_syncram.template','rt') as templatefile:
    template = templatefile.read()
    
    for ioWidth in [4,7,8,12,16]:
        for addrBits in [4,8,9,10,11,12]:
            gen_dualportsyncram(addrBits, ioWidth, ''.join(template))
