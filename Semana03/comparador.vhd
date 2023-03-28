LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY comparador IS
  PORT (
    a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    enable : IN STD_LOGIC;
    equal : OUT STD_LOGIC;
    greater : OUT STD_LOGIC;
    less : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE behavioral OF comparador IS
BEGIN

  PROCESS (a, b, enable)
  BEGIN
    IF (enable = '1') THEN
      IF (a = b) THEN
        equal <= '1';
        greater <= '0';
        less <= '0';
      ELSIF (a > b) THEN
        equal <= '0';
        greater <= '1';
        less <= '0';
      ELSE
        equal <= '0';
        greater <= '0';
        less <= '1';
      END IF;
    ELSE
      equal <= '0';
      greater <= '0';
      less <= '0';
    END IF;
  END PROCESS;
END ARCHITECTURE;