------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008, 2009, Aeroflex Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-----------------------------------------------------------------------------
-- Entity: 	ddr_axcelerator
-- File:	ddr_axcelerator.vhd
-- Author:	Marko Isomaki - Aeroflex Gaisler
-- Description:	DDR input and output registers
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library axcelerator;
library techmap;
use techmap.axcomp.all;

entity axcel_oddr_reg is
  port(
    Q : out std_ulogic;
    C1 : in std_ulogic;
    C2 : in std_ulogic;
    CE : in std_ulogic;
    D1 : in std_ulogic;
    D2 : in std_ulogic;
    R : in std_ulogic;
    S : in std_ulogic);
end entity;

architecture rtl of axcel_oddr_reg is
begin
  ddr_out0 : ddr_out
    port map(
      dr  => d1,
      df  => d2,
      e   => ce,
      clk => c1,
      pre => s,
      clr => r,
      q   => q);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
-- pragma translate_off
library axcelerator;
use axcelerator.ddr_reg;
-- pragma translate_on

entity axcel_iddr_reg is
  port(
    Q1 : out std_ulogic;
    Q2 : out std_ulogic;
    C1 : in std_ulogic;
    C2 : in std_ulogic;
    CE : in std_ulogic;
    D  : in std_ulogic;
    R  : in std_ulogic;
    S  : in std_ulogic);
end entity;

architecture rtl of axcel_iddr_reg is
  component ddr_reg is
  port(
    d   : in std_logic;
    e   : in std_logic;
    clk : in std_logic;
    clr : in std_logic;
    pre : in std_logic;
    qr  : out std_logic;
    qf  : out std_logic);
  end component ddr_reg ;

  signal e_i    : std_ulogic;
  signal clr_i  : std_ulogic;
  signal pre_i  : std_ulogic;
  signal pre_q2 : std_ulogic;
begin
  e_i   <= not ce;
  clr_i <= not r;
  pre_i <= not s;
  
  ddrin0 : ddr_reg
    port map(
      d   => d,
      e   => e_i,
      clk => c1,
      clr => clr_i,
      pre => pre_i,
      qr  => q1,
      qf  => pre_q2
      );

  q2_p : process(c1, clr_i, pre_q2)
  begin
    if clr_i = '0' then
      q2 <= '0';
    elsif rising_edge(c1) then
      q2 <= pre_q2;
    end if;
  end process;
end architecture;
