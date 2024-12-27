library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity HC_SR04 is
    generic (
        CLK_MHZ                  : integer := 50;                    -- frequência do relógio em MHz
        TRIGGER_PULSE_US         : integer := 12;                    -- duração da pulsação do trigger em microssegundos
        TIMEOUT_MS               : integer := 25                     -- timeout em milissegundos
    );
    port (
        clk                      : in std_logic;                     -- sinal de relógio
        trigger                  : out std_logic;                    -- saída para o pino Trig do sensor
        echo                     : in std_logic;                     -- start do pino Echo do sensor
        start                    : in std_logic;                     -- sinal de início de medição
        new_measure              : out std_logic;                    -- indica quando a medição está completa
        timeout                  : out std_logic;                    -- indica timeout na medição
        distance_raw            : out std_logic_vector(20 downto 0)  -- largura do sinal Echo em 21 bits
    );
end entity;

architecture Behavioral of HC_SR04 is

    constant COUNT_TRIGGER_PULSE : integer := CLK_MHZ * TRIGGER_PULSE_US;   -- 600 ciclos de clock para 12us  
    constant COUNT_TIMEOUT       : integer := CLK_MHZ * TIMEOUT_MS * 1000;  -- 1,25e6 ciclos de clock para 25ms

    type estado is (IDLE, TRIG, WAIT_ECHO_UP, MEASURING, MEDICAO_OK);
    signal estado_atual, proximo_estado : estado := IDLE;

    signal contador : unsigned(20 downto 0) := (others => '0');
    signal contador_habilitado   : std_logic;

begin

    -- sincronizador
    process(clk)
    begin
        if rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    -- Controle do estado_atual
    process(estado_atual, start, echo, contador)
    begin
        proximo_estado <= estado_atual;
        case estado_atual is
            when IDLE =>
                if start = '1' then
                    proximo_estado <= TRIG;
                end if;

            when TRIG =>
                if to_integer(contador) = COUNT_TRIGGER_PULSE then         
                    proximo_estado <= WAIT_ECHO_UP;
                end if;

            when WAIT_ECHO_UP =>
                if echo = '1' then
                    proximo_estado <= MEASURING;
                end if;

            when MEASURING =>
                if to_integer(contador) >= COUNT_TIMEOUT or echo = '0' then 
                    proximo_estado <= MEDICAO_OK;
                end if;

            when MEDICAO_OK =>
                proximo_estado <= IDLE;

            when others =>
                proximo_estado <= IDLE;
        end case;
    end process;

    contador_habilitado <= '1' when (estado_atual = TRIG or estado_atual = MEASURING) else '0';

    -- contador
    process(clk)
    begin
        if rising_edge(clk) then
            if contador_habilitado = '1' then
                contador <= contador + 1;
            else
                contador <= (others => '0');
            end if;
        end if;
    end process;

    -- Atualização de distance_raw
    process(clk)
    begin
        if rising_edge(clk) then
            if contador_habilitado = '1' and estado_atual = MEASURING then
                distance_raw <= std_logic_vector(contador);
            end if;
        end if;
    end process;

    -- Sinais de saída
    trigger <= '1' when estado_atual = TRIG else '0';
    new_measure <= '1' when estado_atual = MEDICAO_OK else '0';
    timeout <= '1' when (estado_atual = MEDICAO_OK and to_integer(contador) >= COUNT_TIMEOUT) else '0';

end architecture;