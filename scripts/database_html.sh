#!/bin/bash

tables="$(cd database; ls -d */ | sed 's,/$,,;')"
tests="$(cd database; ls */*.dat | sed 's,.*/,,; s,\.dat$,,;' | sort -n)"

exec > database/index.html

echo "<table border>"
echo "<tr>"
echo "<th>Test</th>"
for tab in $tables; do echo "<th>$tab</th>"; done
echo "</tr>"
for tst in $tests; do
	echo "<tr>"
	echo "<td>$tst</td>"
	for tab in $tables; do
		if test -f database/$tab/$tst.dat; then
			echo "<td>$( cat database/$tab/$tst.dat )</td>"
		else
			echo "<td>N/A</td>"
		fi
	done
	echo "</tr>"
done
echo "</table>"
