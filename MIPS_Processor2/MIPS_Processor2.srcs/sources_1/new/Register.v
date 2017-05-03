`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 08:29:50 PM
// Design Name: 
// Module Name: Register
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


module Register #(parameter WIDTH = 32, INIT = 0)(
    input  clock,
    input  reset,
    input  enable,
    input  [(WIDTH-1):0] D,
    output reg [(WIDTH-1):0] Q
    );
    
initial
    Q = INIT;
always @(posedge clock) begin
    Q <= (reset) ? INIT : ((enable) ? D : Q);
end
        
endmodule
