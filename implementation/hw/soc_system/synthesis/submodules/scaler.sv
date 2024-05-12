/*
 * Component which performs pitch scaling
 */

module scaler(
		input logic	    clk,

		// Communicate with cart_to_polar
		input logic	    go_in,
		input logic	    cur_window,

		// Communicate with software_interface
		input logic [7:0]  scale_amt,

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

	logic going = 0;
	enum logic [2:0] {awaiting, analysis, synthesis, just_finished} state = awaiting;
	logic anal_read = 1;
	logic cur_buf_num;

	logic [15:0] mag_in_data;
	logic [15:0] mag_in_prev_data;
	logic [15:0] phase_in_data;
	logic [15:0] phase_in_prev_data;
	logic [11:0] mag_in_addr;
	logic [11:0] phase_in_addr;
	logic [15:0] mag_out_rdata;
	logic [15:0] mag_out_prev_rdata;
	logic [11:0] mag_out_raddr;
	logic [15:0] mag_out_wrdata;
	logic [11:0] mag_out_wraddr;
	logic        mag_out_wren;
	logic [15:0] phase_out_rdata;
	logic [15:0] phase_out_prev_rdata;
	logic [11:0] phase_out_raddr;
	logic [11:0] phase_out_prev_raddr;
	logic [15:0] phase_out_wrdata;
	logic [11:0] phase_out_wraddr;
	logic        phase_out_wren;

	logic [11:0] i = 0;
	logic signed [15:0] d_phase;
	logic signed [15:0] expected_d_phase = 0;
	logic signed [15:0] d_phase_from_expected;
	logic signed [15:0] bin_dev;
	logic signed [15:0] new_bin_dev;
	logic signed [15:0] fractional_bin;
	logic signed [31:0] extended_mult;
	logic signed [15:0] new_bin;
	logic signed [15:0] new_bin_num;

	logic signed [15:0] expected_d_phase_increment = 16'h192; // pi/2
	logic signed [15:0] bin_dev_multiplier = 16'h0a3; // 2/pi
	logic signed [15:0] pi = 16'h324;
	logic signed [15:0] two_pi = 16'h648;
	logic signed [15:0] neg_pi = 16'h9b8;

	always_comb begin

		mag_in_data = cur_buf_num ? mag_in_buf_1_data : mag_in_buf_0_data;
		mag_in_prev_data = cur_buf_num ? mag_in_buf_0_data : mag_in_buf_1_data;
		mag_in_buf_0_addr = mag_in_addr;
		mag_in_buf_1_addr = mag_in_addr;

		phase_in_data = cur_buf_num ? phase_in_buf_1_data : phase_in_buf_0_data;
		phase_in_prev_data = cur_buf_num ? phase_in_buf_0_data : phase_in_buf_1_data;
		phase_in_buf_0_addr = phase_in_addr;
		phase_in_buf_1_addr = phase_in_addr;

		mag_out_rdata = cur_buf_num ? mag_out_buf_1_rdata : mag_out_buf_0_rdata;
		mag_out_prev_rdata = cur_buf_num ? mag_out_buf_0_rdata : mag_out_buf_1_rdata;
		mag_out_buf_0_raddr = mag_out_raddr;
		mag_out_buf_1_raddr = mag_out_raddr;
		mag_out_buf_0_wraddr = mag_out_wraddr;
		mag_out_buf_1_wraddr = mag_out_wraddr;
		mag_out_buf_0_wrdata = mag_out_wrdata;
		mag_out_buf_1_wrdata = mag_out_wrdata;
		mag_out_buf_0_wren = mag_out_wren && !cur_buf_num;
		mag_out_buf_1_wren = mag_out_wren && cur_buf_num;

		phase_out_rdata = cur_buf_num ? phase_out_buf_1_rdata : phase_out_buf_0_rdata;
		phase_out_prev_rdata = cur_buf_num ? phase_out_buf_0_rdata : phase_out_buf_1_rdata;
		phase_out_buf_0_raddr = phase_out_raddr;
		phase_out_buf_1_raddr = phase_out_raddr;
		phase_out_buf_0_wraddr = phase_out_wraddr;
		phase_out_buf_1_wraddr = phase_out_wraddr;
		phase_out_buf_0_wrdata = phase_out_wrdata;
		phase_out_buf_1_wrdata = phase_out_wrdata;
		phase_out_buf_0_wren = phase_out_wren && !cur_buf_num;
		phase_out_buf_1_wren = phase_out_wren && cur_buf_num;

	end
	
	always_ff @(posedge clk) begin
		case (state)
		awaiting: begin
			if (go_in) begin
				go_out <= 0;
				cur_buf_num <= cur_window; // gets set at go, stays for full run
				state <= analysis;
				expected_d_phase <= 0;
				anal_read <= 1;
			end
		end

		analysis: begin
			if (anal_read) begin // do in two phases because we need to read old data from memory, then add to it
				d_phase = phase_in_data - phase_in_prev_data;
				if (d_phase < 0) d_phase = d_phase + two_pi; // wrap from 0 to 2pi
				d_phase_from_expected = d_phase - expected_d_phase;
				if (d_phase_from_expected < neg_pi) d_phase_from_expected = d_phase_from_expected + two_pi; // wrap from -pi to pi
				bin_dev = d_phase_from_expected * bin_dev_multiplier;
				fractional_bin = (i << 8) + bin_dev;
				extended_mult = fractional_bin * scale_amt;
				if (extended_mult > (2047 << 16)) // above Nyquist frequency
					new_bin = 0;
				else
					new_bin = extended_mult >> 16;
				new_bin_num = (new_bin >> 8) << 8;
				if (new_bin[7]) new_bin_num = new_bin_num + (2 ** 8); // if most significant fractional bit is 1, round up
				new_bin_dev = new_bin - new_bin_num;

				synth_mags_raddr = new_bin_num >> 8;
				synth_devs_raddr = new_bin_num >> 8;
				synth_mags_wren = 0;
				synth_devs_wren = 0;
				anal_read = 0;
			end
			else begin
				synth_mags_wrdata <= synth_mags_rdata + mag_in_data;
				synth_devs_wrdata <= synth_devs_rdata + new_bin_dev;
				synth_mags_wraddr <= new_bin_num >> 8;
				synth_devs_wraddr <= new_bin_num >> 8;
				synth_mags_wren <= 1;
				synth_devs_wren <= 1;

				i <= (i == 2048) ? 0 : i + 1;
				expected_d_phase <= expected_d_phase + expected_d_phase_increment;

				if (i == 2048) begin
					state <= synthesis;
					synth_mags_wren <= 0;
					synth_devs_wren <= 0;
					synth_mags_raddr <= 0;
					synth_devs_raddr <= 0;
					synth_mags_wrdata <= 0;
					synth_devs_wrdata <= 0;
					synth_mags_raddr <= 0;
					phase_out_prev_raddr <= 0;
					expected_d_phase <= 0;
				end

				anal_read <= 1;
			end
		end

		synthesis: begin
			
			phase_out_wrdata <= phase_out_prev_rdata + expected_d_phase;
			mag_out_wrdata <= synth_mags_rdata;
			phase_out_wraddr <= i;
			mag_out_wraddr <= i;
			phase_out_wren <= 1;
			mag_out_wren <= 1;

			synth_mags_raddr <= i + 1;
			phase_out_prev_raddr <= i + 1;		
			i <= i + 1;
			expected_d_phase <= expected_d_phase + expected_d_phase_increment;

			if (i == 2047) begin
				state <= just_finished;
			end
		end

		just_finished: begin
			expected_d_phase <= 0;
			synth_mags_wren <= 0;
			synth_devs_wren <= 0;
			synth_mags_raddr <= 0;
			synth_devs_raddr <= 0;
			synth_mags_wrdata <= 0;
			synth_devs_wrdata <= 0;
			expected_d_phase <= 0;
			i <= 0;

			go_out <= 1;
			state <= awaiting;
		end
		endcase
	end

endmodule
