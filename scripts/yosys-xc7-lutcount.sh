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
    echo "read -vhdl $1" > script.yos
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > script.yos
fi
echo "synth_xilinx -top $topmodule" >> script.yos

# run tools
yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
sed -r '1,/^[0-9\.]+ Printing statistics\.$/d' -i $logfile
grep -q 'LUT1' $logfile && sed -rn 's/\s+LUT1\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT2' $logfile && sed -rn 's/\s+LUT2\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT3' $logfile && sed -rn 's/\s+LUT3\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT4' $logfile && sed -rn 's/\s+LUT4\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT5' $logfile && sed -rn 's/\s+LUT5\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT6' $logfile && sed -rn 's/\s+LUT6\s+([0-9]+)/\1/p' $logfile || echo '0'
rm -f $logfile
rm -f script.yos
