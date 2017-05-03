`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 08:28:54 PM
// Design Name: 
// Module Name: IFID_Stage
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


module IFID_Stage(
    input clock,
    input reset,
    input ID_Stall,
    input IF_Flush,
    
    input  [31:0] IF_Instruction,
    input  [31:0] IF_PCAdd4,
    output reg [31:0] ID_Instruction,
    output reg [31:0] ID_PCAdd4
    );
    
always @(posedge clock) begin
    //ID_Instruction <= (reset) ? 32'b0 : ((ID_Stall) ? ID_Instruction : ((IF_Stall | IF_Flush) ? 32'b0 : IF_Instruction));
    ID_Instruction <= (reset) ? 32'b0 : ((ID_Stall) ? ID_Instruction : ( IF_Instruction));
    ID_PCAdd4      <= (reset) ? 32'b0 : ((ID_Stall) ? ID_PCAdd4      : ( IF_PCAdd4));
end
    
endmodule
