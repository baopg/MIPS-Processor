`timescale 1ns / 1ps
`include "MIPS_Parameters.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2017 01:39:11 AM
// Design Name: 
// Module Name: Branch_Control
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


module Branch_Control(
    input reset,
    input [31:0] ID_PCAdd4, ID_Inst,
    input [1:0] SelFwdBrA, SelFwdBrB,
    input [31:0] ID_ReadData1, ID_ReadData2,
    input [31:0] EX_DataOut,
    input [31:0] ALUorMem,
    input [31:0] M_MemData,
    
    output reg [31:0] BranchAddr,
    output reg IsBranch,
    output reg resetIFID
    );
    
reg [31:0] opA, opB;
wire [31:0] JumpAddr;
wire [31:0] JumpRegAddr;
wire [31:0] CondAddr;
wire [5:0] Opcode, Funct;
assign Opcode = ID_Inst[31:26];
assign Funct = ID_Inst[5:0];

assign JumpAddr = {ID_PCAdd4[31:28], ID_Inst[25:0], 2'b00};
assign JumpRegAddr = opA;
assign CondAddr = ID_PCAdd4 + {{14{ID_Inst[15]}}, ID_Inst[15:0], 2'b00};

always @(*) begin
    if (reset) 
        opA <= 32'b0;
    else begin
        case (SelFwdBrA)
            2'b00: opA <= ID_ReadData1;
            2'b01: opA <= EX_DataOut;
            2'b10: opA <= M_MemData;
            2'b11: opA <= ALUorMem;
            default: opA <= ID_ReadData1;
        endcase
    end
end

always @(*) begin
    if (reset) 
        opB <= 32'b0;
    else begin
        case (SelFwdBrB)
            2'b00: opB <= ID_ReadData2;
            2'b01: opB <= EX_DataOut;
            2'b10: opB <= M_MemData;
            2'b11: opB <= ALUorMem;
            default: opB <= ID_ReadData1;
        endcase
    end
end

always @(*) begin
    if (reset) begin
        BranchAddr <= 32'b0;
        IsBranch <= 1'b0;
        resetIFID <= 1'b0;
    end
    else begin
        case (Opcode)
            `Op_Type_R: begin
                BranchAddr <= (Funct == `Funct_Jr) ? JumpRegAddr : 32'b0;
                IsBranch <= (Funct == `Funct_Jr) ? 1'b1 : 1'b0;
                resetIFID <= (Funct == `Funct_Jr) ? 1'b1 : 1'b0;
            end
            `Op_J: begin
                 BranchAddr <= JumpAddr;
                 IsBranch <= 1'b1;
                 resetIFID <= 1'b1;
             end
            `Op_Jal: begin
                 BranchAddr <= JumpAddr;
                 IsBranch <= 1'b1;
                 resetIFID <= 1'b1;
            end
            `Op_Beq: begin
                 BranchAddr <= (opA == opB) ? CondAddr : 32'b0;
                 IsBranch <= (opA == opB) ? 1'b1 : 1'b0;
                 resetIFID <= (opA == opB) ? 1'b1 : 1'b0;
            end
            `Op_Bne: begin
                 BranchAddr <= (opA != opB) ? CondAddr : 32'b0;
                 IsBranch <= (opA != opB) ? 1'b1 : 1'b0;
                 resetIFID <= (opA != opB) ? 1'b1 : 1'b0;
            end
            default: begin
                BranchAddr <= 32'b0;
                IsBranch <= 1'b0;
                resetIFID <= 1'b0;
            end
        endcase
    end
end
endmodule
