#!/usr/bin/env python3

from common import *

if __name__ == "__main__":
    for N in [2,3,4,5] + [7,8,9] + [15,16,17] + [31,32,33]:
        for W in [1,2,3,4,5,8]:
            gen_mux_index(N,W)
            gen_mux_case(N,W)
            gen_mux_if(N,W)
