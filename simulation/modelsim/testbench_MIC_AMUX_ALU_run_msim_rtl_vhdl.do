transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Adm/Documents/UFPI/2021.1/Arquitetura de Computadores/avaliacao2/ProjetoProva2-ArqComputadores/MIC_ULA.vhd}
vcom -93 -work work {C:/Users/Adm/Documents/UFPI/2021.1/Arquitetura de Computadores/avaliacao2/ProjetoProva2-ArqComputadores/MIC_BankRegisters.vhd}
vcom -93 -work work {C:/Users/Adm/Documents/UFPI/2021.1/Arquitetura de Computadores/avaliacao2/ProjetoProva2-ArqComputadores/PROJETO_MIC.vhd}

vcom -93 -work work {C:/Users/Adm/Documents/UFPI/2021.1/Arquitetura de Computadores/avaliacao2/ProjetoProva2-ArqComputadores/testbench_MIC_AMUX_ALU.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  testbench_MIC_AMUX_ALU

add wave *
view structure
view signals
run 1600 ns
