module buffer 
        #(parameter BUFFER_SIZE = 1024, 
	parameter DATA_SIZE = 24)

        (input logic clk,
	input logic wren, // 1: write to buffer, 0: idle
	input logic [$clog2(BUFFER_SIZE)-1:0] wraddr, // write address
	input logic [$clog2(BUFFER_SIZE)-1:0] rdaddr, // read address
	input logic signed [DATA_SIZE-1:0] wrdata, // write data
	output logic signed [DATA_SIZE-1:0] rddata); //read data
	
	logic signed [DATA_SIZE-1:0] mem [BUFFER_SIZE-1:0]; // Memory array: 1024, 24-bit
	
	always_ff @(posedge clk)
	begin
		rddata <= mem[rdaddr];
		if(wren) mem[wraddr] <= wrdata;
	end
endmodule	
