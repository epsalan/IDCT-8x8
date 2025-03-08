module weight_matrix (
    input wire clk,
    input wire rst,
    input wire [2:0] row,
    input wire [2:0] col,
    output reg signed [15:0] weight
);

    // Local Parameters
    localparam ROWS = 8;
    localparam COLS = 8;

    // LUT with 64 entries (for an 8x8 matrix)
    reg signed [15:0] weight_lut [0:63];

    // Row and column indices (ensured within limits)
    reg [2:0] row_idx, col_idx;

    // Initialize the LUT (example values)
     initial begin
        weight_lut[0]  =  16'd181;  weight_lut[1]  =  16'd181;  weight_lut[2]  =  16'd181;  weight_lut[3]  =  16'd181;
        weight_lut[4]  =  16'd181;  weight_lut[5]  =  16'd181;  weight_lut[6]  =  16'd181;  weight_lut[7]  =  16'd181;

        weight_lut[8]  =  16'd251;  weight_lut[9]  =  16'd213;  weight_lut[10] =  16'd142;  weight_lut[11] =  16'd50;
        weight_lut[12] = -16'sd50;  weight_lut[13] = -16'sd142; weight_lut[14] = -16'sd213; weight_lut[15] = -16'sd251;

        weight_lut[16] =  16'd236;  weight_lut[17] =  16'd98;   weight_lut[18] = -16'sd98;  weight_lut[19] = -16'sd236;
        weight_lut[20] = -16'sd236; weight_lut[21] = -16'sd98;  weight_lut[22] =  16'd98;   weight_lut[23] =  16'd236;

        weight_lut[24] =  16'd213;  weight_lut[25] = -16'sd50;  weight_lut[26] = -16'sd251; weight_lut[27] = -16'sd142;
        weight_lut[28] =  16'd142;  weight_lut[29] =  16'd251;  weight_lut[30] =  16'd50;   weight_lut[31] = -16'sd213;

        weight_lut[32] =  16'd181;  weight_lut[33] = -16'sd181; weight_lut[34] = -16'sd181; weight_lut[35] =  16'd181;
        weight_lut[36] =  16'd181;  weight_lut[37] = -16'sd181; weight_lut[38] = -16'sd181; weight_lut[39] =  16'd181;

        weight_lut[40] =  16'd142;  weight_lut[41] = -16'sd251; weight_lut[42] =  16'd50;   weight_lut[43] =  16'd213;
        weight_lut[44] = -16'sd213; weight_lut[45] = -16'sd50;  weight_lut[46] =  16'd251;  weight_lut[47] = -16'sd142;

        weight_lut[48] =  16'd98;   weight_lut[49] = -16'sd236; weight_lut[50] =  16'd236;  weight_lut[51] = -16'sd98;
        weight_lut[52] = -16'sd98;  weight_lut[53] =  16'd236;  weight_lut[54] = -16'sd236; weight_lut[55] =  16'd98;

        weight_lut[56] =  16'd50;   weight_lut[57] = -16'sd142; weight_lut[58] =  16'd213;  weight_lut[59] = -16'sd251;
        weight_lut[60] =  16'd251;  weight_lut[61] = -16'sd213; weight_lut[62] =  16'd142;  weight_lut[63] = -16'sd50;
    end

    // Ensuring row_idx and col_idx stay within bounds
    always @(posedge clk or posedge rst) begin
        if (rst)
            row_idx <= 3'd0;
        else if (row_idx < 3'd7)
            row_idx <= row_idx + 3'd1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            col_idx <= 3'd0;
        else if (col_idx < 3'd7)
            col_idx <= col_idx + 3'd1;
    end

    // LUT access logic with bounds check
    always @(*) begin
        if (row < ROWS && col < COLS)  // Prevent out-of-bounds index
            weight = weight_lut[row * COLS + col];
        else
            weight = 16'sd0;  // Default safe value
    end
