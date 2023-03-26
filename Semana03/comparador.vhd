library ieee;
use ieee.std_logic_1164.all;

entity comparador is
  port (
    a     : in  std_logic_vector(11 downto 0);
    b     : in  std_logic_vector(11 downto 0);
    enable : in  std_logic;
    equal : out std_logic;
    greater : out std_logic;
    less : out std_logic
  );
end entity;

architecture behavioral of comparador is
begin

  process (a, b, enable)
  begin
    if (enable = '1') then
        if (a = b) then
        equal <= '1';
        greater <= '0';
        less <= '0';
        elsif (a > b) then
        equal <= '0';
        greater <= '1';
        less <= '0';
        else
        equal <= '0';
        greater <= '0';
        less <= '1';
        end if;
    else
        equal <= '0';
        greater <= '0';
        less <= '0';
    end if;
  end process;
end architecture;
