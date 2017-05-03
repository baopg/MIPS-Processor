`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 08:29:26 PM
// Design Name: 
// Module Name: Mux2to1
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


module Mux2to1 #(parameter WIDTH = 32) (
    input  sel,
    input  [(WIDTH-1):0] in_0, in_1,
    output [(WIDTH-1):0] out
    );

assign out = (sel) ? in_1 : in_0;
    
endmodule
