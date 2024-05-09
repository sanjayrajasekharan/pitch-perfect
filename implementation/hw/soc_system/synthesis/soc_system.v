// soc_system.v

// Generated using ACDS version 21.1 842

`timescale 1 ps / 1 ps
module soc_system (
		input  wire        clk_clk,                         //                       clk.clk
		input  wire [11:0] hann_to_fft_buf_memreader_addr,  // hann_to_fft_buf_memreader.addr
		output wire [15:0] hann_to_fft_buf_memreader_data,  //                          .data
		input  wire [15:0] hann_to_fft_buf_memwriter_data,  // hann_to_fft_buf_memwriter.data
		input  wire [11:0] hann_to_fft_buf_memwriter_addr,  //                          .addr
		input  wire        hann_to_fft_buf_memwriter_valid, //                          .valid
		output wire        hps_hps_io_emac1_inst_TX_CLK,    //                       hps.hps_io_emac1_inst_TX_CLK
		output wire        hps_hps_io_emac1_inst_TXD0,      //                          .hps_io_emac1_inst_TXD0
		output wire        hps_hps_io_emac1_inst_TXD1,      //                          .hps_io_emac1_inst_TXD1
		output wire        hps_hps_io_emac1_inst_TXD2,      //                          .hps_io_emac1_inst_TXD2
		output wire        hps_hps_io_emac1_inst_TXD3,      //                          .hps_io_emac1_inst_TXD3
		input  wire        hps_hps_io_emac1_inst_RXD0,      //                          .hps_io_emac1_inst_RXD0
		inout  wire        hps_hps_io_emac1_inst_MDIO,      //                          .hps_io_emac1_inst_MDIO
		output wire        hps_hps_io_emac1_inst_MDC,       //                          .hps_io_emac1_inst_MDC
		input  wire        hps_hps_io_emac1_inst_RX_CTL,    //                          .hps_io_emac1_inst_RX_CTL
		output wire        hps_hps_io_emac1_inst_TX_CTL,    //                          .hps_io_emac1_inst_TX_CTL
		input  wire        hps_hps_io_emac1_inst_RX_CLK,    //                          .hps_io_emac1_inst_RX_CLK
		input  wire        hps_hps_io_emac1_inst_RXD1,      //                          .hps_io_emac1_inst_RXD1
		input  wire        hps_hps_io_emac1_inst_RXD2,      //                          .hps_io_emac1_inst_RXD2
		input  wire        hps_hps_io_emac1_inst_RXD3,      //                          .hps_io_emac1_inst_RXD3
		inout  wire        hps_hps_io_sdio_inst_CMD,        //                          .hps_io_sdio_inst_CMD
		inout  wire        hps_hps_io_sdio_inst_D0,         //                          .hps_io_sdio_inst_D0
		inout  wire        hps_hps_io_sdio_inst_D1,         //                          .hps_io_sdio_inst_D1
		output wire        hps_hps_io_sdio_inst_CLK,        //                          .hps_io_sdio_inst_CLK
		inout  wire        hps_hps_io_sdio_inst_D2,         //                          .hps_io_sdio_inst_D2
		inout  wire        hps_hps_io_sdio_inst_D3,         //                          .hps_io_sdio_inst_D3
		inout  wire        hps_hps_io_usb1_inst_D0,         //                          .hps_io_usb1_inst_D0
		inout  wire        hps_hps_io_usb1_inst_D1,         //                          .hps_io_usb1_inst_D1
		inout  wire        hps_hps_io_usb1_inst_D2,         //                          .hps_io_usb1_inst_D2
		inout  wire        hps_hps_io_usb1_inst_D3,         //                          .hps_io_usb1_inst_D3
		inout  wire        hps_hps_io_usb1_inst_D4,         //                          .hps_io_usb1_inst_D4
		inout  wire        hps_hps_io_usb1_inst_D5,         //                          .hps_io_usb1_inst_D5
		inout  wire        hps_hps_io_usb1_inst_D6,         //                          .hps_io_usb1_inst_D6
		inout  wire        hps_hps_io_usb1_inst_D7,         //                          .hps_io_usb1_inst_D7
		input  wire        hps_hps_io_usb1_inst_CLK,        //                          .hps_io_usb1_inst_CLK
		output wire        hps_hps_io_usb1_inst_STP,        //                          .hps_io_usb1_inst_STP
		input  wire        hps_hps_io_usb1_inst_DIR,        //                          .hps_io_usb1_inst_DIR
		input  wire        hps_hps_io_usb1_inst_NXT,        //                          .hps_io_usb1_inst_NXT
		output wire        hps_hps_io_spim1_inst_CLK,       //                          .hps_io_spim1_inst_CLK
		output wire        hps_hps_io_spim1_inst_MOSI,      //                          .hps_io_spim1_inst_MOSI
		input  wire        hps_hps_io_spim1_inst_MISO,      //                          .hps_io_spim1_inst_MISO
		output wire        hps_hps_io_spim1_inst_SS0,       //                          .hps_io_spim1_inst_SS0
		input  wire        hps_hps_io_uart0_inst_RX,        //                          .hps_io_uart0_inst_RX
		output wire        hps_hps_io_uart0_inst_TX,        //                          .hps_io_uart0_inst_TX
		inout  wire        hps_hps_io_i2c0_inst_SDA,        //                          .hps_io_i2c0_inst_SDA
		inout  wire        hps_hps_io_i2c0_inst_SCL,        //                          .hps_io_i2c0_inst_SCL
		inout  wire        hps_hps_io_i2c1_inst_SDA,        //                          .hps_io_i2c1_inst_SDA
		inout  wire        hps_hps_io_i2c1_inst_SCL,        //                          .hps_io_i2c1_inst_SCL
		inout  wire        hps_hps_io_gpio_inst_GPIO09,     //                          .hps_io_gpio_inst_GPIO09
		inout  wire        hps_hps_io_gpio_inst_GPIO35,     //                          .hps_io_gpio_inst_GPIO35
		inout  wire        hps_hps_io_gpio_inst_GPIO40,     //                          .hps_io_gpio_inst_GPIO40
		inout  wire        hps_hps_io_gpio_inst_GPIO48,     //                          .hps_io_gpio_inst_GPIO48
		inout  wire        hps_hps_io_gpio_inst_GPIO53,     //                          .hps_io_gpio_inst_GPIO53
		inout  wire        hps_hps_io_gpio_inst_GPIO54,     //                          .hps_io_gpio_inst_GPIO54
		inout  wire        hps_hps_io_gpio_inst_GPIO61,     //                          .hps_io_gpio_inst_GPIO61
		output wire [14:0] hps_ddr3_mem_a,                  //                  hps_ddr3.mem_a
		output wire [2:0]  hps_ddr3_mem_ba,                 //                          .mem_ba
		output wire        hps_ddr3_mem_ck,                 //                          .mem_ck
		output wire        hps_ddr3_mem_ck_n,               //                          .mem_ck_n
		output wire        hps_ddr3_mem_cke,                //                          .mem_cke
		output wire        hps_ddr3_mem_cs_n,               //                          .mem_cs_n
		output wire        hps_ddr3_mem_ras_n,              //                          .mem_ras_n
		output wire        hps_ddr3_mem_cas_n,              //                          .mem_cas_n
		output wire        hps_ddr3_mem_we_n,               //                          .mem_we_n
		output wire        hps_ddr3_mem_reset_n,            //                          .mem_reset_n
		inout  wire [31:0] hps_ddr3_mem_dq,                 //                          .mem_dq
		inout  wire [3:0]  hps_ddr3_mem_dqs,                //                          .mem_dqs
		inout  wire [3:0]  hps_ddr3_mem_dqs_n,              //                          .mem_dqs_n
		output wire        hps_ddr3_mem_odt,                //                          .mem_odt
		output wire [3:0]  hps_ddr3_mem_dm,                 //                          .mem_dm
		input  wire        hps_ddr3_oct_rzqin,              //                          .oct_rzqin
		input  wire        reset_reset_n                    //                     reset.reset_n
	);

	wire  [31:0] hps_0_f2h_irq0_irq; // irq_mapper:sender_irq -> hps_0:f2h_irq_p0
	wire  [31:0] hps_0_f2h_irq1_irq; // irq_mapper_001:sender_irq -> hps_0:f2h_irq_p1

	windowmem hann_to_fft_buf (
		.data      (hann_to_fft_buf_memwriter_data),  // memwriter.data
		.wraddress (hann_to_fft_buf_memwriter_addr),  //          .addr
		.wren      (hann_to_fft_buf_memwriter_valid), //          .valid
		.rdaddress (hann_to_fft_buf_memreader_addr),  // memreader.addr
		.q         (hann_to_fft_buf_memreader_data),  //          .data
		.clock     (clk_clk)                          //     clock.clk
	);

	soc_system_hps_0 #(
		.F2S_Width (2),
		.S2F_Width (2)
	) hps_0 (
		.h2f_user1_clk            (),                             //   h2f_user1_clock.clk
		.mem_a                    (hps_ddr3_mem_a),               //            memory.mem_a
		.mem_ba                   (hps_ddr3_mem_ba),              //                  .mem_ba
		.mem_ck                   (hps_ddr3_mem_ck),              //                  .mem_ck
		.mem_ck_n                 (hps_ddr3_mem_ck_n),            //                  .mem_ck_n
		.mem_cke                  (hps_ddr3_mem_cke),             //                  .mem_cke
		.mem_cs_n                 (hps_ddr3_mem_cs_n),            //                  .mem_cs_n
		.mem_ras_n                (hps_ddr3_mem_ras_n),           //                  .mem_ras_n
		.mem_cas_n                (hps_ddr3_mem_cas_n),           //                  .mem_cas_n
		.mem_we_n                 (hps_ddr3_mem_we_n),            //                  .mem_we_n
		.mem_reset_n              (hps_ddr3_mem_reset_n),         //                  .mem_reset_n
		.mem_dq                   (hps_ddr3_mem_dq),              //                  .mem_dq
		.mem_dqs                  (hps_ddr3_mem_dqs),             //                  .mem_dqs
		.mem_dqs_n                (hps_ddr3_mem_dqs_n),           //                  .mem_dqs_n
		.mem_odt                  (hps_ddr3_mem_odt),             //                  .mem_odt
		.mem_dm                   (hps_ddr3_mem_dm),              //                  .mem_dm
		.oct_rzqin                (hps_ddr3_oct_rzqin),           //                  .oct_rzqin
		.hps_io_emac1_inst_TX_CLK (hps_hps_io_emac1_inst_TX_CLK), //            hps_io.hps_io_emac1_inst_TX_CLK
		.hps_io_emac1_inst_TXD0   (hps_hps_io_emac1_inst_TXD0),   //                  .hps_io_emac1_inst_TXD0
		.hps_io_emac1_inst_TXD1   (hps_hps_io_emac1_inst_TXD1),   //                  .hps_io_emac1_inst_TXD1
		.hps_io_emac1_inst_TXD2   (hps_hps_io_emac1_inst_TXD2),   //                  .hps_io_emac1_inst_TXD2
		.hps_io_emac1_inst_TXD3   (hps_hps_io_emac1_inst_TXD3),   //                  .hps_io_emac1_inst_TXD3
		.hps_io_emac1_inst_RXD0   (hps_hps_io_emac1_inst_RXD0),   //                  .hps_io_emac1_inst_RXD0
		.hps_io_emac1_inst_MDIO   (hps_hps_io_emac1_inst_MDIO),   //                  .hps_io_emac1_inst_MDIO
		.hps_io_emac1_inst_MDC    (hps_hps_io_emac1_inst_MDC),    //                  .hps_io_emac1_inst_MDC
		.hps_io_emac1_inst_RX_CTL (hps_hps_io_emac1_inst_RX_CTL), //                  .hps_io_emac1_inst_RX_CTL
		.hps_io_emac1_inst_TX_CTL (hps_hps_io_emac1_inst_TX_CTL), //                  .hps_io_emac1_inst_TX_CTL
		.hps_io_emac1_inst_RX_CLK (hps_hps_io_emac1_inst_RX_CLK), //                  .hps_io_emac1_inst_RX_CLK
		.hps_io_emac1_inst_RXD1   (hps_hps_io_emac1_inst_RXD1),   //                  .hps_io_emac1_inst_RXD1
		.hps_io_emac1_inst_RXD2   (hps_hps_io_emac1_inst_RXD2),   //                  .hps_io_emac1_inst_RXD2
		.hps_io_emac1_inst_RXD3   (hps_hps_io_emac1_inst_RXD3),   //                  .hps_io_emac1_inst_RXD3
		.hps_io_sdio_inst_CMD     (hps_hps_io_sdio_inst_CMD),     //                  .hps_io_sdio_inst_CMD
		.hps_io_sdio_inst_D0      (hps_hps_io_sdio_inst_D0),      //                  .hps_io_sdio_inst_D0
		.hps_io_sdio_inst_D1      (hps_hps_io_sdio_inst_D1),      //                  .hps_io_sdio_inst_D1
		.hps_io_sdio_inst_CLK     (hps_hps_io_sdio_inst_CLK),     //                  .hps_io_sdio_inst_CLK
		.hps_io_sdio_inst_D2      (hps_hps_io_sdio_inst_D2),      //                  .hps_io_sdio_inst_D2
		.hps_io_sdio_inst_D3      (hps_hps_io_sdio_inst_D3),      //                  .hps_io_sdio_inst_D3
		.hps_io_usb1_inst_D0      (hps_hps_io_usb1_inst_D0),      //                  .hps_io_usb1_inst_D0
		.hps_io_usb1_inst_D1      (hps_hps_io_usb1_inst_D1),      //                  .hps_io_usb1_inst_D1
		.hps_io_usb1_inst_D2      (hps_hps_io_usb1_inst_D2),      //                  .hps_io_usb1_inst_D2
		.hps_io_usb1_inst_D3      (hps_hps_io_usb1_inst_D3),      //                  .hps_io_usb1_inst_D3
		.hps_io_usb1_inst_D4      (hps_hps_io_usb1_inst_D4),      //                  .hps_io_usb1_inst_D4
		.hps_io_usb1_inst_D5      (hps_hps_io_usb1_inst_D5),      //                  .hps_io_usb1_inst_D5
		.hps_io_usb1_inst_D6      (hps_hps_io_usb1_inst_D6),      //                  .hps_io_usb1_inst_D6
		.hps_io_usb1_inst_D7      (hps_hps_io_usb1_inst_D7),      //                  .hps_io_usb1_inst_D7
		.hps_io_usb1_inst_CLK     (hps_hps_io_usb1_inst_CLK),     //                  .hps_io_usb1_inst_CLK
		.hps_io_usb1_inst_STP     (hps_hps_io_usb1_inst_STP),     //                  .hps_io_usb1_inst_STP
		.hps_io_usb1_inst_DIR     (hps_hps_io_usb1_inst_DIR),     //                  .hps_io_usb1_inst_DIR
		.hps_io_usb1_inst_NXT     (hps_hps_io_usb1_inst_NXT),     //                  .hps_io_usb1_inst_NXT
		.hps_io_spim1_inst_CLK    (hps_hps_io_spim1_inst_CLK),    //                  .hps_io_spim1_inst_CLK
		.hps_io_spim1_inst_MOSI   (hps_hps_io_spim1_inst_MOSI),   //                  .hps_io_spim1_inst_MOSI
		.hps_io_spim1_inst_MISO   (hps_hps_io_spim1_inst_MISO),   //                  .hps_io_spim1_inst_MISO
		.hps_io_spim1_inst_SS0    (hps_hps_io_spim1_inst_SS0),    //                  .hps_io_spim1_inst_SS0
		.hps_io_uart0_inst_RX     (hps_hps_io_uart0_inst_RX),     //                  .hps_io_uart0_inst_RX
		.hps_io_uart0_inst_TX     (hps_hps_io_uart0_inst_TX),     //                  .hps_io_uart0_inst_TX
		.hps_io_i2c0_inst_SDA     (hps_hps_io_i2c0_inst_SDA),     //                  .hps_io_i2c0_inst_SDA
		.hps_io_i2c0_inst_SCL     (hps_hps_io_i2c0_inst_SCL),     //                  .hps_io_i2c0_inst_SCL
		.hps_io_i2c1_inst_SDA     (hps_hps_io_i2c1_inst_SDA),     //                  .hps_io_i2c1_inst_SDA
		.hps_io_i2c1_inst_SCL     (hps_hps_io_i2c1_inst_SCL),     //                  .hps_io_i2c1_inst_SCL
		.hps_io_gpio_inst_GPIO09  (hps_hps_io_gpio_inst_GPIO09),  //                  .hps_io_gpio_inst_GPIO09
		.hps_io_gpio_inst_GPIO35  (hps_hps_io_gpio_inst_GPIO35),  //                  .hps_io_gpio_inst_GPIO35
		.hps_io_gpio_inst_GPIO40  (hps_hps_io_gpio_inst_GPIO40),  //                  .hps_io_gpio_inst_GPIO40
		.hps_io_gpio_inst_GPIO48  (hps_hps_io_gpio_inst_GPIO48),  //                  .hps_io_gpio_inst_GPIO48
		.hps_io_gpio_inst_GPIO53  (hps_hps_io_gpio_inst_GPIO53),  //                  .hps_io_gpio_inst_GPIO53
		.hps_io_gpio_inst_GPIO54  (hps_hps_io_gpio_inst_GPIO54),  //                  .hps_io_gpio_inst_GPIO54
		.hps_io_gpio_inst_GPIO61  (hps_hps_io_gpio_inst_GPIO61),  //                  .hps_io_gpio_inst_GPIO61
		.h2f_rst_n                (),                             //         h2f_reset.reset_n
		.h2f_axi_clk              (clk_clk),                      //     h2f_axi_clock.clk
		.h2f_AWID                 (),                             //    h2f_axi_master.awid
		.h2f_AWADDR               (),                             //                  .awaddr
		.h2f_AWLEN                (),                             //                  .awlen
		.h2f_AWSIZE               (),                             //                  .awsize
		.h2f_AWBURST              (),                             //                  .awburst
		.h2f_AWLOCK               (),                             //                  .awlock
		.h2f_AWCACHE              (),                             //                  .awcache
		.h2f_AWPROT               (),                             //                  .awprot
		.h2f_AWVALID              (),                             //                  .awvalid
		.h2f_AWREADY              (),                             //                  .awready
		.h2f_WID                  (),                             //                  .wid
		.h2f_WDATA                (),                             //                  .wdata
		.h2f_WSTRB                (),                             //                  .wstrb
		.h2f_WLAST                (),                             //                  .wlast
		.h2f_WVALID               (),                             //                  .wvalid
		.h2f_WREADY               (),                             //                  .wready
		.h2f_BID                  (),                             //                  .bid
		.h2f_BRESP                (),                             //                  .bresp
		.h2f_BVALID               (),                             //                  .bvalid
		.h2f_BREADY               (),                             //                  .bready
		.h2f_ARID                 (),                             //                  .arid
		.h2f_ARADDR               (),                             //                  .araddr
		.h2f_ARLEN                (),                             //                  .arlen
		.h2f_ARSIZE               (),                             //                  .arsize
		.h2f_ARBURST              (),                             //                  .arburst
		.h2f_ARLOCK               (),                             //                  .arlock
		.h2f_ARCACHE              (),                             //                  .arcache
		.h2f_ARPROT               (),                             //                  .arprot
		.h2f_ARVALID              (),                             //                  .arvalid
		.h2f_ARREADY              (),                             //                  .arready
		.h2f_RID                  (),                             //                  .rid
		.h2f_RDATA                (),                             //                  .rdata
		.h2f_RRESP                (),                             //                  .rresp
		.h2f_RLAST                (),                             //                  .rlast
		.h2f_RVALID               (),                             //                  .rvalid
		.h2f_RREADY               (),                             //                  .rready
		.f2h_axi_clk              (clk_clk),                      //     f2h_axi_clock.clk
		.f2h_AWID                 (),                             //     f2h_axi_slave.awid
		.f2h_AWADDR               (),                             //                  .awaddr
		.f2h_AWLEN                (),                             //                  .awlen
		.f2h_AWSIZE               (),                             //                  .awsize
		.f2h_AWBURST              (),                             //                  .awburst
		.f2h_AWLOCK               (),                             //                  .awlock
		.f2h_AWCACHE              (),                             //                  .awcache
		.f2h_AWPROT               (),                             //                  .awprot
		.f2h_AWVALID              (),                             //                  .awvalid
		.f2h_AWREADY              (),                             //                  .awready
		.f2h_AWUSER               (),                             //                  .awuser
		.f2h_WID                  (),                             //                  .wid
		.f2h_WDATA                (),                             //                  .wdata
		.f2h_WSTRB                (),                             //                  .wstrb
		.f2h_WLAST                (),                             //                  .wlast
		.f2h_WVALID               (),                             //                  .wvalid
		.f2h_WREADY               (),                             //                  .wready
		.f2h_BID                  (),                             //                  .bid
		.f2h_BRESP                (),                             //                  .bresp
		.f2h_BVALID               (),                             //                  .bvalid
		.f2h_BREADY               (),                             //                  .bready
		.f2h_ARID                 (),                             //                  .arid
		.f2h_ARADDR               (),                             //                  .araddr
		.f2h_ARLEN                (),                             //                  .arlen
		.f2h_ARSIZE               (),                             //                  .arsize
		.f2h_ARBURST              (),                             //                  .arburst
		.f2h_ARLOCK               (),                             //                  .arlock
		.f2h_ARCACHE              (),                             //                  .arcache
		.f2h_ARPROT               (),                             //                  .arprot
		.f2h_ARVALID              (),                             //                  .arvalid
		.f2h_ARREADY              (),                             //                  .arready
		.f2h_ARUSER               (),                             //                  .aruser
		.f2h_RID                  (),                             //                  .rid
		.f2h_RDATA                (),                             //                  .rdata
		.f2h_RRESP                (),                             //                  .rresp
		.f2h_RLAST                (),                             //                  .rlast
		.f2h_RVALID               (),                             //                  .rvalid
		.f2h_RREADY               (),                             //                  .rready
		.h2f_lw_axi_clk           (clk_clk),                      //  h2f_lw_axi_clock.clk
		.h2f_lw_AWID              (),                             // h2f_lw_axi_master.awid
		.h2f_lw_AWADDR            (),                             //                  .awaddr
		.h2f_lw_AWLEN             (),                             //                  .awlen
		.h2f_lw_AWSIZE            (),                             //                  .awsize
		.h2f_lw_AWBURST           (),                             //                  .awburst
		.h2f_lw_AWLOCK            (),                             //                  .awlock
		.h2f_lw_AWCACHE           (),                             //                  .awcache
		.h2f_lw_AWPROT            (),                             //                  .awprot
		.h2f_lw_AWVALID           (),                             //                  .awvalid
		.h2f_lw_AWREADY           (),                             //                  .awready
		.h2f_lw_WID               (),                             //                  .wid
		.h2f_lw_WDATA             (),                             //                  .wdata
		.h2f_lw_WSTRB             (),                             //                  .wstrb
		.h2f_lw_WLAST             (),                             //                  .wlast
		.h2f_lw_WVALID            (),                             //                  .wvalid
		.h2f_lw_WREADY            (),                             //                  .wready
		.h2f_lw_BID               (),                             //                  .bid
		.h2f_lw_BRESP             (),                             //                  .bresp
		.h2f_lw_BVALID            (),                             //                  .bvalid
		.h2f_lw_BREADY            (),                             //                  .bready
		.h2f_lw_ARID              (),                             //                  .arid
		.h2f_lw_ARADDR            (),                             //                  .araddr
		.h2f_lw_ARLEN             (),                             //                  .arlen
		.h2f_lw_ARSIZE            (),                             //                  .arsize
		.h2f_lw_ARBURST           (),                             //                  .arburst
		.h2f_lw_ARLOCK            (),                             //                  .arlock
		.h2f_lw_ARCACHE           (),                             //                  .arcache
		.h2f_lw_ARPROT            (),                             //                  .arprot
		.h2f_lw_ARVALID           (),                             //                  .arvalid
		.h2f_lw_ARREADY           (),                             //                  .arready
		.h2f_lw_RID               (),                             //                  .rid
		.h2f_lw_RDATA             (),                             //                  .rdata
		.h2f_lw_RRESP             (),                             //                  .rresp
		.h2f_lw_RLAST             (),                             //                  .rlast
		.h2f_lw_RVALID            (),                             //                  .rvalid
		.h2f_lw_RREADY            (),                             //                  .rready
		.f2h_irq_p0               (hps_0_f2h_irq0_irq),           //          f2h_irq0.irq
		.f2h_irq_p1               (hps_0_f2h_irq1_irq)            //          f2h_irq1.irq
	);

	soc_system_irq_mapper irq_mapper (
		.clk        (),                   //       clk.clk
		.reset      (),                   // clk_reset.reset
		.sender_irq (hps_0_f2h_irq0_irq)  //    sender.irq
	);

	soc_system_irq_mapper irq_mapper_001 (
		.clk        (),                   //       clk.clk
		.reset      (),                   // clk_reset.reset
		.sender_irq (hps_0_f2h_irq1_irq)  //    sender.irq
	);

endmodule