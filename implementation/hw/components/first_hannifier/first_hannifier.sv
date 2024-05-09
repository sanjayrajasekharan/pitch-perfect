/*
 * Apply Hann Windowing function to a window of samples from the input ring
 * buffer
 */

module first_hannifier(
		input logic	    clk,

		// Communicate with input_reader
		input logic [2:0]   window_start,
		input logic	    go_in,

		// Read from ring buffer
		input logic [15:0]  ring_buf_data,
		output logic [12:0] ring_buf_addr = 0, // larger than typical buffer because ringbuf holds one extra window

		// Read from Hann Window ROM
		input logic [15:0]  hann_rom_data,
		output logic [11:0] hann_rom_addr = 0,

		// Write to pre-FFT buffer
		output logic [15:0] out_buf_data = 0,
		output logic [11:0] out_buf_addr = 0,
		output logic	    out_buf_wren = 0,

		// Communicate with ffter
		output logic	    go_out = 0
	);

	logic going = 0;
	logic just_finished = 0
	
	always_ff @(posedge clk) begin
		if (!going) begin
			if (go_in) begin
				ring_buf_addr <= window_start;
				hann_rom_addr <= 0;
				out_buf_addr <= 0;
				going <= 1;
			end
		end 
		else begin
			if (!just_finished) begin
				out_buf_wren <= 1;
				out_buf_data <= ring_buf_data * hann_rom_data;
				out_buf_addr <= hann_rom_addr;
				hann_rom_addr <= hann_rom_addr + 1;
				
				if (ring_buf_addr == 4095 + 1024) begin
					ring_buf_addr <= 0;
				end
				else begin
					ring_buf_addr <= ring_buf_addr + 1;
				end

				// Need to finish one cycle later so we can write last to out buf
				if (hann_rom_addr == 4095) begin
					just_finished <= 1;
				end
			end
			else begin
				out_buf_wren <= 0;
				just_finished <= 0;
				go_out <= 1;
				going <= 0;
			end
		end
	end

endmodule
