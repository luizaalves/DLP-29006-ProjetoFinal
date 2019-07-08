library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmissao_serial is
	port
	(
		-- Input ports
		rst_in, clk_in,sel_paridade , load_in: in  std_logic;
		sel_baudrate : in std_logic_vector(0 to 1);
		palavra_in: in std_logic_vector(0 to 1);

		-- Output ports
		ssd_out : out std_logic_vector(0 to 6);
		tx : out std_logic;
		led_1_out, led_2_out, led_3_out, led_4_out : out std_logic  := '0';
		baudrate : out std_logic
	);
end entity;

architecture v1 of transmissao_serial is
	--componentes
------------------------------------------
	component entrada_mensagem is
	port 
	(
		rst,clk,load : in std_logic;
		palavra 	: in std_logic_vector(0 to 1);
		letra_bin : out std_logic_vector(6 downto 0)
	);
	end component;
-------------------------------------------
	component bintossd is 
		port 
		(
			bin : in std_logic_vector(0 to 6);
			ssd : out std_logic_vector(0 to 6)
		);
	end component;
-------------------------------------------
	component div_clock is
		generic(MAX_clk : natural := 5);  
		port
		(
			clk, rst: in  std_logic;
			select_baudrate: in std_logic_vector(0 to 1);
			led_1, led_2, led_3, led_4 : out std_logic  := '0';
			clk_out : out std_logic
		);
	end component;
-------------------------------------------
	component conversor is 
		port 
		(
			clk_baud,select_paridade,rst, load : in std_logic;
			letra_bin1 : in std_logic_vector(6 downto 0);
			tx : out std_logic
		);
	end component;
-------------------------------------------
	signal letra: std_logic_vector(6 downto 0);
	signal s_ssd : std_logic_vector(0 to 6);
	signal baudrate_s, tx_s:std_logic;

	begin
		
-------------------------------------------
		u1: component bintossd 
			port map	( bin => letra, ssd => s_ssd);
------------------------------------------
		u2: component entrada_mensagem
		port map	(rst => rst_in, clk =>clk_in,load => load_in, palavra=>palavra_in, letra_bin=> letra);
-------------------------------------------
		u3: component conversor
		port map	(clk_baud => baudrate_s, select_paridade  => sel_paridade, rst => rst_in, load => load_in, letra_bin1 =>letra, tx =>tx_s);
-------------------------------------------
		u5: component div_clock
		generic map(MAX_clk => 25000000)
		port map(clk=> clk_in,rst=> rst_in, select_baudrate => sel_baudrate, led_1 => led_1_out, led_2 => led_2_out, led_3 => led_3_out, led_4 => led_4_out, clk_out => baudrate_s);
-------------------------------------------
		baudrate <= baudrate_s;
		ssd_out <=s_ssd;
		tx <= tx_s;
end architecture;
