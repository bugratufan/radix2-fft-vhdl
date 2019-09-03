----------------------------------------------------------------------------------
-- Company: YONGATEK
-- Designer: Buğra Tufan
-- E-mail: bugratufan97@gmail.com
--
-- Create Date:    21.08.2019
-- Design Name:
-- Module Name:    MULTI
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: VHDL implementation of complex multiplication algorithm for IEEE-754
-- single precision floating point data format
--
-- Dependencies:
-- This module needs some extra vhdl files that listed below:
--  - multiplier.vhd
--
-- Revision:
-- Revision 1.0 - alpha
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.fixed_pkg.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MULTI is
  port (
    CLK        : in std_logic;
    Z1_IM      : in std_logic_vector(31 downto 0);
    Z1_RE      : in std_logic_vector(31 downto 0);
    Z2_RE      : in std_logic_vector(31 downto 0);
    Z2_IM      : in std_logic_vector(31 downto 0);
    RESULT_RE  : out std_logic_vector(31 downto 0);
    RESULT_IM  : out std_logic_vector(31 downto 0)
  );

end MULTI;

architecture RTL of MULTI is

  signal AC      : std_logic_vector(31 downto 0);
  signal BD      : std_logic_vector(31 downto 0);
  signal BC      : std_logic_vector(31 downto 0);
  signal AD      : std_logic_vector(31 downto 0);
  signal neg_BD      : std_logic_vector(31 downto 0);



  component multiplier
  port (
    x : in  STD_LOGIC_VECTOR (31 downto 0);
    y : in  STD_LOGIC_VECTOR (31 downto 0);
    z : out  STD_LOGIC_VECTOR (31 downto 0)
  );
  end component;

  component adder
  port (
    x : in  STD_LOGIC_VECTOR (31 downto 0);
    y : in  STD_LOGIC_VECTOR (31 downto 0);
    z : out  STD_LOGIC_VECTOR (31 downto 0);
    clk: in std_logic
  );
  end component;
begin
  -- (a+bi)(c+di) = (ac-bd) + i(bc+ad)
  AC_MULTI : multiplier
  port map(
    x => Z1_RE,
    y => Z2_RE,
    z => AC
  );
  BD_MULTI : multiplier
  port map(
    x => Z1_IM,
    y => Z2_IM,
    z => BD
  );

  BC_MULTI : multiplier
  port map(
    x => Z1_IM,
    y => Z2_RE,
    z => BC
  );
  AD_MULTI : multiplier
  port map(
    x => Z1_RE,
    y => Z2_IM,
    z => AD
  );

  RE_ADDER : adder
  port map(
    x => AC,
    y => neg_BD,
    z => RESULT_RE,
    clk => CLK
  );

  IM_ADDER : adder
  port map(
    x => BC,
    y => AD,
    z => RESULT_IM,
    clk => CLK
  );

  neg_BD(30 downto 0) <= BD(30 downto 0);
  neg_BD(31) <= not BD(31);

end architecture;
