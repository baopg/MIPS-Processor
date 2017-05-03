`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 11:41:11 PM
// Design Name: 
// Module Name: Forwarding
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


module Forwarding(
    input reset,
    input [4:0] ID_Addr1, ID_Addr2,
    
    input [4:0] EX_Addr1, EX_Addr2,
    input [4:0] EX_Target,
    input EX_WriteReg,
    
    input [4:0] M_Addr2,
    input [4:0] M_Target,
    input M_WriteReg,
    input M_MemOrAlu,
    input M_weHI, M_weLO,
    
    input [4:0] WB_Target,
    input WB_WriteReg,
    input WB_weHI, WB_weLO,
    
    output [1:0] SelFwdA,
    output [1:0] SelFwdB,
    output reg [1:0] SelFwdHi,
    output reg [1:0] SelFwdLo,
    output [1:0] SelFwdBrA,
    output [1:0] SelFwdBrB,
    output SelFwdLs
    );
    
// Forwarding should not happen when the src/dst register is $zero
wire EX_Target_NZ  = (EX_Target  != 5'b00000);
wire M_Target_NZ = (M_Target != 5'b00000);
wire WB_Target_NZ  = (WB_Target  != 5'b00000);

// ID Dependencies
wire IDEX_Match  = EX_Target_NZ  & EX_WriteReg;
// EX Dependencies
wire EXMEM_Match = M_Target_NZ & M_WriteReg;
// MEM Dependencies
wire MEMWB_Match = WB_Target_NZ  & WB_WriteReg;

//Forward branch A
wire fwdA_br1 = IDEX_Match & (ID_Addr1 == EX_Target);
wire fwdA_br2 = EXMEM_Match & (ID_Addr1 == M_Target);
wire fwdA_br3 = fwdA_br2 & M_MemOrAlu;
wire fwdA_br4 = fwdA_br2 & ~M_MemOrAlu;
//Forward branch B
wire fwdB_br1 = IDEX_Match & (ID_Addr2 == EX_Target);
wire fwdB_br2 = EXMEM_Match & (ID_Addr2 == M_Target);
wire fwdB_br3 = fwdB_br2 & M_MemOrAlu;
wire fwdB_br4 = fwdB_br2 & ~M_MemOrAlu;

//Forward A
wire fwdA1 = EXMEM_Match & (EX_Addr1 == M_Target);
wire fwdA2 = MEMWB_Match & (EX_Addr1 == WB_Target);
//Forward B
wire fwdB1 = EXMEM_Match & (EX_Addr2 == M_Target);
wire fwdB2 = MEMWB_Match & (EX_Addr2 == WB_Target);

assign SelFwdBrA = (fwdA_br1) ? 2'b01 : ( (fwdA_br3) ? 2'b11 : ( (fwdA_br4) ? 2'b10 : 2'b00) );
assign SelFwdBrB = (fwdB_br1) ? 2'b01 : ( (fwdB_br3) ? 2'b11 : ( (fwdB_br4) ? 2'b10 : 2'b00) );
assign SelFwdA = (fwdA1) ? 2'b01 : ( (fwdA2) ? 2'b10 : 2'b00 );
assign SelFwdB = (fwdB1) ? 2'b01 : ( (fwdB2) ? 2'b10 : 2'b00 );
assign SelFwdLs = (MEMWB_Match & (M_Addr2 == WB_Target)) ? 1'b1 : 1'b0;
always @(*) begin
    if (reset) begin
        SelFwdHi <= 0;
        SelFwdLo <= 0;
    end
    else begin
        // stage EX hi
                if (M_weHI == 1'b1) begin
                    SelFwdHi <= 2'b01;
                end
                else if (WB_weHI == 1'b1) begin
                    SelFwdHi <= 2'b10;
                end
                else begin
                    SelFwdHi <= 2'b00;
                end
    
                // stage EX lo
                if (M_weLO == 1'b1) begin
                    SelFwdLo <= 2'b01;
                end
                else if (WB_weLO == 1'b1) begin
                    SelFwdLo <= 2'b10;
                end
                else begin
                    SelFwdLo <= 2'b00;
                end
    end
end
endmodule
