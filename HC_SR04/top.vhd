library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity top is
    Port ( CLOCK_50 : in  STD_LOGIC;
           ECHO : in  STD_LOGIC;
           TRIG : out  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (7 downto 0)
         );
end top;

architecture Behavioral of top is

    -- Constants
    constant CLK_MHZ : integer := 50;        -- Clock frequency in MHz
    constant PERIOD_PING_MS : integer := 60;  -- Period of pings in milliseconds
    constant COUNTER_MAX_PING : integer := CLK_MHZ * PERIOD_PING_MS * 1000;
    constant D : integer := 2900;             -- Constant for distance conversion

    -- Signals
    signal start : STD_LOGIC;
    signal new_measure : STD_LOGIC;
    signal timeout : STD_LOGIC;
    signal distance_raw : STD_LOGIC_VECTOR (20 downto 0);
    signal counter_ping : unsigned (24 downto 0);

begin

    -- Instance of ultrasonic module
    U1 : entity work.HC_SR04
        generic map (
            CLK_MHZ => 50,
            TRIGGER_PULSE_US => 12,
            TIMEOUT_MS => 3
        )
        port map (
            clk => CLOCK_50,
            trigger => TRIG,
            echo => ECHO,
            start => start,
            new_measure => new_measure,
            timeout => timeout,
            distance_raw => distance_raw
        );

    -- LED logic
    LED(6) <= '1' when (to_integer(unsigned(distance_raw)) > 40 * D) else '0';
    LED(5) <= '1' when (to_integer(unsigned(distance_raw)) > 30 * D) else '0';
    LED(4) <= '1' when (to_integer(unsigned(distance_raw)) > 25 * D) else '0';
    LED(3) <= '1' when (to_integer(unsigned(distance_raw)) > 20 * D) else '0';
    LED(2) <= '1' when (to_integer(unsigned(distance_raw)) > 15 * D) else '0';
    LED(1) <= '1' when (to_integer(unsigned(distance_raw)) > 10 * D) else '0';
    LED(0) <= '1' when (to_integer(unsigned(distance_raw)) > 5 * D) else '0';
    LED(7) <= timeout;

    -- Start signal generation logic
    start <= '1' when (counter_ping = COUNTER_MAX_PING - 1) else '0';

    -- Counter for ping period
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if new_measure = '1' then
                counter_ping <= (others => '0');
            elsif counter_ping = COUNTER_MAX_PING - 1 then
                counter_ping <= (others => '0');
            else
                counter_ping <= counter_ping + 1;
            end if;
        end if;
    end process;

end Behavioral;