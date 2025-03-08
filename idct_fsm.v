`timescale 1ns / 1ps

module idct_fsm (
    input wire clk, rst, start, mac_done,
    output reg mac_enable, load_row, load_col, done
);
    localparam IDLE        = 3'b000,  
               LOAD_ROW    = 3'b001,  
               COMPUTE_ROW = 3'b010,  
               LOAD_COL    = 3'b011,  
               COMPUTE_COL = 3'b100,  
               FINISH      = 3'b101;  

    reg [2:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:        if (start) next_state = LOAD_ROW;
            LOAD_ROW:    next_state = COMPUTE_ROW;
            COMPUTE_ROW: if (mac_done) next_state = LOAD_COL;  // Wait for MAC to finish
            LOAD_COL:    next_state = COMPUTE_COL;
            COMPUTE_COL: if (mac_done) next_state = FINISH;    // Wait for MAC to finish
            FINISH:      if (!start) next_state = IDLE;
        endcase
    end

    always @(*) begin
        {mac_enable, load_row, load_col, done} = 4'b0000;
        case (state)
            LOAD_ROW:    load_row = 1;
            COMPUTE_ROW: mac_enable = 1;
            LOAD_COL:    load_col = 1;
            COMPUTE_COL: mac_enable = 1;
            FINISH:      done = 1;
        endcase
    end
endmodule
