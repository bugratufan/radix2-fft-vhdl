Library IEEE;
use IEEE.Std_Logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity T_RADIX is
end entity;


architecture TEST of T_RADIX is
  file file_VECTORS : text;
  file file_RESULTS : text;

  signal CLK     :  std_logic;
  signal X0      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X1      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X2      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X3      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X4      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X5      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X6      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X7      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X8      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X9      :  STD_LOGIC_VECTOR (31 downto 0);
  signal X10     :  STD_LOGIC_VECTOR (31 downto 0);
  signal X11     :  STD_LOGIC_VECTOR (31 downto 0);
  signal X12     :  STD_LOGIC_VECTOR (31 downto 0);
  signal X13     :  STD_LOGIC_VECTOR (31 downto 0);
  signal X14     :  STD_LOGIC_VECTOR (31 downto 0);
  signal X15     :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z0_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z0_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z1_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z1_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z2_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z2_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z3_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z3_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z4_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z4_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z5_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z5_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z6_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z6_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z7_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z7_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z8_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z8_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z9_RE   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z9_IM   :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z10_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z10_IM  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z11_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z11_IM  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z12_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z12_IM  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z13_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z13_IM  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z14_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z14_IM  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z15_RE  :  STD_LOGIC_VECTOR (31 downto 0);
  signal Z15_IM  :  STD_LOGIC_VECTOR (31 downto 0);

component RADIX
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
end component;

begin

  comp : RADIX
  port map (
    CLK     =>  CLK,
    X0      =>  X0,
    X1      =>  X1,
    X2      =>  X2,
    X3      =>  X3,
    X4      =>  X4,
    X5      =>  X5,
    X6      =>  X6,
    X7      =>  X7,
    X8      =>  X8,
    X9      =>  X9,
    X10     =>  X10,
    X11     =>  X11,
    X12     =>  X12,
    X13     =>  X13,
    X14     =>  X14,
    X15     =>  X15,
    Z0_RE   =>  Z0_RE,
    Z0_IM   =>  Z0_IM,
    Z1_RE   =>  Z1_RE,
    Z1_IM   =>  Z1_IM,
    Z2_RE   =>  Z2_RE,
    Z2_IM   =>  Z2_IM,
    Z3_RE   =>  Z3_RE,
    Z3_IM   =>  Z3_IM,
    Z4_RE   =>  Z4_RE,
    Z4_IM   =>  Z4_IM,
    Z5_RE   =>  Z5_RE,
    Z5_IM   =>  Z5_IM,
    Z6_RE   =>  Z6_RE,
    Z6_IM   =>  Z6_IM,
    Z7_RE   =>  Z7_RE,
    Z7_IM   =>  Z7_IM,
    Z8_RE   =>  Z8_RE,
    Z8_IM   =>  Z8_IM,
    Z9_RE   =>  Z9_RE,
    Z9_IM   =>  Z9_IM,
    Z10_RE  =>  Z10_RE,
    Z10_IM  =>  Z10_IM,
    Z11_RE  =>  Z11_RE,
    Z11_IM  =>  Z11_IM,
    Z12_RE  =>  Z12_RE,
    Z12_IM  =>  Z12_IM,
    Z13_RE  =>  Z13_RE,
    Z13_IM  =>  Z13_IM,
    Z14_RE  =>  Z14_RE,
    Z14_IM  =>  Z14_IM,
    Z15_RE  =>  Z15_RE,
    Z15_IM  =>  Z15_IM
    );


  test_proc: process
    variable v_ILINE     : line;
    variable v_OLINE     : line;
    variable v_TERM0 : std_logic_vector(31 downto 0);
    variable v_TERM1 : std_logic_vector(31 downto 0);
    variable v_TERM2 : std_logic_vector(31 downto 0);
    variable v_TERM3 : std_logic_vector(31 downto 0);
    variable v_TERM4 : std_logic_vector(31 downto 0);
    variable v_TERM5 : std_logic_vector(31 downto 0);
    variable v_TERM6 : std_logic_vector(31 downto 0);
    variable v_TERM7 : std_logic_vector(31 downto 0);
    variable v_TERM8 : std_logic_vector(31 downto 0);
    variable v_TERM9 : std_logic_vector(31 downto 0);
    variable v_TERM10 : std_logic_vector(31 downto 0);
    variable v_TERM11 : std_logic_vector(31 downto 0);
    variable v_TERM12 : std_logic_vector(31 downto 0);
    variable v_TERM13 : std_logic_vector(31 downto 0);
    variable v_TERM14 : std_logic_vector(31 downto 0);
    variable v_TERM15 : std_logic_vector(31 downto 0);
    variable v_SPACE     : character;
  begin
    file_open(file_VECTORS, "input_vectors.txt",  read_mode);
    file_open(file_RESULTS, "output_results.txt", write_mode);

    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM0);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM1);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM2);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM3);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM4);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM5);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM6);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM7);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM8);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM9);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM10);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM11);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM12);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM13);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM14);
    readline(file_VECTORS, v_ILINE);
    read(v_ILINE, v_TERM15);


    X0  <= v_TERM0;
    X1  <= v_TERM1;
    X2  <= v_TERM2;
    X3  <= v_TERM3;
    X4  <= v_TERM4;
    X5  <= v_TERM5;
    X6  <= v_TERM6;
    X7  <= v_TERM7;
    X8  <= v_TERM8;
    X9  <= v_TERM9;
    X10 <= v_TERM10;
    X11 <= v_TERM11;
    X12 <= v_TERM12;
    X13 <= v_TERM13;
    X14 <= v_TERM14;
    X15 <= v_TERM15;

    wait for 170 ns;

    write(v_OLINE, Z0_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z0_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z1_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z1_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z2_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z2_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z3_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z3_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z4_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z4_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z5_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z5_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z6_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z6_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z7_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z7_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z8_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z8_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z9_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z9_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z10_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z10_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z11_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z11_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z12_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z12_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z13_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z13_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z14_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z14_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z15_RE, right, 32);
    writeline(file_RESULTS, v_OLINE);
    write(v_OLINE, Z15_IM, right, 32);
    writeline(file_RESULTS, v_OLINE);

    wait;
  end process test_proc;

  clk_proc: process
  begin
    clk <= '1';
    wait for 1 ns;
    clk <= '0';
    wait for 1 ns;
  end process clk_proc;

end TEST;
