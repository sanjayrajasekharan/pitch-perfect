/*
 * Wrapper around the Altera FFT IP block to perform the IFFT on samples in one
 * buffer and send the results to another buffer
 */

module ffter(
		input logic	    clk,

		// Communicate with first_hannifier
		input logic	    go_in,

		// Read from pre_ifft_real_buf
		input logic [15:0]  real_buf_data,
		output logic [11:0] real_buf_addr = 0,

        // Read from pre_ifft_imag_buf
		input logic [15:0]  imag_buf_data,
		output logic [11:0] imag_buf_addr = 0,

		// Communicate with IFFT IP block
		// [TODO]

		// Write to post_ifft_buf
		output logic [15:0] out_buf_data = 0,
		output logic [11:0] out_buf_addr = 0,
		output logic        out_buf_wren = 0,

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
