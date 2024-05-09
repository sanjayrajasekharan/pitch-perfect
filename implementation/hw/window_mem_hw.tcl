# TCL File Generated by Component Editor 21.1
# Thu May 09 15:28:46 EDT 2024
# DO NOT MODIFY


# 
# window_mem "Window Mem" v1.0
#  2024.05.09.15:28:46
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module window_mem
# 
set_module_property DESCRIPTION ""
set_module_property NAME window_mem
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Window Mem"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL windowmem
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file windowmem.v VERILOG PATH components/memblocks/window_mem/windowmem.v
add_fileset_file windowmem_bb.v VERILOG PATH components/memblocks/window_mem/windowmem_bb.v
add_fileset_file windowmem_inst.v VERILOG PATH components/memblocks/window_mem/windowmem_inst.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point memwriter
# 
add_interface memwriter conduit end
set_interface_property memwriter associatedClock ""
set_interface_property memwriter associatedReset ""
set_interface_property memwriter ENABLED true
set_interface_property memwriter EXPORT_OF ""
set_interface_property memwriter PORT_NAME_MAP ""
set_interface_property memwriter CMSIS_SVD_VARIABLES ""
set_interface_property memwriter SVD_ADDRESS_GROUP ""

add_interface_port memwriter data data Input 16
add_interface_port memwriter wraddress addr Input 12
add_interface_port memwriter wren valid Input 1


# 
# connection point memreader
# 
add_interface memreader conduit end
set_interface_property memreader associatedClock ""
set_interface_property memreader associatedReset ""
set_interface_property memreader ENABLED true
set_interface_property memreader EXPORT_OF ""
set_interface_property memreader PORT_NAME_MAP ""
set_interface_property memreader CMSIS_SVD_VARIABLES ""
set_interface_property memreader SVD_ADDRESS_GROUP ""

add_interface_port memreader rdaddress addr Input 12
add_interface_port memreader q data Output 16


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

add_interface_port clock clock clk Input 1

