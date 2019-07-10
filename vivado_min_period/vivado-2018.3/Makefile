include ../common.mk

TARGETS = $(patsubst %,tab_%_xc7a_1/results.txt,$(basename $(notdir $(BENCHMARKS))))

unexport YOSYS

all: $(TARGETS)

tab_%_xc7a_1/results.txt:
	bash ../../scripts/vivado_min_period.sh ../../*/benchmarks_*/*/$*.{v,vhdl} xc7a 1

clean:
	rm -r tab_*
