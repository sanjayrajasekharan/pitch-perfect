/*
 * Convert the imaginary coordinates from the FFT to polar coordinates
 */

module cart_to_polar(
		input logic	    clk,

		// Communicate with ffter
		input logic	    go_in,

		// Read from post_fft_buf_real
		input logic [15:0]  real_buf_data,
		output logic [12:0] real_buf_addr = 0,

		// Read from post_fft_buf_imag
		input logic [15:0]  imag_buf_data,
		output logic [12:0] imag_buf_addr = 0,

		// Write to scaler_mag_buf_0
		output logic [15:0] mag_buf_0_data = 0,
		output logic [11:0] mag_buf_0_addr = 0,
		output logic        mag_buf_0_wren = 0,

		// Write to scaler_phase_buf_0
		output logic [15:0] phase_buf_0_data = 0,
		output logic [11:0] phase_buf_0_addr = 0,
		output logic        phase_buf_0_wren = 0,

		// Write to scaler_mag_buf_1
		output logic [15:0] mag_buf_1_data = 0,
		output logic [11:0] mag_buf_1_addr = 0,
		output logic        mag_buf_1_wren = 0,

		// Write to scaler_phase_buf_1
		output logic [15:0] phase_buf_1_data = 0,
		output logic [11:0] phase_buf_1_addr = 0,
		output logic        phase_buf_1_wren = 0,

		// Communicate with scaler
		output logic        cur_buf = 0,
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
