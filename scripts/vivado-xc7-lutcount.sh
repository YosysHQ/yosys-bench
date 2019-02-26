#!/bin/bash

#
# mode script for Xilinx FPGA LUT count
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
echo "report_utilization -file $logfile" >> script.tcl

# run tools
vivado -mode batch -nolog -nojournal -source script.tcl > /dev/null
grep -q '^|\s\+LUT1' $logfile && sed -rn 's/^\|\s+LUT1\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+LUT2' $logfile && sed -rn 's/^\|\s+LUT2\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+LUT3' $logfile && sed -rn 's/^\|\s+LUT3\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+LUT4' $logfile && sed -rn 's/^\|\s+LUT4\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+LUT5' $logfile && sed -rn 's/^\|\s+LUT5\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+LUT6' $logfile && sed -rn 's/^\|\s+LUT6\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
rm -f $logfile
rm -f script.tcl
