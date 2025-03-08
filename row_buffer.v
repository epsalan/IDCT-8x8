`timescale 1ns / 1ps

module row_buffer (
    

    input clk, rst, write_enable, read_enable,
    input [5:0] index, 
    input signed [15:0] data_in,
    output reg signed [15:0] data_out
);
    reg signed [15:0] buffer [0:63];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 64; i = i + 1)
                buffer[i] <= 0;
        end else if (write_enable) begin
            buffer[index] <= data_in;
        end
    end

    always @(*) begin
        if (read_enable) data_out = buffer[index]; // Read only when enabled
    end
endmodule
