#!/usr/bin/env python3

## Generate a pipelined CORDIC with a certain number of iteration stages
## The script must also generate the angle table
##
## <w> = bit width of cordic stage
## <s> = number of stages
## <v> = cordic vector start magnitude, approx 0.6199505
## <g> = generated calls to cordic_stage
##
## https://github.com/cebarnes/cordic/blob/master/cordic.v

import math

def gen_cordic(stages, bits, template):
    amp = 1.0
    for I in range(0,stages):
        amp = amp * math.sqrt(1.0 + math.pow(2.0,-2*I))

    print("Cordic gain compensation factor is " + str(1.0/amp))
    startval = int( math.floor((2**(bits-2)-1) / amp) )

    template = template.replace("<w>", str(bits)).replace("<s>", str(stages))
    template = template.replace("<v>", str(bits)+"'d"+str(startval))

    ## generate calls to cordic_stage    
    
    gen = "    cordic_stage_<w> #(0) stage0(clk, rst_n, x_in, y_in, z_in, <a>, xbus[0], ybus[0], zbus[0]);\n"
    tanval = int( round((2**(bits)) * 0.125,0) )
    gen = gen.replace("<a>", str(bits) + "'sd" + str(tanval))
    gen = gen.replace("<w>", str(bits))

    s = "    cordic_stage_<w> #(<j>) stage<j>(clk, rst_n, xbus[<i>], ybus[<i>], zbus[<i>], <a>, xbus[<j>], ybus[<j>], zbus[<j>]);"
    for I in range(1,stages):
        tanval = int( round((2**(bits)) * math.atan(math.pow(2.0, -I))/(2.0*3.14159265359),0) )
        gen_s = s.replace("<i>", str(I-1)).replace("<a>", str(bits) + "'sd" + str(tanval)) + "\n"
        gen_s = gen_s.replace("<j>",str(I))
        gen_s = gen_s.replace("<w>",str(bits))
        gen = gen + gen_s
        

    template = template.replace("<g>", gen)

    with open("cordic_%d_%d.v" % (stages, bits), "w") as f:
        print(template, file=f)

with open('cordic.template','rt') as templatefile:
    template = templatefile.read()
    
    for stages in [4,5,6,7,8,9,10]:
        for bits in [8,12,16]:
            gen_cordic(stages, bits, ''.join(template))
