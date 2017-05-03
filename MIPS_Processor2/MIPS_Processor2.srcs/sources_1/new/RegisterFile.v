`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 09:13:34 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input  clock,
    input  reset,
    input  [4:0]  ReadReg1, ReadReg2, WriteReg,
    input  [31:0] WriteData,
    input  RegWrite,
    output [31:0] ReadData1, ReadData2
    );
    
reg [31:0] RF [1:31];
    
// Initialize all to zero
integer i;
initial begin
    for (i=0; i<32; i=i+1) begin
        RF[i] <= 0;
    end
end

    // 'WriteReg' is the register index to write. 'RegWrite' is the command.
    always @(posedge clock) begin
        if (reset) begin
            for (i=1; i<32; i=i+1) begin
                RF[i] <= 0;
            end
        end
        else begin
            if (WriteReg != 0)
                RF[WriteReg] <= (RegWrite) ? WriteData : RF[WriteReg];
        end
    end

    // Combinatorial Read. Register 0 is all 0s.
    assign ReadData1 = (ReadReg1 == 0) ? 32'h00000000 : RF[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 32'h00000000 : RF[ReadReg2];

endmodule
