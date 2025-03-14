----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2023 10:12:15 PM
-- Design Name: 
-- Module Name: pacman - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pacman is
port(u,d,l,r,c : in std_logic;
clk : in std_logic;
led: out std_logic_vector(15 downto 0);
ann : out std_logic_vector(7 downto 0);
cat : out std_logic_vector(6 downto 0));
end pacman;

architecture Behavioral of pacman is

component ssd is
    Port ( clk1 : in  STD_LOGIC;
           val0 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 0( those three orizontal lines)
           val1 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 1
           val2 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 2
           val3 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 3
           val4 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 4
           val5 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 5
           val6 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 6
           val7 : in  STD_LOGIC_VECTOR (2 downto 0);-- values anode 7
           anod : out  STD_LOGIC_VECTOR (7 downto 0);
           catod : out  STD_LOGIC_VECTOR (6 downto 0));
          
end component ssd;

signal xp: integer:=0;--the x coordonate of the pacman
signal yp: integer:=0;--the y coordonate of the pacman
signal sel: std_logic_vector(3 downto 0);--selection for buttons
--a struct
type vector_t is record 
vector: std_logic_vector(2 downto 0);
end record;
--array of structs
type vector_a is array (natural range <>) of vector_t;

signal v: vector_a (0 to 7);-- are the values send to ssd
signal val: vector_t;--position of y on vertical of pacman
signal val1: vector_t;--position of y on vertical of food
-- if both val and val1 are the same we use only val
-- val s ar placed in v on orizontal
signal div_clk: std_logic_vector(24 downto 0):="0000000000000000000000000";--frequecy devider so we can see the pacman moving, and for the timer
signal xf: integer;--the x coordonate of the food
signal yf: integer;--the y coordonate of the food
signal random: integer:= 0;--counter from 0 to 8, it s used to take random coordinates for the food
signal score: integer:=0;--counter for the score
signal timer: integer:=0;--counter for the time
begin

sel(0)<=r;
sel(1)<=l;
sel(2)<=d;
sel(3)<=u;
--process for frequency devider
process(clk, div_clk)

begin

if(rising_edge(clk)) then
div_clk<=div_clk+1;-- the clock is an integer of 24 bits and we add 1 after 1 and we take into consideration the msb because is the one that changes the hardest
end if;
end process;

process(clk, random)

begin
if(rising_edge(clk)) then
if(random=8) then 
random<=0;
else random<=random+1;
end if;
end if;
end process;

process(div_clk, u, d, l, r, c, sel)

begin

if(c='1') then 
xp<=0;
yp<=0;
score<=0;
xf<=random mod 8;
yf<=(random+2) mod 3;

elsif(rising_edge(div_clk(23))) then 

case sel is
when "0001"=>--the right button

if((xp+1=xf or (xp+1>7 and xf=0) ) and yp=yf )then

score<=score+1;
xf<=(random+5) mod 8;
yf<=(random+1) mod 3;
end if;

if(xp+1<=7) then
xp<=xp+1;
else 
xp<=0;
end if;

when "0010"=>

if(xp-1=xf or (xp-1<0 and xf=7) ) and yp=yf then

score<=score+1;
xf<=(random+3) mod 8;
yf<=(random+2) mod 3;
end if;


if(xp-1>=0) then
xp<=xp-1;
else 
xp<=7;
end if;

when "1000"=>

if(yp+1=yf or (yp+1>2 and yf=0) ) and xp=xf then

score<=score+1;
xf<=(random+1) mod 8;
yf<=(random+1) mod 3;
end if;

if(yp+1<=2) then
yp<=yp+1;
else 
yp<=0;
end if;

when "0100"=>

if(yp-1=yf or (yp-1<0 and yf=2) ) and xp=xf then

score<=score+1;
xf<=(random+4) mod 8;
yf<=(random+1) mod 3;
end if;

if(yp-1>=0) then
yp<=yp-1;
else 
yp<=2;
end if; 

when others=>
xp<=xp;
yp<=yp;

end case;
end if;
end process;

process(val, sel, clk, c, yp, yf, xp, xf)

begin
if(rising_edge(clk)) then
if(xp=xf) then
if(yp=0 or yf=0) then
val.vector(0)<='1';
else
val.vector(0)<='0';
end if;

if(yp=1 or yf=1) then
val.vector(1)<='1';
else
val.vector(1)<='0';
end if;

if(yp=2 or yf=2) then
val.vector(2)<='1';
else
val.vector(2)<='0';
end if;

else 

case yp is
when 0=> val.vector<="001";
when 1=> val.vector<="010";
when 2=> val.vector<="100";
when others=> val.vector<="000";

end case;

case yf is
when 0=> val1.vector<="001";
when 1=> val1.vector<="010";
when 2=> val1.vector<="100";
when others=> val1.vector<="000";

end case;

end if;

end if;
end process;

process( xp, yp, div_clk, sel, val, val1, xf, yf)

begin

if(timer<90 and score<16) then

if(xf=xp) then

l3: for i in 0 to 7 loop

if(i=xf) then
v(i)<=val;
else
v(i).vector<="000";

end if;
end loop l3;
else
l4: for i in 0 to 7 loop

if(i=xf) then

v(i)<=val1;

elsif(i=xp) then

v(i)<=val;

else

v(i).vector<="000";
end if;
end loop l4;

end if;

else

l5 : for i in 0 to 7 loop
v(i).vector<="111";
end loop l5;
end if;
end process;

process( score, clk)

begin

l2: for i in 0 to 15 loop
if(i < score) then
led(i)<='1';
else led(i)<='0';
end if;
end loop l2;
end process;

process(timer, div_clk)

begin
if(c='1') then
timer<=0;
else
if(timer<90 and score<16) then
if(rising_edge(div_clk(24))) then

timer<=timer+1;
end if;
end if;
end if;
end process;




l1: ssd port map ( clk1=>clk, val0=>v(0).vector, val1=>v(1).vector, val2=>v(2).vector,val3=>v(3).vector,val4=>v(4).vector,val5=>v(5).vector,val6=>v(6).vector,val7=>v(7).vector, anod=>ann, catod=>cat); 
end Behavioral;
