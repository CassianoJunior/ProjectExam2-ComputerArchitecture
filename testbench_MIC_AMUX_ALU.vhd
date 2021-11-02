library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY testbench_MIC_AMUX_ALU is
	port(
		SAIDA : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
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
Signal Signal_MAR_OUTPUT : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
Signal Signal_RD_OUTPUT  : STD_LOGIC := '0';
Signal Signal_WR_OUTPUT  : STD_LOGIC := '0';
Signal Signal_Z          : STD_LOGIC := '0';
Signal Signal_N          : STD_LOGIC := '0';


--Sinais da arquitetura
SIGNAL Signal_A_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_B_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_C_BUS          : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

SIGNAL Signal_REG_MBR_IN     : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_REG_MBR_OUT    : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL Signal_REG_MAR        : STD_LOGIC_VECTOR(11 DOWNTO 0):= "000000000000";
SIGNAL Signal_RD_OUT, WR_OUT : STD_LOGIC := '0';

COMPONENT PROJETO_MIC IS
	PORT(
		CLK        : IN STD_LOGIC;
		RESET      : IN STD_LOGIC;
		AMUX       : IN STD_LOGIC;
		ALU        : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		MBR        : IN STD_LOGIC;
		MAR        : IN STD_LOGIC;
		RD         : IN STD_LOGIC;
		WR         : IN STD_LOGIC;
		ENC        : IN STD_LOGIC;
		C          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		B          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		A          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		SH         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DATA_OK    : IN STD_LOGIC;
		
		MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		RD_OUTPUT  : OUT STD_LOGIC;
		WR_OUTPUT  : OUT STD_LOGIC;
		Z          : OUT STD_LOGIC;
		N          : OUT STD_LOGIC
	);
END COMPONENT;


BEGIN

MIC : PROJETO_MIC
	PORT MAP (
		CLK         => Signal_CLK,
		RESET       => Signal_RESET,
		AMUX        => Signal_AMUX,
		ALU         => Signal_ALU,
		MBR         => Signal_MBR,
		MAR         => Signal_MAR,
		RD          => Signal_RD,
		WR          => Signal_WR,
		ENC         => Signal_ENC,
		C           => Signal_C,
		B           => Signal_B,
		A           => Signal_A,
		SH          => Signal_SH,
		MEM_TO_MBR  => Signal_MEM_TO_MBR,
		DATA_OK     => Signal_DATA_OK,
		
		MBR_TO_MEM  => SAIDA,
		MAR_OUTPUT  => Signal_MAR_OUTPUT,
		RD_OUTPUT   => Signal_RD_OUTPUT,
		WR_OUTPUT   => Signal_WR_OUTPUT,
		Z           => Signal_Z,
		N           => Signal_N
	);

Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.

IF (Clk_count = 40) THEN     
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
		--RESET
		wait for 40 ns;
		--AC := PC + 1;
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "0001";
		Signal_B    <= "0110";
		Signal_A    <= "0000";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';
		
		wait for 40 ns;
		-- SP := AC + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "0010";
		Signal_B    <= "0110";
		Signal_A    <= "0001";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- IR := SP + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "0011";
		Signal_B    <= "0110";
		Signal_A    <= "0010";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- TIR := IR + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "0100";
		Signal_B    <= "0110";
		Signal_A    <= "0011";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- A := TIR + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1010";
		Signal_B    <= "0110";
		Signal_A    <= "0100";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		--B := A + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1011";
		Signal_B    <= "0110";
		Signal_A    <= "1010";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		--C := B + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1100";
		Signal_B    <= "0110";
		Signal_A    <= "1011";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		--D := C + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1101";
		Signal_B    <= "0110";
		Signal_A    <= "1100";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		--E := D + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1110";
		Signal_B    <= "0110";
		Signal_A    <= "1101";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		--F := E + 1
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "1111";
		Signal_B    <= "0110";
		Signal_A    <= "1110";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := IR + TIR
		Signal_AMUX <= '0';
		Signal_ALU  <= "00";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "1111";
		Signal_B    <= "0011";
		Signal_A    <= "0100";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := k(0)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "0101";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := k(1)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "0110";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := k(-1)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "0111";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := k(AM)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "1000";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := k(SM)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "1001";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';
		
		wait for 40 ns;
		-- MBR := NOT K(AM)
		Signal_AMUX <= '0';
		Signal_ALU  <= "11";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0000";
		Signal_A    <= "1000";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';
		
		

		wait for 40 ns;
		-- MBR := K(1) AND K(-1)
		Signal_AMUX <= '0';
		Signal_ALU  <= "01";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0110";
		Signal_A    <= "0111";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		-- Executando ADDD X

		wait for 40 ns;
		-- MAR := IR;
		Signal_AMUX <= '0';
		Signal_ALU  <= "01";
		Signal_MBR  <= '0';
		Signal_MAR  <= '1';
		Signal_RD   <= '1';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0011";
		Signal_A    <= "0111";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- Dado da memória (0000000000000001) para o MBR
		Signal_AMUX <= '0';
		Signal_ALU  <= "01";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '1';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0011";
		Signal_A    <= "0111";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000001";
		Signal_DATA_OK <= '1';

		wait for 40 ns;
		-- AC := AC + MBR
		Signal_AMUX <= '1';
		Signal_ALU  <= "00";
		Signal_MBR  <= '0';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '1';
		Signal_C    <= "0001";
		Signal_B    <= "0001";
		Signal_A    <= "0111";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';

		wait for 40 ns;
		-- MBR := AC (ver na saída)
		Signal_AMUX <= '0';
		Signal_ALU  <= "10";
		Signal_MBR  <= '1';
		Signal_MAR  <= '0';
		Signal_RD   <= '0';
		Signal_WR   <= '0';
		Signal_ENC  <= '0';
		Signal_C    <= "0000";
		Signal_B    <= "0001";
		Signal_A    <= "0001";
		Signal_SH   <= "00";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK <= '0';


		wait;
END PROCESS TEST;


END ARCHITECTURE tb_MIC;