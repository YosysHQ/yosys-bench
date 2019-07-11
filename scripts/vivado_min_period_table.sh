for D in *; do
    if [ -d "$D" ] && [ -f "$D/results.txt" ]; then
        min_period="$(<$D/results.txt)"
        echo "$D @ ${min_period:0: -1}.${min_period: -1} ns"
        sed -n "s/|\s\+\(LUT as Logic\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/|\s\+\(LUT as Shift Register\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/|\s\+\(Register as Flip Flop\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/|\s\+\(Register as Latch\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        if grep -q -e "|\s\+CARRY4\s\+" "$D/test_$min_period.txt"; then
            sed -n "s/|\s\+\(CARRY4\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        else
            echo "	CARRY4: 0"
        fi
        f7=`sed -n "s/|\s\+\(F7 Muxes\)\s\+|\s\+\([0-9]\+\).*/\2/p" "$D/test_$min_period.txt" | tail -n 1`
        f8=`sed -n "s/|\s\+\(F8 Muxes\)\s\+|\s\+\([0-9]\+\).*/\2/p" "$D/test_$min_period.txt" | tail -n 1`
        echo "	F7 Muxes: $f7"
        echo "	F8 Muxes: $f8"
        echo "	Fx Muxes: $(($f7+$f8))"
        sed -n "s/|\s\+\(DSP48E1\)\s\+|\s\+\([0-9]\+\).*/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/|\s\+End Point Clock\s\+.*|\s\+\([0-9]\+\).*/\tLogic Levels: \1/p" "$D/test_$min_period.txt" | tail -n 1
        sed -n "s/|\s\+\(Logical Path\)\s\+|\s\+\(.*\+\)\s\+|$/\t\1: \2/p" "$D/test_$min_period.txt" | tail -n 1
    fi
done
