-- tx_serial_fd.vhd
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity tx_serial_fd is
    port (
        clock, reset: in std_logic;
        zera, conta, carrega, desloca, paridade: in std_logic;
        dados_ascii: in std_logic_vector (6 downto 0);
        saida_serial, fim : out std_logic
    );
end tx_serial_fd;

architecture tx_serial_fd of tx_serial_fd is
    signal D, S: std_logic_vector (9 downto 0);
     
    component deslocador_n
    generic (
        constant N: integer    -- numero de bits
    );
    port (
        clock, reset: in std_logic;
        carrega, desloca, entrada_serial: in std_logic; 
        dados: in std_logic_vector (N-1 downto 0);
        saida: out  std_logic_vector (N-1 downto 0));
    end component;

    component contador_m
      generic (
        constant M: integer;  -- modulo do contador
        constant N: integer   -- numero de bits da saida
    );
    port (
        CLK, zera, conta: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (N-1 downto 0);
        fim: out STD_LOGIC);
    end component;
    
begin

    D(0) <= '1';
    D(1) <= '0';
    D(8 downto 2) <= dados_ascii;
    D(9) <= paridade xor dados_ascii(0) xor dados_ascii(1) xor dados_ascii(2) xor dados_ascii(3) 
            xor dados_ascii(4) xor dados_ascii(5) xor dados_ascii(6);
    U1: deslocador_n generic map (N => 10)  port map (clock, reset, carrega, desloca, '1', D, S);
    U2: contador_m generic map (M => 13, N => 4) port map (clock, zera, conta, open, fim);
    saida_serial <= S(0);
    
end tx_serial_fd;

