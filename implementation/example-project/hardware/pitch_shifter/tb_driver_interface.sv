`define OUT_DATA "out_data"
`define OUT_DATA_SIM "../../matlab/out_data_sim"
`define IN_DATA_SIM "../../matlab/in_data_sim"

module tb_driver_interface;
	timeunit 1ns;
	timeprecision 10ps;

	// params
	localparam BUFFER_SIZE = 1024; 
	localparam DATA_SIZE = 24;

	// shifter flags
	logic clk;
	logic rst;
	logic [DATA_SIZE-1:0] in_left;
	logic [DATA_SIZE-1:0] in_right;
	logic in_ready;
	logic [DATA_SIZE-1:0] out_left;
	logic [DATA_SIZE-1:0] out_right;
	logic out_ready;

	// driver flags
	logic chipselect;
	logic [2:0] address;
	logic read;
	logic [63:0] read_data;
	logic irq;
	
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

	driver_interface #(DATA_SIZE) driver_interface_0 (
		.clk(clk),
		.rst(rst),
		.in_left(out_left),
		.in_right(out_right),
		.in_ready(out_ready),
		.chipselect(chipselect),
		.address(address),
		.read(read),
		.read_data(read_data),
		.irq(irq)
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

		for (i=0 ; i<50; i=i+1) begin 
			// Read the binary inputs from Matlab simulation
			$fscanf(in_data_sim, "%b", in_left);
			$fscanf(in_data_sim, "%b", in_right);	
			in_ready <= 1;
			
			@(posedge clk);
			#20; 
			in_ready <=0;
			
			#60;
			// compare w/ the results from Matlab sim
			$fscanf(out_data_sim, "%b", out_left_sim);
			$fscanf(out_data_sim, "%b", out_right_sim);
	
			#20;
			chipselect <= 1;
			read <= 1;
			address <= 0;
		
			#20;
			chipselect <= 0;
			read <= 0;
			address <= 0;
			
		end
 
		// Close files
		$fclose(in_data_sim);
		$fclose(out_data);
		$finish;
	end
endmodule