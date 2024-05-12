/*
 * Avalon streaming component to write to both left and right to_dac channels of
 * the Wolfson Audio CODEC
 */

module emitter(
		input logic	    clk,

		// Communicate with stitcher
		input logic [1:0]   window_start,
		input logic	    go_in,

		// Write to avalon_left_channel_sink of audio codec
		output logic [15:0] left_out_data = 0,
		output logic        left_out_valid = 0,
		input logic         left_out_ready,

		// Write to avalon_right_channel_sink of audio codec
		output logic [15:0] right_out_data = 0,
		output logic        right_out_valid = 0,
		input logic         right_out_ready
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
