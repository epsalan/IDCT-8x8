`timescale 1ns / 1ps

module output_scaler (
    input signed [31:0] idct_value,
    output reg [7:0] pixel_out  // Unsigned 8-bit output
);
    reg signed [7:0] temp;

    always @(*) begin
        temp = idct_value[15:8];  // Extract the relevant bits
        
        // Clamping logic
        if (temp < 0) 
            pixel_out = 8'd0;        // Clamp to 0
        else if (temp > 8'sd127)  // Max positive signed 8-bit is 127
            pixel_out = 8'd255;      // Clamp to 255
        else 
            pixel_out = temp[7:0];   // Assign valid range value
    end
endmodule
