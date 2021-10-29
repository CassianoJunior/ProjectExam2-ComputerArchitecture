transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/MIC_ULA.vhd}
vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/MIC_BankRegisters.vhd}
vcom -93 -work work {C:/Users/cassi/OneDrive/Documents/UFPI/Disciplinas/3P/ArquiteturaDeComputadores/VHDL/Programs/prova2/PROJETO_MIC.vhd}

