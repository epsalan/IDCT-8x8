`timescale 1ns / 1ps

module mac_unit (
    
    input clk,
    input rst,
    input start,
    input signed [15:0] data,
    input signed [15:0] weight,
    output reg signed [31:0] mac_out,
    output reg done
);
    reg signed [31:0] accumulator;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 0;
            mac_out <= 0;
            done <= 0;
        end else if (start) begin
            accumulator <= data * weight;
            mac_out <= accumulator;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
