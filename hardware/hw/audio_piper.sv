/*
 * Avalon streaming component to pipe left from_adc chanel of Wolfson Audio 
 * CODEC to both left and right channels of output
 *
 * Steven Winnick
 * Columbia University
 */

module audio_piper(
        input logic         clk,
        input logic 	    reset,

        // from avalon_left_channel_source from audio codec
        input logic [15:0]  left_in_data,
        input logic 	    left_in_valid,
        output logic        left_in_ready = 0,

        // from avalon_right_channel_source from audio codec
        input logic [15:0]  right_in_data,
        input logic 	    right_in_valid,
        output logic        right_in_ready = 0,

        // to avalon_left_channel_sink in audio codec
        output logic [15:0] left_out_data = 0,
        output logic        left_out_valid = 0,
        input logic         left_out_ready,

        // to avalon_right_channel_sink in audio codec
        output logic [15:0] right_out_data = 0,
        output logic        right_out_valid = 0,
        input logic         right_out_ready,

        output logic [9:0]  lights = 0
    );

    logic [15:0] data = 0;
    logic [9:0] ctr1 = 0;
    logic [9:0] ctr2 = 0;
    logic [9:0] ctr3 = 0;
    logic [9:0] ctr4 = 0;
    logic [9:0] ctr5 = 0;

    always_ff @(posedge clk) begin
        if (left_in_valid) begin
            data <= left_in_data;
            left_in_ready <= 1;
        end

        // Per Avalon Interface Specification, ready only flashes for one cycle
        if (left_in_ready) begin
            left_in_ready <= 0;
        end

        if (left_out_ready) begin
            left_out_data <= data;
            left_out_valid <= 1;
        end

        if (right_out_ready) begin
            right_out_data <= data;
            right_out_valid <= 1;
        end

        if (left_out_valid) begin
            left_out_valid <= 0;
        end

        if (right_out_valid) begin
            right_out_valid <= 0;
        end

        if (left_in_valid)
	    if (ctr1 == 0)
                lights[0] <= 1;
	    else
		ctr1 <= ctr1 + 1;
        else
	    if (ctr2 == 0)
                lights[0] <= 0;
	    else
		ctr2 <= ctr2 + 1;

        if (right_in_valid)
            lights[1] <= 1;
        else
            lights[1] <= 0;

        if (left_out_ready)
            lights[2] <= 1;
        else
            lights[2] <= 0;

        if (right_out_ready)
            lights[3] <= 1;
        else
            lights[3] <= 0;

    	if (ctr3 == 0)
            if (lights[9])
                lights[9] <= 0;
	    else
		lights[9] <= 1;
        else
            ctr3 <= ctr3 + 1;
    end
endmodule
