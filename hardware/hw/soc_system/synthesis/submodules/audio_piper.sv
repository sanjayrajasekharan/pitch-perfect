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

        // to avalon_left_channel_sink in audio codec
        output logic [15:0] left_out_data = 0,
        output logic        left_out_valid = 0,
        input logic         left_out_ready,

        // to avalon_right_channel_sink in audio codec
        output logic [15:0] right_out_data = 0,
        output logic        right_out_valid = 0,
        input logic         right_out_ready
    );

    logic [15:0] data = 0;

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
    end
endmodule
