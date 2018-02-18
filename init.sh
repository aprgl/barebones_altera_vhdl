#!/bin/bash
PROJECT_NAME=''
DEVICE=''

help(){
echo "
Barebones Quartus Project Files
Version 0.0.1 02/17/2018 
Tested on 2015 SJ Lite Edition

Usage:
------

init [-h]
init --- Build a default project named foo for the DE0 Nano Deb Board 
init -n <project name> --- Build a set of project files for DE0 Nano Dev Board
init -n <project name> -d <device> --- Build a set of project files for a specific device

Description:
------------
This is a tool used to generate the minium set of files required for a command line build environment for Altrea devices

Options:
--------

	-h | help
	-n | name of the project and top level VHDL file
	-d | Altera Device eg. EP4CE22F17C6


"
  exit 0
}

while getopts ":d:n:ha:" opt; do
  case $opt in
    n)
      PROJECT_NAME=$OPTARG
      echo "Project Name: $PROJECT_NAME" >&2
      ;;
    d)
      DEVICE=$OPTARG
      echo "Device: $OPTARG" >&2
      ;;
    h)
      help
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


if [ -z "$PROJECT_NAME" ]
then
    echo "Default project name (foo) selected">&2
    PROJECT_NAME=foo
fi

if [ -d "$PROJECT_NAME" ]
then
    echo "A project with the name "$PROJECT_NAME" already exists. Please select a different project name."
    exit 1
fi

if [ -z "$DEVICE" ]
then
    echo "Default device (Cyclone IV EP4CE22F17C6) selected">&2
    DEVICE=EP4CE22F17C6
fi

mkdir $PROJECT_NAME
mkdir $PROJECT_NAME/output_files

echo '
QUARTUS_VERSION = "15.1"
DATE = "23:59:59  December 31, 2016"
PROJECT_REVISION = '$PROJECT_NAME'' > $PROJECT_NAME/$PROJECT_NAME.qpf


echo '
# -------------------------------------------------------------------------- #
#
# Notes:
#
# 1) The default values for assignments are stored in the file:
#		virtual_jtag_assignment_defaults.qdf
#    If this file doesn not exist, see file:
#		assignment_defaults.qdf
#
# 2) Altera recommends that you do not modify this file. This
#    file is updated automatically by the Quartus Prime software
#    and any changes you make may be lost or overwritten.
#
# -------------------------------------------------------------------------- #


set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE '$DEVICE'
set_global_assignment -name TOP_LEVEL_ENTITY '$PROJECT_NAME'
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.1.1
set_global_assignment -name PROJECT_CREATION_TIME_DATE "23:59:59  DECEMBER 31, 2016"
set_global_assignment -name LAST_QUARTUS_VERSION 15.1.1
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
set_global_assignment -name VHDL_FILE '$PROJECT_NAME'.vhd
set_location_assignment PIN_A13 -to LEDS[1]
set_location_assignment PIN_A15 -to LEDS[0]' > $PROJECT_NAME/$PROJECT_NAME.qsf

echo '
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

--============================================================================
-- '$PROJECT_NAME'
--============================================================================
-- Barebones Altera Project
-- Version: 0.0.0 
------------------------------------------------------------------------------

entity '$PROJECT_NAME' is
Port (
	LEDS	: out	std_logic_vector(1 downto 0)
    );
end entity '$PROJECT_NAME';

architecture rtl of '$PROJECT_NAME' is
    -- Signals
    begin

    --=======================================================================
    --  Stateless Signals
    --=======================================================================
    LEDS <= "00";
    --------------------------------------------------------------------------

end architecture rtl;' > $PROJECT_NAME/$PROJECT_NAME.vhd

echo "quartus_cmd "$PROJECT_NAME" -c "$PROJECT_NAME""> $PROJECT_NAME/build.sh
chmod +755 $PROJECT_NAME/build.sh

echo 'quartus_pgm -m "JTAG" -o "p;output_files/'$PROJECT_NAME'.sof"'> $PROJECT_NAME/load.sh
chmod +755 $PROJECT_NAME/load.sh

