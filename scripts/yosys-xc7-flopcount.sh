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
    echo "read -vhdl $1" > $tmpdir/script.ys
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > $tmpdir/script.ys
fi
echo "synth_xilinx -top $topmodule" >> $tmpdir/script.ys

# run tools
yosys -ql $logfile -p "script $tmpdir/script.ys" >/dev/null
if grep -q "^=== design hierarchy ===$" $logfile; then
    sed -r '1,/^=== design hierarchy ===$/d' -i $logfile;
else
    sed -r '1,/^[0-9\.]+ Printing statistics\.$/d' -i $logfile;
fi
grep -q '^\s\+FD' $logfile && sed -rn 's/^\s+FD.*\s+([0-9]+)/\1/p' $logfile || echo '0'
rm -r $tmpdir
