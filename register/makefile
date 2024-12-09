clean:
	rm -f work-*.cf test_my_register.vcd 

.PHONY:	test_my_register.vcd
test_my_register.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 my_register.vhd register_tb.vhd
	ghdl -m --std=08 register_tb
	ghdl -r --std=08 register_tb --stop-time=5000ps --vcd=test_my_register.vcd

