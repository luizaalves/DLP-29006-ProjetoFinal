library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity div_clock is

	generic(MAX_clk : natural := 25000000);--1);  
	port
	(
		select_baudrate: in std_logic_vector(0 to 1);
		led_1, led_2, led_3, led_4 : out std_logic  := '0';
		clk, rst: in  std_logic;
		clk_out : out std_logic
	);
			
end entity;

architecture v1 of div_clock is
	signal tmp : std_logic := '1';
		signal clk_s : natural ;
begin

process(select_baudrate, clk, rst,tmp) is
	variable cnt: integer range 0 to max_clk;
	begin
		case select_baudrate is
			when "00" => clk_s <= (max_clk);--1s
			when "01" => clk_s <= (max_clk/2); --0,5s
			when "10" => clk_s <= (max_clk/4); --0,025s
			when others => clk_s <= (9600); --ele mandou por esse valor
		end case;
		
		if select_baudrate  <= "00" then
			led_1 <= '1';
			led_2 <= '0';
			led_3 <= '0';
			led_4 <= '0';
		elsif select_baudrate  <= "01" then
			led_1 <= '0';
			led_2 <= '1';
			led_3 <= '0';
			led_4 <= '0';
		elsif select_baudrate  <= "10" then
			led_1 <= '0';
			led_2 <= '0';
			led_3 <= '1';
			led_4 <= '0';
		elsif select_baudrate  <= "11" then
			led_1 <= '0';
			led_2 <= '0';
			led_3 <= '0';
			led_4 <= '1';
		else 
			led_1 <= '0';
			led_2 <= '0';
			led_3 <= '0';
			led_4 <= '0';
		end if;
			if(rst = '1') then
				cnt := 0;
				tmp<= '1';
				elsif (rising_edge(clk)) then
					if (cnt = clk_s-1) then
						cnt :=0;
						tmp <= not tmp;
					else cnt := cnt + 1;
				end if;
			end if;
	clk_out <= tmp;
end process;
end architecture;