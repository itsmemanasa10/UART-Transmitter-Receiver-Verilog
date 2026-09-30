module uart_top #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input clk,
    input rst,

    input tx_start,
    input [7:0] tx_data,
    output tx,
    output tx_done,

    input rx,
    output [7:0] rx_data,
    output rx_done
);

    wire tx_clk_en;
    wire rx_clk_en;

    wire tx_busy;
    wire rx_ready;

    wire [7:0] rx_data_internal;


    // Baud rate generator
    baud_rate_genrator #(
        .clk_freq(CLK_FREQ),
        .baud_rate(BAUD_RATE)
    ) brg (
        .clock(clk),
        .reset(rst),
        .enb_tx(tx_clk_en),
        .enb_rx(rx_clk_en)
    );


    // UART transmitter
    uart_sender us (
        .clk(clk),
        .wr_en(tx_start),
        .enb(tx_clk_en),
        .rst(rst),
        .data_in(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );


    // UART receiver
    uart_reciever ur (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rdy_clr(1'b0),
        .clken(rx_clk_en),
        .rdy(rx_ready),
        .data_out(rx_data_internal)
    );


    assign tx_done = ~tx_busy;
    assign rx_done = rx_ready;
    assign rx_data = rx_data_internal;

endmodule