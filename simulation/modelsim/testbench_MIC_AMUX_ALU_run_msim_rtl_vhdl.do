transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/MIC_ULA.vhd}
vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/MIC_BankRegisters.vhd}
vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/PROJETO_MIC.vhd}

vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/testbench_MIC_AMUX_ALU.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  testbench_MIC_AMUX_ALU

add wave *
view structure
view signals
run 1600 ns
