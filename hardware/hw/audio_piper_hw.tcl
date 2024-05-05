# TCL File Generated by Component Editor 21.1
# Sun May 05 16:46:17 EDT 2024
# DO NOT MODIFY


# 
# audio_piper "Audio Piper" v1.0
#  2024.05.05.16:46:17
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module audio_piper
# 
set_module_property DESCRIPTION ""
set_module_property NAME audio_piper
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Audio Piper"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL audio_piper
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file audio_piper.sv SYSTEM_VERILOG PATH audio_piper.sv TOP_LEVEL_FILE


# 
# parameters
# 


# 
# module assignments
# 
set_module_assignment embeddedsw.dts.group piper
set_module_assignment embeddedsw.dts.name audio_piper
set_module_assignment embeddedsw.dts.vendor csee4840


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
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point left_out
# 
add_interface left_out avalon_streaming start
set_interface_property left_out associatedClock clock
set_interface_property left_out associatedReset reset
set_interface_property left_out dataBitsPerSymbol 8
set_interface_property left_out errorDescriptor ""
set_interface_property left_out firstSymbolInHighOrderBits true
set_interface_property left_out maxChannel 0
set_interface_property left_out readyLatency 0
set_interface_property left_out ENABLED true
set_interface_property left_out EXPORT_OF ""
set_interface_property left_out PORT_NAME_MAP ""
set_interface_property left_out CMSIS_SVD_VARIABLES ""
set_interface_property left_out SVD_ADDRESS_GROUP ""

add_interface_port left_out left_out_data data Output 16
add_interface_port left_out left_out_ready ready Input 1
add_interface_port left_out left_out_valid valid Output 1


# 
# connection point right_out
# 
add_interface right_out avalon_streaming start
set_interface_property right_out associatedClock clock
set_interface_property right_out associatedReset reset
set_interface_property right_out dataBitsPerSymbol 8
set_interface_property right_out errorDescriptor ""
set_interface_property right_out firstSymbolInHighOrderBits true
set_interface_property right_out maxChannel 0
set_interface_property right_out readyLatency 0
set_interface_property right_out ENABLED true
set_interface_property right_out EXPORT_OF ""
set_interface_property right_out PORT_NAME_MAP ""
set_interface_property right_out CMSIS_SVD_VARIABLES ""
set_interface_property right_out SVD_ADDRESS_GROUP ""

add_interface_port right_out right_out_data data Output 16
add_interface_port right_out right_out_ready ready Input 1
add_interface_port right_out right_out_valid valid Output 1


# 
# connection point left_in
# 
add_interface left_in avalon_streaming end
set_interface_property left_in associatedClock clock
set_interface_property left_in associatedReset reset
set_interface_property left_in dataBitsPerSymbol 8
set_interface_property left_in errorDescriptor ""
set_interface_property left_in firstSymbolInHighOrderBits true
set_interface_property left_in maxChannel 0
set_interface_property left_in readyLatency 0
set_interface_property left_in ENABLED true
set_interface_property left_in EXPORT_OF ""
set_interface_property left_in PORT_NAME_MAP ""
set_interface_property left_in CMSIS_SVD_VARIABLES ""
set_interface_property left_in SVD_ADDRESS_GROUP ""

add_interface_port left_in left_in_data data Input 16
add_interface_port left_in left_in_ready ready Output 1
add_interface_port left_in left_in_valid valid Input 1


# 
# connection point right_in
# 
add_interface right_in avalon_streaming end
set_interface_property right_in associatedClock clock
set_interface_property right_in associatedReset reset
set_interface_property right_in dataBitsPerSymbol 8
set_interface_property right_in errorDescriptor ""
set_interface_property right_in firstSymbolInHighOrderBits true
set_interface_property right_in maxChannel 0
set_interface_property right_in readyLatency 0
set_interface_property right_in ENABLED true
set_interface_property right_in EXPORT_OF ""
set_interface_property right_in PORT_NAME_MAP ""
set_interface_property right_in CMSIS_SVD_VARIABLES ""
set_interface_property right_in SVD_ADDRESS_GROUP ""

add_interface_port right_in right_in_data data Input 16
add_interface_port right_in right_in_ready ready Output 1
add_interface_port right_in right_in_valid valid Input 1

