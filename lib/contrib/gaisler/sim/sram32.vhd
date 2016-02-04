-----------------------------------------------------------------------------
-- Entity: 	sram32
-- File:	sram32.vhd
-- Author:	Jiri Gaisler Gaisler Research
-- Description:	Simulation model of generic 16-bit async SRAM
------------------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

library gaisler;
use gaisler.sim.all;
library grlib;
use grlib.stdlib.all;

entity sram32 is
  generic (
    index : integer := 0;		-- Byte lane (0 - 3)
    abits: Positive := 32;		-- Default 10 address bits (1 Kbyte)
    tacc : integer := 10;		-- access time (ns)
    fname : string := "ram.dat";	-- File to read from
    clear : integer := 0);		-- clear memory
  port (  
    a     : in  std_logic_vector(abits-1 downto 0);
    d_in  : in  std_logic_vector(31 downto 0);
    d_out : out std_logic_vector(31 downto 0);
--    d     : inout std_logic_vector(31 downto 0);
    b0    : in  std_logic;
    b1    : in  std_logic;
    b2    : in  std_logic;
    b3    : in  std_logic;
    ce    : in  std_logic;
    we    : in  std_ulogic;
    oe    : in  std_ulogic);
end;


architecture sim of sram32 is

signal cex : std_logic_vector(0 to 3);
signal d_inout: std_logic_vector(31 downto 0);

begin

  d_inout <= d_in;

  cex(0) <= ce or b0;
  cex(1) <= ce or b1;
  cex(2) <= ce or b2;
  cex(3) <= ce or b3;

  sr0 : sram generic map (index+3, abits, tacc, fname, clear)
	port map (a, d_inout(7 downto 0), cex(0), we, oe);

  sr1 : sram generic map (index+2, abits, tacc, fname, clear)
	port map (a, d_inout(15 downto 8), cex(1), we, oe);

  sr2 : sram generic map (index+1, abits, tacc, fname, clear)
	port map (a, d_inout(23 downto 16), cex(2), we, oe);

  sr3 : sram generic map (index, abits, tacc, fname, clear)
	port map (a, d_inout(31 downto 24), cex(3), we, oe);

  process (d_inout)
  begin
    if we = '0' then
      d_out <= d_inout;
    end if;
  end process;


end sim;
-- pragma translate_on
