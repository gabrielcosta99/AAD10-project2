clean:
	rm -f work-*.cf accumulator.vcd

AUX_FILES = triple_port_ram/triple_port_ram.vhd register/my_register.vhd adder/full_adder.vhd adder/adder_n.vhd

.PHONY:	accumulator.vcd
accumulator.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 $(AUX_FILES) accumulator_single_cycle.vhd accumulator_tb.vhd
	ghdl -m --std=08 accumulator_tb
	ghdl -r --std=08 accumulator_tb --stop-time=30000ps --vcd=accumulator.vcd


.PHONY:	accumulator_pipeline.vcd
accumulator_pipeline.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 $(AUX_FILES) accumulator_pipeline.vhd accumulator_tb.vhd multiplexer.vhd vector_comparator.vhd
	ghdl -m --std=08 accumulator_tb
	ghdl -r --std=08 accumulator_tb --stop-time=30000ps --vcd=accumulator.vcd


