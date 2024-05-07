module pitch_shifter
	#(BUFFER_SIZE = 1024, parameter DATA_SIZE = 24)
       (input logic clk, // 50 MHz
	input logic rst, 
	input logic signed [DATA_SIZE-1:0] in_left,
	input logic signed [DATA_SIZE-1:0] in_right,
	input logic in_ready,
	output logic signed [DATA_SIZE-1:0] out_left,
	output logic signed [DATA_SIZE-1:0] out_right,
	output logic out_ready
	);
	
	logic [$clog2(BUFFER_SIZE)+28:0] shift_factor = {{$clog2(BUFFER_SIZE){1'b0}}, 4'b1111, 25'b0}; //0.9375 --> Q10.29
	logic l_wren_0, l_wren_1, r_wren_0, r_wren_1; // Write-enable flags 
	logic [$clog2(BUFFER_SIZE)-1:0] l_w_0, l_w_1, // Write pointers 
					r_w_0, r_w_1; 
	logic [$clog2(BUFFER_SIZE)-1:0] l_r_0, l_r_1, // Read pointers
					r_r_0, r_r_1;  
	logic [$clog2(BUFFER_SIZE)+28:0] l_i_0, l_i_1, r_i_0, r_i_1; // Fractional indexes; Q BUFFER_SIZE.29
	logic signed [DATA_SIZE-1:0] l_wrdata_0, l_wrdata_1, r_wrdata_0, r_wrdata_1; // Write data
	logic signed [DATA_SIZE-1:0] l_rddata_0, l_rddata_1, r_rddata_0, r_rddata_1; // Read data 

	enum logic [2:0] {WAIT = 3'b000, WRITE = 3'b001, READ = 3'b010, OUTPUT =
		3'b011} state; // State encodings

	buffer #(BUFFER_SIZE, DATA_SIZE) l_buf_0(
		.clk(clk),
		.wren(l_wren_0),
		.wraddr(l_w_0),
		.rdaddr(l_r_0),
		.wrdata(l_wrdata_0),
		.rddata(l_rddata_0)
	);
	buffer #(BUFFER_SIZE, DATA_SIZE) l_buf_1(
		.clk(clk),
		.wren(l_wren_1),
		.wraddr(l_w_1),
		.rdaddr(l_r_1),
		.wrdata(l_wrdata_1),
		.rddata(l_rddata_1)
	);

	buffer #(BUFFER_SIZE, DATA_SIZE) r_buf_0(
		.clk(clk),
		.wren(r_wren_0),
		.wraddr(r_w_0),
		.rdaddr(r_r_0),
		.wrdata(r_wrdata_0),
		.rddata(r_rddata_0)
	);
	
	buffer #(BUFFER_SIZE, DATA_SIZE) r_buf_1(
		.clk(clk),
		.wren(r_wren_1),
		.wraddr(r_w_1),
		.rdaddr(r_r_1),
		.wrdata(r_wrdata_1),
		.rddata(r_rddata_1)
	);

	always_ff @(posedge clk) begin
		if(rst) begin
			state <= WAIT;

			// Initialize left buffer pointers
			// Write
			l_w_0 <= 0;
			l_w_1 <= BUFFER_SIZE/2; 

			// Read
			l_r_0 <= 0;
			l_r_1 <= 0;

			// Initialize right buffer pointers
			// Write
			r_w_0 <= 0;
			r_w_1 <= BUFFER_SIZE/2; 

			// Read
			r_r_0 <= 0;
			r_r_1 <= 0;

			// Initialize fractional indexes
			l_i_0 <= 0;
			l_i_1 <= 0;
			r_i_0 <= 0;
			r_i_1 <= 0;

			out_ready <= 0;
		end
		else if(state == WAIT && in_ready) begin
			// Write in_left to left buffer
			l_wren_0 <= 1;
			l_wren_1 <= 1;  
			l_wrdata_0 <= in_left;
			l_wrdata_1 <= in_left;

			// Write in_right to right buffer
			r_wren_0 <= 1;
			r_wren_1 <= 1;
			r_wrdata_0 <= in_right;
			r_wrdata_1 <= in_right;

			state <= WRITE;

			out_ready <= 0;
			
		end
		else if(state == WRITE) begin
			// Do not write, just read
			l_wren_0 <= 0;
			l_wren_1 <= 0; 
			r_wren_0 <= 0;
			r_wren_1 <= 0;
	
			// Advance write pointers
			l_w_0 <= l_w_0 + 1;
			l_w_1 <= l_w_1 + 1;
			r_w_0 <= r_w_0 + 1;
			r_w_1 <= r_w_1 + 1;

			// Update fractional indexes
			l_i_0 <= l_i_0 + shift_factor;
			l_i_1 <= l_i_1 + shift_factor;
		
			r_i_0 <= r_i_0 + shift_factor;
			r_i_1 <= r_i_1 + shift_factor;

			// Advance read pointers
			l_r_0 <= l_i_0[$clog2(BUFFER_SIZE)+28:29]; // Take first 10b (int part of i_0)
			r_r_0 <= r_i_0[$clog2(BUFFER_SIZE)+28:29]; 

			l_r_1 <= l_i_1[$clog2(BUFFER_SIZE)+28:29]; // Take first 10b (int part of i_1)
			r_r_1 <= r_i_1[$clog2(BUFFER_SIZE)+28:29];	
			
			out_ready <= 0;
			state <= READ;

		end
		else if(state == READ) begin
			// Reading state
			state <= OUTPUT;
		end
		else if(state == OUTPUT) begin
			// Alert driver that data is valiD
			out_ready <= 1;
			state <= WAIT;
		end
		else begin // WAIT 
			// Do not write 
			l_wren_0 <= 0;
			l_wren_1 <= 0; 
			r_wren_0 <= 0;
			r_wren_1 <= 0;

			out_ready <= 0;
			state <= WAIT;
		end
	end
	// Take average of outputs of buffers 0 and 1 for left and right buffers
	assign out_left = state == OUTPUT ? (((l_rddata_0 === 24'dx ? 0 : l_rddata_0) >>> 1) + ((l_rddata_1 === 24'dx ? 0 : l_rddata_1) >>> 1)): out_left;
	assign out_right = state == OUTPUT ? (((r_rddata_0 === 24'dx ? 0 : r_rddata_0)  >>> 1) + ((r_rddata_1 === 24'dx ? 0 : r_rddata_1) >>> 1)): out_right;

endmodule
	
