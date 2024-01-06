
read_file -type verilog Def.v
read_file -type verilog top_riscv_core.v
read_file -type verilog Icache.v
read_file -type verilog Control.v
read_file -type verilog ALU.v
read_file -type verilog imm_gen.v
read_file -type verilog EX_M.v
read_file -type verilog Dcache.v
read_file -type verilog ID_EX.v
read_file -type verilog IF_ID.v
read_file -type verilog regfile.v
read_file -type verilog PC.v
read_file -type verilog M_RB.v

set_option ignoredu {Dcache}
set_option ignoredu {Icache}

current_goal lint/lint_rtl -alltop

run_goal

capture moresimple_all.rpt {write_report moresimple}

current_goal lint/lint_turbo_rtl -alltop

run_goal

capture -append moresimple_all.rpt {write_report moresimple}

current_goal lint/lint_functional_rtl -alltop
run_goal
capture -append moresimple_all.rpt {write_report moresimple}

current_goal lint/lint_abstract -alltop
run_goal
capture -append moresimple_all.rpt {write_report moresimple}
