`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2017 01:48:34 PM
// Design Name: 
// Module Name: Mux4to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux4to1 #(parameter WIDTH = 32) (
    input  [1:0] sel,
    input  [(WIDTH-1):0] in0, in1, in2, in3,
    output [(WIDTH-1):0] out
    );

assign out = (sel == 2'b00) ? in0 : ((sel == 2'b01) ? in1 : ((sel == 2'b10) ? in2 : in3));

endmodule
