#!/bin/bash

#
# mode script for Xilinx FPGA FF count
#

tmpdir=$( mktemp -d )
logfile=$tmpdir/log.out

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read_vhdl $1" > $tmpdir/script.tcl
else
    topmodule=$( basename -s .v "$1")
    echo "read_verilog $1" > $tmpdir/script.tcl
fi
echo "synth_design -top $topmodule -part XC7A100TCSG324-1" >> $tmpdir/script.tcl
echo "report_utilization -file $logfile" >> $tmpdir/script.tcl

# run tools
vivado -mode batch -nolog -nojournal -source $tmpdir/script.tcl > /dev/null
grep -q '^|\s\+FDRE' $logfile && sed -rn 's/^\|\s+FDRE\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+FDRE_1' $logfile && sed -rn 's/^\|\s+FDRE_1\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+FDCE' $logfile && sed -rn 's/^\|\s+FDCE\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+FDCE_1' $logfile && sed -rn 's/^\|\s+FDCE_1\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+FDPE' $logfile && sed -rn 's/^\|\s+FDPE\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep -q '^|\s\+FDPE_1' $logfile && sed -rn 's/^\|\s+FDPE_1\s+\|\s+([0-9]+)\s+\|.*/\1/p' $logfile || echo '0'
grep '^|\s\+FD' $logfile >> /home/eddie/fd.log
rm -rf $tmpdir
