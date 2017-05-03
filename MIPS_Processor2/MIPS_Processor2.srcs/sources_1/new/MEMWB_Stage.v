`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 11:32:16 PM
// Design Name: 
// Module Name: MEMWB_Stage
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


module MEMWB_Stage(
    input clock,
    input reset,
    input [4:0] M_Target, //jal
    input [31:0] M_ALUResult,
    input [31:0] M_MemData,
    input M_weHI, M_weLO,
    input [31:0] M_hi, M_lo,
    input M_WriteReg,
    input M_MemOrAlu,
    
    output reg [4:0] WB_Target,
    output reg [31:0] WB_ALUResult,
    output reg [31:0] WB_MemData,
    output reg WB_weHI, WB_weLO,
    output reg [31:0] WB_hi, WB_lo,
    output reg WB_WriteReg,
    output reg WB_MemOrAlu
    );
    
always @(posedge clock) begin
    WB_Target <= (reset) ? 0 : M_Target;
    WB_ALUResult <= (reset) ? 0 : M_ALUResult;
    WB_MemData <= (reset) ? 0 : M_MemData;
    WB_weHI <= (reset) ? 0 : M_weHI;
    WB_weLO <= (reset) ? 0 : M_weLO;
    WB_hi <= (reset) ? 0 : M_hi;
    WB_lo <= (reset) ? 0 : M_lo;
    WB_WriteReg <= (reset) ? 0 : M_WriteReg;
    WB_MemOrAlu <= (reset) ? 0 : M_MemOrAlu;
end
endmodule
