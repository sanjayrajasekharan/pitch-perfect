/*
 * Software Interface for Pitch Perfect Project
 *
 * Steven Winnick
 * Columbia University
 */

module software_interface(
        input logic         clk,
	    input logic 	    reset,

        // Input from the  Avalon Bus
		input logic [7:0]   writedata,
		input logic 	    write,
		input 		        chipselect,
		input logic [2:0]   address,

        // Tell the rest of the system how much to shift by (controlled by software)
		output logic [7:0]  shift_amt = 0,

        // Fill the AV Config component's avalon slave module to quiet warnings
        output logic [1:0]  av_config_slave_address = 0,
        output logic [3:0]  av_config_slave_byteenable = 0,
        output logic        av_config_slave_read = 0,
        output logic        av_config_slave_write = 0,
        output logic [31:0] av_config_slave_writedata = 0,
        input  logic [31:0] av_config_slave_readdata,
        input logic         av_config_slave_waitrequest,

    );

    always_ff @(posedge clk) begin
        if (chipselect && write)
            shift_amt <= writedata;
    end
	       
endmodule