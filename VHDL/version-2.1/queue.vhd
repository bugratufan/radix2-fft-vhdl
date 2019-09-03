----------------------------------------------------------------------------------
-- Company: YONGATEK
-- Designer: Buğra Tufan
-- E-mail: bugratufan97@gmail.com
--
-- Create Date:    29.08.2019
-- Design Name:
-- Module Name:    QUEUE
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: buffer output ready flip-flop for RADIX (version 2.1 - alpha) Module
--
-- Dependencies:
-- Revision:
-- Revision 0.2
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity QUEUE is
  port (
    valid : in std_logic;
    ready : out std_logic;
    clk   : in std_logic;
    reset : in std_logic
  );
end entity;

architecture RTL of QUEUE is
  signal counter : integer := 0;
  signal ready_state : std_logic;
begin
  state_proc: process(clk)
  begin
    if(reset = '0') then
      counter <= 0;
      ready <= '0';
    else
      if(clk'event and clk = '1') then
        if (valid = '1' and counter <= 0) then
          counter <= 1;
        elsif(counter = 1) then
          counter <= 2;
        elsif(counter = 2) then
          counter <= 3;
          ready <= '1';
        else
          counter <= 0;
          ready <= '0';
        end if;
      end if;
    end if;
  end process state_proc;

end architecture;
