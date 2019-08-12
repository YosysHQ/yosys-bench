include ../common.mk
export YOSYS=/opt/yosys-master/bin/yosys

DEVICE=xc7a
GRADE=1
TARGETS = $(patsubst %,tab_%_$(DEVICE)_$(GRADE)/results.txt,$(basename $(notdir $(BENCHMARKS))))

all: $(TARGETS)
	../../scripts/vivado_min_period_table.sh

tab_%_$(DEVICE)_$(GRADE)/results.txt:
	if ! zgrep -q "\(* top *\)" ../../*/benchmarks_*/*/$*.{v,v.gz,vhdl}; then \
		TOP="-top $*"; \
	fi; \
	YOSYS_SYNTH="synth_xilinx -abc9 -edif $(PWD)/$$(dirname $@)/$*.edif" bash ../../scripts/vivado_min_period.sh ../../*/benchmarks_*/*/$*.{v,v.gz,vhdl} $(DEVICE) $(GRADE)

clean:
	rm -r tab_*
