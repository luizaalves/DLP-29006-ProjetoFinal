library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity conversor is 
		port 
		(
			clk_baud, select_paridade,rst, load : in std_logic;
			letra_bin1: in std_logic_vector(0 to 6);
			tx : out std_logic
		);
end entity;

architecture v1 of conversor is
--fazer uma variavel para o vetor total q acrescenta os bits la
	signal vetorletra_s : std_logic_vector(0 to 10);
	signal paridade : std_logic;
	signal entrada : std_logic_vector(0 to 6);
	signal varrer_variavel : integer range 0 to 11 := 0 ;
	signal botao_press : std_logic := '0';
begin
	entrada <=letra_bin1;
	paridade <= select_paridade;
	vetorletra_s(0)<= '0'; --start
	vetorletra_s(9)<= '1'; --stop
	vetorletra_s(10)<= '1'; --stop
		
	process(entrada,paridade) is
	variable letra1 : std_logic;
	begin
		letra1 := entrada(0);
		for i in 1 to 6 loop
			letra1 := entrada(i) xor letra1;
		end loop;
		
		if(paridade = '1') then
			letra1 := not letra1;
		end if;
		vetorletra_s(8)<= letra1; --paridade
	end process;
	
	gen: 
	for i in 0 to 6 generate
		vetorletra_s(i+1) <= letra_bin1(i);
	end generate;
	
	process (clk_baud, load, botao_press,varrer_variavel, rst) is
	variable enviar : std_logic := '0'; 
	variable count2 : integer range 0 to 11;
	variable ver : std_logic;
	begin
		
		if rising_edge(clk_baud) and rst = '1' then 
			count2:=0;
			
			elsif rising_edge(clk_baud)  then  --começa a transmitir
				if load ='0' and botao_press ='1' then
					count2:= varrer_variavel;
					--botao_press <= '0';
					enviar := '0';
					tx <= vetorletra_s(count2);					
					count2 := count2+1;
					if count2 =11 then
						count2 := 0;
						botao_press <= '0';
					end if;
				elsif load = '1' and enviar = '0' then 
					--count2:=0;
					enviar := '1';
					botao_press <= '1';
				
				end if;
		end if;
		varrer_variavel <= count2;
		
end process;
	
end architecture;