LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
--Testbench--
ENTITY testbench_JosephAbner IS
	PORT(
	OUTPUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	OUTPUT2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END testbench_JosephAbner;
--------------------------------
ARCHITECTURE Type_01 OF testbench_JosephAbner IS

CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

	SIGNAl CLK_Signal, RESET_Signal, AMUX_Signal, MBR_Signal, MAR_Signal : STD_LOGIC := '0';
	SIGNAL RD_Signal, WR_Signal, ENC_Signal : STD_LOGIC := '0';
	SIGNAL A_Signal, B_Signal, C_Signal : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL SH_Signal, ALU_Signal : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL MBR_TO_MEM_Sig, MEM_TO_MBR_Sig : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL MAR_OUTPUT_Sig : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
	SIGNAL RD_OUTPUT_Sig, WR_OUTPUT_Sig, Z_Signal, N_Signal : STD_LOGIC := '0';
	--SIGNAL SOMA_ALU : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DATA_OK_Signal : STD_LOGIC := '0';

COMPONENT MIC_Project IS
	PORT (
		 RESET : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 AMUX  : IN STD_LOGIC;
		 ALU   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MBR   : IN STD_LOGIC;
		 MAR   : IN STD_LOGIC;
		 RD    : IN STD_LOGIC;
		 WR    : IN STD_LOGIC;
		 ENC   : IN STD_LOGIC;
		 C     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 B     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 A     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		SH     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA_OK : IN STD_LOGIC;
		
		MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		RD_OUTPUT : OUT STD_LOGIC;
		WR_OUTPUT : OUT STD_LOGIC;
		Z         : OUT STD_LOGIC;
		N         : OUT STD_LOGIC);
END COMPONENT;
--------------------------------
BEGIN
MIC : MIC_Project
	PORT MAP (
		CLK => CLK_Signal, RESET => RESET_Signal, AMUX => AMUX_Signal,
		MBR => MBR_Signal, MAR => MAR_Signal, RD => RD_Signal, WR => WR_Signal,
		ENC => ENC_Signal, DATA_OK => DATA_OK_Signal, A => A_Signal, B => B_Signal,
		C => C_Signal, SH => SH_Signal, MBR_TO_MEM => OUTPUT,
		MEM_TO_MBR => MEM_TO_MBR_Sig, MAR_OUTPUT => OUTPUT2,
		RD_OUTPUT => RD_OUTPUT_Sig, WR_OUTPUT => WR_OUTPUT_Sig, Z => Z_Signal,
		N => N_Signal, ALU => ALU_Signal
		);
--------------------------------		


Clock_Process : PROCESS 
  Begin
    CLK_Signal <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    CLK_Signal  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 34) THEN     
REPORT "Stopping simulkation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

--------------------------------	

Reset_Process : PROCESS 
  Begin
    RESET_Signal <= '0';
    Wait for 10 ns;
    RESET_Signal <= '1';
    Wait for 30 ns;
    RESET_Signal <= '0';
    wait;

End Process Reset_Process;

--------------------------------	

PROCESS
	BEGIN
	
		--PC := PC + 1;
		wait for 40ns;
		 AMUX_Signal  <= '0';
		 ALU_Signal   <= "00";
		 MBR_Signal   <= '1';
		 MAR_Signal   <= '0';
		 RD_Signal    <= '0';
		 WR_Signal    <= '0';
		 ENC_Signal   <= '1';
		 C_Signal     <= "0000";
		 B_Signal    <= "0110";
		 A_Signal    <= "0000";
		 SH_Signal     <= "00";
		 MEM_TO_MBR_Sig <= "0000000000000000";
		 DATA_OK_Signal <= '0';
		
		wait;
END process;


END Type_01;