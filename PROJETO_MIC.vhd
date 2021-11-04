
--Declaracao das bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--Declaracao da entidade
ENTITY PROJETO_MIC IS
	PORT(
			CLK        : IN STD_LOGIC;
			RESET      : IN STD_LOGIC;
			AMUX       : IN STD_LOGIC;
			ALU        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			MBR        : IN STD_LOGIC;
			MAR        : IN STD_LOGIC;
			RD         : IN STD_LOGIC;
			WR         : IN STD_LOGIC;
			ENC        : IN STD_LOGIC;
			CTRLA      : IN STD_LOGIC_LOGIC(2 DOWNTO 0);
			CTRLB      : IN STD_LOGIC_LOGIC(2 DOWNTO 0);
			C          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			A          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			DATA_OK    : IN STD_LOGIC;
			
			MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			RD_OUTPUT  : OUT STD_LOGIC;
			WR_OUTPUT  : OUT STD_LOGIC;
			Z          : OUT STD_LOGIC;
			N          : OUT STD_LOGIC
	);

END PROJETO_MIC;

--Declaracao da Arquitetura
ARCHITECTURE behavior of PROJETO_MIC is
--Parte declarativa
SIGNAL A_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL B_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL C_BUS : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL REG_MBR_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL REG_MBR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL REG_MAR : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL RD_OUT, WR_OUT : STD_LOGIC;

COMPONENT MIC_BankRegisters 
	port(
		Reset     : IN std_logic;
		Clk       : IN std_logic;
		Enc       : IN std_logic;
		A_Address : IN std_logic_vector(3 DOWNTO 0);
		B_Address : IN std_logic_vector(3 DOWNTO 0);
		C_Address : IN std_logic_vector(3 DOWNTO 0);
		C_Input   : IN std_logic_vector(15 DOWNTO 0);
		
		A_Output  : OUT std_logic_vector(15 DOWNTO 0);
		B_Output  : OUT std_logic_vector(15 DOWNTO 0)
	);

end COMPONENT;

COMPONENT MIC_ULA
	port(
		amux      : IN std_logic;
		alu_sh    : IN std_logic_vector(3 downto 0);
		A_Input   : IN std_logic_vector(15 DOWNTO 0);
		B_Input   : IN std_logic_vector(15 DOWNTO 0);
		MBR_Input : IN std_logic_vector(15 DOWNTO 0);

		N         : OUT std_logic;
		Z         : OUT std_logic;
		ULA_Output : OUT std_logic_vector(15 DOWNTO 0)
	);

end component;

begin

MAR_OUTPUT <= REG_MAR(11 DOWNTO 0);
MBR_TO_MEM <= REG_MBR_OUT(15 DOWNTO 0);
WR_OUTPUT <= WR_OUT; -- Conteúdo do registrador escrito na saída
RD_OUTPUT <= RD_OUT; -- Conteúdo do registrador escrito na saída

-- WITH CTRLA SELECT
-- 	A <= A



Registers: MIC_BankRegisters 
	PORT MAP(
		Reset       => RESET,
		Clk         => CLK,
		Enc         => ENC,
		A_Address   => A,
		B_Address   => B,
		C_Address   => C,
		C_Input     => C_BUS,
		A_Output    => A_BUS,
		B_Output    => B_BUS
	);

MUX_ALU_DESLOCADOR: MIC_ULA
	PORT MAP (
		amux      => AMUX, -- Segundo AMUX é interface do MIC
		alu_sh    => ALU, -- segundo ALU é interface do MIC
		A_Input   => A_BUS, -- segundo sinal é sinal deste arquivo
		B_Input   => B_BUS, -- segundo sinal é sinal deste arquivo
		MBR_Input => REG_MBR_IN, -- REG_MBR_IN é sinal deste arquivo
		N         => N, -- Segundo N é interface do MIC
		Z         => Z, -- Segundo Z é interface do MIC
		ULA_Output => C_BUS -- C_BUS é sinal deste arquivo
	);
		
MAR_Process : PROCESS (Clk, Reset, MAR)
	BEGIN
		IF Reset = '1' THEN
			REG_MAR <= "000000000000"; --(12 bits)
		ELSIF (rising_edge(Clk) AND MAR = '1') THEN
			REG_MAR <= B_BUS(11 DOWNTO 0);
		ELSE
			REG_MAR <= REG_MAR;
		END IF;
End Process MAR_Process;

MBR_OUT_Process : PROCESS (Clk, Reset, MBR)
	BEGIN
		IF Reset = '1' THEN
			REG_MBR_OUT <= "0000000000000000";
		ELSIF (rising_edge(Clk) AND MBR = '1') THEN
			REG_MBR_OUT <= C_BUS(15 DOWNTO 0);
		ELSE
			REG_MBR_OUT <= REG_MBR_OUT;
		END IF;
End Process MBR_OUT_Process;
	

MBR_IN_Process : PROCESS (Clk, Reset, DATA_OK)
	BEGIN
		IF Reset = '1' THEN
			REG_MBR_IN <= "0000000000000000";
		ELSIF (rising_edge(Clk) AND DATA_OK = '1') THEN
			REG_MBR_IN <= MEM_TO_MBR(15 DOWNTO 0);
		ELSE
			REG_MBR_IN <= REG_MBR_IN;
		END IF;
End Process MBR_IN_Process;


RD_OUT_Process : PROCESS (Clk, Reset, RD)
	BEGIN
		IF Reset = '1' THEN
			RD_OUT <= '0';
		ELSIF (rising_edge(Clk)) THEN
			RD_OUT <= RD;
		ELSE
			RD_OUT <= RD_OUT;
		END IF;
End Process RD_OUT_Process ;

WR_OUT_Process : PROCESS (Clk, Reset, WR)
	BEGIN
		IF Reset = '1' THEN
			WR_OUT <= '0';
		ELSIF (rising_edge(Clk)) THEN
			WR_OUT <= WR;
		ELSE
			WR_OUT <= WR_OUT;
		END IF;
End Process WR_OUT_Process ;

end behavior;

