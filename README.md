# barebones_altera_vhdl
Barebones VHDL project files for Altera without the GUI.

# Useage
## init.sh
Creates a directory structure and required Quartus project files.

foo (Project Folder)
foo.qpf (Quartus Project File)
foo.qsf (Quartus Settings File)
foo.vhd (Top Level VHDL File)
build.sh (Calls quartus_cmd with the project) - Needs Quartus bin in PATH
load.sh (Calls quartus_pgm with JTAG program options and the nonvolatile foo.sof from output_files)
output_files (Directory where Quartus drops some of the many files it generates)

# ToDo
This is a hack-n-slash first pass - it needs a lot of love to be super useful. Also the pin assignments are just dropped into the .qsf, currently only showing my two test LEDs.

