`define OUT_DATA "../../matlab/out_data"
`define OUT_DATA_SIM "../../matlab/out_data_sim"
`define IN_DATA_SIM "../../matlab/in_data_sim"
module tb_pitch_shifter;
	timeunit 1ns;
	timeprecision 10ps;

	localparam BUFFER_SIZE = 10; // Test with a smaller buffer size
	localparam DATA_SIZE = 24;
	logic clk;
	logic rst;
	logic [DATA_SIZE-1:0] in_left;
	logic [DATA_SIZE-1:0] in_right;
	logic in_ready;
	logic [DATA_SIZE-1:0] out_left;
	logic [DATA_SIZE-1:0] out_right;
	logic out_ready;

	integer i;
	integer out_data;
	integer out_data_sim;
	integer in_data_sim;

	logic [DATA_SIZE-1:0] out_left_sim;
	logic [DATA_SIZE-1:0] out_right_sim;

	integer left_error_count = 0;
	integer right_error_count = 0;

	pitch_shifter #(BUFFER_SIZE, DATA_SIZE) pitch_shifter_0 (
		.clk(clk),
		.rst(rst),
		.in_left(in_left),
		.out_left(out_left),
		.in_right(in_right),
		.out_right(out_right),
		.in_ready(in_ready),
		.out_ready(out_ready)
	);

	initial begin 
		// File IO
		out_data = $fopen(`OUT_DATA,"w");
		if (!out_data) begin
			$display("Couldn't create the output file.");
			$finish;
		end

		out_data_sim = $fopen(`OUT_DATA_SIM,"r");
		if (!out_data_sim) begin
			$display("Couldn't open the Matlab out file.");
			$finish;
		end

		in_data_sim = $fopen(`IN_DATA_SIM,"r");
		if (!in_data_sim) begin
			$display("Couldn't open the Matlab in file.");
			$finish;
		end
		clk <= 1;
		rst <= 0;
	end 
	always #10 clk = ~clk; // 50 MHz

	always begin
		// Reset for 1 clk cycle
		rst <=1;
		#20;
		rst <= 0;

		for (i=0 ; i<512; i=i+1) begin 
			// Read the binary inputs from Matlab simulation
			$fscanf(in_data_sim, "%b", in_left);
			$fscanf(in_data_sim, "%b", in_right);	
			in_ready <= 1;
			
			@(posedge clk);
			// compare w/ the results from Matlab sim
			$fscanf(out_data_sim, "%b", out_left_sim);
			$fscanf(out_data_sim, "%b", out_right_sim);

			#20; 
			in_ready <=0;
			
			#60;

			$fwrite(out_data, "%b\n", out_left);
			$fwrite(out_data, "%b\n", out_right);
			if (out_left!== out_left_sim) 
			begin
				
				left_error_count = left_error_count + 1;
			end
			if (out_right!== out_right_sim) 
			begin
				
				right_error_count = right_error_count + 1;
			end
		end

		// Any mismatch between RTL and MatLab simulations?
		if (left_error_count > 0 || right_error_count > 0) begin
			$display("The results DO NOT match with those from Matlab :( ");
		end
		else if (left_error_count < 15 && right_error_count < 15) begin
			$display("The results DO NOT match with those from Matlab, but error is < 15 and due to shift_factor size");
		end
		else begin
			$display("The results DO match with those from Matlab :) ");
		end
 
		// Close files
		$fclose(in_data_sim);
		$fclose(out_data_sim);
		$fclose(out_data);
		$finish;
		
		// Raise ready flag for one clock cycle and add random data. 
		// Compared manually to see if output was as expected.
//		for(i = 0; i < 32; i = i + 1) begin
//			in_ready <= 1;
//			in_left <= $urandom & 24'hFFFFFF;  // random 24-bit number
//			in_right <= $urandom & 24'hFFFFFF; // random 24-bit number
//
//			#20; 
//			in_ready <=0;
//
//			#100;
//		end
//		
//		$finish;
	end

endmodule
