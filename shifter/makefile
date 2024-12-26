clean:
	rm -f work-*.cf test_my_shifter.vcd

.PHONY:	test_my_shifter.vcd
test_my_shifter.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 my_shifter.vhd shifter_tb.vhd
	ghdl -m --std=08 shifter_tb
	ghdl -r --std=08 shifter_tb --stop-time=5000ps --vcd=test_my_shifter.vcd

