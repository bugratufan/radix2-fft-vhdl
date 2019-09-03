----------------------------------------------------------------------------------
-- Company: YONGATEK
-- Designer: Buğra Tufan
-- E-mail: bugratufan97@gmail.com
--
-- Create Date:    21.08.2019
-- Design Name:
-- Module Name:    COMPLEX_ADDER
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: VHDL implementation of complex addition algorithm for IEEE-754
-- single precision floating point data format
--
-- Dependencies:
-- This module needs some extra vhdl files that listed below:
--  - adder.vhd
--
-- Revision:
-- Revision 1.0 - alpha
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_Logic_1164.all;

entity COMPLEX_ADDER is
  port (
    CLK        : in std_logic;
    Z1_IM      : in std_logic_vector(31 downto 0);
    Z1_RE      : in std_logic_vector(31 downto 0);
    Z2_RE      : in std_logic_vector(31 downto 0);
    Z2_IM      : in std_logic_vector(31 downto 0);
    RESULT_RE  : out std_logic_vector(31 downto 0);
    RESULT_IM  : out std_logic_vector(31 downto 0)
  );
end entity;

architecture RTL of COMPLEX_ADDER is
  component adder
  port (
    x : in  STD_LOGIC_VECTOR (31 downto 0);
    y : in  STD_LOGIC_VECTOR (31 downto 0);
    z : out  STD_LOGIC_VECTOR (31 downto 0);
    clk: in std_logic
  );
  end component;
begin
  RE_ADDER : adder
  port map(
    x => Z1_RE,
    y => Z2_RE,
    z => RESULT_RE,
    clk => CLK
  );

  IM_ADDER : adder
  port map(
    x => Z1_IM,
    y => Z2_IM,
    z => RESULT_IM,
    clk => CLK
  );

end RTL;
