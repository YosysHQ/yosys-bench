#!/bin/bash

#
# mode script for Xilinx FPGA timing
#

logfile=$( mktemp )
scriptpath=$( pwd )

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read_vhdl $1" > script.tcl
else
    topmodule=$( basename -s .v "$1")
    echo "read_verilog $1" > script.tcl
fi
echo "synth_design -top $topmodule -part XC7A100TCSG324-1" >> script.tcl
echo "create_clock -period 1 [get_nets -of [get_pins -filter {name =~ "*/C"} -of [all_ffs]]]" >> script.tcl
echo "report_design_analysis -timing -file $logfile" >> script.tcl

# run tools
vivado -mode batch -nolog -nojournal -source script.tcl > /dev/null
sed -rn 's/^\|\s+Path Delay\s+\|\s+([0-9\.]+).+/\1/p' $logfile
rm -f $logfile
rm -f script.tcl
