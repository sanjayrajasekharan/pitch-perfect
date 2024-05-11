transcript on
if ![file isdirectory fft_sim_iputf_libs] {
	file mkdir fft_sim_iputf_libs
}

if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/tools/intel/intelFPGA/21.1/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
vlib fft_sim_iputf_libs/nco_ii_0
vmap nco_ii_0 ./fft_sim_iputf_libs/nco_ii_0
vlib fft_sim_iputf_libs/fft_ii_0
vmap fft_ii_0 ./fft_sim_iputf_libs/fft_ii_0
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 

file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0_sin.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0_cos.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi5.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi1.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr4.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr5.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr1.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi2.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi3.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr2.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi4.hex ./
file copy -force /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr3.hex ./

vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_nco_mob_rw.v"                              -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_nco_isdr.v"                                -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_nco_apr_dxx.v"                             -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_dxx_g.v"                                   -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_dxx.v"                                     -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_gal.v"                                     -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_nco_as_m_cen.v"                            -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/mentor/asj_altqmcpipe.v"                              -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0.v"                                       -work nco_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/nco.v"                                                                         
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_text_pkg.vhd"                               -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_math_pkg.vhd"                               -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_lib_pkg.vhd"                                -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_avalon_streaming_block_sink.vhd"     -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_avalon_streaming_block_source.vhd"   -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_roundsat.vhd"                               -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/apn_fft_mult_can.vhd"                          -work fft_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/apn_fft_mult_cpx_1825.v"                       -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/apn_fft_mult_cpx.vhd"                          -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/hyper_opt_OFF_pkg.vhd"                         -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/altera_fft_dual_port_ram.vhd"                  -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/altera_fft_dual_port_rom.vhd"                  -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/altera_fft_mult_add.vhd"                       -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/altera_fft_single_port_rom.vhd"                -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_fft_pkg.vhd"                               -work fft_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/hyper_pipeline_interface.v"                    -work fft_ii_0
vlog -sv "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/counter_module.sv"                             -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_lib_pkg.vhd"                  -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_bit_reverse_reverse_carry_adder.vhd" -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_bit_reverse_addr_control.vhd"        -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_bit_reverse_core.vhd"                -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_adder_fp.vhd"                 -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_addsub.vhd"                   -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_bf_control.vhd"               -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_bfi.vhd"                      -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_bfii.vhd"                     -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_cma.vhd"                      -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_cma_adder_fp.vhd"             -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_cma_bfi_fp.vhd"               -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_cma_fp.vhd"                   -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_core.vhd"                     -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_counter.vhd"                  -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_delay.vhd"                    -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_enable_control.vhd"           -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_stage.vhd"                    -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_stg_out_pipe.vhd"             -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_stg_pipe.vhd"                 -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_top.vhd"                      -work fft_ii_0
vcom     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/mentor/auk_dspip_r22sdf_twrom.vhd"                    -work fft_ii_0
vlog -sv "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0.sv"                                      -work fft_ii_0
vlog     "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/fft.v"                                                                         

vlog -vlog01compat -work work +incdir+/homes/user/stud/fall21/mhr2154/Documents/fft_sim {/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft_wrapper.v}
vlog -vlog01compat -work work +incdir+/homes/user/stud/fall21/mhr2154/Documents/fft_sim {/homes/user/stud/fall21/mhr2154/Documents/fft_sim/testbench.v}
vlog -vlog01compat -work work +incdir+/homes/user/stud/fall21/mhr2154/Documents/fft_sim {/homes/user/stud/fall21/mhr2154/Documents/fft_sim/control_for_fft.v}

