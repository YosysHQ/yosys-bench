#!/usr/bin/env python3

import glob
import os
import matplotlib.pyplot as plt
import numpy as np

class delay:
    min_annotate_y = 0.95
    max_annotate_y = 1.2
    def pre():
        ax = plt.subplot(3, 1, 1)
        ax.grid(True, which='major')
        ax.grid(True, which='minor', linestyle=':')
        ax.minorticks_on()
        ax.set_axisbelow(True)
        plt.ylabel('Post-synth delay normalised to Vivado')
        plt.axhline(1.0, color='0.5', linewidth=0.5, linestyle='-')
    def post():
        plt.legend()
        plt.xlim(left=0)
    def str2float(s): 
        try:
            return float(s)
        except ValueError:
            return 0
    def values():
        return [
            ('vivado-xc7-postsynth-setup', delay.str2float),
            ('yosys-xc7-vivado-postsynth-setup-0.8', delay.str2float),
        ]


class area:
    ylim = 3
    min_annotate_y = 1
    max_annotate_y = ylim
    def pre():
        ax = plt.subplot(3, 1, 2)
        ax.grid(True, which='major')
        ax.grid(True, which='minor', linestyle=':')
        ax.minorticks_on()
        ax.set_axisbelow(True)
        plt.axhline(1.0, color='0.5', linewidth=0.5, linestyle='-')
        plt.ylabel('Composite area normalised to Vivado\n(sum(LUT1-5)/2+LUT6) ')
        plt.ylim(top=area.ylim)
    def post():
        plt.legend()
        plt.xlim(left=0)
    def nluts2area(s): 
        luts = list(map(int, s.split()))
        return sum(luts[:5])/2 + luts[5]
    def values():
        return [
            ('vivado-xc7-lutcount', area.nluts2area),
            ('yosys-xc7-lutcount-0.8', area.nluts2area),
        ]

class flop:
    ylim = 2
    min_annotate_y = 1
    max_annotate_y = 1.1
    def pre():
        ax = plt.subplot(3, 1, 3)
        ax.grid(True, which='major')
        ax.grid(True, which='minor', linestyle=':')
        ax.minorticks_on()
        ax.set_axisbelow(True)
        plt.axhline(1.0, color='0.5', linewidth=0.5, linestyle='-')
        plt.ylabel('Flops normalised to Vivado')
        plt.xlabel('Benchmark Number')
        plt.ylim(top=flop.ylim)
    def post():
        plt.legend()
        plt.xlim(left=0)
    def sum_ints(s): 
        ints = list(map(int, s.split()))
        return sum(ints)
    def values():
        return [
            ('vivado-xc7-flopcount', flop.sum_ints),
            ('yosys-xc7-flopcount-0.8', flop.sum_ints),
        ]

subplots = [
    delay,
    area,
    flop,
]

fig,_ = plt.subplots(figsize=(20,len(subplots)*3))
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
                except ZeroDivisionError:
                    v.append(1 if f(r) == 0 else float('inf'))
        if j == 0: continue
        array = np.array([(x,v[j]) for x,(k,v) in enumerate(sorted(data.items()))])
        plt.scatter(array[:,0], array[:,1], color=cmap(j-1), s=3, marker='x', linewidth=0.5, label=d)
        try:
            over_array = array[array[:,1]>e.ylim]
            plt.scatter(over_array[:,0], [e.ylim]*len(over_array), color=cmap(j-1), s=3, marker='x', linewidth=0.5, zorder=1000)
        except AttributeError:
            pass
        last_min = float('-inf')
        last_max = float('-inf')
        for x,(k,v) in enumerate(sorted(data.items())):
            if v[j] > 0 and v[j] < e.min_annotate_y and x - last_min >= 10:
                plt.text(s=k, x=x, y=max(v[j], plt.ylim()[0]), rotation=-45, fontsize=6, ha='left', va='top', color=cmap(j-1))
                last_min = x
            if v[j] > e.max_annotate_y and x - last_max >= 10:
                plt.text(s=k, x=x, y=min(v[j], plt.ylim()[1]), rotation=45, fontsize=6, ha='left', va='bottom', color=cmap(j-1))
                last_max = x

    e.post()

fig.savefig("norm-area-delay.pdf", bbox_inches="tight")
