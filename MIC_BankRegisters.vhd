
library ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MIC_BankRegisters is
  port (
    reset      : in std_logic;
    clk        : in std_logic;
    enc        : in std_logic;
    CTRLA      : in std_logic_vector(1 DOWNTO 0);
    CTRLB      : in std_logic_vector(1 DOWNTO 0);
    A_Address  : in std_logic_vector(3 DOWNTO 0);
    B_Address  : in std_logic_vector(3 DOWNTO 0);
    C_Address  : in std_logic_vector(3 DOWNTO 0);
    C_Input    : in std_logic_vector(15 DOWNTO 0);
	 
    A_Output   : out std_logic_vector(15 DOWNTO 0);
    B_Output   : out std_logic_vector(15 DOWNTO 0)
  );
end MIC_BankRegisters ;

architecture behavior of MIC_BankRegisters is

TYPE BANKREG is array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL bankRegisters : BANKREG;

SIGNAL RA_Address : std_logic_vector(3 DOWNTO 0);
SIGNAL RB_Address : std_logic_vector(3 DOWNTO 0);

BEGIN

    WITH CTRLA SELECT
        RA_Address <=   bankRegisters(3)(7 DOWNTO 4) WHEN "01",
                        bankRegisters(3)(3 DOWNTO 0) WHEN "10",
                        A_Address WHEN OTHERS;

    WITH CTRLB SELECT
        RB_Address <=   bankRegisters(3)(7 DOWNTO 4) WHEN "01",
                        bankRegisters(3)(3 DOWNTO 0) WHEN "10",
                        B_Address WHEN OTHERS;

    A_Output(15 DOWNTO 0) <= bankRegisters(conv_integer(RA_Address(3 DOWNTO 0)))(15 DOWNTO 0);
    B_Output(15 DOWNTO 0) <= bankRegisters(conv_integer(RB_Address(3 DOWNTO 0)))(15 DOWNTO 0);

    writeBankProcess : PROCESS(clk, enc, reset)
        begin
            if reset = '1' then
                bankRegisters(0)  <= "0000000000000000"; -- PC Register
                bankRegisters(1)  <= "0000000000000000"; -- AC Register
                bankRegisters(2)  <= "0000000000000000"; -- SP Register
                bankRegisters(3)  <= "0000000000000000"; -- IR Regisetr
                bankRegisters(4)  <= "0000000000000000"; -- TIR Register
                bankRegisters(5)  <= "0000000000000000"; -- Constant ZERO Register
                bankRegisters(6)  <= "0000000000000001"; -- Constant +1 Register
                bankRegisters(7)  <= "1111111111111111"; -- Constant -1 Register
                bankRegisters(8)  <= "0000111111111111"; -- AMASK Register
                bankRegisters(9)  <= "0000000011111111"; -- SMASK Register
                bankRegisters(10) <= "0000000000000000"; -- A Register
                bankRegisters(11) <= "0000000000000000"; -- B Register
                bankRegisters(12) <= "0000000000000000"; -- C Register
                bankRegisters(13) <= "0000000000000000"; -- D Register
                bankRegisters(14) <= "0000000000000000"; -- E Register
                bankRegisters(15) <= "0000000000000000"; -- F Register
                
            elsif((clk'event AND clk = '1') AND (enc = '1')) then
                IF (C_Address(3 downto 0) = "0101") THEN
                    bankRegisters(5) <= "0000000000000000";
                ELSIF (C_Address(3 downto 0) = "0110") THEN
                    bankRegisters(6) <= "0000000000000001";
                ELSIF (C_Address(3 downto 0) = "0111") THEN
                    bankRegisters(7) <= "1111111111111111";
                ELSIF (C_Address(3 downto 0) = "1000") THEN
                    bankRegisters(8) <= "0000111111111111";
                ELSIF (C_Address(3 downto 0) = "1001") THEN
                    bankRegisters(9) <= "0000000011111111";
                ELSE
                    bankRegisters(conv_integer(C_Address(3 DOWNTO 0))) <= C_Input(15 downto 0);
                end if;
            end if;
        end process writeBankProcess;

end behavior; -- arch