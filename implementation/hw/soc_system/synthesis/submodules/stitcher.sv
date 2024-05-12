/*
 * Apply Hann Windowing function to a window of samples and insert them to the
 * output buffer
 */

module stitcher(
		input logic	    clk,

		// Communicate with iffter
		input logic	    go_in,

		// Read from post_ifft_buf
		input logic [15:0]  in_buf_data,
		output logic [11:0] in_buf_addr = 0,

		// Read from Hann Window ROM
		input logic [15:0]  hann_rom_data,
		output logic [11:0] hann_rom_addr = 0,

		// Write to stitched_buf
		output logic [15:0] out_buf_data = 0,
		output logic [11:0] out_buf_addr = 0,
		output logic	    out_buf_wren = 0,

		// Communicate with emitter
		output logic [1:0]  window_start = 0,
		output logic	    go_out = 0
	);

	
	always_ff @(posedge clk) begin
		window_start = 1;
	end
endmodule
