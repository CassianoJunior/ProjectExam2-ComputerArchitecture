library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

entity MIC_ULA is
  port (
    AMUX			: IN std_logic;
    ALU	      : IN std_logic_vector(1 downto 0);
    SH			  : IN std_logic_vector(1 downto 0);
    A_Input		: IN std_logic_vector(15 DOWNTO 0);
    B_Input		: IN std_logic_vector(15 DOWNTO 0);
    MBR_Input	: IN std_logic_vector(15 DOWNTO 0);
    N			    : OUT std_logic;
    Z				  : OUT std_logic;
    SH_Output	: OUT std_logic_vector(15 DOWNTO 0)
  ) ;
end MIC_ULA ;

architecture behavior of MIC_ULA is

SIGNAL Input_A    :  std_logic_vector(15 DOWNTO 0);
SIGNAL ALU_Output	:  std_logic_vector(15 DOWNTO 0);


begin


WITH AMUX SELECT
	Input_A <= A_Input(15 DOWNTO 0) WHEN '0',
		         MBR_Input(15 DOWNTO 0) WHEN OTHERS;

WITH ALU_Output SELECT
      Z <= '1' WHEN "0000000000000000",
           '0' WHEN OTHERS;

N <= ALU_Output(15);

WITH ALU SELECT
	ALU_Output <= Input_A(15 DOWNTO 0) + B_Input(15 DOWNTO 0)   WHEN "00",
	              Input_A(15 DOWNTO 0) AND B_Input(15 DOWNTO 0) WHEN "01",
		            Input_A(15 DOWNTO 0)                          WHEN "10",
		            NOT Input_A(15 DOWNTO 0)                      WHEN OTHERS;
            
WITH SH SELECT
  SH_Output <= ALU_Output(15 DOWNTO 0) WHEN "00",         --Sem deslocamento
               ALU_Output(14 DOWNTO 0) & '0' WHEN "01",   --Deslocamento para a esquerda, ou seja, adiciona 0 a direita
               '0' & ALU_Output(15 DOWNTO 1) WHEN "10",   --Deslocamento para a direita, ou seja, adiciona 0 a esquerda
               ALU_Output(15 DOWNTO 0) WHEN OTHERS;


end behavior ; -- arch