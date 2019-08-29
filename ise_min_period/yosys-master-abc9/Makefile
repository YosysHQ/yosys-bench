include ../common.mk
export YOSYS=/opt/yosys-master/bin/yosys

DEVICE=xc6s
GRADE=2
TARGETS = $(patsubst %,tab_%_$(DEVICE)_$(GRADE)/results.txt,$(basename $(notdir $(BENCHMARKS))))

all: $(TARGETS)
	../../scripts/ise_min_period_table.sh

tab_%_$(DEVICE)_$(GRADE)/results.txt:
	f=(../../*/benchmarks_*/*/$*.{v.gz,v,vhdl}); \
	if ! zgrep -q "\(* top *\)" $${f[0]}; then \
		TOP="-top $*"; \
	fi; \
	YOSYS_SYNTH="synth_xilinx -family xc6s -abc9 -noiopad -edif $(PWD)/$$(dirname $@)/$*.edif" bash ../../scripts/ise_min_period.sh $${f[0]} $(DEVICE) $(GRADE)

clean:
	rm -r tab_*
