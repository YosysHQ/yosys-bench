#!/usr/bin/env python3

import imp, os
f, path, desc = imp.find_module("generate", [os.path.join('..','..','benchmarks_small','mux')])
for k,v in imp.load_module('*', f, path, desc).__dict__.items():
    if not k.startswith('__'):
        globals()[k] = v

if __name__ == "__main__":
    for N in [63,64,65] + [127,128,129] + [255,256,257]:
        for W in [8,16,32]:
            gen_mux_index(N,W)
            gen_mux_case(N,W)
            gen_mux_if(N,W)
