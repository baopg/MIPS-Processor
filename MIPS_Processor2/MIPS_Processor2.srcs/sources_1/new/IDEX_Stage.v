`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 09:23:53 PM
// Design Name: 
// Module Name: IDEX_Stage
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


module IDEX_Stage(
    input  clock,
    input  reset,
    // Control Signals
    // Data Signals
    input [31:0] ID_ReadData1, ID_ReadData2,
    input [4:0] ID_ReadAddr1, ID_ReadAddr2,
    input [4:0] ID_Shamt,
    input ID_WriteReg,
    input ID_MemOrAlu,
    input ID_WriteMem,
    input ID_ReadMem,
    input [4:0] ID_ALUOp,
    input ID_ALUSrcA,
    input ID_ALUSrcB,
    input ID_RegDes,
    input ID_ImmSigned,
    input ID_IsJal,
    input ID_Byte, ID_Half,
    input [4:0] ID_rt, ID_rd,
    input [31:0] ID_SignExtImm,
    input [5:0] ID_Opcode,
    input [31:0] ID_hi, ID_lo,
    input [31:0] ID_PCAdd4,
    
    output reg [31:0] EX_ReadData1, EX_ReadData2,
    output reg [4:0] EX_ReadAddr1, EX_ReadAddr2,
    output reg [4:0] EX_Shamt,
    output reg EX_WriteReg,
    output reg EX_MemOrAlu,
    output reg EX_WriteMem,
    output reg EX_ReadMem,
    output reg [4:0] EX_ALUOp,
    output reg EX_ALUSrcA,
    output reg EX_ALUSrcB,
    output reg EX_RegDes,
    output reg EX_ImmSigned,
    output reg EX_IsJal,
    output reg EX_Byte,
    output reg EX_Half,
    output reg [4:0] EX_rt, EX_rd,
    output reg [31:0] EX_SignExtImm,
    output reg [5:0] EX_Opcode,
    output reg [31:0] EX_hi, EX_lo,
    output reg [31:0] EX_PCAdd4    
    );
    
always @(posedge clock) begin
    EX_ReadData1 <= (reset) ? 0  : ID_ReadData1;
    EX_ReadData2 <= (reset) ? 0  : ID_ReadData2;
    EX_ReadAddr1 <= (reset) ? 0  : ID_ReadAddr1;
    EX_ReadAddr2 <= (reset) ? 0  : ID_ReadAddr2;
    EX_Shamt <= (reset) ? 0  : ID_Shamt;
    EX_WriteReg <= (reset) ? 1'b0  : ID_WriteReg;
    EX_MemOrAlu <= (reset) ? 1'b0  : ID_MemOrAlu;
    EX_WriteMem <= (reset) ? 1'b0  : ID_WriteMem;
    EX_ReadMem <= (reset) ? 1'b0  : ID_ReadMem;
    EX_ALUOp <= (reset) ? 0  : ID_ALUOp;
    EX_ALUSrcA <= (reset) ? 0  : ID_ALUSrcA;
    EX_ALUSrcB <= (reset) ? 0  : ID_ALUSrcB;
    EX_RegDes <= (reset) ? 1'b0  : ID_RegDes;
    EX_ImmSigned <= (reset) ? 1'b0  : ID_ImmSigned;
    EX_IsJal <= (reset) ? 1'b0  : ID_IsJal;
    EX_Byte <= (reset) ? 1'b0  : ID_Byte;
    EX_Half <= (reset) ? 1'b0  : ID_Half;
    EX_rt <= (reset) ? 0  : ID_rt;
    EX_rd <= (reset) ? 0  : ID_rd;
    EX_SignExtImm <= (reset) ? 0  : ID_SignExtImm;
    EX_Opcode <= (reset) ? 0  : ID_Opcode;
    EX_hi <= (reset) ? 0  : ID_hi;
    EX_lo <= (reset) ? 0  : ID_lo;
    EX_PCAdd4 <= (reset) ? 0  : ID_PCAdd4;
end
    
endmodule
