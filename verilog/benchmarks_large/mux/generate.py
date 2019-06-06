#!/usr/bin/env python3

from common import *

if __name__ == "__main__":
    for N in [63,64,65] + [127,128,129] + [255,256,257]:
        for W in [8,16,32]:
            gen_mux_index(N,W)
            gen_mux_case(N,W)
            gen_mux_if_bal(N,W)
            gen_mux_if_unbal(N,W)
