`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2017 01:29:19 AM
// Design Name: 
// Module Name: Hazard
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


module Hazard(
    input reset,
    input EX_ReadMem,
    input ID_WriteMem,
    input [4:0] ID_ReadAddr1,
    input [4:0] ID_ReadAddr2,
    input [4:0] EX_Target,
    
    output IF_Stall,
    output ID_Stall,
    output EX_Stall
    );

assign IF_Stall = (reset) ? 1'b1 : EX_ReadMem & ~ID_WriteMem & (ID_ReadAddr1 == EX_Target | ID_ReadAddr2 == EX_Target);
assign ID_Stall = (reset) ? 1'b1 : EX_ReadMem & ~ID_WriteMem & (ID_ReadAddr1 == EX_Target | ID_ReadAddr2 == EX_Target);
assign EX_Stall = (reset) ? 1'b1 : EX_ReadMem & ~ID_WriteMem & (ID_ReadAddr1 == EX_Target | ID_ReadAddr2 == EX_Target);

endmodule
