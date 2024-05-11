onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/clk
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/reset_n
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/fftpts_in
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/inverse
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_valid
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_sop
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_eop
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_real
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_imag
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_error
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_ready
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/fftpts_out
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/sink_ready
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_error
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_sop
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_eop
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_valid
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_real
add wave -noupdate /test_program/tb/fft_ii_0_example_design_inst/core/source_imag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25906005 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 475
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {25747418 ps} {26034532 ps}
