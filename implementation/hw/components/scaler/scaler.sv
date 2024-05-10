/*
 * Component which performs pitch scaling
 */

module scaler(
		input logic	    clk,

		// Communicate with cart_to_polar
		input logic	    go_in,
        	input logic	    cur_window,

		// Communicate with software_interface
		input logic [7:0]   shift_amt,

		// Read from pre_scaler_mag_buf_0
		input logic [15:0]  mag_in_buf_0_data,
		output logic [11:0] mag_in_buf_0_addr = 0,

		// Read from pre_scaler_phase_buf_0
		input logic [15:0]  phase_in_buf_0_data,
		output logic [11:0] phase_in_buf_0_addr = 0,

		// Read from pre_scaler_mag_buf_1
		input logic [15:0]  mag_in_buf_1_data,
		output logic [11:0] mag_in_buf_1_addr = 0,

		// Read from pre_scaler_phase_buf_1
		input logic [15:0]  phase_in_buf_1_data,
		output logic [11:0] phase_in_buf_1_addr = 0,

		// Read from and write to post_scaler_mag_buf_0
		input logic [15:0]  mag_out_buf_0_rdata,
		output logic [11:0] mag_out_buf_0_raddr = 0,
		output logic [15:0] mag_out_buf_0_wrdata = 0,
		output logic [11:0] mag_out_buf_0_wraddr = 0,
		output logic        mag_out_buf_0_wren = 0,

		// Read from and write to post_scaler_mag_buf_0
		input logic [15:0]  phase_out_buf_0_rdata,
		output logic [11:0] phase_out_buf_0_raddr = 0,
		output logic [15:0] phase_out_buf_0_wrdata = 0,
		output logic [11:0] phase_out_buf_0_wraddr = 0,
		output logic        phase_out_buf_0_wren = 0,

		// Read from and write to post_scaler_mag_buf_1
		input logic [15:0]  mag_out_buf_1_rdata,
		output logic [11:0] mag_out_buf_1_raddr = 0,
		output logic [15:0] mag_out_buf_1_wrdata = 0,
		output logic [11:0] mag_out_buf_1_wraddr = 0,
		output logic        mag_out_buf_1_wren = 0,

		// Read from and write to post_scaler_mag_buf_1
		input logic [15:0]  phase_out_buf_1_rdata,
		output logic [11:0] phase_out_buf_1_raddr = 0,
		output logic [15:0] phase_out_buf_1_wrdata = 0,
		output logic [11:0] phase_out_buf_1_wraddr = 0,
		output logic        phase_out_buf_1_wren = 0,

		// Communicate with polar_to_cart
		output logic        cur_buf = 0,
		output logic	    go_out = 0
	);

	function automatic signed [23:0] fixed_point_modulus(
        input signed [23:0] a,  
        input signed [23:0] b 
    );
        signed [47:0] scaled_a = a;            
        signed [47:0] scaled_b = b;       
        signed [23:0] mod_result = scaled_a % scaled_b;

        if (mod_result < 0) begin
            mod_result += scaled_b;
        end

        return mod_result;  // Return the result in Q1.15 format
    endfunction

	function automatic signed [23:0] wrap_phase(
		input signed [23:0] phase_in
	);

	signed [23:0] pi = 24'h0324;
	signed [23:0] two_pi = 24'h0648;
	signed [23:0] neg_two_pi = 24'f9b8;
	

	if (phase_in > 0) begin
		return fixed_point_modulus(phase_in + pi, two_pi) - pi;
	end else begin
		return fixed_point_modulus(phase_in - pi, neg_two_pi) + pi;
	end
	endfunction


	logic going = 0;
	logic just_finished = 0;
	logic tmp = 0;

	logic [0:9] i = 0;

	logic signed [23:0] d_phase;
	logic signed [23:0] expected_d_phase = 24'b0;
	logic signed [23:0] d_phase_from_expected;

	logic signed [23:0] bin_dev;

	logic signed [23:0] new_bin;
	logic [10:0] new_bin_num;




	logic signed [23:0] expected_d_phase_increment = 24'h000192; // pi/2
	logic signed [23:0] bin_dev_multiplier = 24'h0000a3; // 2/pi
	
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

				if (curr_window == 0) d_phase <= wrap_phase(phase_in_buf_0_data, phase_in_buf_1_data)
				else d_phase <= wrap_phase(phase_in_buf_1_data, phase_in_buf_0_data)

				d_phase_from_expected <= d_phase - expected_d_phase;
				bin_dev <= wrap_phase(d_phase_from_expected) * bin_dev_multiplier;



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
