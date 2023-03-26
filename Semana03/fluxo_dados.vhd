LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY fluxo_dados IS
  PORT (
    clock : IN STD_LOGIC;
    zeraCEndereco : IN STD_LOGIC;
    zeraCRodada : IN STD_LOGIC;
    contaCEndereco : IN STD_LOGIC;
    contaCRodada : IN STD_LOGIC;
    enableTimeout : IN STD_LOGIC;
    enableMostraJogada : IN STD_LOGIC;
    escreveM : IN STD_LOGIC;
    zeraR : IN STD_LOGIC;
    zeraTimeout : IN STD_LOGIC;
    zeraMostraJogada : IN STD_LOGIC;
    registraR : IN STD_LOGIC;
    enableControleSelecionaTimeout : IN STD_LOGIC;
    modo1 : IN STD_LOGIC;
    modo2e3 : IN STD_LOGIC;
    botoes : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
    igualEnderecoJogada : OUT STD_LOGIC; --botoesIgualMemoeria
    igualEnderecoRodada : OUT STD_LOGIC; --botoesIgualMemoeria
    fimCEndereco : OUT STD_LOGIC;
    fimCRodada : OUT STD_LOGIC;
    jogada_feita : OUT STD_LOGIC; --sinal de saida do edge (obs: teoricamente o resultado deste sinal tem que ser igual ao db_tem_jogada)
    db_tem_jogada : OUT STD_LOGIC; --(edge) sinal de debub após OR e antes de entrar no edge
    db_jogada_correta : OUT STD_LOGIC;
    db_rodada : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    db_contagem : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    db_memoria : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
    db_jogada : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); --antigo db_botoes
    fim_timeout : OUT STD_LOGIC;
    fim_mostra_jogada : OUT STD_LOGIC;
    leds : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE estrutural OF fluxo_dados IS

  SIGNAL s_Cendereco : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL s_Crodada : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL s_dado : STD_LOGIC_VECTOR (5 DOWNTO 0);
  SIGNAL s_botoes : STD_LOGIC_VECTOR (5 DOWNTO 0);

  SIGNAL s_not_zeraCEndereco : STD_LOGIC;
  SIGNAL s_not_zeraCRodada : STD_LOGIC;
  SIGNAL s_not_escreveM : STD_LOGIC;
  SIGNAL s_chaveacionada : STD_LOGIC;

  SIGNAL s_igualEnderecoRodada : STD_LOGIC;
  SIGNAL s_igualEnderecoJogada : STD_LOGIC;
  SIGNAL s_conta_timeout : STD_LOGIC;
  SIGNAL s_fim_timeout : STD_LOGIC;

  SIGNAL s_reset_timeout : STD_LOGIC;
  SIGNAL s_conta_mostra_jogada : STD_LOGIC;
  SIGNAL s_fim_mostra_jogada : STD_LOGIC;
  SIGNAL s_reset_mostra_jogada : STD_LOGIC;

  SIGNAL fim_timeout5 : STD_LOGIC;
  SIGNAL fim_timeout4 : STD_LOGIC;
  SIGNAL fim_timeout3 : STD_LOGIC;
  SIGNAL s_controla_timeouts : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL s_incrementa_selecao : STD_LOGIC;
  SIGNAL botoes_filtrados : STD_LOGIC_VECTOR(5 DOWNTO 0);
  COMPONENT contador_163
    PORT (
      clock : IN STD_LOGIC;
      clr : IN STD_LOGIC;
      ld : IN STD_LOGIC;
      ent : IN STD_LOGIC;
      enp : IN STD_LOGIC;
      D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
      rco : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT comparador_85
    PORT (
      i_A5 : IN STD_LOGIC;
      i_B5 : IN STD_LOGIC;
      i_A4 : IN STD_LOGIC;
      i_B4 : IN STD_LOGIC;
      i_A3 : IN STD_LOGIC;
      i_B3 : IN STD_LOGIC;
      i_A2 : IN STD_LOGIC;
      i_B2 : IN STD_LOGIC;
      i_A1 : IN STD_LOGIC;
      i_B1 : IN STD_LOGIC;
      i_A0 : IN STD_LOGIC;
      i_B0 : IN STD_LOGIC;
      i_AGTB : IN STD_LOGIC;
      i_ALTB : IN STD_LOGIC;
      i_AEQB : IN STD_LOGIC;
      o_AGTB : OUT STD_LOGIC;
      o_ALTB : OUT STD_LOGIC;
      o_AEQB : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ram_16x6 IS
    PORT (
      clk : IN STD_LOGIC;
      endereco : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      dado_entrada : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      we : IN STD_LOGIC;
      ce : IN STD_LOGIC;
      dado_saida : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
  END COMPONENT;

  COMPONENT registrador_n IS
    GENERIC (
      CONSTANT N : INTEGER := 8
    );
    PORT (
      clock : IN STD_LOGIC;
      clear : IN STD_LOGIC;
      enable : IN STD_LOGIC;
      D : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
      Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT hexa7seg IS
    PORT (
      hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT edge_detector IS
    PORT (
      clock : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      sinal : IN STD_LOGIC;
      pulso : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT contador_m IS
    GENERIC (
      CONSTANT M : INTEGER := 3000 -- modulo do contador
    );
    PORT (
      clock : IN STD_LOGIC;
      zera_as : IN STD_LOGIC;
      zera_s : IN STD_LOGIC;
      conta : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
      fim : OUT STD_LOGIC;
      meio : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN

  -- sinais de controle ativos em alto
  -- sinais dos componentes ativos em baixo
  s_not_zeraCEndereco <= NOT zeraCEndereco;
  s_not_zeraCRodada <= NOT zeraCRodada;
  s_not_escreveM <= NOT escreveM;
  s_chaveacionada <= botoes_filtrados(0) OR botoes_filtrados(1) OR botoes_filtrados(2) OR botoes_filtrados(3) OR botoes_filtrados(4) OR botoes_filtrados(5);

  contador_endereco : contador_163
  PORT MAP(
    clock => clock,
    clr => s_not_zeraCEndereco, -- clr ativo em baixo
    ld => '1',
    ent => '1',
    enp => contaCEndereco,
    D => "0000",
    Q => s_Cendereco,
    rco => fimCEndereco
  );

  contador_rodada : contador_163
  PORT MAP(
    clock => clock,
    clr => s_not_zeraCRodada, -- clr ativo em baixo
    ld => '1',
    ent => '1',
    enp => contaCRodada,
    D => "0000",
    Q => s_Crodada,
    rco => fimCRodada
  );

  comparador_enderecoJogada : comparador_85
  PORT MAP(
    i_A5 => s_dado(5),
    i_B5 => s_botoes(5),
    i_A4 => s_dado(4),
    i_B4 => s_botoes(4),
    i_A3 => s_dado(3),
    i_B3 => s_botoes(3),
    i_A2 => s_dado(2),
    i_B2 => s_botoes(2),
    i_A1 => s_dado(1),
    i_B1 => s_botoes(1),
    i_A0 => s_dado(0),
    i_B0 => s_botoes(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => OPEN, -- saidas nao usadas
    o_ALTB => OPEN,
    o_AEQB => s_igualEnderecoJogada
  );

  comparador_enderecoRodada : comparador_85
  PORT MAP(
    i_A5 => '0',
    i_B5 => '0',
    i_A4 => '0',
    i_B4 => '0',
    i_A3 => s_Crodada(3),
    i_B3 => s_Cendereco(3),
    i_A2 => s_Crodada(2),
    i_B2 => s_Cendereco(2),
    i_A1 => s_Crodada(1),
    i_B1 => s_Cendereco(1),
    i_A0 => s_Crodada(0),
    i_B0 => s_Cendereco(0),
    i_AGTB => '0',
    i_ALTB => '0',
    i_AEQB => '1',
    o_AGTB => OPEN, -- saidas nao usadas
    o_ALTB => OPEN,
    o_AEQB => s_igualEnderecoRodada
  );

  -- memoria : ENTITY work.ram_16x4 (ram_mif) -- usar esta linha para Intel Quartus
  memoria : ENTITY work.ram_16x6 (ram_modelsim) -- usar arquitetura para ModelSim
    PORT MAP(
      clk => clock,
      endereco => s_Cendereco,
      dado_entrada => s_botoes,
      we => s_not_escreveM, -- we ativo em baixo
      ce => '0',
      dado_saida => s_dado
    );

  registrador : registrador_n
  GENERIC MAP(6)
  PORT MAP(
    clock => clock,
    clear => zeraR,
    enable => registraR,
    D => botoes_filtrados,
    Q => s_botoes
  );

  edge_detec : edge_detector
  PORT MAP(
    clock => clock,
    reset => '0',
    sinal => s_chaveacionada,
    pulso => jogada_feita
  );

  contador_controle_seleciona_timeout : contador_m
  GENERIC MAP(5)
  PORT MAP(
    clock => clock,
    zera_as => zeraCRodada,
    zera_s => '0',
    conta => enableControleSelecionaTimeout,
    Q => OPEN,
    fim => s_incrementa_selecao,
    meio => OPEN
  );

  contador_seleciona_timeout : contador_163
  PORT MAP(
    clock => clock,
    clr => s_not_zeraCRodada, -- clr ativo em baixo
    ld => '1',
    ent => '1',
    enp => s_incrementa_selecao,
    D => "0000",
    Q => s_controla_timeouts,
    rco => OPEN
  );

  contador_timeout5 : contador_m
  GENERIC MAP(5000)
  PORT MAP(
    clock => clock,
    zera_as => zeraTimeout,
    zera_s => '0',
    conta => enableTimeout,
    Q => OPEN,
    fim => fim_timeout5,
    meio => OPEN
  );

  contador_timeout4 : contador_m
  GENERIC MAP(4000)
  PORT MAP(
    clock => clock,
    zera_as => zeraTimeout,
    zera_s => '0',
    conta => enableTimeout,
    Q => OPEN,
    fim => fim_timeout4,
    meio => OPEN
  );

  contador_timeout3 : contador_m
  GENERIC MAP(3000)
  PORT MAP(
    clock => clock,
    zera_as => zeraTimeout,
    zera_s => '0',
    conta => enableTimeout,
    Q => OPEN,
    fim => fim_timeout3,
    meio => OPEN
  );

  contador_mostra_jogada : contador_m
  GENERIC MAP(2000)
  PORT MAP(
    clock => clock,
    zera_as => zeraMostraJogada,
    zera_s => '0',
    conta => enableMostraJogada,
    Q => OPEN,
    fim => fim_mostra_jogada,
    meio => OPEN
  );

  WITH enableMostraJogada SELECT leds <= s_dado WHEN '1', botoes WHEN OTHERS;

  WITH s_controla_timeouts(1 DOWNTO 0) SELECT fim_timeout <= fim_timeout5 WHEN "00", fim_timeout4 WHEN "01", fim_timeout3 WHEN OTHERS;

  WITH modo2e3 SELECT botoes_filtrados <= ("00" & botoes(3 DOWNTO 0)) WHEN '0', botoes WHEN others;

  igualEnderecoJogada <= s_igualEnderecoJogada;
  igualEnderecoRodada <= s_igualEnderecoRodada;
  db_tem_jogada <= s_chaveacionada;
  db_contagem <= s_Cendereco;

  db_memoria <= s_dado;
  db_jogada <= s_botoes;
  db_jogada_correta <= s_igualEnderecoJogada;
  db_rodada <= s_Crodada;

END ARCHITECTURE estrutural;