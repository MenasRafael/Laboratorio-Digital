LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY indica_vencedor IS
  PORT (
    clock : IN STD_LOGIC;
    enable : IN STD_LOGIC;
    pa_maior_pb : IN STD_LOGIC;
    pb_maior_pa : IN STD_LOGIC;
    pa_igual_pb : IN STD_LOGIC;
    ta_maior_tb : IN STD_LOGIC;
    tb_maior_ta : IN STD_LOGIC;
    ta_igual_tb : IN STD_LOGIC;
    vencedor : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE behavioral OF indica_vencedor IS
BEGIN

  PROCESS (clock, enable)
  BEGIN
    IF (enable = '1') THEN
      IF (pa_maior_pb = '1') THEN
        vencedor <= "1010";
      ELSIF (pb_maior_pa = '1') THEN
        vencedor <= "1011";
      ELSE
        IF (ta_maior_tb = '1') THEN
          vencedor <= "1011";
        ELSIF (tb_maior_ta = '1') THEN
          vencedor <= "1010";
        ELSE
          vencedor <= "1110"; --empate
        END IF;
      END IF;
    ELSE
      vencedor <= "0000";
    END IF;
  END PROCESS;
END ARCHITECTURE;