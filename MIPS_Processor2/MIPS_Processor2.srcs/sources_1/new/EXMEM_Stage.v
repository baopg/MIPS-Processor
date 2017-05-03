`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 11:15:09 PM
// Design Name: 
// Module Name: EXMEM_Stage
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


module EXMEM_Stage(
    input clock,
    input reset,
    input [4:0] EX_Target, //addr jal (reg)
    input [31:0] EX_ALUResult,
    input EX_weHI, EX_weLO,
    input [31:0] EX_hi, EX_lo,
    input [4:0] EX_ReadAddr2,
    input [31:0] EX_ReadData2,
    input EX_WriteReg,
    input EX_MemOrAlu,
    input EX_WriteMem,
    input EX_ReadMem,
    input [5:0] EX_Opcode,
    input EX_Byte, EX_Half, EX_SignExtend,
    
    output reg [4:0] M_Target,
    output reg [31:0] M_ALUResult,
    output reg M_weHI, M_weLO,
    output reg [31:0] M_hi, M_lo,
    output reg [4:0] M_ReadAddr2,
    output reg [31:0] M_ReadData2,
    output reg M_WriteReg,
    output reg M_MemOrAlu,
    output reg M_WriteMem,
    output reg M_ReadMem,
    output reg [5:0] M_Opcode,
    output reg M_Byte, M_Half, M_SignExtend    
    );

always @(posedge clock) begin    
    M_Target <= (reset) ? 0  : EX_Target;
    M_ALUResult <= (reset) ? 0  : EX_ALUResult;
    M_weHI <= (reset) ? 0  : EX_weHI;
    M_weLO <= (reset) ? 0  : EX_weLO;
    M_hi <= (reset) ? 0  : EX_hi;
    M_lo <= (reset) ? 0  : EX_lo;
    M_ReadAddr2 <= (reset) ? 0  : EX_ReadAddr2;
    M_ReadData2 <= (reset) ? 0  : EX_ReadData2;
    M_WriteReg <= (reset) ? 0  : EX_WriteReg;
    M_MemOrAlu <= (reset) ? 0  : EX_MemOrAlu;
    M_WriteMem <= (reset) ? 0  : EX_WriteMem;
    M_ReadMem <= (reset) ? 0  : EX_ReadMem;
    M_Opcode <= (reset) ? 0  : EX_Opcode;
    M_Byte <= (reset) ? 0  : EX_Byte;
    M_Half <= (reset) ? 0  : EX_Half;
    M_SignExtend <= (reset) ? 0  : EX_SignExtend;
end

endmodule
