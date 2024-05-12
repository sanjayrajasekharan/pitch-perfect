/*
 * Wrapper around the Altera FFT IP block to perform the FFT on samples in one
 * buffer and send the results to another buffer
 */

module ffter(
		input logic	    clk,

		// Communicate with first_hannifier
		input logic	    go_in,

		// Read from pre_fft_buf
		input logic [15:0]  in_buf_data,
		output logic [11:0] in_buf_addr = 0,

		// Communicate with FFT IP block
		// [TODO]

		// Write to post_fft_buf_real
		output logic [15:0] real_buf_data = 0,
		output logic [11:0] real_buf_addr = 0,
		output logic        real_buf_wren = 0,

		// Write to post_fft_buf_imag
		output logic [15:0] imag_buf_data = 0,
		output logic [11:0] imag_buf_addr = 0,
		output logic        imag_buf_wren = 0,

		// Communicate with cart_to_polar
		output logic	    go_out = 0
	);

	logic going = 0;
	logic just_finished = 0;
	logic tmp = 0;
	
	always_ff @(posedge clk) begin
		if (!going) begin
			if (go_in) begin
                		go_out <= 0;
				going <= 1;
			end
		end 
		else begin
			if (!just_finished) begin
				tmp <= 1;

				// Need to finish one cycle later so we can write last to out buf
				if (tmp) begin
					just_finished <= 1;
				end
			end
			else begin // just finished
				// out_buf_wren <= 0;
				just_finished <= 0;
				go_out <= 1;
				going <= 0;
			end
		end
	end

endmodule
