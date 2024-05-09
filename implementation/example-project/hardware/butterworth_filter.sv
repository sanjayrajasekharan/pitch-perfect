////////////////////////////////////////////////////////////////////////////////
// Sixth order IIR filter //////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


module butterworth_filter
		#(parameter DATA_SIZE = 24,
		parameter SCALE = 3'd3,
		parameter B1 = 32'h226C,
		parameter B2 = 32'hCE8B,
		parameter B3 = 32'h2045B,
		parameter B4 = 32'h2B07A,
		parameter B5 = 32'h2045B,
		parameter B6 = 32'hCE8B,
		parameter B7 = 32'h226C,
		parameter A2 = 32'h21DC9D38,
		parameter A3 = 32'hC2BABD8C,
		parameter A4 = 32'h3C58991F,
		parameter A5 = 32'hDDFDB62D,
		parameter A6 = 32'hA5FA11C,
		parameter A7 = 32'hFEAA19B2)
	 (
		 input wire signed [DATA_SIZE-1:0] in_left,
		 input wire signed [DATA_SIZE-1:0] in_right,
		 output reg signed [DATA_SIZE-1:0] out_left,
		 output reg signed [DATA_SIZE-1:0] out_right,
		 output reg signed out_ready,
		 input wire clk, in_ready, rst
	 );

	 logic out_ready_left, out_ready_right;
	 assign out_ready = out_ready_left && out_ready_right;

	 butterworth_filter_mono #(DATA_SIZE, SCALE, B1, B2, B3, B4, B5, B6, B7,
			 A2, A3, A4, A5, A6, A7) filter_left(
			 .in(in_left),
			 .out(out_left),
			 .out_ready(out_ready_left),
			 .clk(clk),
			 .in_ready(in_ready),
			 .rst(rst)
			 );

	 butterworth_filter_mono #(DATA_SIZE, SCALE, B1, B2, B3, B4, B5, B6, B7,
			 A2, A3, A4, A5, A6, A7) filter_right(
			 .in(in_right),
			 .out(out_right),
			 .out_ready(out_ready_right),
			 .clk(clk),
			 .in_ready(in_ready),
			 .rst(rst)
			 );

endmodule

module butterworth_filter_mono
		#(parameter DATA_SIZE = 24,
		parameter SCALE = 3'd3,
		parameter B1 = 32'h226C,
		parameter B2 = 32'hCE8B,
		parameter B3 = 32'h2045B,
		parameter B4 = 32'h2B07A,
		parameter B5 = 32'h2045B,
		parameter B6 = 32'hCE8B,
		parameter B7 = 32'h226C,
		parameter A2 = 32'h21DC9D38,
		parameter A3 = 32'hC2BABD8C,
		parameter A4 = 32'h3C58991F,
		parameter A5 = 32'hDDFDB62D,
		parameter A6 = 32'hA5FA11C,
		parameter A7 = 32'hFEAA19B2)
	 (
		 input wire signed [DATA_SIZE-1:0] in,
		 output reg signed [DATA_SIZE-1:0] out,
		 output reg signed        out_ready,
		 input wire               clk, in_ready, rst
	 );
												 
   // The filter is a "Direct Form II Transposed"
   //
   //    a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
   //                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
   //
   //    If a(1) is not equal to 1, FILTER normalizes the filter
   //    coefficients by a(1).
   //

   // one audio sample, 32 bit, 2's complement
   reg signed [31:0] audio_out;
   // one audio sample, 32 bit, 2's complement
   reg signed [31:0] audio_in;
   // shift factor for output

   /// filter vars
   wire signed [31:0]       f1_mac_new, f1_coeff_x_value;
   reg signed [31:0]        f1_coeff, f1_mac_old, f1_value;

   // input to filter
   reg signed [31:0]        x_n;
   // input history x(n-1), x(n-2)
   reg signed [31:0]        x_n1, x_n2, x_n3, x_n4, x_n5, x_n6;

   // output history: y_n is the new filter output, BUT it is
   // immediately stored in f1_y_n1 for the next loop through
   // the filter state machine
   reg signed [31:0]        f1_y_n1, f1_y_n2, f1_y_n3, f1_y_n4, f1_y_n5, f1_y_n6;

   // MAC operation
   signed_mult f1_c_x_v (.out(f1_coeff_x_value), .a(f1_coeff), .b(f1_value));
   assign f1_mac_new = f1_mac_old + f1_coeff_x_value;

   // state variable
   reg [4:0]                state;

   ///////////////////////////////////////////////////////////////////

   //Run the filter state machine FAST so that it completes in one
   //audio cycle
   always_ff @ (posedge clk)
     begin
        if (rst) begin
           state         <= 5'd16; //turn off the state machine
           f1_value      <= 0;
           f1_coeff      <= 0;
           f1_mac_old    <= 0;
           x_n           <= 0;
           x_n1          <= 0;
           x_n2          <= 0;
           x_n3          <= 0;
           x_n4          <= 0;
           x_n5          <= 0;
           x_n6          <= 0;
           f1_y_n1       <= 0;
           f1_y_n2       <= 0;
           f1_y_n3       <= 0;
           f1_y_n4       <= 0;
           f1_y_n5       <= 0;
           f1_y_n6       <= 0;
           out_ready <= 0;
        end
        else begin
           case (state)
             0:
               begin
		  audio_in <= {in[DATA_SIZE - 1], {{32 - DATA_SIZE}{1'b0}}, in[DATA_SIZE - 2: 0]};
                  state    <= 5'd1;
               end

             1:
               begin
                  // set up b1*x(n)
                  f1_mac_old <= 32'd0;
                  f1_coeff   <= B1;
                  f1_value   <= (audio_in >>> 1);
                  //register input
                  x_n        <= (audio_in >>> 1);
                  // next state
                  state      <= 5'd2;
               end

             2:
               begin
                  // set up b2*x(n-1)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B2;
                  f1_value   <= x_n1;
                  // next state
                  state      <= 5'd3;
               end

             3:
               begin
                  // set up b3*x(n-2)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B3;
                  f1_value   <= x_n2;
                  // next state
                  state      <= 5'd4;
               end

             4:
               begin
                  // set up b4*x(n-3)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B4;
                  f1_value   <= x_n3;
                  // next state
                  state      <= 5'd5;
               end

             5:
               begin
                  // set up b5*x(n-4)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B5;
                  f1_value   <= x_n4;
                  // next state
                  state      <= 5'd6;
               end

             6:
               begin
                  // set up b6*x(n-5)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B6;
                  f1_value   <= x_n5;
                  // next state
                  state      <= 5'd7;

               end

             7:
               begin
                  // set up b7*x(n-6)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= B7;
                  f1_value   <= x_n6;
                  // next state
                  state      <= 5'd8;

               end

             8:
               begin
                  // set up -a2*y(n-1)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A2;
                  f1_value   <= f1_y_n1;
                  //next state
                  state      <= 5'd9;
               end

             9:
               begin
                  // set up -a3*y(n-2)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A3;
                  f1_value   <= f1_y_n2;
                  //next state
                  state      <= 5'd10;
               end

             10:
               begin
                  // set up -a4*y(n-3)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A4;
                  f1_value   <= f1_y_n3;
                  //next state
                  state      <= 5'd11;
               end

             11:
               begin
                  // set up -a5*y(n-4)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A5;
                  f1_value   <= f1_y_n4;
                  //next state
                  state      <= 5'd12;
               end

             12:
               begin
                  // set up -a6*y(n-5)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A6;
                  f1_value   <= f1_y_n5;
                  //next state
                  state      <= 5'd13;
               end

             13:
               begin
                  // set up -a7*y(n-6)
                  f1_mac_old <= f1_mac_new;
                  f1_coeff   <= A7;
                  f1_value   <= f1_y_n6;
                  //next state
                  state      <= 5'd14;
               end

             14:
               begin
                  // get the output
                  // and put it in the LAST output var
                  // for the next pass thru the state machine
                  //mult by four because of coeff scaling
                  // to prevent overflow
                  f1_y_n1 <= f1_mac_new<<SCALE;

                  audio_out <= f1_y_n1;
                  // update output history
                  f1_y_n2 <= f1_y_n1;
                  f1_y_n3 <= f1_y_n2;
                  f1_y_n4 <= f1_y_n3;
                  f1_y_n5 <= f1_y_n4;
                  f1_y_n6 <= f1_y_n5;
                  // update input history
                  x_n1 <= x_n;
                  x_n2 <= x_n1;
                  x_n3 <= x_n2;
                  x_n4 <= x_n3;
                  x_n5 <= x_n4;
                  x_n6 <= x_n5;
                  //next state
                  state <= 5'd15;
               end

	     15:
		begin
		  out <= {audio_out[31], audio_out[DATA_SIZE-2:0]};
		  out_ready <= 1'b1;
		  state <= 5'd16;
		end


             16:
               begin
                  // wait for data valid signal
                  out_ready <= 1'b0;
                  if (in_ready)
                    begin
                       state <= 5'd0;
                    end
               end

             default:
               begin
                  // default state is end state
                  state <= 5'd16;
               end
           endcase
        end
     end

endmodule

///////////////////////////////////////////////////
//// signed mult of 2.30 format 2'comp ////////////
///////////////////////////////////////////////////
module signed_mult (out, a, b);

   output    [31:0]  out;
   input   signed [31:0] a;
   input   signed [31:0] b;

   wire  signed [31:0]   out;
   wire  signed [63:0]   mult_out;

   assign mult_out = a * b;
   //assign out = mult_out[33:17];
   assign out = {mult_out[63], mult_out[59:30]};
endmodule
//////////////////////////////////////////////////

