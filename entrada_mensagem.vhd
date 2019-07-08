library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity entrada_mensagem is

	port 
	(
		rst, clk,load : in std_logic;
		palavra 	: in std_logic_vector(1 downto 0);
		letra_bin : out std_logic_vector(0 to 6)
	);
end entity;
	
architecture v1 of entrada_mensagem is
	signal palavra_s : std_logic_vector(0 to 27);
	signal count : integer range 0 to 30 :=0;
	signal botao_press : std_logic := '0';
begin
	
	process(palavra) is
	begin
		case palavra is
			when "00" => palavra_s <= "1100010110000111011001100001"; --bala
			when "01" => palavra_s <= "1110000110000111001111101111"; --pago
			when "10" => palavra_s <= "1100110110100111001111101111"; --figo
			when others => palavra_s <= "1110010110000111100111101111"; --raso
		end case;
	end process;
	
process (clk, load, botao_press, rst, palavra_s) is
	variable enviar : std_logic := '0'; 
	variable count2 : integer range 0 to 28;
	variable letra_bin_var : std_logic_vector(0 to 6);
	begin
		--count2:= count;
		if rising_edge(clk) and rst = '1' then 
			count2:=0;
			elsif rising_edge(clk)  then  --começa a transmitir
			if load ='0' and botao_press ='1' then 
				count2:= count;
				botao_press <= '0';
				enviar := '0';
				for i in 0 to 6 loop
					letra_bin_var(i) := palavra_s(count2);
					count2:= count2+1;
				end loop;	
				if count2 =28 then
					count2 := 0;
				end if;
				letra_bin <= letra_bin_var;
				elsif load = '1' and enviar = '0' then 
					botao_press <= '1';
					enviar := '1';
			end if;
				
		end if;
		count <= count2;
end process;
		
end architecture;