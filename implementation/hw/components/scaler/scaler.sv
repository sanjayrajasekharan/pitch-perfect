/*
 * Component which performs pitch scaling
 */

module scaler(
		input logic	    clk,

		// Communicate with cart_to_polar
		input logic	    go_in,
		input logic	    cur_window,

		// Communicate with software_interface
		input logic [15:0]  scale_amt,

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
		output logic	mag_out_buf_0_wren = 0,

		// Read from and write to post_scaler_phase_buf_0
		input logic [15:0]  phase_out_buf_0_rdata,
		output logic [11:0] phase_out_buf_0_raddr = 0,
		output logic [15:0] phase_out_buf_0_wrdata = 0,
		output logic [11:0] phase_out_buf_0_wraddr = 0,
		output logic	phase_out_buf_0_wren = 0,

		// Read from and write to post_scaler_mag_buf_1
		input logic [15:0]  mag_out_buf_1_rdata,
		output logic [11:0] mag_out_buf_1_raddr = 0,
		output logic [15:0] mag_out_buf_1_wrdata = 0,
		output logic [11:0] mag_out_buf_1_wraddr = 0,
		output logic	mag_out_buf_1_wren = 0,

		// Read from and write to post_scaler_phase_buf_1
		input logic [15:0]  phase_out_buf_1_rdata,
		output logic [11:0] phase_out_buf_1_raddr = 0,
		output logic [15:0] phase_out_buf_1_wrdata = 0,
		output logic [11:0] phase_out_buf_1_wraddr = 0,
		output logic	phase_out_buf_1_wren = 0,

		// Read from and write to scaler_synth_mags_buf
		input logic [15:0]  synth_mags_rdata,
		output logic [11:0] synth_mags_raddr = 0,
		output logic [15:0] synth_mags_wrdata = 0,
		output logic [11:0] synth_mags_wraddr = 0,
		output logic	synth_mags_wren = 0,

		// Read from and write to scaler_synth_devs_buf
		input logic [15:0]  synth_devs_rdata,
		output logic [11:0] synth_devs_raddr = 0,
		output logic [15:0] synth_devs_wrdata = 0,
		output logic [11:0] synth_devs_wraddr = 0,
		output logic	synth_devs_wren = 0,

		// Communicate with polar_to_cart
		output logic	cur_buf = 0,
		output logic	go_out = 0
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

	function automatic signed [15:0] fp_mult(
		input signed [15:0] m1,
		input signed [15:0] m2
	);
		signed [31:0] big;

		big = m1 * m2;
		return big >> 16;
	endfunction

	logic going = 0;
	enum logic [2:0] {awaiting, analysis, synthesis, just_finished} state = awaiting;
	logic anal_read = 0;

	logic cur_buf_num;

	logic [9:0] i = 0;

	logic signed [23:0] d_phase;
	logic signed [23:0] expected_d_phase = 24'b0;
	logic signed [23:0] d_phase_from_expected;

	logic signed [23:0] bin_dev;

	logic signed [23:0] new_bin;
	logic [10:0] new_bin_num;




	logic signed [23:0] expected_d_phase_increment = 24'h000192; // pi/2
	logic signed [23:0] bin_dev_multiplier = 24'h0000a3; // 2/pi

	always_comb begin

		// Decide which of the two buffers represents current data, and which is previous
		if (!cur_buf_num) begin
			mag_prev = mag_in_buf_1_data;
			mag_new = mag_in_buf_0_data;
			phase_prev = phase_in_buf_1_data;
			phase_new = phase_in_buf_0_data;
			mag_out_prev = mag_out_buf_1_rdata;
			mag_out_new = mag_out_buf_0_rdata;
			phase_out_prev = phase_out_buf_1_rdata;
			phase_out_new = phase_out_buf_0_rdata;
			mag_prev_addr = mag_in_buf_1_addr;
			mag_new_addr = mag_in_buf_0_addr;
			phase_prev_addr = phase_in_buf_1_addr;
			phase_new_addr = phase_in_buf_0_addr;
			mag_out_prev_addr = mag_out_buf_1_raddr;
			mag_out_new_addr = mag_out_buf_0_raddr;
			phase_out_prev_addr = phase_out_buf_1_raddr;	
			phase_out_new_addr = phase_out_buf_0_raddr;
		end
		else begin
			// Pick the opposites of above
		end

	end
	
	always_ff @(posedge clk) begin
		case (state)
		awaiting: begin
			if (go_in) begin
				go_out <= 0;
				cur_buf_num <= cur_window; // gets set at go, stays for full run
				state <= analysis;
				anal_read <= 1;
			end
		end

		analysis: begin
			if (anal_read) begin // do in two phases because we need to read old data from memory, then add to it
				d_phase = wrap_phase(phase_new - phase_prev)
				d_phase_from_expected <= d_phase - expected_d_phase;
				bin_dev = wrap_phase(d_phase_from_expected) * bin_dev_multiplier;

				new_bin = fp_mult(i + binDeviation, scale_amt); // TODO: needs to only be 12 bits unsigned, 0 to 4095
				new_bin_num = new_bin[7] ? (new_bin >> 8) << 8;
				if (new_bin[7]) new_bin_num = new_bin_num + 1;
				new_bin_dev = new_bin - new_bin_num;

				synth_mags_raddr = new_bin;
				synth_devs_raddr = new_bin;
				synth_mags_wren = 0;
				synth_devs_wren = 0;
			end
			else begin
				synth_mags_wrdata <= synth_mags_rdata + mag_new;
				synth_devs_wrdata <= synth_devs_rdata + new_bin_dev;

				i <= (i == 4095) ? 0 : i + 1;
				expected_d_phase <= expected_d_phase + expected_d_phase_increment;

				if (i == 4095) begin
					state <= synthesis;
					expected_d_phase <= 0;
				end
			end
		end

		synthesis: begin

			// Remember to clear the synth_x_data for the next cycle

		end

		just_finished: begin
			// Might be able to just put this in the end of the synthesis step
			go_out <= 1;
			state <= awaiting;
			i <= 0;
		end
		endcase
	end

endmodule
