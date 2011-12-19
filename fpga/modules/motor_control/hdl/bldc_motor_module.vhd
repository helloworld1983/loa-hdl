-------------------------------------------------------------------------------
-- Title      : Motor control
-- Project    : Loa
-------------------------------------------------------------------------------
-- File       : motor_control.vhd
-- Author     : Fabian Greif  <fabian.greif@rwth-aachen.de>
-- Company    : Roboterclub Aachen e.V.
-- Created    : 2011-12-16
-- Last update: 2011-12-19
-- Platform   : Spartan 3-400
-------------------------------------------------------------------------------
-- Description:
--
-- Generates a symmetric (center-aligned) PWM with deadtime
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.bus_pkg.all;
use work.motor_control_pkg.all;

package bldc_motor_module_pkg is

   component bldc_motor_module is
      generic (
         BASE_ADDRESS : integer range 0 to 32767;
         WIDTH        : positive;
         PRESCALER    : positive);
      port (
         driver_stage_p : out bldc_driver_stage_type;
         hall_p         : in  hall_sensor_type;
         bus_o          : out busdevice_out_type;
         bus_i          : in  busdevice_in_type;
         reset          : in  std_logic;
         clk            : in  std_logic);
   end component bldc_motor_module;

end package bldc_motor_module_pkg;

-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.bus_pkg.all;
use work.utils_pkg.all;
use work.motor_control_pkg.all;
use work.symmetric_pwm_deadtime_pkg.all;
use work.commutation_pkg.all;

entity bldc_motor_module is
   generic (
      BASE_ADDRESS : integer range 0 to 32767;
      WIDTH        : positive := 12;  -- Number of bits for the PWM generation (e.g. 12 => 0..4095)
      PRESCALER    : positive
      );
   port (
      driver_stage_p : out bldc_driver_stage_type;
      hall_p         : in  hall_sensor_type;

      bus_o : out busdevice_out_type;
      bus_i : in  busdevice_in_type;

      reset : in std_logic;
      clk   : in std_logic
      );
end bldc_motor_module;

-------------------------------------------------------------------------------
architecture behavioral of bldc_motor_module is

   type bldc_motor_module_type is record
      data_out  : std_logic_vector(15 downto 0);         -- currently not used
      pwm_value : std_logic_vector(WIDTH - 1 downto 0);  -- PWM value
      sd        : std_logic;                             -- Shutdown
   end record;

   signal clk_en : std_logic := '1';
   signal center : std_logic;           -- currently not used
   signal pwm    : half_bridge_type;

   signal r, rin : bldc_motor_module_type;
begin

   seq_proc : process(reset, clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            r.data_out  <= (others => '0');
            r.pwm_value <= (others => '0');
            r.sd        <= '1';
         else
            r <= rin;
         end if;
      end if;
   end process seq_proc;

   comb_proc : process(bus_i.addr, bus_i.data(15),
                       bus_i.data(WIDTH - 1 downto 0), bus_i.re, bus_i.we, r)
      variable v : bldc_motor_module_type;
   begin
      v := r;

      -- Set default values
      v.data_out := (others => '0');

      -- Check Bus Address
      if bus_i.addr = std_logic_vector(to_unsigned(BASE_ADDRESS, 15)) then
         if bus_i.we = '1' then
            v.pwm_value := bus_i.data(WIDTH - 1 downto 0);
            v.sd        := bus_i.data(15);
         elsif bus_i.re = '1' then
         -- v.data_out := r.counter;
         end if;
      end if;

      rin <= v;
   end process comb_proc;

   bus_o.data <= r.data_out;

   -- Generate clock for the PWM generator
   divider : clock_divider
      generic map (
         DIVIDER => PRESCALER)
      port map (
         clk_out_p => clk_en,
         clk       => clk);

   pwm_generator : symmetric_pwm_deadtime
      generic map (
         WIDTH  => WIDTH,
         -- Deadtime settings:
         -- 50 MHz clock => 20ns per cycle
         -- T_DEAD = 20 * 20ns = 400ns
         T_DEAD => 20)
      port map (
         pwm_p    => pwm,
         center_p => center,
         clk_en_p => clk_en,
         value_p  => r.pwm_value,
         reset    => reset,
         clk      => clk);

   commutation_1 : commutation
      port map (
         driver_stage_p => driver_stage_p,
         hall_p         => hall_p,
         pwm_p          => pwm,
         sd_p           => r.sd,
         clk            => clk);
end behavioral;