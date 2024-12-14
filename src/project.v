/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

module FIR_Filter #(
    parameter DATA_WIDTH = 16,    // Width of the input/output data
    parameter COEFF_WIDTH = 16,  // Width of the filter coefficients
    parameter TAPS = 8           // Number of filter taps
)(
    input wire clk,                     // System clock
    input wire rst,                     // Reset signal (active high)
    input wire valid_in,                // Input data valid signal
    input wire [DATA_WIDTH-1:0] data_in,// Input data
    output reg valid_out,               // Output data valid signal
    output reg [DATA_WIDTH-1:0] data_out // Filtered output data
);

    // Coefficient array
    reg [COEFF_WIDTH-1:0] coeffs [0:TAPS-1];
    
    // Data pipeline registers
    reg [DATA_WIDTH-1:0] pipeline [0:TAPS-1];
    
    // Accumulator for output
    reg [DATA_WIDTH+COEFF_WIDTH-1:0] acc;

    integer i;

    // Coefficients initialization (hardcoded for this example)
    initial begin
        coeffs[0] = 16'd1; // Replace these values with actual coefficients
        coeffs[1] = 16'd2;
        coeffs[2] = 16'd3;
        coeffs[3] = 16'd4;
        coeffs[4] = 16'd4;
        coeffs[5] = 16'd3;
        coeffs[6] = 16'd2;
        coeffs[7] = 16'd1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            for (i = 0; i < TAPS; i = i + 1) begin
                pipeline[i] <= 0;
            end
            acc <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            // Shift pipeline and accumulate
            acc = 0;
            for (i = TAPS-1; i > 0; i = i - 1) begin
                pipeline[i] <= pipeline[i-1];
                acc = acc + (pipeline[i] * coeffs[i]);
            end
            pipeline[0] <= data_in;
            acc = acc + (data_in * coeffs[0]);

            // Update output
            data_out <= acc[DATA_WIDTH+COEFF_WIDTH-1:COEFF_WIDTH]; // Truncate to output width
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

endmodule
