-------------------------------------------------------------------------------
-- Title      : Package for Ultrasonic transmitter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uss_tx_pkg.vhd
-- Author     : strongly-typed
-- Company    : 
-- Created    : 2012-04-13
-- Last update: 2012-04-13
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_pkg.all;
use work.motor_control_pkg.all;

package uss_tx_pkg is

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------
  component uss_tx_module
    generic (
      BASE_ADDRESS : integer range 0 to 32767);
    port (
      uss_tx0_out_p    : out half_bridge_type;
      uss_tx1_out_p    : out half_bridge_type;
      uss_tx2_out_p    : out half_bridge_type;
      modulation_p     : in  std_logic_vector(2 downto 0);
      clk_uss_enable_p : out std_logic;
      bus_o            : out busdevice_out_type;
      bus_i            : in  busdevice_in_type;
      clk              : in  std_logic);
  end component;

end uss_tx_pkg;