
# Name of the testbench without extenstion
#TESTBENCH = encoder_module_tb
#TESTBENCH = quadrature_decoder_tb
#TESTBENCH = input_capture_tb
TESTBENCH = hall_sensor_decoder_tb

# VHDL files
ifeq ($(TESTBENCH), encoder_module_tb)
FILES = ../../hdl/*.vhd \
	../../hdl/motor_control_pkg.vhd \
	../../hdl/bus_pkg.vhd
GHDL_SIM_OPT = --stop-time=2us
else ifeq ($(TESTBENCH), quadrature_decoder_tb)
FILES = ../../hdl/*.vhd \
	../../hdl/bus_pkg.vhd 
GHDL_SIM_OPT = --stop-time=2us
else ifeq ($(TESTBENCH), hall_sensor_decoder_tb)
FILES = ../../hdl/hall_sensor_decoder.vhd \
	../../hdl/motor_control_pkg.vhd \
	../../hdl/bus_pkg.vhd
GHDL_SIM_OPT = --stop-time=2us
else  ifeq ($(TESTBENCH), input_capture_tb)
FILES = ../../hdl/input_capture.vhd
GHDL_SIM_OPT = --stop-time=3ms
endif

# Default settings for gtkwave (visable signal etc.)
#  use gtkwave > File > Write Save File (Strg + S) to generate the file
WAVEFORM_SETTINGS = $(TESTBENCH).sav

# Load default options for GHDL.
# Defines make [all|compile|run|view|clean]
include makefile.ghdl.mk

