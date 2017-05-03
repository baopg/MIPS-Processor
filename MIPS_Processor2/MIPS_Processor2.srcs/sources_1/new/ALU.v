`timescale 1ns / 1ps
`include "MIPS_Parameters.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 10:24:29 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clock,
    input reset,
    
    input [31:0] A, B,
    input [4:0] ALUOp,
    input [4:0] EX_Shamt,
    input [31:0] hi, lo,
    
    output reg Is_Overflow,
    output reg signed [31:0] ALU_Result,
    output reg we_hi = 0, we_lo = 0,
    output reg [31:0] ALU_hi, ALU_lo    
    );

wire signed [31:0] As, Bs;

assign As = A;
assign Bs = B;

always @(*) begin
    if (reset) begin
        ALU_Result <= 32'b0;
    end
    else begin
        case (ALUOp)
            `AluOp_Add: begin
                ALU_Result <= A + B;
                Is_Overflow <= ((ALU_Result[31] ^ A[31]) && (A[31] ~^B[31])) ? 1'b1 : 1'b0;
            end
            `AluOp_Addu: begin
                ALU_Result <= A + B;
                Is_Overflow <= 1'b0;
            end
            `AluOp_Sub: begin
                ALU_Result <= A - B;
                Is_Overflow <= ((ALU_Result[31] ^ A[31]) && (A[31] ~^B[31])) ? 1'b1 : 1'b0;
            end
            `AluOp_Subu: begin
                ALU_Result <= A - B;
                Is_Overflow <= 1'b0;
            end
            `AluOp_And  : ALU_Result <= A & B;
            `AluOp_Nor  : ALU_Result <= ~(A | B);
            `AluOp_Or   : ALU_Result <= A | B;
            `AluOp_Xor  : ALU_Result <= A ^ B;
            `AluOp_Sll  : ALU_Result <= B << EX_Shamt; //shamt
            `AluOp_Srl  : ALU_Result <= B >> EX_Shamt;
            `AluOp_Sra  : ALU_Result <= Bs >>> EX_Shamt;
            `AluOp_Slt  : ALU_Result <= (As < Bs) ? 32'h00000001 : 32'h00000000;
            `AluOp_Sltu : ALU_Result <= (A < B)   ? 32'h00000001 : 32'h00000000;
            `AluOp_Mfhi : begin
                ALU_Result <= hi;
                ALU_hi <= hi;
            end
            `AluOp_Mflo : begin
                ALU_lo <= lo;
                ALU_Result <= lo;
            end
            `AluOp_Sllc : ALU_Result <= {B[15:0], 16'b0}; //LUI
        endcase
    end
end

endmodule
