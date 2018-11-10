#!/bin/sh

iverilog -o pwm256_tb.vvp pwm256_tb.v pwm256.v
vvp pwm256_tb.vvp
