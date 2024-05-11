
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0_sin.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0_cos.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi5.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi1.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr4.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr5.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr1.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi2.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi3.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr2.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twi4.hex ./
cp -f /homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0_opt_twr3.hex ./

vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_nco_mob_rw.v"                              -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_nco_isdr.v"                                -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_nco_apr_dxx.v"                             -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_dxx_g.v"                                   -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_dxx.v"                                     -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_gal.v"                                     -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_nco_as_m_cen.v"                            -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/synopsys/asj_altqmcpipe.v"                              -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/submodules/nco_nco_ii_0.v"                                         -work nco_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/nco/simulation/nco.v"                                                                           
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_text_pkg.vhd"                                 -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_math_pkg.vhd"                                 -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_lib_pkg.vhd"                                  -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_avalon_streaming_block_sink.vhd"     -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_avalon_streaming_block_source.vhd"   -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/auk_dspip_roundsat.vhd"                                 -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/apn_fft_mult_can.vhd"                          -work fft_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/apn_fft_mult_cpx_1825.v"                       -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/apn_fft_mult_cpx.vhd"                          -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/hyper_opt_OFF_pkg.vhd"                         -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/altera_fft_dual_port_ram.vhd"                  -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/altera_fft_dual_port_rom.vhd"                  -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/altera_fft_mult_add.vhd"                       -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/altera_fft_single_port_rom.vhd"                -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_fft_pkg.vhd"                               -work fft_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/hyper_pipeline_interface.v"                    -work fft_ii_0
vlogan +v2k -sverilog "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/counter_module.sv"                             -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_lib_pkg.vhd"                  -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_bit_reverse_reverse_carry_adder.vhd" -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_bit_reverse_addr_control.vhd"        -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_bit_reverse_core.vhd"                -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_adder_fp.vhd"                 -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_addsub.vhd"                   -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_bf_control.vhd"               -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_bfi.vhd"                      -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_bfii.vhd"                     -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_cma.vhd"                      -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_cma_adder_fp.vhd"             -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_cma_bfi_fp.vhd"               -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_cma_fp.vhd"                   -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_core.vhd"                     -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_counter.vhd"                  -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_delay.vhd"                    -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_enable_control.vhd"           -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_stage.vhd"                    -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_stg_out_pipe.vhd"             -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_stg_pipe.vhd"                 -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_top.vhd"                      -work fft_ii_0
vhdlan -xlrm          "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/synopsys/auk_dspip_r22sdf_twrom.vhd"                    -work fft_ii_0
vlogan +v2k -sverilog "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/submodules/fft_fft_ii_0.sv"                                        -work fft_ii_0
vlogan +v2k           "/homes/user/stud/fall21/mhr2154/Documents/fft_sim/fft/simulation/fft.v"                                                                           
