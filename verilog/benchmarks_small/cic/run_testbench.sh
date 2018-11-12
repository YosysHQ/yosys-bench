#!/bin/sh

iverilog -o cic5_tb.vvp cic5_tb.v cic5.v
vvp cic5_tb.vvp
