`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2017 02:18:37 AM
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clock,
    input reset,
    //Instruction 
    input [31:0] Instruction_In,
    output [31:0] Instruction_Addr,
    output reg Instruction_Read,
    //Data
    input [31:0] MemData_In,
    output [31:0] MemAddr,
    output [31:0] Data_Out,
    output [3:0] WriteEnable,
    output MemWrite,
    output MemRead
    );
    
/*** IF (Instruction Fetch) Signals ***/    
wire [31:0] IF_Instruction, IF_PCAdd4;
wire [31:0] IF_PCOut, IF_PCIn;
//Branch Signals
wire [31:0] BranchAddr;
wire IsBranch, IF_Flush;
/*** ID (Instruction Decode) Signals ***/   
wire [31:0] Instruction;
wire [5:0] Opcode = Instruction[31:26];
wire [4:0] Rs = Instruction[25:21];
wire [4:0] Rt = Instruction[20:16];
wire [4:0] Rd = Instruction[15:11];
wire [5:0] Funct = Instruction[5:0];
wire [4:0] ID_Shamt = Instruction[10:6];
wire [15:0] Immediate = Instruction[15:0];
wire [31:0] ID_SignExtImm;
wire [31:0] ID_ImmLeftShift2 = {ID_SignExtImm[29:0], 2'b00};
wire [31:0] ID_PCAdd4;
//Control Signals
wire ID_WriteReg, ID_MemOrAlu, ID_WriteMem, ID_ReadMem, ID_AluSrcA, ID_AluSrcB, ID_RegDes, ID_ImmSigned, ID_IsJal, ID_Byte, ID_Half;
wire [4:0] ID_ALUOp;
//Register Files
wire [31:0] ID_ReadData1, ID_ReadData2;
//HI LO
wire [63:0] HI_LOOut, HI_LOIn;
wire [31:0] ID_hi, ID_lo;
//wire WB_weHILO;
/*** EX (Execute) Signals ***/
wire [31:0] EX_ReadData1, EX_ReadData2;
wire [4:0] EX_ReadAddr1, EX_ReadAddr2;
wire [4:0] EX_Shamt;
wire EX_WriteReg, EX_MemOrAlu, EX_WriteMem, EX_ReadMem, EX_ALUSrcA, EX_ALUSrcB, EX_RegDes, EX_ImmSigned, EX_IsJal, EX_Byte, EX_Half;
wire [4:0] EX_rt, EX_rd;
wire [31:0] EX_SignExtImm;
wire [5:0] EX_Opcode;
wire [31:0] EX_hi, EX_lo;
wire [31:0] EX_PCAdd4;
wire [4:0] EX_ALUOp;
wire [4:0] EX_PreTarget, EX_Target;
wire [31:0] EX_hiOut, EX_loOut;
//Fowarding
wire [1:0] EX_SelFwdA, EX_SelFwdB, EX_SelFwdHi, EX_SelFwdLo, EX_SelFwdBrA, EX_SelFwdBrB;
wire EX_SelFwdLs;
wire [31:0] EX_FwdAData, EX_FwdBData, EX_FwdHiData, EX_FwdLoData;
//ALU
wire [31:0] SrcB;
wire Overflow;
wire signed [31:0] ALU_Result;
wire ALU_weHI, ALU_weLo;
wire [31:0] ALU_hi, ALU_lo;
wire [31:0] EX_DataOut;
/*** MEM (Memory) Signals ***/
wire [4:0] M_Target;
wire [31:0] M_ALUResult;
wire M_weHI, M_weLO;
wire [31:0] M_hi, M_lo;
wire [4:0] M_ReadAddr2;
wire [31:0] M_ReadData2;
wire M_WriteReg;
wire M_MemOrAlu;
wire M_WriteMem;
wire M_ReadMem;
wire M_Byte, M_Half;
wire M_SignExtend;
wire [5:0] M_Opcode;
wire [31:0] M_WriteData_Pre;
wire [31:0] M_DataMem;
/*** WB (WRITE BACK) Signals ***/
wire [4:0] WB_Target;
wire [31:0] WB_ALUResult;
wire [31:0] WB_DataMem;
wire WB_weHI, WB_weLO;
wire [31:0] WB_hi, WB_lo;
wire WB_WriteReg;
wire WB_MemOrAlu;
wire [31:0] WB_WriteData;
wire IF_Stall, ID_Stall, EX_Stall;
wire WB_weHILO = WB_weHI | WB_weLO;

/* IF STAGE*/
assign IF_Instruction = Instruction_In;
assign Instruction_Addr = IF_PCOut;
assign MemWrite = M_WriteMem;
assign MemRead = M_ReadMem;
assign ID_hi = HI_LOOut [63:32];
assign ID_lo = HI_LOOut [31:0];
assign HI_LOIn = {WB_hi,WB_lo};
assign MemAddr = M_ALUResult;
assign ID_SignExtImm = (ID_ImmSigned & Immediate[15]) ? {16'hFFFF, Immediate} : {16'h0000, Immediate};
always @(posedge clock) begin
    Instruction_Read <= (reset) ? 1'b0 : 1'b1;
end
//PCAdd4
Add PCAdd4(
        .A(IF_PCOut),
        .B(32'd4),
        .C(IF_PCAdd4)
    );
        
//Mux
Mux2to1 #(.WIDTH(32)) PCSrcStd_Mux(
		.in_0(IF_PCAdd4),
		.in_1(BranchAddr),
		.sel(IsBranch),
		.out(IF_PCIn)
	);
    
//Register PC    ishold 
Register #(.WIDTH(32), .INIT (-4)) Program_Counter (
        .clock(clock),
        .reset(reset),
        .enable(~IF_Stall),
        .Q(IF_PCOut),
        .D(IF_PCIn)
    );
/*IFID Stage_ HOLDER*/
IFID_Stage IFID(
        .clock (clock),
        .reset(reset),
        .IF_Flush(IF_Flush),
        .ID_Stall(ID_Stall),
        .IF_Instruction(IF_Instruction),
        .IF_PCAdd4(IF_PCAdd4),
        .ID_Instruction(Instruction),
        .ID_PCAdd4(ID_PCAdd4)
    );
/*ID STAGE */
//Control
Control Controller (
        .reset(reset),
        .Opcode(Opcode),
        .Funct(Funct),
        .WriteReg(ID_WriteReg),
        .MemOrAlu(ID_MemOrAlu),
        .WriteMem(ID_WriteMem),
        .ReadMem(ID_ReadMem),
        .ALUOp(ID_ALUOp),
        .AluSrcA(ID_AluSrcA),
        .AluSrcB(ID_AluSrcB),
        .RegDes(ID_RegDes),
        .ImmSigned(ID_ImmSigned),
        .Is_Jal(ID_IsJal),
        .Byte(ID_Byte),
        .Half(ID_Half)
    );
    
RegisterFile RegisterFile (
        .clock(clock),
        .reset(reset),
        .ReadReg1(Rs),
        .ReadReg2(Rt),
        .WriteReg(WB_Target),
        .WriteData(WB_WriteData),
        .RegWrite(WB_WriteReg),
        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2)
    );

Register #(.WIDTH(64), .INIT (0)) HI_LO (
        .clock(clock),
        .reset(reset),
        .enable(WB_weHILO),
        .Q(HI_LOOut),
        .D(HI_LOIn)
    );
/*IDEX STAGE*/         //.ID_SignExtImm(ID_SignExtImm),
IDEX_Stage IDEX (
        .clock(clock),
        .reset(EX_Stall),
        .ID_ReadData1(ID_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .ID_ReadAddr1(Rs),
        .ID_ReadAddr2(Rt),
        .ID_Shamt(ID_Shamt),
        .ID_WriteReg(ID_WriteReg),
        .ID_MemOrAlu(ID_MemOrAlu),
        .ID_WriteMem(ID_WriteMem),
        .ID_ReadMem(ID_ReadMem),
        .ID_ALUOp(ID_ALUOp),
        .ID_ALUSrcA(ID_AluSrcA),
        .ID_ALUSrcB(ID_AluSrcB),
        .ID_RegDes(ID_RegDes),
        .ID_ImmSigned(ID_ImmSigned),
        .ID_IsJal(ID_IsJal),
        .ID_Byte(ID_Byte),
        .ID_Half(ID_Half),
        .ID_rt(Rt),
        .ID_rd(Rd),
        .ID_SignExtImm(ID_SignExtImm),
        .ID_Opcode(Opcode),
        .ID_hi(ID_hi),
        .ID_lo(ID_lo),
        .ID_PCAdd4(ID_PCAdd4),
        .EX_ReadData1(EX_ReadData1),
        .EX_ReadData2(EX_ReadData2),
        .EX_ReadAddr1(EX_ReadAddr1),
        .EX_ReadAddr2(EX_ReadAddr2),
        .EX_Shamt(EX_Shamt),
        .EX_WriteReg(EX_WriteReg),
        .EX_MemOrAlu(EX_MemOrAlu),
        .EX_WriteMem(EX_WriteMem),
        .EX_ReadMem(EX_ReadMem),
        .EX_ALUSrcA(EX_ALUSrcA),
        .EX_ALUSrcB(EX_ALUSrcB),
        .EX_RegDes(EX_RegDes),
        .EX_ImmSigned(EX_ImmSigned),
        .EX_IsJal(EX_IsJal),
        .EX_Byte(EX_Byte),
        .EX_Half(EX_Half),
        .EX_rt(EX_rt),
        .EX_rd(EX_rd),
        .EX_SignExtImm(EX_SignExtImm),
        .EX_Opcode(EX_Opcode),
        .EX_hi(EX_hi),
        .EX_lo(EX_lo),
        .EX_PCAdd4(EX_PCAdd4),
        .EX_ALUOp(EX_ALUOp)
    );
//Forwarding A    
Mux4to1 #(.WIDTH(32)) FwdA_Mux (
        .sel  (EX_SelFwdA),
        .in0  (EX_ReadData1),
        .in1  (M_ALUResult),
        .in2  (WB_WriteData),
        .in3  (32'h00000000),
        .out  (EX_FwdAData)
    ); 
//Forwarding B    
Mux4to1 #(.WIDTH(32)) FwdB_Mux (
        .sel  (EX_SelFwdB),
        .in0  (EX_ReadData2),
        .in1  (M_ALUResult),
        .in2  (WB_WriteData),
        .in3  (32'h00000000),
        .out  (EX_FwdBData)
    );
//Forwarding hi   
Mux4to1 #(.WIDTH(32)) FwdHi_Mux (
        .sel  (EX_SelFwdHi),
        .in0  (EX_hi),
        .in1  (M_hi),
        .in2  (WB_hi),
        .in3  (32'h00000000),
        .out  (EX_FwdHiData)
   ); 
//Forwarding lo    
Mux4to1 #(.WIDTH(32)) Fwdlo_Mux (
        .sel  (EX_SelFwdLo),
        .in0  (EX_lo),
        .in1  (M_lo),
        .in2  (WB_lo),
        .in3  (32'h00000000),
        .out  (EX_FwdLoData)
    );
//ALU Src B MUX
Mux2to1 #(.WIDTH(32)) ALUSrcB_Mux (
        .sel  (EX_ALUSrcB),
        .in_0 (EX_FwdBData),
        .in_1 (EX_SignExtImm),
        .out  (SrcB)
    ); 
    
Mux2to1 #(.WIDTH(5)) PreTarget_Mux (
        .sel  (EX_RegDes),
        .in_0 (EX_rt),
        .in_1 (EX_rd),
        .out  (EX_PreTarget)
    );
Mux2to1 #(.WIDTH(5)) Target_Mux (
        .sel  (EX_IsJal),
        .in_0 (EX_PreTarget),
        .in_1 (5'd31),
        .out  (EX_Target)
    );
    
ALU ALU (
        .clock(clock),
        .reset(reset),
        .A(EX_FwdAData),
        .B(SrcB),
        .ALUOp(EX_ALUOp),
        .EX_Shamt(EX_Shamt),
        .hi(EX_FwdHiData),
        .lo(EX_FwdLoData),
        .Is_Overflow(OverFlow),
        .ALU_Result(ALU_Result),
        .we_hi(ALU_weHI),
        .we_lo(ALU_weLO),
        .ALU_hi(ALU_hi), 
        .ALU_lo(ALU_lo)
    );
    
//HI MUX
Mux2to1 #(.WIDTH(32)) Hi_Mux (
        .sel  (ALU_weHI),
        .in_0 (EX_FwdHiData),
        .in_1 (ALU_hi),
        .out  (EX_hiOut)
    );
Mux2to1 #(.WIDTH(32)) Lo_Mux (
        .sel  (ALU_weLO),
        .in_0 (EX_FwdLoData),
        .in_1 (ALU_lo),
        .out  (EX_loOut)
    );
Mux2to1 #(.WIDTH(32)) DataOut_Mux (
        .sel  (EX_IsJal),
        .in_0 (ALU_Result),
        .in_1 (EX_PCAdd4),
        .out  (EX_DataOut)
    ); 
/*EXMEM STAGE*/
EXMEM_Stage EXMEM(
        .clock(clock),
        .reset(reset),
        .EX_Target(EX_Target),
        .EX_ALUResult(EX_DataOut),
        .EX_weHI(ALU_weHI),
        .EX_weLO(ALU_weLO),
        .EX_hi(EX_hiOut),
        .EX_lo(EX_loOut),
        .EX_ReadAddr2(EX_ReadAddr2),
        .EX_ReadData2(EX_ReadData2),
        .EX_WriteReg(EX_WriteReg),
        .EX_MemOrAlu(EX_MemOrAlu),
        .EX_WriteMem(EX_WriteMem),
        .EX_ReadMem(EX_ReadMem),
        .EX_Opcode(EX_Opcode),
        .EX_Byte(EX_Byte),
        .EX_Half(EX_Half),
        .EX_SignExtend(EX_ImmSigned),
        .M_Target(M_Target),
        .M_ALUResult(M_ALUResult),
        .M_weHI(M_weHI),
        .M_weLO(M_weLO),
        .M_hi(M_hi),
        .M_lo(M_lo),
        .M_ReadAddr2(M_ReadAddr2),
        .M_ReadData2(M_ReadData2),
        .M_WriteReg(M_WriteReg),
        .M_MemOrAlu(M_MemOrAlu),
        .M_WriteMem(M_WriteMem),
        .M_ReadMem(M_ReadMem),
        .M_Opcode(M_Opcode),
        .M_Byte(M_Byte),
        .M_Half(M_Half),
        .M_SignExtend(M_SignExtend)
    );
    
/*** MEM Write Data Mux ***/    
Mux2to1 #(.WIDTH(32)) LS_Mux (
        .sel  (EX_SelFwdLs),
        .in_0 (M_ReadData2),
        .in_1 (WB_WriteData),
        .out  (M_WriteData_Pre)
    );     
Mem_Control MemControl (
        .reset(reset),
        .DataIn(M_WriteData_Pre),           // Data from CPU
        .Address(M_ALUResult),          // From CPU
        .MReadData(MemData_In),        // Data from Memory
        .MemWrite(M_WriteMem),                // Memory Write command from CPU
        .Byte(M_Byte),                    // Load/Store is Byte (8-bit)
        .Half(M_Half),                    // Load/Store is Half (16-bit)
        .SignExtend(M_SignExtend),              // Sub-word load should be sign extended
        .DataOut(M_DataMem),      // Data to CPU
        .MWriteData(Data_Out),       // Data to Memory
        .WriteEnable(WriteEnable)   // Write Enable to Memory for each of 4 bytes of Memory    
    ); 
/*MEMWB STAGE*/
MEMWB_Stage MEMWB(
        .clock(clock),
        .reset(reset),
        .M_Target(M_Target), //jal
        .M_ALUResult(M_ALUResult),
        .M_MemData(M_DataMem),
        .M_weHI(M_weHI),
        .M_weLO(M_weLO),
        .M_hi(M_hi),
        .M_lo(M_lo),
        .M_WriteReg(M_WriteReg),
        .M_MemOrAlu(M_MemOrAlu),
        .WB_Target(WB_Target),
        .WB_ALUResult(WB_ALUResult),
        .WB_MemData(WB_DataMem),
        .WB_weHI(WB_weHI),
        .WB_weLO(WB_weLO),
        .WB_hi(WB_hi),
        .WB_lo(WB_lo),
        .WB_WriteReg(WB_WriteReg),
        .WB_MemOrAlu(WB_MemOrAlu)
    );    
Mux2to1 #(.WIDTH(32)) MemOrAlu_Mux (
        .sel  (WB_MemOrAlu),
        .in_0 (WB_DataMem),
        .in_1 (WB_ALUResult),
        .out  (WB_WriteData)
        );
//FOWARDING
Forwarding Fowarding_Control(
    .reset(reset),
    .ID_Addr1(Rs),
    .ID_Addr2(Rt),
    .EX_Addr1(EX_ReadAddr1),
    .EX_Addr2(EX_ReadAddr2),
    .EX_Target(EX_Target),
    .EX_WriteReg(EX_WriteReg),
    .M_Addr2(M_ReadAddr2),
    .M_Target(M_Target),
    .M_WriteReg(M_WriteReg),
    .M_MemOrAlu(M_MemOrAlu),
    .M_weHI(M_weHI),
    .M_weLO(M_weLO),
    .WB_Target(WB_Target),
    .WB_WriteReg(WB_WriteReg),
    .WB_weHI(WB_weHI),
    .WB_weLO(WB_weLO),
    .SelFwdA(EX_SelFwdA),
    .SelFwdB(EX_SelFwdB),
    .SelFwdHi(EX_SelFwdHi),
    .SelFwdLo(EX_SelFwdLo),
    .SelFwdBrA(EX_SelFwdBrA),
    .SelFwdBrB(EX_SelFwdBrB),
    .SelFwdLs(EX_SelFwdLs)
    );
Branch_Control Branch_Control(
        .reset(reset),
        .ID_PCAdd4(ID_PCAdd4),
        .ID_Inst(Instruction),
        .SelFwdBrA(EX_SelFwdBrA),
        .SelFwdBrB(EX_SelFwdBrB),
        .ID_ReadData1(ID_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .EX_DataOut(EX_DataOut),
        .ALUorMem(M_ALUResult),
        .M_MemData(M_DataMem),
        .BranchAddr(BranchAddr),
        .IsBranch(IsBranch),
        .resetIFID(IF_Flush)
    );
Hazard Hazard(
        .reset(reset),
        .EX_ReadMem(EX_ReadMem),
        .ID_WriteMem(EX_WriteMem),
        .ID_ReadAddr1(Rs),
        .ID_ReadAddr2(Rt),
        .EX_Target(EX_Target),
        .IF_Stall(IF_Stall),
        .ID_Stall(ID_Stall),
        .EX_Stall(EX_Stall)
        );
                      
endmodule
