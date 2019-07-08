library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bintossd is 
	port 
	(
		bin : in std_logic_vector(0 to 6);
		ssd : out std_logic_vector(0 to 6)
	);
end entity;

architecture v1 of bintossd is
	signal count : integer range 0 to 9;
	signal bin_s: std_logic_vector(0 to 6);
begin
	bin_s <= bin; 
	process(bin_s) is
	variable ssd_t : std_logic_vector(0 to 6);
	begin
		case bin_s is
			when "1100001" => ssd_t:= "1111101"; --a
			when "1100010" => ssd_t:= "0011111"; --b
			when "1100110" => ssd_t:= "1001111"; --f
			when "1100111" => ssd_t:= "1011111"; --g
			when "1101001" => ssd_t:= "0110000"; --i
			when "1101100" => ssd_t:= "0001110"; --l
			when "1101111" => ssd_t:= "1111110"; --o
			when "1110000" => ssd_t:= "1100111"; --p
			when "1110010" => ssd_t:= "1110111"; --r
			when "1110011" => ssd_t:= "1011011"; --s
			when others => ssd_t:= "0110000";
		end case;
		ssd<=ssd_t;
	end process;

end architecture;