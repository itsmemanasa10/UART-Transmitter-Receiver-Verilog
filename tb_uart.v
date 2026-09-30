`timescale 1ns / 1ps

module tb_uart;

    reg clk;
    reg rst;

    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_done;

    wire rx;
    wire [7:0] rx_data;
    wire rx_done;


    // Loopback connection
    assign rx = tx;


    // DUT
    uart_top #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) uut (

        .clk(clk),
        .rst(rst),

        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done),

        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)

    );


    // 50 MHz clock
    always #10 clk = ~clk;


    initial begin

        clk = 0;
        rst = 1;

        tx_start = 0;
        tx_data = 8'h00;


        // Reset
        #100;
        rst = 0;


        // Wait
        #100;


        // Send AA
        tx_data = 8'hAA;
        tx_start = 1;

        #20;
        tx_start = 0;


        // Wait for receiver
        wait(rx_done == 1);


        // Check received data
        if (rx_data == 8'hAA)
            $display("SUCCESS: Sent 0xAA, Received 0xAA");
        else
            $display("FAILURE: Sent 0xAA, Received 0x%h", rx_data);


        #1000;

        $stop;

    end

endmodule