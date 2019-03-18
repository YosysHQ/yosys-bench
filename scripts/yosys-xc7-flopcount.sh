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
sed -r '1,/^=== design hierarchy ===$/d' -i $logfile
grep -q 'FDRE '  $logfile && sed -rn 's/\s+FDRE\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'FDRE_1' $logfile && sed -rn 's/\s+FDRE_1\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'FDCE '  $logfile && sed -rn 's/\s+FDCE\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'FDCE_1' $logfile && sed -rn 's/\s+FDCE_1\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'FDPE '  $logfile && sed -rn 's/\s+FDPE\s+([0-9]+)/\1/p' $logfile || echo '0'
grep -q 'FDPE_1' $logfile && sed -rn 's/\s+FDPE_1\s+([0-9]+)/\1/p' $logfile || echo '0'
rm -r $tmpdir
