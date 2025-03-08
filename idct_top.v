`timescale 1ns / 1ps

module idct_top (
    input clk,
    input rst,
    input start,
    input signed [15:0] F_in,
    output signed [7:0] idct_out,
    output done
);

    wire signed [31:0] mac_result;
    wire mac_done;
    wire signed [15:0] weight;
    wire signed [15:0] row_buffer_data;  
    wire load_row, load_col, mac_enable;

    reg [2:0] row_idx;  
    reg [2:0] col_idx;  

    // Weight Matrix Instantiation
    weight_matrix weight_table (
        .row(row_idx),
        .col(col_idx),
        .weight(weight)
    );

    // MAC Unit Instantiation
    mac_unit mac (
        .clk(clk),
        .rst(rst),
        .start(mac_enable),  
        .data(load_col ? row_buffer_data : F_in),  // ✅ Corrected: MAC reads from row buffer for column ops
        .weight(weight), 
        .mac_out(mac_result),
        .done(mac_done)
    );

    // Row Buffer Instantiation
    row_buffer row_buf (
        .clk(clk),
        .rst(rst),
        .write_enable(load_row),
        .index(row_idx),  
        .data_in(mac_result[23:8]),  
        .data_out(row_buffer_data)   // ✅ Ensures data is available for MAC column operations
    );

    // FSM Controller Instantiation
    idct_fsm fsm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mac_done(mac_done),
        .mac_enable(mac_enable),   
        .load_row(load_row),       
        .load_col(load_col),       
        .done(done)  // ✅ Direct connection, no need for fsm_done
    );

    // Output Scaler
    output_scaler scaler (
        .idct_value(mac_result),
        .pixel_out(idct_out)
    );

    // Row and Column Index Management
    always @(posedge clk or posedge rst) begin
        if (rst)
            row_idx <= 0;  
        else if (load_row && row_idx < 7)  
            row_idx <= row_idx + 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            col_idx <= 0;  
        else if (load_col && col_idx < 7)  
            col_idx <= col_idx + 1;
    end

endmodule
