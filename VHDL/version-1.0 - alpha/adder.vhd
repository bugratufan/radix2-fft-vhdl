----------------------------------------------------------------------------------
-- Company: YONGATEK
-- Designer: Buğra Tufan
-- E-mail: bugratufan97@gmail.com
--
-- Create Date:    21.08.2019
-- Design Name:
-- Module Name:    adder
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description: VHDL implementation of addition algorithm for IEEE-754
-- single precision floating point data format
--
-- Dependencies:
-- Revision:
-- Revision 1.0 - alpha
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adder is
  Port (
  x   : in  STD_LOGIC_VECTOR (31 downto 0);
  y   : in  STD_LOGIC_VECTOR (31 downto 0);
  z   : out  STD_LOGIC_VECTOR (31 downto 0);
  clk : in std_logic
  );
end adder;


architecture RTL of adder is
  signal x_mantissa : STD_LOGIC_VECTOR (23 downto 0);
  signal x_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal x_sign : STD_LOGIC;
  signal y_mantissa : STD_LOGIC_VECTOR (23 downto 0);
  signal y_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal y_sign : STD_LOGIC;
  signal z_mantissa : STD_LOGIC_VECTOR (22 downto 0);
  signal z_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal z_sign : STD_LOGIC;
  -- TEMPORAL SIGNALS
  signal tmp_x_mantissa : STD_LOGIC_VECTOR (24 downto 0);
  signal tmp_neg_x_mantissa : STD_LOGIC_VECTOR (24 downto 0);
  signal tmp_x_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal tmp_y_mantissa : STD_LOGIC_VECTOR (24 downto 0);
  signal tmp_neg_y_mantissa : STD_LOGIC_VECTOR (24 downto 0);
  signal tmp_y_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal tmp_z_mantissa : STD_LOGIC_VECTOR (24 downto 0) := (others => '0');
  signal neg_ready : STD_LOGIC := '0';
  signal temp_exponent : STD_LOGIC_VECTOR (7 downto 0);
  signal temp_mantissa : STD_LOGIC_VECTOR (22 downto 0);
  signal exp_decrease : integer := 0;



  begin

    x_mantissa(23) <= '1';
    x_mantissa(22 downto 0) <= x(22 downto 0);
    x_exponent <= x(30 downto 23);
    x_sign <= x(31);
    y_mantissa(23) <= '1';
    y_mantissa(22 downto 0) <= y(22 downto 0);
    y_exponent <= y(30 downto 23);
    y_sign <= y(31);

    adding : process(clk)
    begin
      -- if x = "00000000000000000000000000000000" then
      --   z <= y;
      -- elsif y = "00000000000000000000000000000000" then
      --   z <= x;
      -- end if;

      if clk'event and clk='1' then --and ((x /= "00000000000000000000000000000000") and (y /= "00000000000000000000000000000000")) then
        tmp_y_mantissa(24) <= '0';
        tmp_x_mantissa(24) <= '0';

        if x_exponent > y_exponent then
          tmp_y_mantissa(23 downto 0) <= std_logic_vector(SHIFT_RIGHT(unsigned(y_mantissa), to_integer(unsigned(x_exponent)-unsigned(y_exponent))));--to_integer(unsigned(x_exponent)-unsigned(y_exponent)));
          tmp_x_exponent <= x_exponent;
          tmp_y_exponent <= x_exponent;
          tmp_x_mantissa(23 downto 0) <= x_mantissa;
        elsif x_exponent = y_exponent then
          tmp_y_mantissa(23 downto 0) <= y_mantissa;
          tmp_y_exponent <= y_exponent;
          tmp_x_mantissa(23 downto 0) <= x_mantissa;
          tmp_x_exponent <= x_exponent;
        else
          tmp_x_mantissa(23 downto 0) <= std_logic_vector(SHIFT_RIGHT(unsigned(x_mantissa), to_integer(unsigned(y_exponent)-unsigned(x_exponent))));--to_integer(unsigned(y_exponent)-unsigned(x_exponent)));
          tmp_x_exponent <= y_exponent;
          tmp_y_exponent <= y_exponent;
          tmp_y_mantissa(23 downto 0) <= y_mantissa;
        end if;
        if (x_sign = '1' and y_sign = '1') or (x_sign = '0' and y_sign = '0') then
          tmp_z_mantissa <= std_logic_vector(unsigned(tmp_x_mantissa) + unsigned(tmp_y_mantissa));
          z_sign <= x_sign;

        else
          if (x_exponent>y_exponent)  then
            tmp_z_mantissa <= std_logic_vector(unsigned(tmp_x_mantissa) - unsigned(tmp_y_mantissa));
            z_sign <= x_sign;

          elsif (y_exponent>x_exponent) then
            tmp_z_mantissa <= std_logic_vector(unsigned(tmp_y_mantissa) - unsigned(tmp_x_mantissa));
            z_sign <= y_sign;

          else
            -- tmp_y_exponent <= (others => '0');
            -- tmp_x_exponent <= (others => '0');
            if y_mantissa > x_mantissa then
              tmp_z_mantissa <= std_logic_vector(unsigned(tmp_y_mantissa) - unsigned(tmp_x_mantissa));
              z_sign <= y_sign;
            elsif x_mantissa > y_mantissa then
              tmp_z_mantissa <= std_logic_vector(unsigned(tmp_x_mantissa) - unsigned(tmp_y_mantissa));
              z_sign <= x_sign;
            else
              tmp_z_mantissa <= (others => '0');
              z_sign <= '0';
            end if;
          end if;
        end if;
      end if;
    end process adding;
    update_proc: process(tmp_z_mantissa, x_sign, y_sign, tmp_x_exponent, clk)
    begin
      if (x_sign = '1' xor y_sign = '1')then
        if tmp_z_mantissa(23 downto 16) < "00000001" then
          z_exponent <=  "00000000";
          z_mantissa(22 downto 0) <= tmp_z_mantissa(22 downto 0);
        elsif tmp_z_mantissa(23 downto 16) < "00000010" then
          if 7 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 7;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(15 downto 0) & "1111111";
        elsif tmp_z_mantissa(23 downto 16) < "00000100" then
          if 6 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 6;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(16 downto 0) & "111111";
        elsif tmp_z_mantissa(23 downto 16) < "00001000" then
          if 5 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 5;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(17 downto 0) & "11111";
        elsif tmp_z_mantissa(23 downto 16) < "00010000" then
          if 4 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 4;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(18 downto 0) & "1111";
        elsif tmp_z_mantissa(23 downto 16) < "00100000" then
          if 3 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 3;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(19 downto 0) & "111";
        elsif tmp_z_mantissa(23 downto 16) < "01000000" then
          if 2 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 2;
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(20 downto 0) & "11";
        elsif tmp_z_mantissa(23 downto 16) < "10000000" then
          if 1 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 1;
            report("girdi");
          end if;
          z_mantissa(22 downto 0) <= tmp_z_mantissa(21 downto 0) & '1';
        else
          if 0 > to_integer(unsigned(tmp_x_exponent)) then
            z_exponent <= "00000000";
          else
            z_exponent <= tmp_x_exponent - 0;
          end if;
          z_mantissa <= tmp_z_mantissa(22 downto 0);
        end if;

      else
        if tmp_z_mantissa(24) = '0' then
          z_exponent <= tmp_x_exponent;
          z_mantissa <= tmp_z_mantissa(22 downto 0);
        else
          z_exponent <= std_logic_vector(unsigned(tmp_x_exponent) +1);
          z_mantissa <= tmp_z_mantissa(23 downto 1);
        end if;
      end if;
    end process;

    z(22 downto 0) <= z_mantissa;
    z(30 downto 23) <= z_exponent;
    z(31) <= z_sign;
  end RTL;
