transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/jose1/Downloads/ProjetoProva2-ArqComputadores-main/MIC_ULA.vhd}
vcom -93 -work work {C:/Users/jose1/Downloads/ProjetoProva2-ArqComputadores-main/MIC_BankRegisters.vhd}
vcom -93 -work work {C:/Users/jose1/Downloads/ProjetoProva2-ArqComputadores-main/PROJETO_MIC.vhd}

vcom -93 -work work {C:/Users/jose1/Downloads/ProjetoProva2-ArqComputadores-main/testbench_MIC_AMUX_ALU.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  testbench_MIC_AMUX_ALU

add wave *
view structure
view signals
run 400 ns
