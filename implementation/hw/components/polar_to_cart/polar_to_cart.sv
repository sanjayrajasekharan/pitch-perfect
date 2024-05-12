/*
 * Convert the polar coordinates from the scaler to imaginary coordinates
 */

module polar_to_cart(
		input logic	    clk,

		// Communicate with scaler
		input logic	    go_in,
        	input logic	    cur_window,

		// Read from scaler_mag_buf_0
		input logic [15:0]  mag_buf_0_data,
		output logic [11:0] mag_buf_0_addr = 0,

		// Read from scaler_phase_buf_0
		input logic [15:0]  phase_buf_0_data,
		output logic [11:0] phase_buf_0_addr = 0,

		// Read from scaler_mag_buf_1
		input logic [15:0]  mag_buf_1_data,
		output logic [11:0] mag_buf_1_addr = 0,

		// Read from scaler_phase_buf_1
		input logic [15:0]  phase_buf_1_data,
		output logic [11:0] phase_buf_1_addr = 0,

		// Write to pre_ifft_real_buf
		output logic [15:0] real_buf_data,
		output logic [11:0] real_buf_addr = 0,
		output logic        real_buf_wren = 0,

		// Write to pre_ifft_imag_buf
		output logic [15:0] imag_buf_data,
		output logic [11:0] imag_buf_addr = 0,
		output logic        imag_buf_wren = 0,

		// Communicate with iffter
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
