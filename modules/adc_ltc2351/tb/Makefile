
# Name of the testbench without extenstion
TESTBENCH = adc_ltc2351_tb
#TESTBENCH = adc_ltc2351_module_tb
#TESTBENCH = adc_ltc2351_model_tb
#TESTBENCH = adc_ltc2351_2_tb

# VHDL files
ifeq ($(TESTBENCH), adc_ltc2351_tb)
FILES = \
../../hdl/bus_pkg.vhd \
../../hdl/adc_ltc2351.vhd \
../../hdl/adc_ltc2351_pkg.vhd 
else ifeq ($(TESTBENCH), adc_ltc2351_model_tb)
FILES = \
../../hdl/bus_pkg.vhd \
../../hdl/adc_ltc2351_model.vhd \
../../hdl/adc_ltc2351_pkg.vhd
else ifeq ($(TESTBENCH), adc_ltc2351_module_tb)
FILES = \
../../hdl/bus_pkg.vhd \
../../hdl/reg_file_pkg.vhd \
../../hdl/reg_file.vhd \
../../hdl/adc_ltc2351.vhd \
../../hdl/adc_ltc2351_pkg.vhd \
../../hdl/adc_ltc2351_model.vhd \
../../hdl/adc_ltc2351_module.vhd \
../peripheral_register/reg_file_tb.vhd 
endif

# Default settings for gtkwave (visable signal etc.)
#  use gtkwave > File > Write Save File (Strg + S) to generate the file
WAVEFORM_SETTINGS = $(TESTBENCH).sav

# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=10us

# Load default options for GHDL.
# Defines make [all|compile|run|view|clean]
include makefile.ghdl.mk

