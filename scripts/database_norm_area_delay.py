#!/usr/bin/env python3

import glob
import os
import matplotlib.pyplot as plt

class delay:
    min_annotate_y = 1.2
    def pre():
        ax = plt.subplot(2, 1, 1)
        ax.grid(True, which='major')
        ax.grid(True, which='minor', linestyle=':')
        ax.minorticks_on()
        plt.ylabel('Post-synth delay normalised to Vivado')
        plt.axhline(1.0, color='0.5', linewidth=0.5, linestyle='-')
    def post():
        plt.xlim(left=0)
    def str2float(s): 
        try:
            return float(s)
        except ValueError:
            return 0.001
    def values():
        return [
            ('vivado-xc7-postsynth-setup', delay.str2float),
            ('yosys-xc7-vivado-postsynth-setup-5706e90', delay.str2float),
        ]


class area:
    min_annotate_y = 3
    def pre():
        ax = plt.subplot(2, 1, 2)
        ax.grid(True, which='major')
        ax.grid(True, which='minor', linestyle=':')
        ax.minorticks_on()
        plt.axhline(1.0, color='0.5', linewidth=0.5, linestyle='-')
        plt.ylabel('Composite area normalised to Vivado\n(sum(LUT1-5)/2+LUT6) ')
        plt.xlabel('Benchmark Number')
        plt.ylim(top=3)
    def post():
        plt.xlim(left=0)
    def nluts2area(s): 
        luts = list(map(int, s.split()))
        return max(1,sum(luts[:5])/2 + luts[5])
    def values():
        return [
            ('vivado-xc7-lutcount', area.nluts2area),
            ('yosys-xc7-lutcount-5706e90', area.nluts2area),
        ]

subplots = [
    delay,
    area,
]

fig,_ = plt.subplots(figsize=(20,6))
cmap = plt.get_cmap("tab10")
for i,e in enumerate(subplots):
    e.pre()
    data = {}
    for j,(d,f) in enumerate(e.values()):
        for fn in glob.glob(os.path.join('database/%s/*.dat' % d)):
            bn,_ = os.path.splitext(os.path.basename(fn))
            r = open(fn).read().strip()
            if j == 0:
                data[bn] = [f(r)]
            else:
                try:
                    v = data[bn]
                    v.append(f(r)/v[0])
                except KeyError:
                    pass
    plt.plot([v[j] for k,v in sorted(data.items())], color=cmap(i))
    last_x = float('-inf')
    for x,(k,v) in enumerate(sorted(data.items())):
        if v[j] > e.min_annotate_y and x - last_x >= 10:
            plt.text(s=k, x=x, y=e.min_annotate_y, rotation=45, fontsize=6, ha='left', va='bottom')
            last_x = x
    e.post()

fig.savefig("norm-area-delay.pdf", bbox_inches="tight")
