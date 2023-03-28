library ieee;
use ieee.std_logic_1164.all;

entity bcd_counter is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    enable  : in  std_logic;
    finish  : out std_logic;
    digit3  : out std_logic_vector(3 downto 0);
    digit2  : out std_logic_vector(3 downto 0);
    digit1  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavioral of bcd_counter is
  signal counter : integer range 0 to 9999 := 0;
begin

  process (clk, reset)
  begin
    if (reset = '1') then
      counter <= 0;
      digit1 <= "0000";
      digit2 <= "0000";
      digit3 <= "0000";
      finish <= '0';
    elsif (rising_edge(clk) and enable = '1') then
      if (counter = 999) then
        finish <= '1';
      else
        finish <= '0';
      end if;
      
      counter <= counter + 1;
      digit1 <= std_logic_vector(to_unsigned(counter mod 10, 4));
      digit2 <= std_logic_vector(to_unsigned((counter / 10) mod 10, 4));
      digit3 <= std_logic_vector(to_unsigned((counter / 100) mod 10, 4));
    end if;
  end process;

end architecture;