include ../common.mk
unexport YOSYS

TARGETS = $(patsubst %,tab_%_xc7a_1/results.txt,$(basename $(notdir $(BENCHMARKS))))
DEVICE=xc7a
GRADE=1

all: $(TARGETS)
	../../scripts/vivado_min_period_table.sh

tab_%_xc7a_1/results.txt:
	../../scripts/vivado_min_period.sh ../../*/benchmarks_*/*/$*.{v,vhdl} $(DEVICE) $(GRADE)

clean:
	rm -r tab_*
