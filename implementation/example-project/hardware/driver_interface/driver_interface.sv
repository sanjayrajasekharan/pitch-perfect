module driver_interface
    #(parameter DATA_SIZE = 24)
   (input logic clk, // 50 MHz
    input logic rst, 
    input logic [DATA_SIZE-1:0] in_left,
    input logic [DATA_SIZE-1:0] in_right,
    input logic in_ready,
    input logic chipselect,
    input logic [2:0] address,
    input logic read,
    output logic [31:0] read_data,
    output logic irq
    );

    logic [DATA_SIZE-1:0] left_buffer;
    logic [DATA_SIZE-1:0] right_buffer;

    always_ff @(posedge clk) begin
        if (in_ready) begin
            left_buffer <= in_left;
            right_buffer <= in_right;
            irq <= 1;
        end
        if (chipselect && read) begin
		case(address)
			3'h0 : read_data <= {{32-DATA_SIZE{1'b0}}, left_buffer};
			3'h1 : read_data <= {{32-DATA_SIZE{1'b0}}, right_buffer};
			3'h2 : begin 
				irq <= 0;
				read_data <= 32'b1;
			end
		endcase
        end
    end
endmodule
