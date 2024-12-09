clean:
	rm -f work-*.cf test_adder_n.vcd

# .PHONY:	ex1.vcd
# ex1.vcd:
# 	rm -f work-*.cf
# 	ghdl -i --std=08 d_flip_flop.vhd ex1_tb.vhd
# 	ghdl -m --std=08 ex1_tb
# 	ghdl -r --std=08 ex1_tb --stop-time=5000ps --vcd=ex1.vcd

# .PHONY:	ex3.vcd
# ex3.vcd:
# 	rm -f work-*.cf
# 	ghdl -i --std=08 dual_port_ram.vhd ex3_tb.vhd
# 	ghdl -m --std=08 ex3_tb
# 	ghdl -r --std=08 ex3_tb --stop-time=20000ps --vcd=ex3.vcd

.PHONY:	test_adder_n.vcd
test_adder_n.vcd:
	rm -f work-*.cf
	ghdl -i --std=08 full_adder.vhd adder_n.vhd adder_n_tb.vhd 
	ghdl -m --std=08 adder_n_tb
	ghdl -r --std=08 adder_n_tb --stop-time=20000ps --vcd=test_adder_n.vcd




