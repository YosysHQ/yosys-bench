for D in *; do
    if [ -d "$D" ] && [ -f "$D/results.txt" ]; then
        min_period="$(<$D/results.txt)"
        echo "$D @ ${min_period:0: -1}.${min_period: -1} ns"
        sed -n "s/^\s\+\(Number used as logic:\)\s\+\([0-9,]\+\).*/\tLUT as Logic: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/^\s\+\(Number used as Shift Register:\)\s\+\([0-9,]\+\).*/\tLUT as Shift Register: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/^\s\+\(Number used as Flip Flops:\)\s\+\([0-9,]\+\).*/\tRegister as Flip Flop: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/^\s\+\(Number used as Latches:\)\s\+\([0-9,]\+\).*/\tRegister as Latch: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/^\s\+\(Number of MUXCYs used:\)\s\+\([0-9,]\+\).*/\tMUXCY: \2/p" "$D/test_$min_period.txt" | tail -n 1
        f7=`sed -n "s/^#\s\+\(MUXF7\)\s\+:\s\+\([0-9]\+\).*/\2/p" "$D/test_$min_period.txt" | tail -n 1`
        f8=`sed -n "s/^#\s\+\(MUXF8\)\s\+:\s\+\([0-9]\+\).*/\2/p" "$D/test_$min_period.txt" | tail -n 1`
        echo "	F7 Muxes: ${f7:-0}"
        echo "	F8 Muxes: ${f8:-0}"
        echo "	Fx Muxes: $((${f7:-0}+${f8:-0}))"
        sed -n "s/^#\s\+\(DSP48A1\)\s\+:\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
    fi
done
