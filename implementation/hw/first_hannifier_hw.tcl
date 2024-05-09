# TCL File Generated by Component Editor 21.1
# Thu May 09 15:28:15 EDT 2024
# DO NOT MODIFY


# 
# first_hannifier "First Hannifier" v1.0
#  2024.05.09.15:28:15
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module first_hannifier
# 
set_module_property DESCRIPTION ""
set_module_property NAME first_hannifier
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "First Hannifier"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL first_hannifier
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file first_hannifier.sv SYSTEM_VERILOG PATH components/first_hannifier/first_hannifier.sv TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point sampler_to_first_hannifier
# 
add_interface sampler_to_first_hannifier conduit end
set_interface_property sampler_to_first_hannifier associatedClock ""
set_interface_property sampler_to_first_hannifier associatedReset ""
set_interface_property sampler_to_first_hannifier ENABLED true
set_interface_property sampler_to_first_hannifier EXPORT_OF ""
set_interface_property sampler_to_first_hannifier PORT_NAME_MAP ""
set_interface_property sampler_to_first_hannifier CMSIS_SVD_VARIABLES ""
set_interface_property sampler_to_first_hannifier SVD_ADDRESS_GROUP ""

add_interface_port sampler_to_first_hannifier window_start data Input 3
add_interface_port sampler_to_first_hannifier go_in valid Input 1


# 
# connection point first_hannifier_to_ffter
# 
add_interface first_hannifier_to_ffter conduit end
set_interface_property first_hannifier_to_ffter associatedClock ""
set_interface_property first_hannifier_to_ffter associatedReset ""
set_interface_property first_hannifier_to_ffter ENABLED true
set_interface_property first_hannifier_to_ffter EXPORT_OF ""
set_interface_property first_hannifier_to_ffter PORT_NAME_MAP ""
set_interface_property first_hannifier_to_ffter CMSIS_SVD_VARIABLES ""
set_interface_property first_hannifier_to_ffter SVD_ADDRESS_GROUP ""

add_interface_port first_hannifier_to_ffter go_out data Output 1


# 
# connection point hann_rom_reader
# 
add_interface hann_rom_reader conduit end
set_interface_property hann_rom_reader associatedClock ""
set_interface_property hann_rom_reader associatedReset ""
set_interface_property hann_rom_reader ENABLED true
set_interface_property hann_rom_reader EXPORT_OF ""
set_interface_property hann_rom_reader PORT_NAME_MAP ""
set_interface_property hann_rom_reader CMSIS_SVD_VARIABLES ""
set_interface_property hann_rom_reader SVD_ADDRESS_GROUP ""

add_interface_port hann_rom_reader hann_rom_data data Input 16
add_interface_port hann_rom_reader hann_rom_addr addr Output 12


# 
# connection point ring_buf_reader
# 
add_interface ring_buf_reader conduit end
set_interface_property ring_buf_reader associatedClock ""
set_interface_property ring_buf_reader associatedReset ""
set_interface_property ring_buf_reader ENABLED true
set_interface_property ring_buf_reader EXPORT_OF ""
set_interface_property ring_buf_reader PORT_NAME_MAP ""
set_interface_property ring_buf_reader CMSIS_SVD_VARIABLES ""
set_interface_property ring_buf_reader SVD_ADDRESS_GROUP ""

add_interface_port ring_buf_reader ring_buf_addr addr Output 13
add_interface_port ring_buf_reader ring_buf_data data Input 16


# 
# connection point pre_fft_buf_writer
# 
add_interface pre_fft_buf_writer conduit end
set_interface_property pre_fft_buf_writer associatedClock ""
set_interface_property pre_fft_buf_writer associatedReset ""
set_interface_property pre_fft_buf_writer ENABLED true
set_interface_property pre_fft_buf_writer EXPORT_OF ""
set_interface_property pre_fft_buf_writer PORT_NAME_MAP ""
set_interface_property pre_fft_buf_writer CMSIS_SVD_VARIABLES ""
set_interface_property pre_fft_buf_writer SVD_ADDRESS_GROUP ""

add_interface_port pre_fft_buf_writer out_buf_addr addr Output 12
add_interface_port pre_fft_buf_writer out_buf_data data Output 16
add_interface_port pre_fft_buf_writer out_buf_wren valid Output 1

