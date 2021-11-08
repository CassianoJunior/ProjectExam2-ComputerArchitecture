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
SIGNAL Signal_ALU        : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_MBR        : STD_LOGIC := '0';
Signal Signal_MAR        : STD_LOGIC := '0';
SIGNAL Signal_RD         : STD_LOGIC := '0';
Signal Signal_WR         : STD_LOGIC := '0';
Signal Signal_ENC        : STD_LOGIC := '0';
SIGNAL Signal_CTRLA      : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";	
SIGNAL Signal_CTRLB      : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
Signal Signal_C          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_B          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
Signal Signal_A          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
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
		ALU        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		MBR        : IN STD_LOGIC;
		MAR        : IN STD_LOGIC;
		RD         : IN STD_LOGIC;
		WR         : IN STD_LOGIC;
		ENC        : IN STD_LOGIC;
		CTRLA      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CTRLB      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
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
		CTRLA       => Signal_CTRLA,
		CTRLB      	=> Signal_CTRLB,
		C           => Signal_C,
		B           => Signal_B,
		A           => Signal_A,
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
		MBR := K(1) OR K(-1)
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0100";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0111";
		Signal_A          <= "0110";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;
		--MBR := SLT(K(-1) k(0))
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0101";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0101";
		Signal_A          <= "0111";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;
		--MBR := K(AM) - K(SM)
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0110";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "1001";
		Signal_A          <= "1000";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;
		--MBR := K(1) XOR K(-1)
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0111";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0111";
		Signal_A          <=  "0110";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK          <= '0';
		
		wait for 40 ns;
		--MBR := SLL K(-1)
		Signal_AMUX       <= '0';
		Signal_ALU        <= "1011";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0000";
		Signal_A          <= "0111";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;
		--MBR := SRL K(-1)
		Signal_AMUX       <= '0';
		Signal_ALU        <= "1111";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0000";
		Signal_A          <= "0111";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';

		wait for 40 ns;
		
		----------- A := A + 1 -------------
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0000";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '1';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "1010";
		Signal_B          <= "1010";
		Signal_A          <= "0110";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		-------------------------------------

		wait for 40 ns;
		-- Colocando possivel instrucao em IR
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '1';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "1111000110100010";
		Signal_DATA_OK    <= '1';
		
		wait for 40 ns;

		Signal_AMUX       <= '1';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '1';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;

		Signal_AMUX       <= '0';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0011";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		-- Execucao ADDRT
		
		wait for 40 ns;
		-- Ciclo 1: AC := SP + RB;
		Signal_AMUX       <= '0'; -- Seleciona Entrada A Amux
		Signal_ALU        <= "0000"; -- Soma
		Signal_MBR        <= '0'; -- nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao ler da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- Escreve no Banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "10"; -- Endereco RB
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0000"; -- Nao importa
		Signal_A          <= "0010"; -- Endereco SP
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Ciclo 2: MAR := AC; RD;
		Signal_AMUX       <= '0'; -- Nao importa
		Signal_ALU        <= "0000"; -- Nao importa
		Signal_MBR        <= '0'; -- nao escreve MBR 
		Signal_MAR        <= '1'; -- escreve em MAR
		Signal_RD         <= '1'; -- Primeira ordem de leitura
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao Escreve no Banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "00"; -- Endereco B
		Signal_C          <= "0001"; -- Nao Importa
		Signal_B          <= "0001"; -- Endereco AC
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Ciclo 3: RD; Recebe valor (6) da memoria e bota em MBR
		Signal_AMUX       <= '0'; -- Nao importa
		Signal_ALU        <= "0000"; -- Nao importa
		Signal_MBR        <= '0'; -- nao escreve em MBR a partir do C_BUS
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '1'; -- Segunda ordem de leitura
		Signal_WR         <= '0'; -- Nao escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- Nao Importa
		Signal_B          <= "0001"; -- nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000110"; -- dado mem
		Signal_DATA_OK    <= '1'; -- Data no mbr
		
		wait for 40 ns;
		-- Ciclo 4: AC := RA + MBR;
		Signal_AMUX       <= '1'; -- Escolhe MBR no amux
		Signal_ALU        <= "0000"; -- Soma
		Signal_MBR        <= '0'; -- Nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao le da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- escreve no banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "01"; -- Endereco RA
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0001"; -- nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Conferir dado em AC
		Signal_AMUX       <= '0'; -- Escolhe entrada A amux
		Signal_ALU        <= "0010"; -- Transparencia de A
		Signal_MBR        <= '1'; -- escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao le da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- nao importa
		Signal_B          <= "0000"; -- nao importa
		Signal_A          <= "0001"; -- Endereco AC
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		
		-- Execucao SUBRT
		
		wait for 40 ns;
		-- Ciclo 1: AC := SP + RB;
		Signal_AMUX       <= '0'; -- Seleciona Entrada A Amux
		Signal_ALU        <= "0000"; -- Soma
		Signal_MBR        <= '0'; -- nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao ler da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- Escreve no Banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "10"; -- Endereco RB
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0000"; -- Nao importa
		Signal_A          <= "0010"; -- Endereco SP
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Ciclo 2: MAR := AC; RD;
		Signal_AMUX       <= '0'; -- Nao importa
		Signal_ALU        <= "0000"; -- Nao importa
		Signal_MBR        <= '0'; -- nao escreve MBR 
		Signal_MAR        <= '1'; -- escreve em MAR
		Signal_RD         <= '1'; -- Primeira ordem de leitura
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao Escreve no Banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "00"; -- Endereco B
		Signal_C          <= "0001"; -- Nao Importa
		Signal_B          <= "0001"; -- Endereco AC
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Ciclo 3: RD; Recebe valor (6) da memoria e bota em MBR
		Signal_AMUX       <= '0'; -- Nao importa
		Signal_ALU        <= "0000"; -- Nao importa
		Signal_MBR        <= '0'; -- nao escreve em MBR a partir do C_BUS
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '1'; -- Segunda ordem de leitura
		Signal_WR         <= '0'; -- Nao escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- Nao Importa
		Signal_B          <= "0001"; -- nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000110"; -- dado mem
		Signal_DATA_OK    <= '1'; -- Data no mbr
		
		wait for 40 ns;
		-- Ciclo 4: AC := RA - MBR;
		Signal_AMUX       <= '1'; -- Escolhe MBR no amux
		Signal_ALU        <= "0110"; -- Subtracao
		Signal_MBR        <= '0'; -- Nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao le da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- escreve no banco
		Signal_CTRLA      <= "00"; -- nao importa
		Signal_CTRLB      <= "01"; -- Endereco RA
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0001"; -- nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Conferir dado em AC
		Signal_AMUX       <= '0'; -- Escolhe entrada A amux
		Signal_ALU        <= "0010"; -- Transparencia de A
		Signal_MBR        <= '1'; -- escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao le da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- nao importa
		Signal_B          <= "0000"; -- nao importa
		Signal_A          <= "0001"; -- Endereco AC
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		-------------------------------------
		
		wait for 40 ns;
		-- Colocando possivel instrucao em IR
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0000";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '1';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "1111011100101010";
		Signal_DATA_OK    <= '1';
		
		wait for 40 ns;

		Signal_AMUX       <= '1';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '1';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;

		Signal_AMUX       <= '0';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0011";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';

		-- Execucao SLTAC(Caso bom)
		wait for 40 ns;
		-- Ciclo 1: AC := SLT(RA, RB);
		Signal_AMUX       <= '0'; -- Seleciona Entrada A Amux
		Signal_ALU        <= "0101"; -- SLT
		Signal_MBR        <= '0'; -- nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao ler da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- Escreve no Banco
		Signal_CTRLA      <= "01"; -- Endereco RA
		Signal_CTRLB      <= "10"; -- Endereco RB
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0000"; -- Nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Conferir dado em AC
		Signal_AMUX       <= '0'; -- Escolhe entrada A amux
		Signal_ALU        <= "0010"; -- Transparencia de A
		Signal_MBR        <= '1'; -- escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao le da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- nao importa
		Signal_B          <= "0000"; -- nao importa
		Signal_A          <= "0001"; -- Endereco AC
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		-------------------------------------
		
		wait for 40 ns;
		-- Colocando possivel instrucao em IR
		Signal_AMUX       <= '0';
		Signal_ALU        <= "0000";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '1';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0000";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "1111011110100010";
		Signal_DATA_OK    <= '1';
		
		wait for 40 ns;

		Signal_AMUX       <= '1';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '0';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '1';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0000";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';
		
		wait for 40 ns;

		Signal_AMUX       <= '0';
		Signal_ALU        <= "0010";
		Signal_MBR        <= '1';
		Signal_MAR        <= '0';
		Signal_RD         <= '0';
		Signal_WR         <= '0';
		Signal_ENC        <= '0';
		Signal_CTRLA      <= "00";
		Signal_CTRLB      <= "00";
		Signal_C          <= "0011";
		Signal_B          <= "0000";
		Signal_A          <= "0011";
		Signal_MEM_TO_MBR <= "0000000000000000";
		Signal_DATA_OK    <= '0';

		-- Execucao SLTAC(Caso ruim)
		wait for 40 ns;
		-- Ciclo 1: AC := SLT(RA, RB);
		Signal_AMUX       <= '0'; -- Seleciona Entrada A Amux
		Signal_ALU        <= "0101"; -- SLT
		Signal_MBR        <= '0'; -- nao escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao ler da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '1'; -- Escreve no Banco
		Signal_CTRLA      <= "01"; -- Endereco RA
		Signal_CTRLB      <= "10"; -- Endereco RB
		Signal_C          <= "0001"; -- Endereco AC
		Signal_B          <= "0000"; -- Nao importa
		Signal_A          <= "0010"; -- Nao importa
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		wait for 40 ns;
		-- Conferir dado em AC
		Signal_AMUX       <= '0'; -- Escolhe entrada A amux
		Signal_ALU        <= "0010"; -- Transparencia de A
		Signal_MBR        <= '1'; -- escreve em MBR
		Signal_MAR        <= '0'; -- Nao escreve em MAR
		Signal_RD         <= '0'; -- Nao ler da memoria
		Signal_WR         <= '0'; -- NAo escreve na memoria
		Signal_ENC        <= '0'; -- nao escreve no banco
		Signal_CTRLA      <= "00"; -- Endereco A
		Signal_CTRLB      <= "00"; -- nao importa
		Signal_C          <= "0001"; -- nao importa
		Signal_B          <= "0000"; -- nao importa
		Signal_A          <= "0001"; -- Endereco AC
		Signal_MEM_TO_MBR <= "0000000000000000"; -- Nao importa
		Signal_DATA_OK    <= '0'; -- Nao importa
		
		
		
		wait;
END PROCESS TEST;


END ARCHITECTURE tb_MIC;