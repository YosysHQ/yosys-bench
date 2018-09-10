-- testbench for cordic_10_16.vhdl
-- Author: Niels A. Moseley

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_tb is
end cordic_tb;

architecture tb of cordic_tb is
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    signal angle_in : signed(15 downto 0) := (others => '0');
    signal sin_out  : signed(15 downto 0) := (others => '0');
    signal cos_out  : signed(15 downto 0) := (others => '0');

    signal run_sim  : std_logic := '1';
begin

    -- device under test
    dut: entity work.cordic_10_16
        port map(clk, rst_n, angle_in, cos_out, sin_out);

    proc_clk: process
    begin
        if (run_sim = '1') then
            wait for 1 ns;
            clk <= not clk;
        else
            wait;
        end if;
    end process proc_clk;        

    proc_stim: process
    begin
        wait for 10 ns;
        rst_n <= '1';

        wait for 2000 ns;

        run_sim <= '0';

        wait;
    end process proc_stim;

    proc_angle: process(clk)
    begin
        if (rising_edge(clk) and (rst_n = '1')) then
            angle_in <= angle_in + to_signed(123,16);
        end if;
    end process proc_angle;

end tb;