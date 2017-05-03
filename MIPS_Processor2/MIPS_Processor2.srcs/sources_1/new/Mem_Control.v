`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 11:31:50 PM
// Design Name: 
// Module Name: Mem_Control
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


module Mem_Control(
    input  reset,
    input  [31:0] DataIn,           // Data from CPU
    input  [31:0] Address,          // From CPU
    input  [31:0] MReadData,        // Data from Memory
    input  MemWrite,                // Memory Write command from CPU
    input  Byte,                    // Load/Store is Byte (8-bit)
    input  Half,                    // Load/Store is Half (16-bit)
    input  SignExtend,              // Sub-word load should be sign extended
    output reg [31:0] DataOut,      // Data to CPU
    output [31:0] MWriteData,       // Data to Memory
    output reg [3:0] WriteEnable   // Write Enable to Memory for each of 4 bytes of Memory
    );
wire [7:0] ByteSign = (SignExtend & DataIn[7]) ? 8'b1 : 8'b0;
wire [13:0] HalfSign = (SignExtend & DataIn[13]) ? 16'b1 : 16'b0;

//WriteEneble     
always @(*) begin
    if (reset) begin
        WriteEnable <= 4'b0;
    end
    else begin
        WriteEnable <= (MemWrite) ? (Byte) ? 4'b0001 : ((Half) ? 4'b0011 : 4'b1111) : 4'b0000;
    end
end
always @(*) begin
    if (reset) begin
        DataOut <= 32'b0;
    end
    else begin
        if (Byte)
            DataOut <= (SignExtend & MReadData[7])  ? {24'hFFFFFF, MReadData[7:0]}   : {24'h000000, MReadData[7:0]};
        else if (Half)
            DataOut <= (SignExtend & MReadData[15]) ? {16'hFFFF, MReadData[15:0]}  : {16'h0000, MReadData[15:0]};
        else
            DataOut <= MReadData;    
    end
end


assign MWriteData[31:16] = (Byte | Half) ? HalfSign : DataIn[31:16];
assign MWriteData[15:8]  = (Byte) ? ByteSign : DataIn[15:8];
assign MWriteData[7:0]   = DataIn[7:0];    
endmodule
