module fft_wrapper(
    input wire clk,
    input wire [15:0] ram_in_data,
    output wire [15:0] ram_out_data,
    output wire ram_in_ready,
    input wire ram_in_valid,
    output wire ram_out_ready,
    output wire ram_out_valid,
    output wire [15:0] real_to_fft_p,
    output wire [15:0] imag_to_fft_p
);

wire [11:0] fft_pts;
wire reset_n;

// RAM Writing Signals
reg [15:0] ram_out_data_reg;
reg ram_out_ready_reg;
reg ram_out_valid_reg;

// RAM Writing Logic
always @(posedge clk) begin
    if (ram_out_valid_reg && ram_out_ready_reg) begin
        ram_out_valid_reg <= 0;
    end
    if (ram_out_ready && !ram_out_valid_reg) begin
        ram_out_valid_reg <= 1;
        ram_out_data_reg <= {real_to_fft_p, imag_to_fft_p};
    end
end

assign ram_out_data = ram_out_data_reg;
assign ram_out_ready = ram_out_ready_reg;
assign ram_out_valid = ram_out_valid_reg;

// Instantiate control_for_fft module
control_for_fft control_for_fft_inst (
    .clk(clk),
    .insignal(ram_in_data),
    .sink_valid(ram_in_valid),
    .sink_ready(ram_in_ready),
    .sink_sop(),
    .sink_eop(),
    .inverse(),
    .outreal(real_to_fft_p),
    .outimag(imag_to_fft_p),
    .fft_pts(fft_pts)
);

// Instantiate FFT IP
fft fft_inst (
    .clk(clk),
    .reset_n(reset_n),
    .sink_valid(ram_out_valid),
    .sink_ready(ram_out_ready),
    .sink_error(),
    .sink_sop(),
    .sink_eop(),
    .sink_real(real_to_fft_p),
    .sink_imag(imag_to_fft_p),
    .fftpts_in(fft_pts),
    .inverse(1'b0),
    .source_valid(),
    .source_ready(),
    .source_error(),
    .source_sop(),
    .source_eop(),
    .source_real(),
    .source_imag(),
    .fftpts_out()
);

endmodule
