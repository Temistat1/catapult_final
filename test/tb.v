`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module FIR_Filter_tb;

    // Parameters
    parameter DATA_WIDTH = 16;
    parameter COEFF_WIDTH = 16;
    parameter TAPS = 8;

    // Testbench signals
    reg clk;
    reg rst;
    reg valid_in;
    reg [DATA_WIDTH-1:0] data_in;
    wire valid_out;
    wire [DATA_WIDTH-1:0] data_out;

    // DUT instantiation
    FIR_Filter #(
        .DATA_WIDTH(DATA_WIDTH),
        .COEFF_WIDTH(COEFF_WIDTH),
        .TAPS(TAPS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .data_in(data_in),
        .valid_out(valid_out),
        .data_out(data_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Stimulus generation
    initial begin
        // Initialization
        rst = 1;
        valid_in = 0;
        data_in = 0;

        // Reset deassertion
        #20;
        rst = 0;

        // Test input data sequence
        valid_in = 1;
        data_in = 16'd1;  #10;
        data_in = 16'd2;  #10;
        data_in = 16'd3;  #10;
        data_in = 16'd4;  #10;
        data_in = 16'd5;  #10;
        data_in = 16'd6;  #10;
        data_in = 16'd7;  #10;
        data_in = 16'd8;  #10;

        // Wait for the filter to process the inputs
        valid_in = 0;
        #100;

        // End simulation
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | data_in: %d | data_out: %d | valid_out: %b", 
                 $time, data_in, data_out, valid_out);
    end

    // Expected output checker
    initial begin
        #30;
        // Add assertions to validate outputs
        // For example: assert(data_out == expected_value)
        // based on the known coefficients
    end

endmodule

