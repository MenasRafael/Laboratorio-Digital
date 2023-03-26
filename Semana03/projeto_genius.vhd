LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY projeto_genius IS
    PORT (
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        iniciar : IN STD_LOGIC;
        modo1 : IN STD_LOGIC;
        modo2e3 : IN STD_LOGIC;
        botoes : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        leds : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        botoes_p2 : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        leds_p2 : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        pronto : OUT STD_LOGIC;
        ganhou : OUT STD_LOGIC;
        perdeu : OUT STD_LOGIC;
        pronto_p2 : OUT STD_LOGIC;
        ganhou_p2 : OUT STD_LOGIC;
        perdeu_p2 : OUT STD_LOGIC;
        db_rodada : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_contagem : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_memoria : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_jogadafeita : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        db_botoesIgualMemoria : OUT STD_LOGIC;
        db_clock : OUT STD_LOGIC;
        db_enderecoIgualRodada : OUT STD_LOGIC;
        db_timeout : OUT STD_LOGIC;
        db_fim_mostra_jogada : OUT STD_LOGIC;
        db_escreveM : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE estrutural OF projeto_genius IS

    SIGNAL s_db_botoes : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_db_contagem : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_db_memoria : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_db_rodada : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL s_fimCRodada : STD_LOGIC;
    SIGNAL s_fimCEndereco : STD_LOGIC;
    SIGNAL s_enderecoIgualRodada : STD_LOGIC;
    SIGNAL s_botoesIgualMemoria : STD_LOGIC;

    SIGNAL s_jogada_correta : STD_LOGIC;
    SIGNAL s_registraR : STD_LOGIC;
    SIGNAL s_contaCEndereco : STD_LOGIC;
    SIGNAL s_contaCRodada : STD_LOGIC;

    SIGNAL s_db_estado : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_zeraCEndereco : STD_LOGIC;
    SIGNAL s_zeraCRodada : STD_LOGIC;
    SIGNAL s_zeraR : STD_LOGIC;

    SIGNAL s_jogada_feita : STD_LOGIC;
    SIGNAL s_tem_jogada : STD_LOGIC;
    SIGNAL s_db_jogada : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_conta_timeout : STD_LOGIC;

    SIGNAL s_fim_timeout : STD_LOGIC;
    SIGNAL s_reset_timeout : STD_LOGIC;
    SIGNAL s_fim_mostra_jogada : STD_LOGIC;
    SIGNAL s_reset_mostra_jogada : STD_LOGIC;

    SIGNAL s_conta_mostra_jogada : STD_LOGIC;
    SIGNAL s_escreveM : STD_LOGIC;
    SIGNAL s_modo2e3 : STD_LOGIC;
    SIGNAL s_modo1 : STD_LOGIC;

    SIGNAL s_modo : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL s_enableControlaSelecionaTimeout : STD_LOGIC;

    SIGNAL s_fimCRodada_p2 : STD_LOGIC;
    SIGNAL s_fimCEndereco_p2 : STD_LOGIC;
    SIGNAL s_enderecoIgualRodada_p2 : STD_LOGIC;
    SIGNAL s_botoesIgualMemoria_p2 : STD_LOGIC;

    SIGNAL s_jogada_correta_p2 : STD_LOGIC;
    SIGNAL s_registraR_p2 : STD_LOGIC;
    SIGNAL s_contaCEndereco_p2 : STD_LOGIC;
    SIGNAL s_contaCRodada_p2 : STD_LOGIC;

    SIGNAL s_db_estado_p2 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_zeraCEndereco_p2 : STD_LOGIC;
    SIGNAL s_zeraCRodada_p2 : STD_LOGIC;
    SIGNAL s_zeraR_p2 : STD_LOGIC;

    SIGNAL s_jogada_feita_p2 : STD_LOGIC;
    SIGNAL s_tem_jogada_p2 : STD_LOGIC;
    SIGNAL s_db_jogada_p2 : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_conta_timeout_p2 : STD_LOGIC;

    SIGNAL s_fim_timeout_p2 : STD_LOGIC;
    SIGNAL s_reset_timeout_p2 : STD_LOGIC;
    SIGNAL s_fim_mostra_jogada_p2 : STD_LOGIC;
    SIGNAL s_reset_mostra_jogada_p2 : STD_LOGIC;

    SIGNAL s_conta_mostra_jogada_p2 : STD_LOGIC;
    SIGNAL s_escreveM_p2 : STD_LOGIC;

    SIGNAL s_db_botoes_p2 : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_db_contagem_p2 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL s_db_memoria_p2 : STD_LOGIC_VECTOR (5 DOWNTO 0);
    SIGNAL s_db_rodada_p2 : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL s_enableControlaSelecionaTimeout_p2 : STD_LOGIC;
    
    SIGNAL s_dig1_pontuacao_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig2_pontuacao_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig3_pontuacao_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL s_dig1_pontuacao_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig2_pontuacao_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig3_pontuacao_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL s_dig1_tempo_total_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig2_tempo_total_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig3_tempo_total_p1: STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL s_dig1_tempo_total_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig2_tempo_total_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_dig3_tempo_total_p2: STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL pronto_final: std_logic;



    COMPONENT unidade_controle IS
        PORT (
            clock : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            iniciar : IN STD_LOGIC;
            igualChaveMemoria : IN STD_LOGIC;
            igualRodadaEndereco : IN STD_LOGIC;
            ultimaRodada : IN STD_LOGIC;
            jogada : IN STD_LOGIC; --joga_feita
            fim_timeout : IN STD_LOGIC;
            fim_mostra_jogada : IN STD_LOGIC;
            modo : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --dois bits concatenados dos sinais de modo
            zeraCEndereco : OUT STD_LOGIC;
            zeraCRodada : OUT STD_LOGIC;
            contaCEndereco : OUT STD_LOGIC;
            contaCRodada : OUT STD_LOGIC;
            zeraR : OUT STD_LOGIC;
            registraR : OUT STD_LOGIC;
            acertou : OUT STD_LOGIC;
            errou : OUT STD_LOGIC;
            pronto : OUT STD_LOGIC;
            db_estado : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            conta_timeout : OUT STD_LOGIC;
            reset_timeout : OUT STD_LOGIC;
            enableMostraJogada : OUT STD_LOGIC;
            zeraMostraJogada : OUT STD_LOGIC;
            escreveM : OUT STD_LOGIC;
            enableControlaSelecionaTimeout : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fluxo_dados IS
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
    END COMPONENT;

    component bcd_counter is
        port (
          clk     : in  std_logic;
          reset   : in  std_logic;
          enable  : in  std_logic;
          finish  : out std_logic;
          digit3  : out std_logic_vector(3 downto 0);
          digit2  : out std_logic_vector(3 downto 0);
          digit1  : out std_logic_vector(3 downto 0)
        );
    end component;

    component comparador is
        port (
          a     : in  std_logic_vector(11 downto 0);
          b     : in  std_logic_vector(11 downto 0);
          enable : in  std_logic;
          equal : out std_logic;
          greater : out std_logic;
          less : out std_logic
        );
    end component;      

    COMPONENT hexa7seg IS
        PORT (
            hexa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    UCp1 : unidade_controle
    PORT MAP(
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        igualChaveMemoria => s_botoesIgualMemoria,
        igualRodadaEndereco => s_enderecoIgualRodada,
        ultimaRodada => s_fimCRodada,
        jogada => s_jogada_feita,
        fim_timeout => s_fim_timeout,
        fim_mostra_jogada => s_fim_mostra_jogada,
        modo => s_modo,
        zeraCEndereco => s_zeraCEndereco,
        zeraCRodada => s_zeraCRodada,
        contaCEndereco => s_contaCEndereco,
        contaCRodada => s_contaCRodada,
        zeraR => s_zeraR,
        registraR => s_registraR,
        acertou => ganhou,
        errou => perdeu,
        pronto => pronto,
        db_estado => s_db_estado,
        conta_timeout => s_conta_timeout,
        reset_timeout => s_reset_timeout,
        enableMostraJogada => s_conta_mostra_jogada,
        zeraMostraJogada => s_reset_mostra_jogada,
        escreveM => s_escreveM,
        enableControlaSelecionaTimeout => s_enableControlaSelecionaTimeout
    );

    FDp1 : fluxo_dados
    PORT MAP(
        clock => clock,
        zeraCEndereco => s_zeraCEndereco,
        zeraCRodada => s_zeraCRodada,
        contaCEndereco => s_contaCEndereco,
        contaCRodada => s_contaCRodada,
        enableTimeout => s_conta_timeout,
        enableMostraJogada => s_conta_mostra_jogada,
        escreveM => s_escreveM,
        zeraR => s_zeraR,
        zeraTimeout => s_reset_timeout,
        zeraMostraJogada => s_reset_mostra_jogada,
        registraR => s_registraR,
        enableControleSelecionaTimeout => s_enableControlaSelecionaTimeout,
        modo1 => s_modo1,
        modo2e3 => s_modo2e3,
        botoes => botoes,
        igualEnderecoJogada => s_botoesIgualMemoria,
        igualEnderecoRodada => s_enderecoIgualRodada,
        fimCEndereco => s_fimCEndereco,
        fimCRodada => s_fimCRodada,
        jogada_feita => s_jogada_feita,
        db_jogada_correta => s_jogada_correta,
        db_rodada => s_db_rodada,
        db_contagem => s_db_contagem,
        db_memoria => s_db_memoria,
        db_jogada => s_db_jogada,
        fim_timeout => s_fim_timeout,
        fim_mostra_jogada => s_fim_mostra_jogada,
        leds => leds
    );

    UCp2 : unidade_controle
    PORT MAP(
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        igualChaveMemoria => s_botoesIgualMemoria_p2,
        igualRodadaEndereco => s_enderecoIgualRodada_p2,
        ultimaRodada => s_fimCRodada_p2,
        jogada => s_jogada_feita_p2,
        fim_timeout => s_fim_timeout_p2,
        fim_mostra_jogada => s_fim_mostra_jogada_p2,
        modo => s_modo,
        zeraCEndereco => s_zeraCEndereco_p2,
        zeraCRodada => s_zeraCRodada_p2,
        contaCEndereco => s_contaCEndereco_p2,
        contaCRodada => s_contaCRodada_p2,
        zeraR => s_zeraR_p2,
        registraR => s_registraR_p2,
        acertou => ganhou_p2,
        errou => perdeu_p2,
        pronto => pronto_p2,
        db_estado => s_db_estado_p2,
        conta_timeout => s_conta_timeout_p2,
        reset_timeout => s_reset_timeout_p2,
        enableMostraJogada => s_conta_mostra_jogada_p2,
        zeraMostraJogada => s_reset_mostra_jogada_p2,
        escreveM => s_escreveM_p2,
        enableControlaSelecionaTimeout => s_enableControlaSelecionaTimeout_p2
    );

    FDp2 : fluxo_dados
    PORT MAP(
        clock => clock,
        zeraCEndereco => s_zeraCEndereco_p2,
        zeraCRodada => s_zeraCRodada_p2,
        contaCEndereco => s_contaCEndereco_p2,
        contaCRodada => s_contaCRodada_p2,
        enableTimeout => s_conta_timeout_p2,
        enableMostraJogada => s_conta_mostra_jogada_p2,
        escreveM => s_escreveM_p2,
        zeraR => s_zeraR_p2,
        zeraTimeout => s_reset_timeout_p2,
        zeraMostraJogada => s_reset_mostra_jogada_p2,
        registraR => s_registraR_p2,
        enableControleSelecionaTimeout => s_enableControlaSelecionaTimeout_p2,
        modo1 => s_modo1,
        modo2e3 => s_modo2e3,
        botoes => botoes_p2,
        igualEnderecoJogada => s_botoesIgualMemoria_p2,
        igualEnderecoRodada => s_enderecoIgualRodada_p2,
        fimCEndereco => s_fimCEndereco_p2,
        fimCRodada => s_fimCRodada_p2,
        jogada_feita => s_jogada_feita_p2,
        db_jogada_correta => s_jogada_correta_p2,
        db_rodada => s_db_rodada_p2,
        db_contagem => s_db_contagem_p2,
        db_memoria => s_db_memoria_p2,
        db_jogada => s_db_jogada_p2,
        fim_timeout => s_fim_timeout_p2,
        fim_mostra_jogada => s_fim_mostra_jogada_p2,
        leds => leds_p2
    );

    pontuacao_p1 : bcd_counter is
        port map(
          clk    => clock,
          reset  => reset,
          enable => s_contaCEndereco,
          finish  => OPEN,
          digit3  => s_dig3_pontuacao_p1,
          digit2  => s_dig2_pontuacao_p1,
          digit1  => s_dig1_pontuacao_p1
    );

    pontuacao_p2 : bcd_counter is
        port map(
          clk    => clock,
          reset  => reset,
          enable => s_contaCEndereco_p2,
          finish  => OPEN,
          digit3  => s_dig3_pontuacao_p2,
          digit2  => s_dig2_pontuacao_p2,
          digit1  => s_dig1_pontuacao_p2
    );

    tempo_total_p1 : bcd_counter is
        port map(
          clk    => clock,
          reset  => reset,
          enable => s_conta_timeout,
          finish  => OPEN,
          digit3  => s_dig3_tempo_total_p1,
          digit2  => s_dig2_tempo_total_p1,
          digit1  => s_dig1_tempo_total_p1
    );

    tempo_total_p2 : bcd_counter is
        port map(
          clk    => clock,
          reset  => reset,
          enable => s_conta_timeout_p2,
          finish  => OPEN,
          digit3  => s_dig3_tempo_total_p2,
          digit2  => s_dig2_tempo_total_p2,
          digit1  => s_dig1_tempo_total_p2
    );

    compara_pontuacoes : comparador is
        port (
          a => s_pontuacao_p1,
          b => s_pontuacao_p2,
          enable => pronto_final,
          equal => s_pontuacao_igual,
          greater => s_pontuacao_maior,
          less => s_pontuacao_menor 
    );
    
    compara_tempos : comparador is
        port (
          a => s_tempo_total_p1,
          b => s_tempo_total_p1,
          enable => pronto_final,
          equal => s_tempo_total_igual,
          greater => s_tempo_total_maior,
          less => s_tempo_total_menor
    );  
    
    HEX0 : hexa7seg
    PORT MAP(
        hexa => s_db_contagem,
        sseg => db_contagem
    );

    HEX1 : hexa7seg
    PORT MAP(
        hexa => s_db_memoria(3 DOWNTO 0),
        sseg => db_memoria
    );

    HEX2 : hexa7seg
    PORT MAP(
        hexa => s_db_jogada(3 DOWNTO 0),
        sseg => db_jogadafeita
    );

    HEX3 : hexa7seg
    PORT MAP(
        hexa => s_db_estado,
        sseg => db_estado
    );

    HEX4 : hexa7seg
    PORT MAP(
        hexa => s_db_rodada,
        sseg => db_rodada
    );

    pronto_final <= pronto OR pronto_p2

    s_modo1 <= modo1;
    s_modo2e3 <= modo2e3;
    s_modo <= (modo2e3 & modo1);

    s_pontuacao_p1 <= s_dig3_pontuacao_p1&s_dig2_pontuacao_p1&s_dig1_pontuacao_p1;
    s_pontuacao_p2 <= s_dig3_pontuacao_p2&s_dig2_pontuacao_p2&s_dig1_pontuacao_p2;

    s_tempo_total_p1 <= s_dig3_tempo_total_p1&s_dig2_tempo_total_p1&s_dig1_tempo_total_p1;
    s_tempo_total_p1 <= s_dig3_tempo_total_p2&s_dig2_tempo_total_p2&s_dig1_tempo_total_p2;

    db_clock <= clock;
    db_botoesIgualMemoria <= s_botoesIgualMemoria;
    db_enderecoIgualRodada <= s_enderecoIgualRodada;
    db_timeout <= s_fim_timeout;
    db_fim_mostra_jogada <= s_fim_mostra_jogada;
    db_escreveM <= s_escreveM;

END estrutural;