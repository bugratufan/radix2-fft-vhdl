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
-- Description: VHDL implementation of radix2 fft pipeline algorithm for IEEE-754
-- single precision floating point data format
--
-- Dependencies:
-- This module needs some extra vhdl files that listed below:
--  - adder.vhd
--  - complex_adder.vhd
--  - multiplier.vhd
--  - complex_multi.vhd
--  - input_ready_ff.vhd
--  - queue.vhd
--
-- Revision:
-- Revision 2.1 - alpha
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
    Z15_IM  : inout  STD_LOGIC_VECTOR (31 downto 0);
    result_ready : out std_logic;
    input_ready : out std_logic;
    valid : in std_logic;
    reset : in std_logic
  );
end entity;

architecture RTL of RADIX is
  type statetype is (ST1_A,ST1_M,ST2_A,ST2_M,ST3_A,ST3_M,ST4_A,RESULT);
  signal STATE : statetype := ST1_A;
  subtype	bufferType   is std_logic_vector(31 downto 0);
  type 	addType  is array (63 downto 0) of bufferType;
  type 	multiType  is array (23 downto 0) of bufferType;
  type 	buffersType_8  is array (7 downto 0) of bufferType;
  type 	buffersType_16  is array (15 downto 0) of bufferType;
  signal	add_input_1_re	:	addType := ((others=> (others=>'0')));
  signal	add_input_1_im	:	addType := ((others=> (others=>'0')));
  signal	add_input_2_re	:	addType := ((others=> (others=>'0')));
  signal	add_input_2_im	:	addType := ((others=> (others=>'0')));
  signal	add_result_re	:	addType := ((others=> (others=>'0')));
  signal	add_result_im	:	addType := ((others=> (others=>'0')));

  signal buffer1_RE : buffersType_16;
  signal buffer1_IM : buffersType_16;
  signal buffer2_RE : buffersType_16;
  signal buffer2_IM : buffersType_16;
  signal buffer3_RE : buffersType_16;
  signal buffer3_IM : buffersType_16;
  signal buffer4_RE : buffersType_16;
  signal buffer4_IM : buffersType_16;
  signal buffer5_RE : buffersType_16;
  signal buffer5_IM : buffersType_16;
  signal buffer6_RE : buffersType_16;
  signal buffer6_IM : buffersType_16;


  subtype	validType   is std_logic;
  type 	validListType is array (6 downto 0) of validType ;
  signal valid_list : validListType;
  signal ready_list : validListType;




  signal	multi_input_1_re	:	multiType := ((others=> (others=>'0')));
  signal	multi_input_1_im	:	multiType := ((others=> (others=>'0')));
  signal	multi_input_2_re	:	multiType := ((others=> (others=>'0')));
  signal	multi_input_2_im	:	multiType := ((others=> (others=>'0')));
  signal	multi_result_re	:	multiType := ((others=> (others=>'0')));
  signal	multi_result_im	:	multiType := ((others=> (others=>'0')));


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

  component QUEUE
    port (
      valid : in std_logic;
      ready : out std_logic;
      clk   : in std_logic;
      reset : in std_logic
    );
  end component;

  component READY
    port (
      valid : in std_logic;
      ready : out std_logic;
      clk   : in std_logic;
      reset : in std_logic
    );
  end component;
begin

    -------------SUMMATION PORT MAP
  ADDERS: for i in 0 to 63 generate
    UX: COMPLEX_ADDER port map(
      CLK => CLK,
      Z1_IM => add_input_1_im(i),
      Z1_RE => add_input_1_re(i),
      Z2_IM => add_input_2_im(i),
      Z2_RE => add_input_2_re(i),
      RESULT_IM => add_result_im(i),
      RESULT_RE => add_result_re(i)
    );
  end generate;

  -------------MULTIPLICATION PORT MAP
  MULTIPLIERS: for i in 0 to 23 generate
    UX: MULTI port map(
      CLK => CLK,
      Z1_IM => multi_input_1_im(i),
      Z1_RE => multi_input_1_re(i),
      Z2_IM => multi_input_2_im(i),
      Z2_RE => multi_input_2_re(i),
      RESULT_IM => multi_result_im(i),
      RESULT_RE => multi_result_re(i)
    );
  end generate;

  QUEUE_LIST: for i in 0 to 6 generate
    UX: QUEUE port map(
      CLK => CLK,
      ready => ready_list(i),
      valid => valid_list(i),
      reset => reset
    );
  end generate;

  UX: READY port map(
    CLK => CLK,
    ready => input_ready,
    valid => valid,
    reset => reset
  );


  state_proc: process(CLK)
  begin
    if (clk'event and clk = '1') then
      if(ready_list(0) = '1') then
        buffer1_RE(0) <= add_result_re(0);
        buffer1_IM(0) <= add_result_im(0);
        buffer1_RE(1) <= add_result_re(1);
        buffer1_IM(1) <= add_result_im(1);
        buffer1_RE(2) <= add_result_re(2);
        buffer1_IM(2) <= add_result_im(2);
        buffer1_RE(3) <= add_result_re(3);
        buffer1_IM(3) <= add_result_im(3);
        buffer1_RE(4) <= add_result_re(4);
        buffer1_IM(4) <= add_result_im(4);
        buffer1_RE(5) <= add_result_re(5);
        buffer1_IM(5) <= add_result_im(5);
        buffer1_RE(6) <= add_result_re(6);
        buffer1_IM(6) <= add_result_im(6);
        buffer1_RE(7) <= add_result_re(7);
        buffer1_IM(7) <= add_result_im(7);
        buffer1_RE(8) <= add_result_re(8);
        buffer1_IM(8) <= add_result_im(8);
        buffer1_RE(9) <= add_result_re(9);
        buffer1_IM(9) <= add_result_im(9);
        buffer1_RE(10) <= add_result_re(10);
        buffer1_IM(10) <= add_result_im(10);
        buffer1_RE(11) <= add_result_re(11);
        buffer1_IM(11) <= add_result_im(11);
        buffer1_RE(12) <= add_result_re(12);
        buffer1_IM(12) <= add_result_im(12);
        buffer1_RE(13) <= add_result_re(13);
        buffer1_IM(13) <= add_result_im(13);
        buffer1_RE(14) <= add_result_re(14);
        buffer1_IM(14) <= add_result_im(14);
        buffer1_RE(15) <= add_result_re(15);
        buffer1_IM(15) <= add_result_im(15);
      end if;
      if(ready_list(1) = '1') then
        buffer2_RE(0) <= buffer1_RE(0);
        buffer2_IM(0) <= buffer1_IM(0);
        buffer2_RE(1) <= buffer1_RE(1);
        buffer2_IM(1) <= buffer1_IM(1);
        buffer2_RE(2) <= buffer1_RE(2);
        buffer2_IM(2) <= buffer1_IM(2);
        buffer2_RE(3) <= buffer1_RE(3);
        buffer2_IM(3) <= buffer1_IM(3);
        buffer2_RE(4) <= buffer1_RE(4);
        buffer2_IM(4) <= buffer1_IM(4);
        buffer2_RE(5) <= buffer1_RE(5);
        buffer2_IM(5) <= buffer1_IM(5);
        buffer2_RE(6) <= buffer1_RE(6);
        buffer2_IM(6) <= buffer1_IM(6);
        buffer2_RE(7) <= buffer1_RE(7);
        buffer2_IM(7) <= buffer1_IM(7);

        buffer2_RE(8) <=  multi_result_re(0);
        buffer2_IM(8) <=  multi_result_im(0);
        buffer2_RE(9) <=  multi_result_re(1);
        buffer2_IM(9) <=  multi_result_im(1);
        buffer2_RE(10) <= multi_result_re(2);
        buffer2_IM(10) <= multi_result_im(2);
        buffer2_RE(11) <= multi_result_re(3);
        buffer2_IM(11) <= multi_result_im(3);
        buffer2_RE(12) <= multi_result_re(4);
        buffer2_IM(12) <= multi_result_im(4);
        buffer2_RE(13) <= multi_result_re(5);
        buffer2_IM(13) <= multi_result_im(5);
        buffer2_RE(14) <= multi_result_re(6);
        buffer2_IM(14) <= multi_result_im(6);
        buffer2_RE(15) <= multi_result_re(7);
        buffer2_IM(15) <= multi_result_im(7);
      end if;
      if(ready_list(2) = '1') then
        buffer3_RE(0) <=  add_result_re(16);
        buffer3_IM(0) <=  add_result_im(16);
        buffer3_RE(1) <=  add_result_re(17);
        buffer3_IM(1) <=  add_result_im(17);
        buffer3_RE(2) <=  add_result_re(18);
        buffer3_IM(2) <=  add_result_im(18);
        buffer3_RE(3) <=  add_result_re(19);
        buffer3_IM(3) <=  add_result_im(19);
        buffer3_RE(4) <=  add_result_re(20);
        buffer3_IM(4) <=  add_result_im(20);
        buffer3_RE(5) <=  add_result_re(21);
        buffer3_IM(5) <=  add_result_im(21);
        buffer3_RE(6) <=  add_result_re(22);
        buffer3_IM(6) <=  add_result_im(22);
        buffer3_RE(7) <=  add_result_re(23);
        buffer3_IM(7) <=  add_result_im(23);
        buffer3_RE(8) <=  add_result_re(24);
        buffer3_IM(8) <=  add_result_im(24);
        buffer3_RE(9) <=  add_result_re(25);
        buffer3_IM(9) <=  add_result_im(25);
        buffer3_RE(10) <= add_result_re(26);
        buffer3_IM(10) <= add_result_im(26);
        buffer3_RE(11) <= add_result_re(27);
        buffer3_IM(11) <= add_result_im(27);
        buffer3_RE(12) <= add_result_re(28);
        buffer3_IM(12) <= add_result_im(28);
        buffer3_RE(13) <= add_result_re(29);
        buffer3_IM(13) <= add_result_im(29);
        buffer3_RE(14) <= add_result_re(30);
        buffer3_IM(14) <= add_result_im(30);
        buffer3_RE(15) <= add_result_re(31);
        buffer3_IM(15) <= add_result_im(31);
      end if;
      if(ready_list(3) = '1') then
        buffer4_RE(0) <= buffer3_RE(0);
        buffer4_IM(0) <= buffer3_IM(0);
        buffer4_RE(1) <= buffer3_RE(1);
        buffer4_IM(1) <= buffer3_IM(1);
        buffer4_RE(2) <= buffer3_RE(2);
        buffer4_IM(2) <= buffer3_IM(2);
        buffer4_RE(3) <= buffer3_RE(3);
        buffer4_IM(3) <= buffer3_IM(3);
        buffer4_RE(4) <= buffer3_RE(8);
        buffer4_IM(4) <= buffer3_IM(8);
        buffer4_RE(5) <= buffer3_RE(9);
        buffer4_IM(5) <= buffer3_IM(9);
        buffer4_RE(6) <= buffer3_RE(10);
        buffer4_IM(6) <= buffer3_IM(10);
        buffer4_RE(7) <= buffer3_RE(11);
        buffer4_IM(7) <= buffer3_IM(11);

        buffer4_RE(8) <= multi_result_re(8);
        buffer4_IM(8) <= multi_result_im(8);
        buffer4_RE(9) <= multi_result_re(9);
        buffer4_IM(9) <= multi_result_im(9);
        buffer4_RE(10) <= multi_result_re(10);
        buffer4_IM(10) <= multi_result_im(10);
        buffer4_RE(11) <= multi_result_re(11);
        buffer4_IM(11) <= multi_result_im(11);
        buffer4_RE(12) <= multi_result_re(12);
        buffer4_IM(12) <= multi_result_im(12);
        buffer4_RE(13) <= multi_result_re(13);
        buffer4_IM(13) <= multi_result_im(13);
        buffer4_RE(14) <= multi_result_re(14);
        buffer4_IM(14) <= multi_result_im(14);
        buffer4_RE(15) <= multi_result_re(15);
        buffer4_IM(15) <= multi_result_im(15);
      end if;
      if(ready_list(4) = '1') then
        buffer5_RE(0) <= add_result_re(32);
        buffer5_IM(0) <= add_result_im(32);
        buffer5_RE(1) <= add_result_re(33);
        buffer5_IM(1) <= add_result_im(33);
        buffer5_RE(2) <= add_result_re(34);
        buffer5_IM(2) <= add_result_im(34);
        buffer5_RE(3) <= add_result_re(35);
        buffer5_IM(3) <= add_result_im(35);
        buffer5_RE(4) <= add_result_re(36);
        buffer5_IM(4) <= add_result_im(36);
        buffer5_RE(5) <= add_result_re(37);
        buffer5_IM(5) <= add_result_im(37);
        buffer5_RE(6) <= add_result_re(38);
        buffer5_IM(6) <= add_result_im(38);
        buffer5_RE(7) <= add_result_re(39);
        buffer5_IM(7) <= add_result_im(39);
        buffer5_RE(8) <= add_result_re(40);
        buffer5_IM(8) <= add_result_im(40);
        buffer5_RE(9) <= add_result_re(41);
        buffer5_IM(9) <= add_result_im(41);
        buffer5_RE(10) <= add_result_re(42);
        buffer5_IM(10) <= add_result_im(42);
        buffer5_RE(11) <= add_result_re(43);
        buffer5_IM(11) <= add_result_im(43);
        buffer5_RE(12) <= add_result_re(44);
        buffer5_IM(12) <= add_result_im(44);
        buffer5_RE(13) <= add_result_re(45);
        buffer5_IM(13) <= add_result_im(45);
        buffer5_RE(14) <= add_result_re(46);
        buffer5_IM(14) <= add_result_im(46);
        buffer5_RE(15) <= add_result_re(47);
        buffer5_IM(15) <= add_result_im(47);
      end if;
      if(ready_list(5) = '1') then
        buffer6_RE(0) <= buffer5_RE(0);
        buffer6_IM(0) <= buffer5_IM(0);
        buffer6_RE(1) <= buffer5_RE(1);
        buffer6_IM(1) <= buffer5_IM(1);
        buffer6_RE(2) <= buffer5_RE(4);
        buffer6_IM(2) <= buffer5_IM(4);
        buffer6_RE(3) <= buffer5_RE(5);
        buffer6_IM(3) <= buffer5_IM(5);
        buffer6_RE(4) <= buffer5_RE(8);
        buffer6_IM(4) <= buffer5_IM(8);
        buffer6_RE(5) <= buffer5_RE(9);
        buffer6_IM(5) <= buffer5_IM(9);
        buffer6_RE(6) <= buffer5_RE(12);
        buffer6_IM(6) <= buffer5_IM(12);
        buffer6_RE(7) <= buffer5_RE(13);
        buffer6_IM(7) <= buffer5_IM(13);

        buffer6_RE(8) <= multi_result_re(16);
        buffer6_IM(8) <= multi_result_im(16);
        buffer6_RE(9) <= multi_result_re(17);
        buffer6_IM(9) <= multi_result_im(17);
        buffer6_RE(10) <= multi_result_re(18);
        buffer6_IM(10) <= multi_result_im(18);
        buffer6_RE(11) <= multi_result_re(19);
        buffer6_IM(11) <= multi_result_im(19);
        buffer6_RE(12) <= multi_result_re(20);
        buffer6_IM(12) <= multi_result_im(20);
        buffer6_RE(13) <= multi_result_re(21);
        buffer6_IM(13) <= multi_result_im(21);
        buffer6_RE(14) <= multi_result_re(22);
        buffer6_IM(14) <= multi_result_im(22);
        buffer6_RE(15) <= multi_result_re(23);
        buffer6_IM(15) <= multi_result_im(23);
      end if;
    end if;
  end process state_proc;

  valid_list(0) <= valid;
  valid_list(1) <= ready_list(0);
  valid_list(2) <= ready_list(1);
  valid_list(3) <= ready_list(2);
  valid_list(4) <= ready_list(3);
  valid_list(5) <= ready_list(4);
  valid_list(6) <= ready_list(5);
  result_ready <= ready_list(6);


  ---------------------ST1_A (LAYER 1)

  add_input_1_re(0) <= X0;
  add_input_1_im(0) <= (others => '0');
  add_input_2_re(0) <= X8;
  add_input_2_im(0) <= (others => '0');

  add_input_1_re(1) <= X1;
  add_input_1_im(1) <= (others => '0');
  add_input_2_re(1) <= X9;
  add_input_2_im(1) <= (others => '0');

  add_input_1_re(2) <= X2;
  add_input_1_im(2) <= (others => '0');
  add_input_2_re(2) <= X10;
  add_input_2_im(2) <= (others => '0');

  add_input_1_re(3) <= X3;
  add_input_1_im(3) <= (others => '0');
  add_input_2_re(3) <= X11;
  add_input_2_im(3) <= (others => '0');

  add_input_1_re(4) <= X4;
  add_input_1_im(4) <= (others => '0');
  add_input_2_re(4) <= X12;
  add_input_2_im(4) <= (others => '0');

  add_input_1_re(5) <= X5;
  add_input_1_im(5) <= (others => '0');
  add_input_2_re(5) <= X13;
  add_input_2_im(5) <= (others => '0');

  add_input_1_re(6) <= X6;
  add_input_1_im(6) <= (others => '0');
  add_input_2_re(6) <= X14;
  add_input_2_im(6) <= (others => '0');

  add_input_1_re(7) <= X7;
  add_input_1_im(7) <= (others => '0');
  add_input_2_re(7) <= X15;
  add_input_2_im(7) <= (others => '0');

  add_input_1_re(8) <= X0;
  add_input_1_im(8) <= (others => '0');
  add_input_2_re(8)(31) <= not X8(31);
  add_input_2_re(8)(30 downto 0) <= X8(30 downto 0);
  add_input_2_im(8) <= (others => '0');

  add_input_1_re(9) <= X1;
  add_input_1_im(9) <= (others => '0');
  add_input_2_re(9)(31) <= not X9(31);
  add_input_2_re(9)(30 downto 0) <= X9(30 downto 0);
  add_input_2_im(9) <= (others => '0');

  add_input_1_re(10) <= X2;
  add_input_1_im(10) <= (others => '0');
  add_input_2_re(10)(31) <= not X10(31);
  add_input_2_re(10)(30 downto 0) <= X10(30 downto 0);
  add_input_2_im(10) <= (others => '0');

  add_input_1_re(11) <= X3;
  add_input_1_im(11) <= (others => '0');
  add_input_2_re(11)(31) <= not X11(31);
  add_input_2_re(11)(30 downto 0) <= X11(30 downto 0);
  add_input_2_im(11) <= (others => '0');

  add_input_1_re(12) <= X4;
  add_input_1_im(12) <= (others => '0');
  add_input_2_re(12)(31) <= not X12(31);
  add_input_2_re(12)(30 downto 0) <= X12(30 downto 0);
  add_input_2_im(12) <= (others => '0');

  add_input_1_re(13) <= X5;
  add_input_1_im(13) <= (others => '0');
  add_input_2_re(13)(31) <= not X13(31);
  add_input_2_re(13)(30 downto 0) <= X13(30 downto 0);
  add_input_2_im(13) <= (others => '0');

  add_input_1_re(14) <= X6;
  add_input_1_im(14) <= (others => '0');
  add_input_2_re(14)(31) <= not X14(31);
  add_input_2_re(14)(30 downto 0) <= X14(30 downto 0);
  add_input_2_im(14) <= (others => '0');

  add_input_1_re(15) <= X7;
  add_input_1_im(15) <= (others => '0');
  add_input_2_re(15)(31) <= not X15(31);
  add_input_2_re(15)(30 downto 0) <= X15(30 downto 0);
  add_input_2_im(15) <= (others => '0');

  ---------------------ST1_M (LAYER 2)

  multi_input_1_re(0) <= buffer1_RE(8);
  multi_input_1_im(0) <= buffer1_IM(8);
  multi_input_2_re(0) <= W16_0_RE;
  multi_input_2_im(0) <= W16_0_IM;

  multi_input_1_re(1) <= buffer1_RE(9);
  multi_input_1_im(1) <= buffer1_IM(9);
  multi_input_2_re(1) <= W16_1_RE;
  multi_input_2_im(1) <= W16_1_IM;

  multi_input_1_re(2) <= buffer1_RE(10);
  multi_input_1_im(2) <= buffer1_IM(10);
  multi_input_2_re(2) <= W16_2_RE;
  multi_input_2_im(2) <= W16_2_IM;

  multi_input_1_re(3) <= buffer1_RE(11);
  multi_input_1_im(3) <= buffer1_IM(11);
  multi_input_2_re(3) <= W16_3_RE;
  multi_input_2_im(3) <= W16_3_IM;

  multi_input_1_re(4) <= buffer1_RE(12);
  multi_input_1_im(4) <= buffer1_IM(12);
  multi_input_2_re(4) <= W16_4_RE;
  multi_input_2_im(4) <= W16_4_IM;

  multi_input_1_re(5) <= buffer1_RE(13);
  multi_input_1_im(5) <= buffer1_IM(13);
  multi_input_2_re(5) <= W16_5_RE;
  multi_input_2_im(5) <= W16_5_IM;

  multi_input_1_re(6) <= buffer1_RE(14);
  multi_input_1_im(6) <= buffer1_IM(14);
  multi_input_2_re(6) <= W16_6_RE;
  multi_input_2_im(6) <= W16_6_IM;

  multi_input_1_re(7) <= buffer1_RE(15);
  multi_input_1_im(7) <= buffer1_IM(15);
  multi_input_2_re(7) <= W16_7_RE;
  multi_input_2_im(7) <= W16_7_IM;

  ---------------------ST2_A (LAYER 3)

  add_input_1_re(16) <= buffer2_RE(0);
  add_input_1_im(16) <= buffer2_IM(0);
  add_input_2_re(16) <= buffer2_RE(4);
  add_input_2_im(16) <= buffer2_IM(4);

  add_input_1_re(17) <= buffer2_RE(1);
  add_input_1_im(17) <= buffer2_IM(1);
  add_input_2_re(17) <= buffer2_RE(5);
  add_input_2_im(17) <= buffer2_IM(5);

  add_input_1_re(18) <= buffer2_RE(2);
  add_input_1_im(18) <= buffer2_IM(2);
  add_input_2_re(18) <= buffer2_RE(6);
  add_input_2_im(18) <= buffer2_IM(6);

  add_input_1_re(19) <= buffer2_RE(3);
  add_input_1_im(19) <= buffer2_IM(3);
  add_input_2_re(19) <= buffer2_RE(7);
  add_input_2_im(19) <= buffer2_IM(7);

  add_input_1_re(20) <= buffer2_RE(0);
  add_input_1_im(20) <= buffer2_IM(0);
  add_input_2_re(20)(31) <= not buffer2_RE(4)(31);
  add_input_2_re(20)(30 downto 0) <= buffer2_RE(4)(30 downto 0);
  add_input_2_im(20)(31) <= not buffer2_IM(4)(31);
  add_input_2_im(20)(30 downto 0) <= buffer2_IM(4)(30 downto 0);

  add_input_1_re(21) <= buffer2_RE(1);
  add_input_1_im(21) <= buffer2_IM(1);
  add_input_2_re(21)(31) <= not buffer2_RE(5)(31);
  add_input_2_re(21)(30 downto 0) <= buffer2_RE(5)(30 downto 0);
  add_input_2_im(21)(31) <= not buffer2_IM(5)(31);
  add_input_2_im(21)(30 downto 0) <= buffer2_IM(5)(30 downto 0);

  add_input_1_re(22) <= buffer2_RE(2);
  add_input_1_im(22) <= buffer2_IM(2);
  add_input_2_re(22)(31) <= not buffer2_RE(6)(31);
  add_input_2_re(22)(30 downto 0) <= buffer2_RE(6)(30 downto 0);
  add_input_2_im(22)(31) <= not buffer2_IM(6)(31);
  add_input_2_im(22)(30 downto 0) <= buffer2_IM(6)(30 downto 0);

  add_input_1_re(23) <= buffer2_RE(3);
  add_input_1_im(23) <= buffer2_IM(3);
  add_input_2_re(23)(31) <= not buffer2_RE(7)(31);
  add_input_2_re(23)(30 downto 0) <= buffer2_RE(7)(30 downto 0);
  add_input_2_im(23)(31) <= not buffer2_IM(7)(31);
  add_input_2_im(23)(30 downto 0) <= buffer2_IM(7)(30 downto 0);
--
  add_input_1_re(24) <= buffer2_RE(8);
  add_input_1_im(24) <= buffer2_IM(8);
  add_input_2_re(24) <= buffer2_RE(12);
  add_input_2_im(24) <= buffer2_IM(12);

  add_input_1_re(25) <= buffer2_RE(9);
  add_input_1_im(25) <= buffer2_IM(9);
  add_input_2_re(25) <= buffer2_RE(13);
  add_input_2_im(25) <= buffer2_IM(13);

  add_input_1_re(26) <= buffer2_RE(10);
  add_input_1_im(26) <= buffer2_IM(10);
  add_input_2_re(26) <= buffer2_RE(14);
  add_input_2_im(26) <= buffer2_IM(14);

  add_input_1_re(27) <= buffer2_RE(11);
  add_input_1_im(27) <= buffer2_IM(11);
  add_input_2_re(27) <= buffer2_RE(15);
  add_input_2_im(27) <= buffer2_IM(15);

  add_input_1_re(28) <= buffer2_RE(8);
  add_input_1_im(28) <= buffer2_IM(8);
  add_input_2_re(28)(31) <= not buffer2_RE(12)(31);
  add_input_2_re(28)(30 downto 0) <= buffer2_RE(12)(30 downto 0);
  add_input_2_im(28)(31) <= not buffer2_IM(12)(31);
  add_input_2_im(28)(30 downto 0) <= buffer2_IM(12)(30 downto 0);

  add_input_1_re(29) <= buffer2_RE(9);
  add_input_1_im(29) <= buffer2_IM(9);
  add_input_2_re(29)(31) <= not buffer2_RE(13)(31);
  add_input_2_re(29)(30 downto 0) <= buffer2_RE(13)(30 downto 0);
  add_input_2_im(29)(31) <= not buffer2_IM(13)(31);
  add_input_2_im(29)(30 downto 0) <= buffer2_IM(13)(30 downto 0);

  add_input_1_re(30) <= buffer2_RE(10);
  add_input_1_im(30) <= buffer2_IM(10);
  add_input_2_re(30)(31) <= not buffer2_RE(14)(31);
  add_input_2_re(30)(30 downto 0) <= buffer2_RE(14)(30 downto 0);
  add_input_2_im(30)(31) <= not buffer2_IM(14)(31);
  add_input_2_im(30)(30 downto 0) <= buffer2_IM(14)(30 downto 0);

  add_input_1_re(31) <= buffer2_RE(11);
  add_input_1_im(31) <= buffer2_IM(11);
  add_input_2_re(31)(31) <= not buffer2_RE(15)(31);
  add_input_2_re(31)(30 downto 0) <= buffer2_RE(15)(30 downto 0);
  add_input_2_im(31)(31) <= not buffer2_IM(15)(31);
  add_input_2_im(31)(30 downto 0) <= buffer2_IM(15)(30 downto 0);

    ---------------------ST2_M (LAYER 4)


  multi_input_1_re(8) <= buffer3_RE(4);
  multi_input_1_im(8) <= buffer3_IM(4);
  multi_input_2_re(8) <= W8_0_RE;
  multi_input_2_im(8) <= W8_0_IM;

  multi_input_1_re(9) <= buffer3_RE(5);
  multi_input_1_im(9) <= buffer3_IM(5);
  multi_input_2_re(9) <= W8_1_RE;
  multi_input_2_im(9) <= W8_1_IM;

  multi_input_1_re(10) <= buffer3_RE(6);
  multi_input_1_im(10) <= buffer3_IM(6);
  multi_input_2_re(10) <= W8_2_RE;
  multi_input_2_im(10) <= W8_2_IM;

  multi_input_1_re(11) <= buffer3_RE(7);
  multi_input_1_im(11) <= buffer3_IM(7);
  multi_input_2_re(11) <= W8_3_RE;
  multi_input_2_im(11) <= W8_3_IM;

  multi_input_1_re(12) <= buffer3_RE(12);
  multi_input_1_im(12) <= buffer3_IM(12);
  multi_input_2_re(12) <= W8_0_RE;
  multi_input_2_im(12) <= W8_0_IM;

  multi_input_1_re(13) <= buffer3_RE(13);
  multi_input_1_im(13) <= buffer3_IM(13);
  multi_input_2_re(13) <= W8_1_RE;
  multi_input_2_im(13) <= W8_1_IM;

  multi_input_1_re(14) <= buffer3_RE(14);
  multi_input_1_im(14) <= buffer3_IM(14);
  multi_input_2_re(14) <= W8_2_RE;
  multi_input_2_im(14) <= W8_2_IM;

  multi_input_1_re(15) <= buffer3_RE(15);
  multi_input_1_im(15) <= buffer3_IM(15);
  multi_input_2_re(15) <= W8_3_RE;
  multi_input_2_im(15) <= W8_3_IM;

  ---------------------ST3_A (LAYER 5)

  add_input_1_re(32) <= buffer4_RE(0);
  add_input_1_im(32) <= buffer4_IM(0);
  add_input_2_re(32) <= buffer4_RE(2);
  add_input_2_im(32) <= buffer4_IM(2);

  add_input_1_re(33) <= buffer4_RE(1);
  add_input_1_im(33) <= buffer4_IM(1);
  add_input_2_re(33) <= buffer4_RE(3);
  add_input_2_im(33) <= buffer4_IM(3);

  add_input_1_re(34) <= buffer4_RE(0);
  add_input_1_im(34) <= buffer4_IM(0);
  add_input_2_re(34)(31) <= not buffer4_RE(2)(31);
  add_input_2_re(34)(30 downto 0) <= buffer4_RE(2)(30 downto 0);
  add_input_2_im(34)(31) <= not buffer4_IM(2)(31);
  add_input_2_im(34)(30 downto 0) <= buffer4_IM(2)(30 downto 0);

  add_input_1_re(35) <= buffer4_RE(1);
  add_input_1_im(35) <= buffer4_IM(1);
  add_input_2_re(35)(31) <= not buffer4_RE(3)(31);
  add_input_2_re(35)(30 downto 0) <= buffer4_RE(3)(30 downto 0);
  add_input_2_im(35)(31) <= not buffer4_IM(3)(31);
  add_input_2_im(35)(30 downto 0) <= buffer4_IM(3)(30 downto 0);

  add_input_1_re(36) <= buffer4_RE(8);
  add_input_1_im(36) <= buffer4_IM(8);
  add_input_2_re(36) <= buffer4_RE(10);
  add_input_2_im(36) <= buffer4_IM(10);

  add_input_1_re(37) <= buffer4_RE(9);
  add_input_1_im(37) <= buffer4_IM(9);
  add_input_2_re(37) <= buffer4_RE(11);
  add_input_2_im(37) <= buffer4_IM(11);

  add_input_1_re(38) <= buffer4_RE(8);
  add_input_1_im(38) <= buffer4_IM(8);
  add_input_2_re(38)(31) <= not buffer4_RE(10)(31);
  add_input_2_re(38)(30 downto 0) <= buffer4_RE(10)(30 downto 0);
  add_input_2_im(38)(31) <= not buffer4_IM(10)(31);
  add_input_2_im(38)(30 downto 0) <= buffer4_IM(10)(30 downto 0);

  add_input_1_re(39) <= buffer4_RE(9);
  add_input_1_im(39) <= buffer4_IM(9);
  add_input_2_re(39)(31) <= not buffer4_RE(11)(31);
  add_input_2_re(39)(30 downto 0) <= buffer4_RE(11)(30 downto 0);
  add_input_2_im(39)(31) <= not buffer4_IM(11)(31);
  add_input_2_im(39)(30 downto 0) <= buffer4_IM(11)(30 downto 0);

  add_input_1_re(40) <= buffer4_RE(4);
  add_input_1_im(40) <= buffer4_IM(4);
  add_input_2_re(40) <= buffer4_RE(6);
  add_input_2_im(40) <= buffer4_IM(6);

  add_input_1_re(41) <= buffer4_RE(5);
  add_input_1_im(41) <= buffer4_IM(5);
  add_input_2_re(41) <= buffer4_RE(7);
  add_input_2_im(41) <= buffer4_IM(7);

  add_input_1_re(42) <= buffer4_RE(4);
  add_input_1_im(42) <= buffer4_IM(4);
  add_input_2_re(42)(31) <= not buffer4_RE(6)(31);
  add_input_2_re(42)(30 downto 0) <= buffer4_RE(6)(30 downto 0);
  add_input_2_im(42)(31) <= not buffer4_IM(6)(31);
  add_input_2_im(42)(30 downto 0) <= buffer4_IM(6)(30 downto 0);

  add_input_1_re(43) <= buffer4_RE(5);
  add_input_1_im(43) <= buffer4_IM(5);
  add_input_2_re(43)(31) <= not buffer4_RE(7)(31);
  add_input_2_re(43)(30 downto 0) <= buffer4_RE(7)(30 downto 0);
  add_input_2_im(43)(31) <= not buffer4_IM(7)(31);
  add_input_2_im(43)(30 downto 0) <= buffer4_IM(7)(30 downto 0);

  add_input_1_re(44) <= buffer4_RE(12);
  add_input_1_im(44) <= buffer4_IM(12);
  add_input_2_re(44) <= buffer4_RE(14);
  add_input_2_im(44) <= buffer4_IM(14);

  add_input_1_re(45) <= buffer4_RE(13);
  add_input_1_im(45) <= buffer4_IM(13);
  add_input_2_re(45) <= buffer4_RE(15);
  add_input_2_im(45) <= buffer4_IM(15);

  add_input_1_re(46) <= buffer4_RE(12);
  add_input_1_im(46) <= buffer4_IM(12);
  add_input_2_re(46)(31) <= not buffer4_RE(14)(31);
  add_input_2_re(46)(30 downto 0) <= buffer4_RE(14)(30 downto 0);
  add_input_2_im(46)(31) <= not buffer4_IM(14)(31);
  add_input_2_im(46)(30 downto 0) <= buffer4_IM(14)(30 downto 0);

  add_input_1_re(47) <= buffer4_RE(13);
  add_input_1_im(47) <= buffer4_IM(13);
  add_input_2_re(47)(31) <= not buffer4_RE(15)(31);
  add_input_2_re(47)(30 downto 0) <= buffer4_RE(15)(30 downto 0);
  add_input_2_im(47)(31) <= not buffer4_IM(15)(31);
  add_input_2_im(47)(30 downto 0) <= buffer4_IM(15)(30 downto 0);

  ---------------------ST3_M (LAYER 6)

  multi_input_1_re(16) <= buffer5_RE(2);
  multi_input_1_im(16) <= buffer5_IM(2);
  multi_input_2_re(16) <= W4_0_RE;
  multi_input_2_im(16) <= W4_0_IM;

  multi_input_1_re(17) <= buffer5_RE(3);
  multi_input_1_im(17) <= buffer5_IM(3);
  multi_input_2_re(17) <= W4_1_RE;
  multi_input_2_im(17) <= W4_1_IM;

  multi_input_1_re(18) <= buffer5_RE(6);
  multi_input_1_im(18) <= buffer5_IM(6);
  multi_input_2_re(18) <= W4_0_RE;
  multi_input_2_im(18) <= W4_0_IM;

  multi_input_1_re(19) <= buffer5_RE(7);
  multi_input_1_im(19) <= buffer5_IM(7);
  multi_input_2_re(19) <= W4_1_RE;
  multi_input_2_im(19) <= W4_1_IM;

  multi_input_1_re(20) <= buffer5_RE(10);
  multi_input_1_im(20) <= buffer5_IM(10);
  multi_input_2_re(20) <= W4_0_RE;
  multi_input_2_im(20) <= W4_0_IM;

  multi_input_1_re(21) <= buffer5_RE(11);
  multi_input_1_im(21) <= buffer5_IM(11);
  multi_input_2_re(21) <= W4_1_RE;
  multi_input_2_im(21) <= W4_1_IM;

  multi_input_1_re(22) <= buffer5_RE(14);
  multi_input_1_im(22) <= buffer5_IM(14);
  multi_input_2_re(22) <= W4_0_RE;
  multi_input_2_im(22) <= W4_0_IM;

  multi_input_1_re(23) <= buffer5_RE(15);
  multi_input_1_im(23) <= buffer5_IM(15);
  multi_input_2_re(23) <= W4_1_RE;
  multi_input_2_im(23) <= W4_1_IM;

  ---------------------ST4_A (LAYER 7)

  add_input_1_re(48) <= buffer6_RE(0);
  add_input_1_im(48) <= buffer6_IM(0);
  add_input_2_re(48) <= buffer6_RE(1);
  add_input_2_im(48) <= buffer6_IM(1);

  add_input_1_re(49) <= buffer6_RE(0);
  add_input_1_im(49) <= buffer6_IM(0);
  add_input_2_re(49)(31) <= not buffer6_RE(1)(31);
  add_input_2_re(49)(30 downto 0) <= buffer6_RE(1)(30 downto 0);
  add_input_2_im(49)(31) <= not buffer6_IM(1)(31);
  add_input_2_im(49)(30 downto 0) <= buffer6_IM(1)(30 downto 0);

  add_input_1_re(50) <= buffer6_RE(8);
  add_input_1_im(50) <= buffer6_IM(8);
  add_input_2_re(50) <= buffer6_RE(9);
  add_input_2_im(50) <= buffer6_IM(9);

  add_input_1_re(51) <= buffer6_RE(8);
  add_input_1_im(51) <= buffer6_IM(8);
  add_input_2_re(51)(31) <= not buffer6_RE(9)(31);
  add_input_2_re(51)(30 downto 0) <= buffer6_RE(9)(30 downto 0);
  add_input_2_im(51)(31) <= not buffer6_IM(9)(31);
  add_input_2_im(51)(30 downto 0) <= buffer6_IM(9)(30 downto 0);

  add_input_1_re(52) <= buffer6_RE(2);
  add_input_1_im(52) <= buffer6_IM(2);
  add_input_2_re(52) <= buffer6_RE(3);
  add_input_2_im(52) <= buffer6_IM(3);

  add_input_1_re(53) <= buffer6_RE(2);
  add_input_1_im(53) <= buffer6_IM(2);
  add_input_2_re(53)(31) <= not buffer6_RE(3)(31);
  add_input_2_re(53)(30 downto 0) <= buffer6_RE(3)(30 downto 0);
  add_input_2_im(53)(31) <= not buffer6_IM(3)(31);
  add_input_2_im(53)(30 downto 0) <= buffer6_IM(3)(30 downto 0);

  add_input_1_re(54) <= buffer6_RE(10);
  add_input_1_im(54) <= buffer6_IM(10);
  add_input_2_re(54) <= buffer6_RE(11);
  add_input_2_im(54) <= buffer6_IM(11);

  add_input_1_re(55) <= buffer6_RE(10);
  add_input_1_im(55) <= buffer6_IM(10);
  add_input_2_re(55)(31) <= not buffer6_RE(11)(31);
  add_input_2_re(55)(30 downto 0) <= buffer6_RE(11)(30 downto 0);
  add_input_2_im(55)(31) <= not buffer6_IM(11)(31);
  add_input_2_im(55)(30 downto 0) <= buffer6_IM(11)(30 downto 0);

  add_input_1_re(56) <= buffer6_RE(4);
  add_input_1_im(56) <= buffer6_IM(4);
  add_input_2_re(56) <= buffer6_RE(5);
  add_input_2_im(56) <= buffer6_IM(5);

  add_input_1_re(57) <= buffer6_RE(4);
  add_input_1_im(57) <= buffer6_IM(4);
  add_input_2_re(57)(31) <= not buffer6_RE(5)(31);
  add_input_2_re(57)(30 downto 0) <= buffer6_RE(5)(30 downto 0);
  add_input_2_im(57)(31) <= not buffer6_IM(5)(31);
  add_input_2_im(57)(30 downto 0) <= buffer6_IM(5)(30 downto 0);

  add_input_1_re(58) <= buffer6_RE(12);
  add_input_1_im(58) <= buffer6_IM(12);
  add_input_2_re(58) <= buffer6_RE(13);
  add_input_2_im(58) <= buffer6_IM(13);

  add_input_1_re(59) <= buffer6_RE(12);
  add_input_1_im(59) <= buffer6_IM(12);
  add_input_2_re(59)(31) <= not buffer6_RE(13)(31);
  add_input_2_re(59)(30 downto 0) <= buffer6_RE(13)(30 downto 0);
  add_input_2_im(59)(31) <= not buffer6_IM(13)(31);
  add_input_2_im(59)(30 downto 0) <= buffer6_IM(13)(30 downto 0);

  add_input_1_re(60) <= buffer6_RE(6);
  add_input_1_im(60) <= buffer6_IM(6);
  add_input_2_re(60) <= buffer6_RE(7);
  add_input_2_im(60) <= buffer6_IM(7);

  add_input_1_re(61) <= buffer6_RE(6);
  add_input_1_im(61) <= buffer6_IM(6);
  add_input_2_re(61)(31) <= not buffer6_RE(7)(31);
  add_input_2_re(61)(30 downto 0) <= buffer6_RE(7)(30 downto 0);
  add_input_2_im(61)(31) <= not buffer6_IM(7)(31);
  add_input_2_im(61)(30 downto 0) <= buffer6_IM(7)(30 downto 0);

  add_input_1_re(62) <= buffer6_RE(14);
  add_input_1_im(62) <= buffer6_IM(14);
  add_input_2_re(62) <= buffer6_RE(15);
  add_input_2_im(62) <= buffer6_IM(15);

  add_input_1_re(63) <= buffer6_RE(14);
  add_input_1_im(63) <= buffer6_IM(14);
  add_input_2_re(63)(31) <= not buffer6_RE(15)(31);
  add_input_2_re(63)(30 downto 0) <= buffer6_RE(15)(30 downto 0);
  add_input_2_im(63)(31) <= not buffer6_IM(15)(31);
  add_input_2_im(63)(30 downto 0) <= buffer6_IM(15)(30 downto 0);

  Z0_RE <= add_result_re(48);
  Z0_IM <= add_result_im(48);
  Z1_RE <= add_result_re(49);
  Z1_IM <= add_result_im(49);
  Z2_RE <= add_result_re(50);
  Z2_IM <= add_result_im(50);
  Z3_RE <= add_result_re(51);
  Z3_IM <= add_result_im(51);
  Z4_RE <= add_result_re(52);
  Z4_IM <= add_result_im(52);
  Z5_RE <= add_result_re(53);
  Z5_IM <= add_result_im(53);
  Z6_RE <= add_result_re(54);
  Z6_IM <= add_result_im(54);
  Z7_RE <= add_result_re(55);
  Z7_IM <= add_result_im(55);
  Z8_RE <= add_result_re(56);
  Z8_IM <= add_result_im(56);
  Z9_RE <= add_result_re(57);
  Z9_IM <= add_result_im(57);
  Z10_RE <= add_result_re(58);
  Z10_IM <= add_result_im(58);
  Z11_RE <= add_result_re(59);
  Z11_IM <= add_result_im(59);
  Z12_RE <= add_result_re(60);
  Z12_IM <= add_result_im(60);
  Z13_RE <= add_result_re(61);
  Z13_IM <= add_result_im(61);
  Z14_RE <= add_result_re(62);
  Z14_IM <= add_result_im(62);
  Z15_RE <= add_result_re(63);
  Z15_IM <= add_result_im(63);

end architecture;
