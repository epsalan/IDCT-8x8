`timescale 1ns / 1ps

module idct_tb;
    // Clock and Reset
    reg clk;
    reg rst;
    reg start;  // Added start signal

    // Flattened Inputs and Outputs as Packed Vectors
    reg [1023:0] f_mem_flat;     
    wire [511:0] output_data_flat; 

    // Flattened Expected Output
    reg [511:0] expected_out_flat;

    // Error Counter
    integer i;
    integer error_count = 0;

    // Instantiate IDCT Module with Flattened I/O
    idct uut (
        .clk(clk),
        .rst(rst),
        .start(start),  
        .f_mem_flat(f_mem_flat),  // ✅ Use flattened vector
        .output_data_flat(output_data_flat),  // ✅ Use flattened vector
        .done(done)
    );

    // Clock Generation (10ns period, 50% duty cycle)
    always #5 clk = ~clk;

    // Test Procedure
    initial begin
        // Initialize Clock and Reset
        clk = 0;
        rst = 1;
        start = 0;
        #50;  // Increased reset duration
        rst = 0;
        #10;

        // Initialize Input Data (Flattened Format)
        f_mem_flat = {
            16'd10, 16'd20, 16'd30, 16'd40, 16'd50, 16'd60, 16'd70, 16'd80,
            16'd15, 16'd25, 16'd35, 16'd45, 16'd55, 16'd65, 16'd75, 16'd85,
            16'd20, 16'd30, 16'd40, 16'd50, 16'd60, 16'd70, 16'd80, 16'd90,
            16'd25, 16'd35, 16'd45, 16'd55, 16'd65, 16'd75, 16'd85, 16'd95,
            16'd30, 16'd40, 16'd50, 16'd60, 16'd70, 16'd80, 16'd90, 16'd100,
            16'd35, 16'd45, 16'd55, 16'd65, 16'd75, 16'd85, 16'd95, 16'd105,
            16'd40, 16'd50, 16'd60, 16'd70, 16'd80, 16'd90, 16'd100, 16'd110,
            16'd45, 16'd55, 16'd65, 16'd75, 16'd85, 16'd95, 16'd105, 16'd115
        };

        // Expected Output Data (Flattened)
        expected_out_flat = {
            8'd16,  8'd32,  8'd48,  8'd64,  8'd80,  8'd96,  8'd112, 8'd128,
            8'd18,  8'd36,  8'd54,  8'd72,  8'd90,  8'd108, 8'd126, 8'd144,
            8'd20,  8'd40,  8'd60,  8'd80,  8'd100, 8'd120, 8'd140, 8'd160,
            8'd22,  8'd44,  8'd66,  8'd88,  8'd110, 8'd132, 8'd154, 8'd176,
            8'd24,  8'd48,  8'd72,  8'd96,  8'd120, 8'd144, 8'd168, 8'd192,
            8'd26,  8'd52,  8'd78,  8'd104, 8'd130, 8'd156, 8'd182, 8'd208,
            8'd28,  8'd56,  8'd84,  8'd112, 8'd140, 8'd168, 8'd196, 8'd224,
            8'd30,  8'd60,  8'd90,  8'd120, 8'd150, 8'd180, 8'd210, 8'd240
        };

        // Start Computation
        start = 1;
        #10;
        start = 0;

        // Wait for computation to finish
        wait (uut.done);

        // Comparison and Debugging Output
        error_count = 0;
        for (i = 0; i < 64; i = i + 1) begin
            if (output_data_flat[(i*8) +: 8] !== expected_out_flat[(i*8) +: 8]) begin
                $display("[%0t] Mismatch at index %d: Expected = %d, Got = %d", 
                         $time, i, expected_out_flat[(i*8) +: 8], output_data_flat[(i*8) +: 8]);
                error_count = error_count + 1;
            end
        end

        // Print Final Result
        if (error_count == 0)
            $display("[%0t] Test Passed: All outputs match!", $time);
        else
            $display("[%0t] Test Failed: %d mismatches found!", $time, error_count);

        // Dump VCD for debugging
        $dumpfile("idct_wave.vcd");
        $dumpvars(0, idct_tb);

        // Finish Simulation
        #10 $finish;
    end
endmodule  
