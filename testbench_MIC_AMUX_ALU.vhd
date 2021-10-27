library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY testbench_MIC_AMUX_ALU is
END testbench_MIC_AMUX_ALU;

architecture tb_MIC of testbench_MIC_AMUX_ALU is 

--Configuracoes do Clock
CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

--Sinais da Entidade
SIGNAL Signal_CLK        : STD_LOGIC := '0';
Signal Signal_RESET      : STD_LOGIC := '0';
Signal Signal_AMUX       : STD_LOGIC := '0';
SIGNAL Signal_ALU        : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
Signal Signal_MBR        : STD_LOGIC := '0';
Signal Signal_MAR        : STD_LOGIC := '0';
SIGNAL Signal_RD         : STD_LOGIC := '0';
Signal Signal_WR         : STD_LOGIC := '0';
Signal Signal_ENC        : STD_LOGIC := '0';
Signal Signal_C          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_B          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_A          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_SH         : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
Signal Signal_MEM_TO_MBR : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_DATA_OK    : STD_LOGIC := '0';

Signal Signal_MBR_TO_MEM : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
Signal Signal_MAR_OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
Signal Signal_RD_OUTPUT  : STD_LOGIC := '0';
Signal Signal_WR_OUTPUT  : STD_LOGIC := '0';
Signal Signal_Z          : STD_LOGIC := '0';
Signal Signal_N          : STD_LOGIC := '0';

--Sinais do Banco de Registradores
SIGNAL Signal_A_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL Signal_B_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL Signal_C_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL Signal_C_Input   : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_A_Output  : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_B_Output  : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

--Sinais ULA
SIGNAL Signal_A_Input   : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_B_Input   : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_MBR_Input : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_SH_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";


--Sinais da arquitetura
SIGNAL Signal_A_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_B_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_C_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

SIGNAL Signal_REG_MBR_IN     : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_REG_MBR_OUT    : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_REG_MAR        : STD_LOGIC_VECTOR(11 DOWNTO 0):= "000000000000";
SIGNAL Signal_RD_OUT, WR_OUT : STD_LOGIC := '0';

COMPONENT MIC_BankRegisters IS
	PORT(
		Reset		: IN std_logic;
		Clk			: IN std_logic;
		Enc			: IN std_logic;
		A_Address	: IN std_logic_vector(3 DOWNTO 0);
		B_Address	: IN std_logic_vector(3 DOWNTO 0);
		C_Address	: IN std_logic_vector(3 DOWNTO 0);
		C_Input		: IN std_logic_vector(15 DOWNTO 0);

		A_Output	: OUT std_logic_vector(15 DOWNTO 0);
		B_Output	: OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT MIC_ULA IS
	PORT(
		amux      : IN std_logic;
		alu       : IN std_logic_vector(1 downto 0);
		sh        : IN std_logic_vector(1 downto 0);
		A_Input   : IN std_logic_vector(15 DOWNTO 0);
		B_Input   : IN std_logic_vector(15 DOWNTO 0);
		MBR_Input : IN std_logic_vector(15 DOWNTO 0);

		N         : OUT std_logic;
		Z         : OUT std_logic;
		SH_Output : OUT std_logic_vector(15 DOWNTO 0)
	);
END COMPONENT;

BEGIN

DUT_BR : entity work.MIC_BankRegisters
	PORT MAP (
		Reset		=> Signal_Reset,
		Clk		    => Signal_Clk,
		Enc		    => Signal_Enc,
		A_Address	=> Signal_A_Address,
		B_Address	=> Signal_B_Address,
		C_Address	=> Signal_C_Address,
		C_Input		=> Signal_C_Input,
		A_Output	=> Signal_A_Output,
		B_Output	=> Signal_B_Output
	);

DUT_ULA : entity work.MIC_ULA
	PORT MAP (
		amux       => Signal_AMUX,
		alu        => Signal_ALU,
		sh         => Signal_SH,
		A_Input    => Signal_A_Input,
		B_Input    => Signal_B_Input,
		MBR_Input  => Signal_MBR_Input,
		z          => Signal_Z,
		n          => Signal_N,
		SH_Output  => Signal_SH_Output
	);

Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.

IF (Clk_count = 2) THEN     
REPORT "Stopping simulation after 40 cycles";
    	  Wait;       
END IF;
End Process Clock_Process;

Reset_Process : PROCESS 
  Begin
    Signal_Reset <= '0';
    Wait for 10 ns;
    Signal_Reset <= '1';
    Wait for 30 ns;
    Signal_Reset <= '0';
    wait;
End Process Reset_Process;


TEST : PROCESS
	BEGIN
		--PC := PC + 1;
		Signal_A_Address <= "0000";
		Signal_B_Address <= "0110";
		Signal_AMUX <= '0';
		Signal_ALU <= "00";
		Signal_SH <= "00";
		Signal_ENC <= '1';
		Signal_C_Address <= "0010";

		wait for 40 ns;
END PROCESS TEST;


END ARCHITECTURE tb_MIC;
