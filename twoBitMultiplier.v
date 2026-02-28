`timescale 1ns / 1ps

module twoBitMultiplier(
    input A0,
    input A1,
    input B0,
    input B1,
    output P0,
    output P1,
    output P2,
    output P3
    );
    wire c1,c2;

    assign P0 = A0 & B0;
    assign P1 = (A1&B1) ^ (A0&B1);
    assign c1 = (A1&B1) & (A0&B1);
    assign P2 = (A1&B1) ^ (c1);
    assign c2 = (A1&B1) & (c1);
    assign P3 = c2;    
endmodule
