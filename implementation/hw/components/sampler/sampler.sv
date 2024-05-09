/*
 * Avalon streaming component to read samples of left from_adc channel of
 * the Wolfson Audio CODEC to a ring buffer
 */

module sampler(
		input logic	    clk,

		// Read from avalon_left_channel_source from audio codec
		input logic [15:0]  left_in_data,
		input logic 	    left_in_valid,
		output logic        left_in_ready = 0,

		// Read from avalon_right_channel_source from audio codec
		input logic [15:0]  right_in_data,
		input logic 	    right_in_valid,
		output logic        right_in_ready = 0,

		// Write to ring buffer
		output logic [15:0] ring_buf_data,
		output logic [12:0] ring_buf_addr = 0, // larger than typical buffer because ringbuf holds one extra window
		output logic        ring_buf_wren = 0,

		// Communicate with first_hannifier
		output logic [1:0]  window_start,
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
