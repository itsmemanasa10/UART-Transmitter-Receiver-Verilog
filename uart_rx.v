module uart_reciever (
    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input clken,
    output reg rdy,
    output reg [7:0] data_out
);

    parameter RX_STATE_START = 2'b00;
    parameter RX_STATE_DATA  = 2'b01;
    parameter RX_STATE_STOP  = 2'b10;

    reg [1:0] state;
    reg [3:0] sample;
    reg [3:0] index;
    reg [7:0] temp;


    always @(posedge clk) begin

        if (rst) begin
            rdy      <= 1'b0;
            data_out <= 8'h00;
            state    <= RX_STATE_START;
            sample   <= 4'h0;
            index    <= 4'h0;
            temp     <= 8'h00;
        end

        else begin

            if (rdy_clr)
                rdy <= 1'b0;


            if (clken) begin

                case (state)

                    RX_STATE_START: begin

                        if (!rx || sample != 0)
                            sample <= sample + 1'b1;

                        if (sample == 4'hF) begin
                            state  <= RX_STATE_DATA;
                            index  <= 4'h0;
                            sample <= 4'h0;
                            temp   <= 8'h00;
                        end

                    end


                    RX_STATE_DATA: begin

                        sample <= sample + 1'b1;

                        if (sample == 4'h8) begin
                            temp[index] <= rx;
                            index <= index + 1'b1;
                        end

                        if (index == 4'h8 && sample == 4'hF)
                            state <= RX_STATE_STOP;

                    end


                    RX_STATE_STOP: begin

                        if (sample == 4'hF) begin

                            state    <= RX_STATE_START;
                            data_out <= temp;
                            rdy      <= 1'b1;
                            sample   <= 4'h0;

                        end

                        else begin
                            sample <= sample + 1'b1;
                        end

                    end


                    default: begin
                        state  <= RX_STATE_START;
                        sample <= 4'h0;
                    end

                endcase

            end

        end

    end

endmodule
