LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL;

-- entidade do testbench
ENTITY projeto_genius_tb_modo3_1ganhaportempo IS
END ENTITY;

ARCHITECTURE tb OF projeto_genius_tb_modo3_1ganhaportempo IS

    -- Componente a ser testado (Device Under Test -- DUT)
    COMPONENT projeto_genius
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
            pronto_p1 : OUT STD_LOGIC;
            ganhou_p1 : OUT STD_LOGIC;
            perdeu_p1 : OUT STD_LOGIC;
            pronto_p2 : OUT STD_LOGIC;
            ganhou_p2 : OUT STD_LOGIC;
            perdeu_p2 : OUT STD_LOGIC;
            fim_de_jogo : OUT STD_LOGIC; --qdo os dois jogadores terminarem 
            ganhador : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); --display p mostrar quem ganhou (apagado nos modos 1 e 2)
            db_rodada : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_rodada_p2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_contagem : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_memoria : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_jogadafeita : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_estado : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_estado_p2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            db_botoesIgualMemoria : OUT STD_LOGIC;
            db_clock : OUT STD_LOGIC;
            db_enderecoIgualRodada : OUT STD_LOGIC;
            db_timeout : OUT STD_LOGIC;
            db_fim_mostra_jogada : OUT STD_LOGIC;
            db_escreveM : OUT STD_LOGIC;
            db_dig1_pontuacao_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig2_pontuacao_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig3_pontuacao_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig1_pontuacao_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig2_pontuacao_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig3_pontuacao_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig1_tempo_total_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig2_tempo_total_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig3_tempo_total_p1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig1_tempo_total_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig2_tempo_total_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            db_dig3_tempo_total_p2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    ---- Declaracao de sinais de entrada para conectar o componente
    SIGNAL clk_in : STD_LOGIC := '0';
    SIGNAL rst_in : STD_LOGIC := '0';
    SIGNAL iniciar_in : STD_LOGIC := '0';
    SIGNAL botoes_in : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
    SIGNAL botoes_p2_in : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";

    SIGNAL modo1_in : STD_LOGIC := '1';
    SIGNAL modo2e3_in : STD_LOGIC := '1';

    ---- Declaracao dos sinais de saida
    SIGNAL leds_out : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
    SIGNAL pronto_p1_out : STD_LOGIC := '0';
    SIGNAL ganhou_p1_out : STD_LOGIC := '0';
    SIGNAL perdeu_p1_out : STD_LOGIC := '0';
    SIGNAL pronto_p2_out : STD_LOGIC := '0';
    SIGNAL ganhou_p2_out : STD_LOGIC := '0';
    SIGNAL perdeu_p2_out : STD_LOGIC := '0';
    SIGNAL fim_de_jogo_out : STD_LOGIC := '0';
    SIGNAL ganhador_out : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    ---- Declaracao das saidas de depuracao
    -- inserir saidas de depuracao do seu projeto
    -- exemplos:
    -- signal estado_out       : std_logic_vector(6 downto 0) := "0000000";
    -- signal clock_out        : std_logic := '0';
    SIGNAL db_rodada_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_rodada_p2_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_contagem_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_memoria_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_jogadafeita_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_estado_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_estado_p2_out : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
    SIGNAL db_botoesIgualMemoria_out : STD_LOGIC := '0';
    SIGNAL db_clock_out : STD_LOGIC := '0';
    SIGNAL db_enderecoIgualRodada_out : STD_LOGIC := '0';
    SIGNAL db_tem_jogada_out : STD_LOGIC := '0';
    SIGNAL db_timeout_out : STD_LOGIC := '0';
    SIGNAL db_fim_mostra_jogada_out : STD_LOGIC := '0';
    SIGNAL db_escreveM_out : STD_LOGIC := '0';
    SIGNAL db_dig1_pontuacao_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig2_pontuacao_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig3_pontuacao_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig1_pontuacao_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig2_pontuacao_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig3_pontuacao_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig1_tempo_total_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig2_tempo_total_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig3_tempo_total_p1_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig1_tempo_total_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig2_tempo_total_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
    SIGNAL db_dig3_tempo_total_p2_out : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";

    -- Array de casos de teste
    TYPE caso_teste_type IS RECORD
        id : NATURAL;
        jogada_certa : STD_LOGIC_VECTOR (5 DOWNTO 0);
        duracao_jogada : INTEGER;
    END RECORD;

    TYPE casos_teste_array IS ARRAY (NATURAL RANGE <>) OF caso_teste_type;
    CONSTANT casos_teste : casos_teste_array :=
    (--  id   jogada_certa   duracao_jogada
    (0, "000001", 10), -- conteudo da ram_16x4
    (1, "000010", 10), -- 
    (2, "000100", 10), -- 
    (3, "001000", 10), -- 
    (4, "000100", 10), -- 
    (5, "000010", 10), -- 
    (6, "000001", 10), -- 
    (7, "000001", 10), -- 
    (8, "000010", 10), -- 
    (9, "000010", 10), -- 
    (10, "000100", 10), -- 
    (11, "000100", 10), -- 
    (12, "001000", 10), -- 
    (13, "100000", 10), -- 
    (14, "010000", 10), -- 
    (15, "000100", 10) -- 
    );

    -- Configurações do clock
    SIGNAL keep_simulating : STD_LOGIC := '0'; -- delimita o tempo de geração do clock
    CONSTANT clockPeriod : TIME := 1 ms; -- frequencia 1 KHz

    -- Identificacao de casos de teste
    SIGNAL caso : INTEGER := 0;

BEGIN
    -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
    -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
    clk_in <= (NOT clk_in) AND keep_simulating AFTER clockPeriod/2;

    ---- DUT para Caso de Teste 1
    dut : projeto_genius
    PORT MAP
    (
        clock => clk_in,
        reset => rst_in,
        iniciar => iniciar_in,
        modo1 => modo1_in,
        modo2e3 => modo2e3_in,
        botoes => botoes_in,
        leds => leds_out,
        botoes_p2 => botoes_p2_in,
        pronto_p1 => pronto_p1_out,
        ganhou_p1 => ganhou_p1_out,
        perdeu_p1 => perdeu_p1_out,
        pronto_p2 => pronto_p2_out,
        ganhou_p2 => ganhou_p2_out,
        perdeu_p2 => perdeu_p2_out,
        fim_de_jogo => fim_de_jogo_out,
        ganhador => ganhador_out,
        -- acrescentar saidas de depuracao
        db_rodada => db_rodada_out,
        db_rodada_p2 => db_rodada_p2_out,
        db_contagem => db_contagem_out,
        db_memoria => db_memoria_out,
        db_jogadafeita => db_jogadafeita_out,
        db_estado => db_estado_out,
        db_estado_p2 => db_estado_p2_out,
        db_botoesIgualMemoria => db_botoesIgualMemoria_out,
        db_clock => db_clock_out,
        db_enderecoIgualRodada => db_enderecoIgualRodada_out,
        db_timeout => db_timeout_out,
        db_fim_mostra_jogada => db_fim_mostra_jogada_out,
        db_escreveM => db_escreveM_out,
        db_dig1_pontuacao_p1 => db_dig1_pontuacao_p1_out,
        db_dig2_pontuacao_p1 => db_dig2_pontuacao_p1_out,
        db_dig3_pontuacao_p1 => db_dig3_pontuacao_p1_out,
        db_dig1_pontuacao_p2 => db_dig1_pontuacao_p2_out,
        db_dig2_pontuacao_p2 => db_dig2_pontuacao_p2_out,
        db_dig3_pontuacao_p2 => db_dig3_pontuacao_p2_out,
        db_dig1_tempo_total_p1 => db_dig1_tempo_total_p1_out,
        db_dig2_tempo_total_p1 => db_dig2_tempo_total_p1_out,
        db_dig3_tempo_total_p1 => db_dig3_tempo_total_p1_out,
        db_dig1_tempo_total_p2 => db_dig1_tempo_total_p2_out,
        db_dig2_tempo_total_p2 => db_dig2_tempo_total_p2_out,
        db_dig3_tempo_total_p2 => db_dig3_tempo_total_p2_out
    );

    ---- Gera sinais de estimulo para a simulacao

    -- Cenario de Teste #1: acerta todas as rodadas
    --                      e decide jogar de novo
    stimulus : PROCESS IS
    BEGIN

        -- inicio da simulacao
        ASSERT false REPORT "inicio da simulacao" SEVERITY note;
        keep_simulating <= '1';

        caso <= 1;
        -- gera pulso de reset (1 periodo de clock)
        rst_in <= '1';
        WAIT FOR clockPeriod;
        rst_in <= '0';

        WAIT UNTIL falling_edge(clk_in);

        caso <= 2;
        -- pulso do sinal de Iniciar
        iniciar_in <= '1';
        WAIT UNTIL falling_edge(clk_in);
        iniciar_in <= '0';
        WAIT FOR 10*clockPeriod;
        -- Cenario de Teste 1
        --
        ---- acerta de todas as rodadas
        FOR rodada IN 0 TO 15 LOOP -- rodadas 0 até 15
            wait for 2100*clockPeriod;
            FOR jogada IN 0 TO rodada LOOP
                IF rodada = 0 THEN
                    WAIT FOR 2 sec;
                END IF;
                -- espera antes da rodada (espera pela apresentacao das jogadas nos leds)
                IF jogada = 0 THEN
                    caso <= rodada + 3;
                END IF;
                -- realiza jogada certa
                IF jogada = 15 Then
                    botoes_in <= casos_teste(jogada).jogada_certa;
                ELSE
                    botoes_in <= casos_teste(jogada).jogada_certa;
                    botoes_p2_in <= casos_teste(jogada).jogada_certa;
                END IF;
                WAIT FOR casos_teste(jogada).duracao_jogada * clockPeriod;
                botoes_in <= "000000";
                botoes_p2_in <= "000000";
                -- espera entre jogadas
                WAIT FOR casos_teste(jogada).duracao_jogada * clockPeriod;
            END LOOP;
        END LOOP;
        WAIT FOR 2000 * clockPeriod;
        botoes_p2_in <= "000100";
        -- espera depois da jogada final
        WAIT FOR 20 * clockPeriod;
        -- decide jogar de novo
        caso <= 19;
        iniciar_in <= '1';
        WAIT FOR 10 * clockPeriod;

        ---- final do testbench
        ASSERT false REPORT "fim da simulacao" SEVERITY note;
        keep_simulating <= '0';

        WAIT; -- fim da simulação: processo aguarda indefinidamente
    END PROCESS;

END ARCHITECTURE;