-- - A + B      (código "0000"- Sendo A a saída do amux)

-- - A AND B  (código "0001"- Sendo A a saída do amux)

-- - A            (código "0010"- Sendo A a saída do amux) 

-- - NOT A     (código "0011"- Sendo A a saída do amux)

-- - A OR B    (código "0100"- Sendo A a saída do amux)

-- - SLT         (código "0101"- Sendo A a saída do amux)  -- (SE A < B ULA_saida = 1; senão ULA_saida = 0;)

-- - A - B       (código "0110"- Sendo A a saída do amux)

-- - A XOR B  (código "0111"- Sendo A a saída do amux)

-- - SLL XX    (código "10XX"- Sendo A a saída do amux) -- Desloca XX bits de A a esquerda

-- - SRL XX   (código "11XX"- Sendo A a saída do amux) -- Desloca XX bits de A a direita





LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY MIC_ULA IS
PORT (
    AMUX       : IN std_logic;
    ALU_SH     : IN std_logic_vector(3 downto 0);
    A_Input    : IN std_logic_vector(15 DOWNTO 0);
    B_Input    : IN std_logic_vector(15 DOWNTO 0);
    MBR_Input  : IN std_logic_vector(15 DOWNTO 0);
    
    N          : OUT std_logic;
    Z          : OUT std_logic;
    ULA_Output : OUT std_logic_vector(15 downto 0)
);
END MIC_ULA;

Architecture behavioral OF MIC_ULA IS

SIGNAL Input_A : std_logic_vector(15 DOWNTO 0);
SIGNAL ALU_Output : std_logic_vector(15 DOWNTO 0);
SIGNAL RESULT : boolean;
SIGNAL SLT : std_logic_vector(15 DOWNTO 0);

BEGIN

WITH AMUX SELECT
    Input_A <= A_Input(15 DOWNTO 0) WHEN '0',
               MBR_Input(15 DOWNTO 0) WHEN OTHERS;

WITH ALU_Output SELECT
    Z <= '1' WHEN "0000000000000000",
         '0' WHEN OTHERS;

N <= ALU_Output(15);

RESULT <= Input_A(15 DOWNTO 0) < B_Input(15 DOWNTO 0);

WITH RESULT SELECT
    SLT <= "0000000000000001" WHEN TRUE,
           "0000000000000000" WHEN FALSE,
           SLT WHEN OTHERS;

WITH ALU_SH SELECT
    ALU_Output <=   Input_A(15 DOWNTO 0) + B_Input(15 DOWNTO 0) WHEN "0000",
                    Input_A(15 DOWNTO 0) AND B_Input(15 DOWNTO 0) WHEN "0001",
                    Input_A(15 DOWNTO 0) WHEN "0010",
                    NOT Input_A(15 DOWNTO 0) WHEN "0011",
                    Input_A(15 DOWNTO 0) OR B_Input(15 DOWNTO 0) WHEN "0100",
                    SLT WHEN "0101",
                    Input_A(15 DOWNTO 0) - B_Input(15 DOWNTO 0) WHEN "0110",
                    Input_A(15 DOWNTO 0) XOR B_Input(15 DOWNTO 0) WHEN "0111",
                    Input_A(15 DOWNTO 0) WHEN "1000",
                    Input_A(14 DOWNTO 0) & '0' WHEN "1001",
                    Input_A(13 DOWNTO 0) & '0' & '0' WHEN "1010",
                    Input_A(12 DOWNTO 0) & '0' & '0' & '0' WHEN "1011",
                    Input_A(15 DOWNTO 0) WHEN "1100",
                    '0' & Input_A(15 DOWNTO 1) WHEN "1101",
                    '0' & '0' & Input_A(15 DOWNTO 2) WHEN "1110",
                    '0' & '0' & '0' & Input_A(15 DOWNTO 3) WHEN OTHERS;
						  
ULA_Output <= ALU_Output(15 downto 0);						  

END behavioral;
