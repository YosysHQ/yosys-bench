#!/bin/bash

#
# mode script for Xilinx FPGA LUT count
#

tmpdir=$( mktemp -d )
logfile=$tmpdir/log.out

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read -vhdl $1" > $tmpdir/script.ys
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > $tmpdir/script.ys
fi
echo "synth_xilinx -top $topmodule" >> $tmpdir/script.ys

# run tools
yosys -ql $logfile -p "script $tmpdir/script.ys" >/dev/null
sed -r '1,/^[0-9\.]+ Printing statistics\.$/d' -i $logfile
grep -q 'LUT1' $logfile && sed -rn 's/\s+LUT1\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT2' $logfile && sed -rn 's/\s+LUT2\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT3' $logfile && sed -rn 's/\s+LUT3\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT4' $logfile && sed -rn 's/\s+LUT4\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT5' $logfile && sed -rn 's/\s+LUT5\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'LUT6' $logfile && sed -rn 's/\s+LUT6\s+([0-9]+)/\1/p' $logfile || echo '0'
rm -r $tmpdir
