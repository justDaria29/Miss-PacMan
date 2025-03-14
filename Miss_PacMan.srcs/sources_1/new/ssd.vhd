----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:34 04/17/2022 
-- Design Name: 
-- Module Name:    ssd1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
    Port ( clk1 : in  STD_LOGIC;
           val0 : in  STD_LOGIC_VECTOR (2 downto 0);
           val1 : in  STD_LOGIC_VECTOR (2 downto 0);
           val2 : in  STD_LOGIC_VECTOR (2 downto 0);
           val3 : in  STD_LOGIC_VECTOR (2 downto 0);
           val4 : in  STD_LOGIC_VECTOR (2 downto 0);
           val5 : in  STD_LOGIC_VECTOR (2 downto 0);
           val6 : in  STD_LOGIC_VECTOR (2 downto 0);
           val7 : in  STD_LOGIC_VECTOR (2 downto 0);
           anod : out  STD_LOGIC_VECTOR (7 downto 0);
           catod : out  STD_LOGIC_VECTOR (6 downto 0));
end ssd;

architecture Behavioral1 of ssd is
signal counter: std_logic_vector(15 downto 0);
signal hex:std_logic_vector(2 downto 0);
begin

process(clk1)
begin
if clk1='1' and clk1'event then counter<=counter+1;
end if;
end process;

--alegere anod

process(counter) 
begin
 case (counter(15 downto 13)) is
   when "111" => anod<="11111110";
	when "110" => anod<="11111101";
	when "101" => anod<="11111011";
	when "100" => anod<="11110111";
	when "011" => anod<="11101111";
	when "010" => anod<="11011111";
	when "001" => anod<="10111111";	
	when others => anod<="01111111";

	end case;

end process;

--process pt cifre

process(counter,val0,val1,val2,val3,val4,val5,val6,val7,hex) 
begin
case (counter(15 downto 13)) is
   when "000" => hex<=val0;
	when "001" => hex<=val1;
	when "010" => hex<=val2;
	when "011" => hex<=val3;
	when "100" => hex<=val4;
	when "101" => hex<=val5;
	when "110" => hex<=val6;	
	when others => hex<=val7;

	end case;

end process;

---decoder hex to 7 segmente
process(hex, counter)
begin

if(hex/="111") then
catod(0)<=not(hex(2));
catod(3)<=not(hex(0));
catod(6)<=not(hex(1));
catod(1)<='1';
catod(2)<='1';
catod(4)<='1';
catod(5)<='1';
else
case (counter(15 downto 13)) is
   when "000" => catod<="0000010";
	when "001" => catod<="0001000";
	when "010" => catod<="0001001";
	when "011" => catod<="0000110";
	when "100" => catod<="1000000";
	when "101" => catod<="1000001";
	when "110" => catod<="0000110";	
	when others => catod<="1001100";

	end case;
end if;
end process;

end Behavioral1;