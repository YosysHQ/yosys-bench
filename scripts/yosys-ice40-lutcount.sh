#!/bin/bash
logfile=$( mktemp )
topmodule=$( basename -s .v "$1" )
yosys -ql $logfile -p "synth_ice40 -top $topmodule" "$1"
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
rm -f $logfile
