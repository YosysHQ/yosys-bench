#!/bin/sh

ghdl -a pwm256.m.vhdl
ghdl -a pwm256_tb.m.vhdl
ghdl -e pwm256_tb
ghdl -r pwm256_tb --wave=pwm256_tb.ghw
