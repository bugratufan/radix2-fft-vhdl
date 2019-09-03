----------------------------------------------------------------------------------
-- Company: YONGATEK
-- Designer: Buğra Tufan
-- E-mail: bugratufan97@gmail.com
--
-- Create Date:    21.08.2019
-- Design Name:
-- Module Name:    RADIX
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: VHDL implementation of radix2 fft algorithm for IEEE-754
-- single precision floating point data format
--
-- Dependencies:
-- This module needs some extra vhdl files that listed below:
--  - adder.vhd
--  - complex_adder.vhd
--  - multiplier.vhd
--  - complex_multi.vhd
--
-- Revision:
-- Revision 1.0 - alpha
--------------------------------------------------------------------------------


Library IEEE;
use IEEE.Std_Logic_1164.all;


entity RADIX is
  port (
    CLK     : in   std_logic;
    X0      : in   STD_LOGIC_VECTOR (31 downto 0);
    X1      : in   STD_LOGIC_VECTOR (31 downto 0);
    X2      : in   STD_LOGIC_VECTOR (31 downto 0);
    X3      : in   STD_LOGIC_VECTOR (31 downto 0);
    X4      : in   STD_LOGIC_VECTOR (31 downto 0);
    X5      : in   STD_LOGIC_VECTOR (31 downto 0);
    X6      : in   STD_LOGIC_VECTOR (31 downto 0);
    X7      : in   STD_LOGIC_VECTOR (31 downto 0);
    X8      : in   STD_LOGIC_VECTOR (31 downto 0);
    X9      : in   STD_LOGIC_VECTOR (31 downto 0);
    X10     : in   STD_LOGIC_VECTOR (31 downto 0);
    X11     : in   STD_LOGIC_VECTOR (31 downto 0);
    X12     : in   STD_LOGIC_VECTOR (31 downto 0);
    X13     : in   STD_LOGIC_VECTOR (31 downto 0);
    X14     : in   STD_LOGIC_VECTOR (31 downto 0);
    X15     : in   STD_LOGIC_VECTOR (31 downto 0);
    Z0_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z0_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z1_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z1_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z2_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z2_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z3_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z3_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z4_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z4_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z5_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z5_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z6_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z6_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z7_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z7_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z8_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z8_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z9_RE   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z9_IM   : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z10_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z10_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z11_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z11_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z12_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z12_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z13_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z13_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z14_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z14_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z15_RE  : inout  STD_LOGIC_VECTOR (31 downto 0);
    Z15_IM  : inout  STD_LOGIC_VECTOR (31 downto 0)
  );
end entity;

architecture RTL of RADIX is
  type statetype is (ST1_A,ST1_M,ST2_A,ST2_M,ST3_A,ST3_M,ST4_A,RESULT);
  signal STATE : statetype := ST1_A;
  signal counter : integer := 0;

  -- LUT
  -- W16_0 = 1
  signal W16_0_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111100000000000000000000000";
  signal W16_0_IM : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
  -- W16_1 = 0.92388-0.38268i
  signal W16_1_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111011011001000001101011110";
  signal W16_1_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111110110000111110111100010101";
  -- W16_2 = 0.70711-0.70711i
  signal W16_2_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111001101010000010011110011";
  signal W16_2_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  -- W16_3 = 0.38268-0.92388i
  signal W16_3_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111110110000111110111100010101";
  signal W16_3_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111011011001000001101011110";
  -- W16_4 = 6.1232e-17-1i
  signal W16_4_RE : STD_LOGIC_VECTOR (31 downto 0) := "00100100100011010011000100110010";
  signal W16_4_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111100000000000000000000000";
  -- W16_5 = -0.38268-0.92388i
  signal W16_5_RE : STD_LOGIC_VECTOR (31 downto 0) := "10111110110000111110111100010101";
  signal W16_5_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111011011001000001101011110";
  -- W16_6 = -0.70711-0.70711i
  signal W16_6_RE : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  signal W16_6_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  -- W16_7 = -0.92388-0.38268i
  signal W16_7_RE : STD_LOGIC_VECTOR (31 downto 0) := "10111111011011001000001101011110";
  signal W16_7_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111110110000111110111100010101";
  -- W8_0 = 1
  signal W8_0_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111100000000000000000000000";
  signal W8_0_IM : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
  -- W8_1 = 0.70711-0.70711i
  signal W8_1_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111001101010000010011110011";
  signal W8_1_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  -- W8_2 = 6.1232e-17-1i
  signal W8_2_RE : STD_LOGIC_VECTOR (31 downto 0) := "00100100100011010011000100110010";
  signal W8_2_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111100000000000000000000000";
  -- W8_3 = -0.70711-0.70711i
  signal W8_3_RE : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  signal W8_3_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111001101010000010011110011";
  -- W40 = 1
  signal W4_0_RE : STD_LOGIC_VECTOR (31 downto 0) := "00111111100000000000000000000000";
  signal W4_0_IM : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
  -- W41 = 6.1232e-17-1i
  signal W4_1_RE : STD_LOGIC_VECTOR (31 downto 0) := "00100100100011010011000100110010";
  signal W4_1_IM : STD_LOGIC_VECTOR (31 downto 0) := "10111111100000000000000000000000";

  -- MULTIPLICATION REGISTERS
  signal CMPM1_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM1_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM1_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM1_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM1_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM1_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM2_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM2_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM2_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM2_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM2_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM2_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM3_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM3_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM3_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM3_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM3_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM3_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM4_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM4_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM4_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM4_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM4_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM4_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM5_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM5_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM5_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM5_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM5_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM5_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM6_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM6_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM6_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM6_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM6_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM6_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM7_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM7_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM7_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM7_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM7_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM7_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPM8_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPM8_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPM8_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPM8_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPM8_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPM8_RESULT_IM  : std_logic_vector(31 downto 0);

  -- ADDER REGISTERS
  signal CMPA1_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA1_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA1_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA1_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA1_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA1_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA2_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA2_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA2_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA2_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA2_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA2_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA3_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA3_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA3_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA3_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA3_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA3_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA4_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA4_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA4_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA4_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA4_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA4_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA5_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA5_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA5_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA5_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA5_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA5_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA6_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA6_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA6_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA6_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA6_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA6_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA7_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA7_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA7_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA7_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA7_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA7_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA8_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA8_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA8_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA8_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA8_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA8_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA9_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA9_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA9_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA9_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA9_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA9_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA10_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA10_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA10_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA10_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA10_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA10_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA11_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA11_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA11_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA11_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA11_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA11_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA12_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA12_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA12_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA12_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA12_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA12_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA13_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA13_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA13_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA13_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA13_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA13_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA14_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA14_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA14_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA14_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA14_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA14_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA15_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA15_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA15_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA15_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA15_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA15_RESULT_IM  : std_logic_vector(31 downto 0);

  signal CMPA16_Z1_IM      : std_logic_vector(31 downto 0);
  signal CMPA16_Z1_RE      : std_logic_vector(31 downto 0);
  signal CMPA16_Z2_RE      : std_logic_vector(31 downto 0);
  signal CMPA16_Z2_IM      : std_logic_vector(31 downto 0);
  signal CMPA16_RESULT_RE  : std_logic_vector(31 downto 0);
  signal CMPA16_RESULT_IM  : std_logic_vector(31 downto 0);

  signal valid  : std_logic := '0';


  component MULTI
    port (
      CLK        : in std_logic;
      Z1_IM      : in std_logic_vector(31 downto 0);
      Z1_RE      : in std_logic_vector(31 downto 0);
      Z2_RE      : in std_logic_vector(31 downto 0);
      Z2_IM      : in std_logic_vector(31 downto 0);
      RESULT_RE  : out std_logic_vector(31 downto 0);
      RESULT_IM  : out std_logic_vector(31 downto 0)
    );
  end component;

  component COMPLEX_ADDER
    port (
      CLK        : in std_logic;
      Z1_IM      : in std_logic_vector(31 downto 0);
      Z1_RE      : in std_logic_vector(31 downto 0);
      Z2_RE      : in std_logic_vector(31 downto 0);
      Z2_IM      : in std_logic_vector(31 downto 0);
      RESULT_RE  : out std_logic_vector(31 downto 0);
      RESULT_IM  : out std_logic_vector(31 downto 0)
    );
  end component;
begin
  COMPLEX_MULTI_1 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM1_Z1_IM,
    Z1_RE => CMPM1_Z1_RE,
    Z2_IM => CMPM1_Z2_IM,
    Z2_RE => CMPM1_Z2_RE,
    RESULT_IM => CMPM1_RESULT_IM,
    RESULT_RE => CMPM1_RESULT_RE
  );
  COMPLEX_MULTI_2 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM2_Z1_IM,
    Z1_RE => CMPM2_Z1_RE,
    Z2_IM => CMPM2_Z2_IM,
    Z2_RE => CMPM2_Z2_RE,
    RESULT_IM => CMPM2_RESULT_IM,
    RESULT_RE => CMPM2_RESULT_RE
  );
  COMPLEX_MULTI_3 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM3_Z1_IM,
    Z1_RE => CMPM3_Z1_RE,
    Z2_IM => CMPM3_Z2_IM,
    Z2_RE => CMPM3_Z2_RE,
    RESULT_IM => CMPM3_RESULT_IM,
    RESULT_RE => CMPM3_RESULT_RE
  );
  COMPLEX_MULTI_4 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM4_Z1_IM,
    Z1_RE => CMPM4_Z1_RE,
    Z2_IM => CMPM4_Z2_IM,
    Z2_RE => CMPM4_Z2_RE,
    RESULT_IM => CMPM4_RESULT_IM,
    RESULT_RE => CMPM4_RESULT_RE
  );
  COMPLEX_MULTI_5 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM5_Z1_IM,
    Z1_RE => CMPM5_Z1_RE,
    Z2_IM => CMPM5_Z2_IM,
    Z2_RE => CMPM5_Z2_RE,
    RESULT_IM => CMPM5_RESULT_IM,
    RESULT_RE => CMPM5_RESULT_RE
  );
  COMPLEX_MULTI_6 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM6_Z1_IM,
    Z1_RE => CMPM6_Z1_RE,
    Z2_IM => CMPM6_Z2_IM,
    Z2_RE => CMPM6_Z2_RE,
    RESULT_IM => CMPM6_RESULT_IM,
    RESULT_RE => CMPM6_RESULT_RE
  );
  COMPLEX_MULTI_7 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM7_Z1_IM,
    Z1_RE => CMPM7_Z1_RE,
    Z2_IM => CMPM7_Z2_IM,
    Z2_RE => CMPM7_Z2_RE,
    RESULT_IM => CMPM7_RESULT_IM,
    RESULT_RE => CMPM7_RESULT_RE
  );
  COMPLEX_MULTI_8 : MULTI
  port map(
    CLK => CLK,
    Z1_IM => CMPM8_Z1_IM,
    Z1_RE => CMPM8_Z1_RE,
    Z2_IM => CMPM8_Z2_IM,
    Z2_RE => CMPM8_Z2_RE,
    RESULT_IM => CMPM8_RESULT_IM,
    RESULT_RE => CMPM8_RESULT_RE
  );

  COMPLEX_ADDER_1: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA1_Z1_IM,
    Z1_RE => CMPA1_Z1_RE,
    Z2_IM => CMPA1_Z2_IM,
    Z2_RE => CMPA1_Z2_RE,
    RESULT_IM => CMPA1_RESULT_IM,
    RESULT_RE => CMPA1_RESULT_RE
  );
  COMPLEX_ADDER_2: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA2_Z1_IM,
    Z1_RE => CMPA2_Z1_RE,
    Z2_IM => CMPA2_Z2_IM,
    Z2_RE => CMPA2_Z2_RE,
    RESULT_IM => CMPA2_RESULT_IM,
    RESULT_RE => CMPA2_RESULT_RE
  );
  COMPLEX_ADDER_3: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA3_Z1_IM,
    Z1_RE => CMPA3_Z1_RE,
    Z2_IM => CMPA3_Z2_IM,
    Z2_RE => CMPA3_Z2_RE,
    RESULT_IM => CMPA3_RESULT_IM,
    RESULT_RE => CMPA3_RESULT_RE
  );
  COMPLEX_ADDER_4: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA4_Z1_IM,
    Z1_RE => CMPA4_Z1_RE,
    Z2_IM => CMPA4_Z2_IM,
    Z2_RE => CMPA4_Z2_RE,
    RESULT_IM => CMPA4_RESULT_IM,
    RESULT_RE => CMPA4_RESULT_RE
  );
  COMPLEX_ADDER_5: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA5_Z1_IM,
    Z1_RE => CMPA5_Z1_RE,
    Z2_IM => CMPA5_Z2_IM,
    Z2_RE => CMPA5_Z2_RE,
    RESULT_IM => CMPA5_RESULT_IM,
    RESULT_RE => CMPA5_RESULT_RE
  );
  COMPLEX_ADDER_6: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA6_Z1_IM,
    Z1_RE => CMPA6_Z1_RE,
    Z2_IM => CMPA6_Z2_IM,
    Z2_RE => CMPA6_Z2_RE,
    RESULT_IM => CMPA6_RESULT_IM,
    RESULT_RE => CMPA6_RESULT_RE
  );
  COMPLEX_ADDER_7: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA7_Z1_IM,
    Z1_RE => CMPA7_Z1_RE,
    Z2_IM => CMPA7_Z2_IM,
    Z2_RE => CMPA7_Z2_RE,
    RESULT_IM => CMPA7_RESULT_IM,
    RESULT_RE => CMPA7_RESULT_RE
  );
  COMPLEX_ADDER_8: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA8_Z1_IM,
    Z1_RE => CMPA8_Z1_RE,
    Z2_IM => CMPA8_Z2_IM,
    Z2_RE => CMPA8_Z2_RE,
    RESULT_IM => CMPA8_RESULT_IM,
    RESULT_RE => CMPA8_RESULT_RE
  );
  COMPLEX_ADDER_9: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA9_Z1_IM,
    Z1_RE => CMPA9_Z1_RE,
    Z2_IM => CMPA9_Z2_IM,
    Z2_RE => CMPA9_Z2_RE,
    RESULT_IM => CMPA9_RESULT_IM,
    RESULT_RE => CMPA9_RESULT_RE
  );
  COMPLEX_ADDER_10: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA10_Z1_IM,
    Z1_RE => CMPA10_Z1_RE,
    Z2_IM => CMPA10_Z2_IM,
    Z2_RE => CMPA10_Z2_RE,
    RESULT_IM => CMPA10_RESULT_IM,
    RESULT_RE => CMPA10_RESULT_RE
  );
  COMPLEX_ADDER_11: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA11_Z1_IM,
    Z1_RE => CMPA11_Z1_RE,
    Z2_IM => CMPA11_Z2_IM,
    Z2_RE => CMPA11_Z2_RE,
    RESULT_IM => CMPA11_RESULT_IM,
    RESULT_RE => CMPA11_RESULT_RE
  );

  COMPLEX_ADDER_12: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA12_Z1_IM,
    Z1_RE => CMPA12_Z1_RE,
    Z2_IM => CMPA12_Z2_IM,
    Z2_RE => CMPA12_Z2_RE,
    RESULT_IM => CMPA12_RESULT_IM,
    RESULT_RE => CMPA12_RESULT_RE
  );
  COMPLEX_ADDER_13: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA13_Z1_IM,
    Z1_RE => CMPA13_Z1_RE,
    Z2_IM => CMPA13_Z2_IM,
    Z2_RE => CMPA13_Z2_RE,
    RESULT_IM => CMPA13_RESULT_IM,
    RESULT_RE => CMPA13_RESULT_RE
  );
  COMPLEX_ADDER_14: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA14_Z1_IM,
    Z1_RE => CMPA14_Z1_RE,
    Z2_IM => CMPA14_Z2_IM,
    Z2_RE => CMPA14_Z2_RE,
    RESULT_IM => CMPA14_RESULT_IM,
    RESULT_RE => CMPA14_RESULT_RE
  );
  COMPLEX_ADDER_15: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA15_Z1_IM,
    Z1_RE => CMPA15_Z1_RE,
    Z2_IM => CMPA15_Z2_IM,
    Z2_RE => CMPA15_Z2_RE,
    RESULT_IM => CMPA15_RESULT_IM,
    RESULT_RE => CMPA15_RESULT_RE
  );
  COMPLEX_ADDER_16: COMPLEX_ADDER
  port map(
    CLK => CLK,
    Z1_IM => CMPA16_Z1_IM,
    Z1_RE => CMPA16_Z1_RE,
    Z2_IM => CMPA16_Z2_IM,
    Z2_RE => CMPA16_Z2_RE,
    RESULT_IM => CMPA16_RESULT_IM,
    RESULT_RE => CMPA16_RESULT_RE
  );
  state_proc: process(CLK)
  begin
    if clk'event and clk='1' then
      case( STATE ) is
        when ST1_A =>
          valid <= '0';
          CMPA1_Z1_RE <= X0;
          CMPA1_Z1_IM <= (others => '0');
          CMPA1_Z2_RE <= X8;
          CMPA1_Z2_IM <= (others => '0');

          CMPA2_Z1_RE <= X1;
          CMPA2_Z1_IM <= (others => '0');
          CMPA2_Z2_RE <= X9;
          CMPA2_Z2_IM <= (others => '0');

          CMPA3_Z1_RE <= X2;
          CMPA3_Z1_IM <= (others => '0');
          CMPA3_Z2_RE <= X10;
          CMPA3_Z2_IM <= (others => '0');

          CMPA4_Z1_RE <= X3;
          CMPA4_Z1_IM <= (others => '0');
          CMPA4_Z2_RE <= X11;
          CMPA4_Z2_IM <= (others => '0');

          CMPA5_Z1_RE <= X4;
          CMPA5_Z1_IM <= (others => '0');
          CMPA5_Z2_RE <= X12;
          CMPA5_Z2_IM <= (others => '0');

          CMPA6_Z1_RE <= X5;
          CMPA6_Z1_IM <= (others => '0');
          CMPA6_Z2_RE <= X13;
          CMPA6_Z2_IM <= (others => '0');

          CMPA7_Z1_RE <= X6;
          CMPA7_Z1_IM <= (others => '0');
          CMPA7_Z2_RE <= X14;
          CMPA7_Z2_IM <= (others => '0');

          CMPA8_Z1_RE <= X7;
          CMPA8_Z1_IM <= (others => '0');
          CMPA8_Z2_RE <= X15;
          CMPA8_Z2_IM <= (others => '0');

          CMPA9_Z1_RE <= X0;
          CMPA9_Z1_IM <= (others => '0');
          CMPA9_Z2_RE(31) <= not X8(31);
          CMPA9_Z2_RE(30 downto 0) <= X8(30 downto 0);
          CMPA9_Z2_IM <= (others => '0');

          CMPA10_Z1_RE <= X1;
          CMPA10_Z1_IM <= (others => '0');
          CMPA10_Z2_RE(31) <= not X9(31);
          CMPA10_Z2_RE(30 downto 0) <= X9(30 downto 0);
          CMPA10_Z2_IM <= (others => '0');

          CMPA11_Z1_RE <= X2;
          CMPA11_Z1_IM <= (others => '0');
          CMPA11_Z2_RE(31) <= not X10(31);
          CMPA11_Z2_RE(30 downto 0) <= X10(30 downto 0);
          CMPA11_Z2_IM <= (others => '0');

          CMPA12_Z1_RE <= X3;
          CMPA12_Z1_IM <= (others => '0');
          CMPA12_Z2_RE(31) <= not X11(31);
          CMPA12_Z2_RE(30 downto 0) <= X11(30 downto 0);
          CMPA12_Z2_IM <= (others => '0');

          CMPA13_Z1_RE <= X4;
          CMPA13_Z1_IM <= (others => '0');
          CMPA13_Z2_RE(31) <= not X12(31);
          CMPA13_Z2_RE(30 downto 0) <= X12(30 downto 0);
          CMPA13_Z2_IM <= (others => '0');

          CMPA14_Z1_RE <= X5;
          CMPA14_Z1_IM <= (others => '0');
          CMPA14_Z2_RE(31) <= not X13(31);
          CMPA14_Z2_RE(30 downto 0) <= X13(30 downto 0);
          CMPA14_Z2_IM <= (others => '0');

          CMPA15_Z1_RE <= X6;
          CMPA15_Z1_IM <= (others => '0');
          CMPA15_Z2_RE(31) <= not X14(31);
          CMPA15_Z2_RE(30 downto 0) <= X14(30 downto 0);
          CMPA15_Z2_IM <= (others => '0');

          CMPA16_Z1_RE <= X7;
          CMPA16_Z1_IM <= (others => '0');
          CMPA16_Z2_RE(31) <= not X15(31);
          CMPA16_Z2_RE(30 downto 0) <= X15(30 downto 0);
          CMPA16_Z2_IM <= (others => '0');
          counter <= counter + 1;
          if counter = 3 then
            Z0_RE <= CMPA1_RESULT_RE;
            Z0_IM <= CMPA1_RESULT_IM;
            Z1_RE <= CMPA2_RESULT_RE;
            Z1_IM <= CMPA2_RESULT_IM;
            Z2_RE <= CMPA3_RESULT_RE;
            Z2_IM <= CMPA3_RESULT_IM;
            Z3_RE <= CMPA4_RESULT_RE;
            Z3_IM <= CMPA4_RESULT_IM;
            Z4_RE <= CMPA5_RESULT_RE;
            Z4_IM <= CMPA5_RESULT_IM;
            Z5_RE <= CMPA6_RESULT_RE;
            Z5_IM <= CMPA6_RESULT_IM;
            Z6_RE <= CMPA7_RESULT_RE;
            Z6_IM <= CMPA7_RESULT_IM;
            Z7_RE <= CMPA8_RESULT_RE;
            Z7_IM <= CMPA8_RESULT_IM;
            Z8_RE <= CMPA9_RESULT_RE;
            Z8_IM <= CMPA9_RESULT_IM;
            Z9_RE <= CMPA10_RESULT_RE;
            Z9_IM <= CMPA10_RESULT_IM;
            Z10_RE <= CMPA11_RESULT_RE;
            Z10_IM <= CMPA11_RESULT_IM;
            Z11_RE <= CMPA12_RESULT_RE;
            Z11_IM <= CMPA12_RESULT_IM;
            Z12_RE <= CMPA13_RESULT_RE;
            Z12_IM <= CMPA13_RESULT_IM;
            Z13_RE <= CMPA14_RESULT_RE;
            Z13_IM <= CMPA14_RESULT_IM;
            Z14_RE <= CMPA15_RESULT_RE;
            Z14_IM <= CMPA15_RESULT_IM;
            Z15_RE <= CMPA16_RESULT_RE;
            Z15_IM <= CMPA16_RESULT_IM;
            counter <= 0;
            STATE <= ST1_M;
          end if;

        when ST1_M =>
          CMPM1_Z1_RE <= Z8_RE;
          CMPM1_Z1_IM <= Z8_IM;
          CMPM1_Z2_RE <= W16_0_RE;
          CMPM1_Z2_IM <= W16_0_IM;

          CMPM2_Z1_RE <= Z9_RE;
          CMPM2_Z1_IM <= Z9_IM;
          CMPM2_Z2_RE <= W16_1_RE;
          CMPM2_Z2_IM <= W16_1_IM;

          CMPM3_Z1_RE <= Z10_RE;
          CMPM3_Z1_IM <= Z10_IM;
          CMPM3_Z2_RE <= W16_2_RE;
          CMPM3_Z2_IM <= W16_2_IM;

          CMPM4_Z1_RE <= Z11_RE;
          CMPM4_Z1_IM <= Z11_IM;
          CMPM4_Z2_RE <= W16_3_RE;
          CMPM4_Z2_IM <= W16_3_IM;

          CMPM5_Z1_RE <= Z12_RE;
          CMPM5_Z1_IM <= Z12_IM;
          CMPM5_Z2_RE <= W16_4_RE;
          CMPM5_Z2_IM <= W16_4_IM;

          CMPM6_Z1_RE <= Z13_RE;
          CMPM6_Z1_IM <= Z13_IM;
          CMPM6_Z2_RE <= W16_5_RE;
          CMPM6_Z2_IM <= W16_5_IM;

          CMPM7_Z1_RE <= Z14_RE;
          CMPM7_Z1_IM <= Z14_IM;
          CMPM7_Z2_IM <= W16_6_IM;
          CMPM7_Z2_RE <= W16_6_RE;

          CMPM8_Z1_RE <= Z15_RE;
          CMPM8_Z1_IM <= Z15_IM;
          CMPM8_Z2_RE <= W16_7_RE;
          CMPM8_Z2_IM <= W16_7_IM;

          counter <= counter + 1;
          if counter = 3 then
            Z8_RE <= CMPM1_RESULT_RE;
            Z8_IM <= CMPM1_RESULT_IM;
            Z9_RE <= CMPM2_RESULT_RE;
            Z9_IM <= CMPM2_RESULT_IM;
            Z10_RE <= CMPM3_RESULT_RE;
            Z10_IM <= CMPM3_RESULT_IM;
            Z11_RE <= CMPM4_RESULT_RE;
            Z11_IM <= CMPM4_RESULT_IM;
            Z12_RE <= CMPM5_RESULT_RE;
            Z12_IM <= CMPM5_RESULT_IM;
            Z13_RE <= CMPM6_RESULT_RE;
            Z13_IM <= CMPM6_RESULT_IM;
            Z14_RE <= CMPM7_RESULT_RE;
            Z14_IM <= CMPM7_RESULT_IM;
            Z15_RE <= CMPM8_RESULT_RE;
            Z15_IM <= CMPM8_RESULT_IM;
            STATE <= ST2_A;
            counter <= 0;
          end if;
        when ST2_A =>
          CMPA1_Z1_RE <= Z0_RE;
          CMPA1_Z1_IM <= Z0_IM;
          CMPA1_Z2_RE <= Z4_RE;
          CMPA1_Z2_IM <= Z4_IM;

          CMPA2_Z1_RE <= Z1_RE;
          CMPA2_Z1_IM <= Z1_IM;
          CMPA2_Z2_RE <= Z5_RE;
          CMPA2_Z2_IM <= Z5_IM;

          CMPA3_Z1_RE <= Z2_RE;
          CMPA3_Z1_IM <= Z2_IM;
          CMPA3_Z2_RE <= Z6_RE;
          CMPA3_Z2_IM <= Z6_IM;

          CMPA4_Z1_RE <= Z3_RE;
          CMPA4_Z1_IM <= Z3_IM;
          CMPA4_Z2_RE <= Z7_RE;
          CMPA4_Z2_IM <= Z7_IM;

          CMPA5_Z1_RE <= Z0_RE;
          CMPA5_Z1_IM <= Z0_IM;
          CMPA5_Z2_RE(31) <= not Z4_RE(31);
          CMPA5_Z2_RE(30 downto 0) <= Z4_RE(30 downto 0);
          CMPA5_Z2_IM(31) <= not Z4_IM(31);
          CMPA5_Z2_IM(30 downto 0) <= Z4_IM(30 downto 0);

          CMPA6_Z1_RE <= Z1_RE;
          CMPA6_Z1_IM <= Z1_IM;
          CMPA6_Z2_RE(31) <= not Z5_RE(31);
          CMPA6_Z2_RE(30 downto 0) <= Z5_RE(30 downto 0);
          CMPA6_Z2_IM(31) <= not Z5_IM(31);
          CMPA6_Z2_IM(30 downto 0) <= Z5_IM(30 downto 0);

          CMPA7_Z1_RE <= Z2_RE;
          CMPA7_Z1_IM <= Z2_IM;
          CMPA7_Z2_RE(31) <= not Z6_RE(31);
          CMPA7_Z2_RE(30 downto 0) <= Z6_RE(30 downto 0);
          CMPA7_Z2_IM(31) <= not Z6_IM(31);
          CMPA7_Z2_IM(30 downto 0) <= Z6_IM(30 downto 0);

          CMPA8_Z1_RE <= Z3_RE;
          CMPA8_Z1_IM <= Z3_IM;
          CMPA8_Z2_RE(31) <= not Z7_RE(31);
          CMPA8_Z2_RE(30 downto 0) <= Z7_RE(30 downto 0);
          CMPA8_Z2_IM(31) <= not Z7_IM(31);
          CMPA8_Z2_IM(30 downto 0) <= Z7_IM(30 downto 0);

          CMPA9_Z1_RE <= Z8_RE;
          CMPA9_Z1_IM <= Z8_IM;
          CMPA9_Z2_RE <= Z12_RE;
          CMPA9_Z2_IM <= Z12_IM;

          CMPA10_Z1_RE <= Z9_RE;
          CMPA10_Z1_IM <= Z9_IM;
          CMPA10_Z2_RE <= Z13_RE;
          CMPA10_Z2_IM <= Z13_IM;

          CMPA11_Z1_RE <= Z10_RE;
          CMPA11_Z1_IM <= Z10_IM;
          CMPA11_Z2_RE <= Z14_RE;
          CMPA11_Z2_IM <= Z14_IM;

          CMPA12_Z1_RE <= Z11_RE;
          CMPA12_Z1_IM <= Z11_IM;
          CMPA12_Z2_RE <= Z15_RE;
          CMPA12_Z2_IM <= Z15_IM;

          CMPA13_Z1_RE <= Z8_RE;
          CMPA13_Z1_IM <= Z8_IM;
          CMPA13_Z2_RE(31) <= not Z12_RE(31);
          CMPA13_Z2_RE(30 downto 0) <= Z12_RE(30 downto 0);
          CMPA13_Z2_IM(31) <= not Z12_IM(31);
          CMPA13_Z2_IM(30 downto 0) <= Z12_IM(30 downto 0);

          CMPA14_Z1_RE <= Z9_RE;
          CMPA14_Z1_IM <= Z9_IM;
          CMPA14_Z2_RE(31) <= not Z13_RE(31);
          CMPA14_Z2_RE(30 downto 0) <= Z13_RE(30 downto 0);
          CMPA14_Z2_IM(31) <= not Z13_IM(31);
          CMPA14_Z2_IM(30 downto 0) <= Z13_IM(30 downto 0);

          CMPA15_Z1_RE <= Z10_RE;
          CMPA15_Z1_IM <= Z10_IM;
          CMPA15_Z2_RE(31) <= not Z14_RE(31);
          CMPA15_Z2_RE(30 downto 0) <= Z14_RE(30 downto 0);
          CMPA15_Z2_IM(31) <= not Z14_IM(31);
          CMPA15_Z2_IM(30 downto 0) <= Z14_IM(30 downto 0);

          CMPA16_Z1_RE <= Z11_RE;
          CMPA16_Z1_IM <= Z11_IM;
          CMPA16_Z2_RE(31) <= not Z15_RE(31);
          CMPA16_Z2_RE(30 downto 0) <= Z15_RE(30 downto 0);
          CMPA16_Z2_IM(31) <= not Z15_IM(31);
          CMPA16_Z2_IM(30 downto 0) <= Z15_IM(30 downto 0);
          counter <= counter + 1;
          if counter = 3 then

            Z0_RE <= CMPA1_RESULT_RE;
            Z0_IM <= CMPA1_RESULT_IM;
            Z1_RE <= CMPA2_RESULT_RE;
            Z1_IM <= CMPA2_RESULT_IM;
            Z2_RE <= CMPA3_RESULT_RE;
            Z2_IM <= CMPA3_RESULT_IM;
            Z3_RE <= CMPA4_RESULT_RE;
            Z3_IM <= CMPA4_RESULT_IM;
            Z4_RE <= CMPA5_RESULT_RE;
            Z4_IM <= CMPA5_RESULT_IM;
            Z5_RE <= CMPA6_RESULT_RE;
            Z5_IM <= CMPA6_RESULT_IM;
            Z6_RE <= CMPA7_RESULT_RE;
            Z6_IM <= CMPA7_RESULT_IM;
            Z7_RE <= CMPA8_RESULT_RE;
            Z7_IM <= CMPA8_RESULT_IM;
            Z8_RE <= CMPA9_RESULT_RE;
            Z8_IM <= CMPA9_RESULT_IM;
            Z9_RE <= CMPA10_RESULT_RE;
            Z9_IM <= CMPA10_RESULT_IM;
            Z10_RE <= CMPA11_RESULT_RE;
            Z10_IM <= CMPA11_RESULT_IM;
            Z11_RE <= CMPA12_RESULT_RE;
            Z11_IM <= CMPA12_RESULT_IM;
            Z12_RE <= CMPA13_RESULT_RE;
            Z12_IM <= CMPA13_RESULT_IM;
            Z13_RE <= CMPA14_RESULT_RE;
            Z13_IM <= CMPA14_RESULT_IM;
            Z14_RE <= CMPA15_RESULT_RE;
            Z14_IM <= CMPA15_RESULT_IM;
            Z15_RE <= CMPA16_RESULT_RE;
            Z15_IM <= CMPA16_RESULT_IM;
            STATE <= ST2_M;
            counter <= 0;
          end if;
        when ST2_M =>
          CMPM1_Z1_RE <= Z4_RE;
          CMPM1_Z1_IM <= Z4_IM;
          CMPM1_Z2_RE <= W8_0_RE;
          CMPM1_Z2_IM <= W8_0_IM;

          CMPM2_Z1_RE <= Z5_RE;
          CMPM2_Z1_IM <= Z5_IM;
          CMPM2_Z2_RE <= W8_1_RE;
          CMPM2_Z2_IM <= W8_1_IM;

          CMPM3_Z1_RE <= Z6_RE;
          CMPM3_Z1_IM <= Z6_IM;
          CMPM3_Z2_RE <= W8_2_RE;
          CMPM3_Z2_IM <= W8_2_IM;

          CMPM4_Z1_RE <= Z7_RE;
          CMPM4_Z1_IM <= Z7_IM;
          CMPM4_Z2_RE <= W8_3_RE;
          CMPM4_Z2_IM <= W8_3_IM;

          CMPM5_Z1_RE <= Z12_RE;
          CMPM5_Z1_IM <= Z12_IM;
          CMPM5_Z2_RE <= W8_0_RE;
          CMPM5_Z2_IM <= W8_0_IM;

          CMPM6_Z1_RE <= Z13_RE;
          CMPM6_Z1_IM <= Z13_IM;
          CMPM6_Z2_RE <= W8_1_RE;
          CMPM6_Z2_IM <= W8_1_IM;

          CMPM7_Z1_RE <= Z14_RE;
          CMPM7_Z1_IM <= Z14_IM;
          CMPM7_Z2_RE <= W8_2_RE;
          CMPM7_Z2_IM <= W8_2_IM;

          CMPM8_Z1_RE <= Z15_RE;
          CMPM8_Z1_IM <= Z15_IM;
          CMPM8_Z2_RE <= W8_3_RE;
          CMPM8_Z2_IM <= W8_3_IM;

          counter <= counter + 1;
          if counter = 3 then
            Z4_RE <= CMPM1_RESULT_RE;
            Z4_IM <= CMPM1_RESULT_IM;
            Z5_RE <= CMPM2_RESULT_RE;
            Z5_IM <= CMPM2_RESULT_IM;
            Z6_RE <= CMPM3_RESULT_RE;
            Z6_IM <= CMPM3_RESULT_IM;
            Z7_RE <= CMPM4_RESULT_RE;
            Z7_IM <= CMPM4_RESULT_IM;
            Z12_RE <= CMPM5_RESULT_RE;
            Z12_IM <= CMPM5_RESULT_IM;
            Z13_RE <= CMPM6_RESULT_RE;
            Z13_IM <= CMPM6_RESULT_IM;
            Z14_RE <= CMPM7_RESULT_RE;
            Z14_IM <= CMPM7_RESULT_IM;
            Z15_RE <= CMPM8_RESULT_RE;
            Z15_IM <= CMPM8_RESULT_IM;
            STATE <= ST3_A;
            counter <= 0;
          end if;
        when ST3_A =>
          CMPA1_Z1_RE <= Z0_RE;
          CMPA1_Z1_IM <= Z0_IM;
          CMPA1_Z2_RE <= Z2_RE;
          CMPA1_Z2_IM <= Z2_IM;

          CMPA2_Z1_RE <= Z1_RE;
          CMPA2_Z1_IM <= Z1_IM;
          CMPA2_Z2_RE <= Z3_RE;
          CMPA2_Z2_IM <= Z3_IM;

          CMPA3_Z1_RE <= Z0_RE;
          CMPA3_Z1_IM <= Z0_IM;
          CMPA3_Z2_RE(31) <= not Z2_RE(31);
          CMPA3_Z2_RE(30 downto 0) <= Z2_RE(30 downto 0);
          CMPA3_Z2_IM(31) <= not Z2_IM(31);
          CMPA3_Z2_IM(30 downto 0) <= Z2_IM(30 downto 0);

          CMPA4_Z1_RE <= Z1_RE;
          CMPA4_Z1_IM <= Z1_IM;
          CMPA4_Z2_RE(31) <= not Z3_RE(31);
          CMPA4_Z2_RE(30 downto 0) <= Z3_RE(30 downto 0);
          CMPA4_Z2_IM(31) <= not Z3_IM(31);
          CMPA4_Z2_IM(30 downto 0) <= Z3_IM(30 downto 0);

          CMPA5_Z1_RE <= Z4_RE;
          CMPA5_Z1_IM <= Z4_IM;
          CMPA5_Z2_RE <= Z6_RE;
          CMPA5_Z2_IM <= Z6_IM;

          CMPA6_Z1_RE <= Z5_RE;
          CMPA6_Z1_IM <= Z5_IM;
          CMPA6_Z2_RE <= Z7_RE;
          CMPA6_Z2_IM <= Z7_IM;

          CMPA7_Z1_RE <= Z4_RE;
          CMPA7_Z1_IM <= Z4_IM;
          CMPA7_Z2_RE(31) <= not Z6_RE(31);
          CMPA7_Z2_RE(30 downto 0) <= Z6_RE(30 downto 0);
          CMPA7_Z2_IM(31) <= not Z6_IM(31);
          CMPA7_Z2_IM(30 downto 0) <= Z6_IM(30 downto 0);

          CMPA8_Z1_RE <= Z5_RE;
          CMPA8_Z1_IM <= Z5_IM;
          CMPA8_Z2_RE(31) <= not Z7_RE(31);
          CMPA8_Z2_RE(30 downto 0) <= Z7_RE(30 downto 0);
          CMPA8_Z2_IM(31) <= not Z7_IM(31);
          CMPA8_Z2_IM(30 downto 0) <= Z7_IM(30 downto 0);

          CMPA9_Z1_RE <= Z8_RE;
          CMPA9_Z1_IM <= Z8_IM;
          CMPA9_Z2_RE <= Z10_RE;
          CMPA9_Z2_IM <= Z10_IM;

          CMPA10_Z1_RE <= Z9_RE;
          CMPA10_Z1_IM <= Z9_IM;
          CMPA10_Z2_RE <= Z11_RE;
          CMPA10_Z2_IM <= Z11_IM;

          CMPA11_Z1_RE <= Z8_RE;
          CMPA11_Z1_IM <= Z8_IM;
          CMPA11_Z2_RE(31) <= not Z10_RE(31);
          CMPA11_Z2_RE(30 downto 0) <= Z10_RE(30 downto 0);
          CMPA11_Z2_IM(31) <= not Z10_IM(31);
          CMPA11_Z2_IM(30 downto 0) <= Z10_IM(30 downto 0);

          CMPA12_Z1_RE <= Z9_RE;
          CMPA12_Z1_IM <= Z9_IM;
          CMPA12_Z2_RE(31) <= not Z11_RE(31);
          CMPA12_Z2_RE(30 downto 0) <= Z11_RE(30 downto 0);
          CMPA12_Z2_IM(31) <= not Z11_IM(31);
          CMPA12_Z2_IM(30 downto 0) <= Z11_IM(30 downto 0);

          CMPA13_Z1_RE <= Z12_RE;
          CMPA13_Z1_IM <= Z12_IM;
          CMPA13_Z2_RE <= Z14_RE;
          CMPA13_Z2_IM <= Z14_IM;

          CMPA14_Z1_RE <= Z13_RE;
          CMPA14_Z1_IM <= Z13_IM;
          CMPA14_Z2_RE <= Z15_RE;
          CMPA14_Z2_IM <= Z15_IM;

          CMPA15_Z1_RE <= Z12_RE;
          CMPA15_Z1_IM <= Z12_IM;
          CMPA15_Z2_RE(31) <= not Z14_RE(31);
          CMPA15_Z2_RE(30 downto 0) <= Z14_RE(30 downto 0);
          CMPA15_Z2_IM(31) <= not Z14_IM(31);
          CMPA15_Z2_IM(30 downto 0) <= Z14_IM(30 downto 0);

          CMPA16_Z1_RE <= Z13_RE;
          CMPA16_Z1_IM <= Z13_IM;
          CMPA16_Z2_RE(31) <= not Z15_RE(31);
          CMPA16_Z2_RE(30 downto 0) <= Z15_RE(30 downto 0);
          CMPA16_Z2_IM(31) <= not Z15_IM(31);
          CMPA16_Z2_IM(30 downto 0) <= Z15_IM(30 downto 0);

          counter <= counter + 1;
          if counter = 3 then

            Z0_RE <= CMPA1_RESULT_RE;
            Z0_IM <= CMPA1_RESULT_IM;
            Z1_RE <= CMPA2_RESULT_RE;
            Z1_IM <= CMPA2_RESULT_IM;
            Z2_RE <= CMPA3_RESULT_RE;
            Z2_IM <= CMPA3_RESULT_IM;
            Z3_RE <= CMPA4_RESULT_RE;
            Z3_IM <= CMPA4_RESULT_IM;
            Z4_RE <= CMPA5_RESULT_RE;
            Z4_IM <= CMPA5_RESULT_IM;
            Z5_RE <= CMPA6_RESULT_RE;
            Z5_IM <= CMPA6_RESULT_IM;
            Z6_RE <= CMPA7_RESULT_RE;
            Z6_IM <= CMPA7_RESULT_IM;
            Z7_RE <= CMPA8_RESULT_RE;
            Z7_IM <= CMPA8_RESULT_IM;
            Z8_RE <= CMPA9_RESULT_RE;
            Z8_IM <= CMPA9_RESULT_IM;
            Z9_RE <= CMPA10_RESULT_RE;
            Z9_IM <= CMPA10_RESULT_IM;
            Z10_RE <= CMPA11_RESULT_RE;
            Z10_IM <= CMPA11_RESULT_IM;
            Z11_RE <= CMPA12_RESULT_RE;
            Z11_IM <= CMPA12_RESULT_IM;
            Z12_RE <= CMPA13_RESULT_RE;
            Z12_IM <= CMPA13_RESULT_IM;
            Z13_RE <= CMPA14_RESULT_RE;
            Z13_IM <= CMPA14_RESULT_IM;
            Z14_RE <= CMPA15_RESULT_RE;
            Z14_IM <= CMPA15_RESULT_IM;
            Z15_RE <= CMPA16_RESULT_RE;
            Z15_IM <= CMPA16_RESULT_IM;
            STATE <= ST3_M;
            counter <= 0;
          end if;
        when ST3_M =>
          CMPM1_Z1_RE <= Z2_RE;
          CMPM1_Z1_IM <= Z2_IM;
          CMPM1_Z2_RE <= W4_0_RE;
          CMPM1_Z2_IM <= W4_0_IM;

          CMPM2_Z1_RE <= Z3_RE;
          CMPM2_Z1_IM <= Z3_IM;
          CMPM2_Z2_RE <= W4_1_RE;
          CMPM2_Z2_IM <= W4_1_IM;

          CMPM3_Z1_RE <= Z6_RE;
          CMPM3_Z1_IM <= Z6_IM;
          CMPM3_Z2_RE <= W4_0_RE;
          CMPM3_Z2_IM <= W4_0_IM;

          CMPM4_Z1_RE <= Z7_RE;
          CMPM4_Z1_IM <= Z7_IM;
          CMPM4_Z2_RE <= W4_1_RE;
          CMPM4_Z2_IM <= W4_1_IM;

          CMPM5_Z1_RE <= Z10_RE;
          CMPM5_Z1_IM <= Z10_IM;
          CMPM5_Z2_RE <= W4_0_RE;
          CMPM5_Z2_IM <= W4_0_IM;

          CMPM6_Z1_RE <= Z11_RE;
          CMPM6_Z1_IM <= Z11_IM;
          CMPM6_Z2_RE <= W4_1_RE;
          CMPM6_Z2_IM <= W4_1_IM;

          CMPM7_Z1_RE <= Z14_RE;
          CMPM7_Z1_IM <= Z14_IM;
          CMPM7_Z2_RE <= W4_0_RE;
          CMPM7_Z2_IM <= W4_0_IM;

          CMPM8_Z1_RE <= Z15_RE;
          CMPM8_Z1_IM <= Z15_IM;
          CMPM8_Z2_RE <= W4_1_RE;
          CMPM8_Z2_IM <= W4_1_IM;

          counter <= counter + 1;
          if counter = 3 then
            Z2_RE <= CMPM1_RESULT_RE;
            Z2_IM <= CMPM1_RESULT_IM;
            Z3_RE <= CMPM2_RESULT_RE;
            Z3_IM <= CMPM2_RESULT_IM;
            Z6_RE <= CMPM3_RESULT_RE;
            Z6_IM <= CMPM3_RESULT_IM;
            Z7_RE <= CMPM4_RESULT_RE;
            Z7_IM <= CMPM4_RESULT_IM;
            Z10_RE <= CMPM5_RESULT_RE;
            Z10_IM <= CMPM5_RESULT_IM;
            Z11_RE <= CMPM6_RESULT_RE;
            Z11_IM <= CMPM6_RESULT_IM;
            Z14_RE <= CMPM7_RESULT_RE;
            Z14_IM <= CMPM7_RESULT_IM;
            Z15_RE <= CMPM8_RESULT_RE;
            Z15_IM <= CMPM8_RESULT_IM;
            STATE <= ST4_A;
            counter <= 0;
          end if;
        when ST4_A =>
          CMPA1_Z1_RE <= Z0_RE;
          CMPA1_Z1_IM <= Z0_IM;
          CMPA1_Z2_RE <= Z1_RE;
          CMPA1_Z2_IM <= Z1_IM;

          CMPA2_Z1_RE <= Z0_RE;
          CMPA2_Z1_IM <= Z0_IM;
          CMPA2_Z2_RE(31) <= not Z1_RE(31);
          CMPA2_Z2_RE(30 downto 0) <= Z1_RE(30 downto 0);
          CMPA2_Z2_IM(31) <= not Z1_IM(31);
          CMPA2_Z2_IM(30 downto 0) <= Z1_IM(30 downto 0);

          CMPA3_Z1_RE <= Z2_RE;
          CMPA3_Z1_IM <= Z2_IM;
          CMPA3_Z2_RE <= Z3_RE;
          CMPA3_Z2_IM <= Z3_IM;

          CMPA4_Z1_RE <= Z2_RE;
          CMPA4_Z1_IM <= Z2_IM;
          CMPA4_Z2_RE(31) <= not Z3_RE(31);
          CMPA4_Z2_RE(30 downto 0) <= Z3_RE(30 downto 0);
          CMPA4_Z2_IM(31) <= not Z3_IM(31);
          CMPA4_Z2_IM(30 downto 0) <= Z3_IM(30 downto 0);

          CMPA5_Z1_RE <= Z4_RE;
          CMPA5_Z1_IM <= Z4_IM;
          CMPA5_Z2_RE <= Z5_RE;
          CMPA5_Z2_IM <= Z5_IM;

          CMPA6_Z1_RE <= Z4_RE;
          CMPA6_Z1_IM <= Z4_IM;
          CMPA6_Z2_RE(31) <= not Z5_RE(31);
          CMPA6_Z2_RE(30 downto 0) <= Z5_RE(30 downto 0);
          CMPA6_Z2_IM(31) <= not Z5_IM(31);
          CMPA6_Z2_IM(30 downto 0) <= Z5_IM(30 downto 0);

          CMPA7_Z1_RE <= Z6_RE;
          CMPA7_Z1_IM <= Z6_IM;
          CMPA7_Z2_RE <= Z7_RE;
          CMPA7_Z2_IM <= Z7_IM;

          CMPA8_Z1_RE <= Z6_RE;
          CMPA8_Z1_IM <= Z6_IM;
          CMPA8_Z2_RE(31) <= not Z7_RE(31);
          CMPA8_Z2_RE(30 downto 0) <= Z7_RE(30 downto 0);
          CMPA8_Z2_IM(31) <= not Z7_IM(31);
          CMPA8_Z2_IM(30 downto 0) <= Z7_IM(30 downto 0);

          CMPA9_Z1_RE <= Z8_RE;
          CMPA9_Z1_IM <= Z8_IM;
          CMPA9_Z2_RE <= Z9_RE;
          CMPA9_Z2_IM <= Z9_IM;

          CMPA10_Z1_RE <= Z8_RE;
          CMPA10_Z1_IM <= Z8_IM;
          CMPA10_Z2_RE(31) <= not Z9_RE(31);
          CMPA10_Z2_RE(30 downto 0) <= Z9_RE(30 downto 0);
          CMPA10_Z2_IM(31) <= not Z9_IM(31);
          CMPA10_Z2_IM(30 downto 0) <= Z9_IM(30 downto 0);

          CMPA11_Z1_RE <= Z10_RE;
          CMPA11_Z1_IM <= Z10_IM;
          CMPA11_Z2_RE <= Z11_RE;
          CMPA11_Z2_IM <= Z11_IM;

          CMPA12_Z1_RE <= Z10_RE;
          CMPA12_Z1_IM <= Z10_IM;
          CMPA12_Z2_RE(31) <= not Z11_RE(31);
          CMPA12_Z2_RE(30 downto 0) <= Z11_RE(30 downto 0);
          CMPA12_Z2_IM(31) <= not Z11_IM(31);
          CMPA12_Z2_IM(30 downto 0) <= Z11_IM(30 downto 0);

          CMPA13_Z1_RE <= Z12_RE;
          CMPA13_Z1_IM <= Z12_IM;
          CMPA13_Z2_RE <= Z13_RE;
          CMPA13_Z2_IM <= Z13_IM;

          CMPA14_Z1_RE <= Z12_RE;
          CMPA14_Z1_IM <= Z12_IM;
          CMPA14_Z2_RE(31) <= not Z13_RE(31);
          CMPA14_Z2_RE(30 downto 0) <= Z13_RE(30 downto 0);
          CMPA14_Z2_IM(31) <= not Z13_IM(31);
          CMPA14_Z2_IM(30 downto 0) <= Z13_IM(30 downto 0);

          CMPA15_Z1_RE <= Z14_RE;
          CMPA15_Z1_IM <= Z14_IM;
          CMPA15_Z2_RE <= Z15_RE;
          CMPA15_Z2_IM <= Z15_IM;

          CMPA16_Z1_RE <= Z14_RE;
          CMPA16_Z1_IM <= Z14_IM;
          CMPA16_Z2_RE(31) <= not Z15_RE(31);
          CMPA16_Z2_RE(30 downto 0) <= Z15_RE(30 downto 0);
          CMPA16_Z2_IM(31) <= not Z15_IM(31);
          CMPA16_Z2_IM(30 downto 0) <= Z15_IM(30 downto 0);
          counter <= counter + 1;
          if counter = 3 then
            Z0_RE <= CMPA1_RESULT_RE;
            Z0_IM <= CMPA1_RESULT_IM;
            Z1_RE <= CMPA2_RESULT_RE;
            Z1_IM <= CMPA2_RESULT_IM;
            Z2_RE <= CMPA3_RESULT_RE;
            Z2_IM <= CMPA3_RESULT_IM;
            Z3_RE <= CMPA4_RESULT_RE;
            Z3_IM <= CMPA4_RESULT_IM;
            Z4_RE <= CMPA5_RESULT_RE;
            Z4_IM <= CMPA5_RESULT_IM;
            Z5_RE <= CMPA6_RESULT_RE;
            Z5_IM <= CMPA6_RESULT_IM;
            Z6_RE <= CMPA7_RESULT_RE;
            Z6_IM <= CMPA7_RESULT_IM;
            Z7_RE <= CMPA8_RESULT_RE;
            Z7_IM <= CMPA8_RESULT_IM;
            Z8_RE <= CMPA9_RESULT_RE;
            Z8_IM <= CMPA9_RESULT_IM;
            Z9_RE <= CMPA10_RESULT_RE;
            Z9_IM <= CMPA10_RESULT_IM;
            Z10_RE <= CMPA11_RESULT_RE;
            Z10_IM <= CMPA11_RESULT_IM;
            Z11_RE <= CMPA12_RESULT_RE;
            Z11_IM <= CMPA12_RESULT_IM;
            Z12_RE <= CMPA13_RESULT_RE;
            Z12_IM <= CMPA13_RESULT_IM;
            Z13_RE <= CMPA14_RESULT_RE;
            Z13_IM <= CMPA14_RESULT_IM;
            Z14_RE <= CMPA15_RESULT_RE;
            Z14_IM <= CMPA15_RESULT_IM;
            Z15_RE <= CMPA16_RESULT_RE;
            Z15_IM <= CMPA16_RESULT_IM;
            STATE <= RESULT;
            counter <= 0;
            valid <= '1';
          end if;
        when others =>
          STATE <= RESULT;
          valid <= '0';
      end case;
    end if;
  end process state_proc;
end architecture;
