#!/usr/bin/env python3

## Generate a pipelined CORDIC with a certain number of iteration stages
## The script must also generate the angle table
##
## <w> = bit width of cordic stage
## <s> = number of stages
## <v> = cordic vector start magnitude, approx 0.6199505
## <g> = generated calls to cordic_stage
##


import math

def gen_cordic(stages, bits, template):
    ## calculate the CORDIC gain so we can compensate this
    ## by reducing the input vector length to avoid overflow.
    ##
    ## the Nth stage has a gain of sqrt(1.0 + 2^-2N) when counting
    ## stages from 0.
    ##
    ## Total gain for 4 stages : 1.64248406575
    ##                5 stages : 1.64568891576
    ##                6 stages : 1.64649227871
    ## 

    amp = 1.0
    for I in range(0,stages):
        amp = amp * math.sqrt(1.0 + math.pow(2.0,-2*I))

    startval = int( math.floor((2**(bits-1)-1) / amp) )

    template = template.replace("<v>", "to_signed(" + str(startval) + ",<w>)")
    template = template.replace("<w>", str(bits)).replace("<s>", str(stages))
    
    ## generate calls to cordic_stage    
    
    gen = "\n"
    gen = gen + " "*4 + "stage_0: entity work.cordic_stage_<w>(rtl)\n"
    gen = gen + " "*4 + "    generic map (shiftN => 0)\n"
    gen = gen + " "*4 + "    port map (clk, rst_n, x_in, y_in, z_in, <a>, xbus(0), ybus(0), zbus(0));\n\n"
    #gen = gen + "        clk    => clk,\n"
    #gen = gen + "        rst_n  => rst_n,\n"
    #gen = gen + "        x_in   => x_in,\n"
    #gen = gen + "        y_in   => y_in,\n"
    #gen = gen + "        y_in   => y_in,\n"

    #gen = "    cordic_stage_<w> #(0) stage0(clk, rst_n, x_in, y_in, z_in, <a>, xbus[0], ybus[0], zbus[0]);\n"
    tanval = int( round((2**(bits)) * 0.125,0) )
    gen = gen.replace("<a>", "to_signed(" + str(tanval) + ",<w>)")
    gen = gen.replace("<w>", str(bits))

    s = ""
    s = s + " "*4 + "stage_<j>: entity work.cordic_stage_<w>(rtl)\n"
    s = s + " "*4 + "    generic map (shiftN => <j>)\n"
    s = s + " "*4 + "    port map (clk, rst_n, xbus(<i>), ybus(<i>), zbus(<i>), <a>, xbus(<j>), ybus(<j>), zbus(<j>));\n"

    for I in range(1,stages):
        tanval = int( round((2**(bits)) * math.atan(math.pow(2.0, -I))/(2.0*3.14159265359),0) )
        gen_s = s.replace("<i>", str(I-1)).replace("<a>", "to_signed(" + str(tanval) + ",<w>)") + "\n"
        gen_s = gen_s.replace("<j>",str(I))
        gen_s = gen_s.replace("<w>",str(bits))
        gen = gen + gen_s
        
    template = template.replace("<g>", gen)

    with open("cordic_%d_%d.vhdl" % (stages, bits), "w") as f:
        print(template, file=f)

with open('cordic.template','rt') as templatefile:
    template = templatefile.read()
    
    for stages in [4,5,6,7,8,9,10]:
        for bits in [8,12,16]:
            gen_cordic(stages, bits, ''.join(template))
