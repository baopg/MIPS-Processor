`timescale 1ns / 1ps
`include "MIPS_Parameters.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2017 08:30:33 PM
// Design Name: 
// Module Name: Control
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


module Control(
	input reset,
    input [5:0] Opcode,
    input [5:0] Funct,
    
    output reg WriteReg,
    output reg MemOrAlu,
    output reg WriteMem,
    output reg ReadMem,
    output reg [4:0] ALUOp,
    output reg AluSrcA,
    output reg AluSrcB,
    output reg RegDes,
    output reg ImmSigned,
    output Is_Jal,
    output reg Byte, Half    
    );

initial begin
    WriteReg = 1'b0;
    MemOrAlu = 1'b0;
    WriteMem = 1'b0;
    ReadMem = 1'b0;
    ALUOp = 4'b0;
    AluSrcA = 1'b0;
    AluSrcB = 1'b0;
    RegDes = 1'b0;
    ImmSigned = 1'b0;
    Byte = 1'b0; 
    Half = 1'b0;   
end    
assign Is_Jal = (Opcode == `Op_Jal) ? 1'b1 : 1'b0;

always @(*) begin : proc_decode
    if (reset == 1'b1) begin
            WriteReg = 1'b0;
            MemOrAlu = 1'b0;
            WriteMem = 1'b0;
            ReadMem = 1'b0;
            AluSrcA = 1'b0;
            AluSrcB = 1'b0;
            RegDes = 1'b0;
            ImmSigned = 1'b0;
            Byte = 1'b0; 
            Half = 1'b0;        
    end
    else begin
	   case (Opcode)
	       `Op_Type_R  : begin
	           case (Funct)
						// Note that in Logic Op, rd <- rt >>(<<) rs(shamt)
						// 						  rd <= ALUSrcB >>(<<) ALUSrcA
						// ALUSrcB = rt
                    `Funct_Sll: begin
					//sll $1,$2,10
					   WriteReg 	= 1'b1;
					   WriteMem 	= 1'b0;
					   ReadMem  	= 1'b0;
					   MemOrAlu 	= 1'b1;
					   AluSrcA  	= `Shamt;
					   AluSrcB  	= `Rt;
					   RegDes   	= `Rd;
						end
						`mips_srl: begin
							//srl $1,$2,10
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							MemOrAlu 	= 1'b1;
							AluSrcA  	= `Shamt;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_sra: begin
							//sra $1,$2,10
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							MemOrAlu 	= 1'b1;
							AluSrcA  	= `Shamt;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_sllv: begin
							//sllv $1,$2,$3
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							MemOrAlu 	= 1'b1;
							AluSrcA  	= `Rs;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_srlv: begin
							//srlv $1,$2,$3
							WriteReg	= `WriteEnable;
							WriteMem	= 1'b0;
							ReadMem		= 1'b0;
							MemOrAlu	= 1'b1;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_srav: begin
							//srav $1,$2,$3
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							MemOrAlu 	= 1'b1;
							AluSrcA  	= `Rs;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_jr: begin
							// jr $31
							WriteReg 	= 1'b0;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
						end
						`mips_mfhi: begin
							// mfhi $d
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							RegDes		= `Rd;
						end
						`mips_mflo: begin
							// mflo $d
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							RegDes		= `Rd;
						end
						`mips_mult: begin
							WriteReg 	= 1'b0;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_multu: begin
							WriteReg 	= 1'b0;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_div: begin
							WriteReg 	= 1'b0;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_divu: begin
							WriteReg 	= 1'b0;
							WriteMem 	= 1'b0;
							ReadMem  	= 1'b0;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_add: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_addu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_sub: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_subu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_and: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_or: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_xor: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_nor: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_slt: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_sltu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= 1'b0;
							MemOrAlu	= 1'b1;
							ReadMem  	= 1'b0;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						default: begin
							WriteReg	= 1'b0;
							WriteMem	= 1'b0;
							ReadMem		= 1'b0;
						end
					endcase // funct
				end
				`mips_jal: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
				end
				`mips_beq: begin
					WriteReg 	= 1'b0;
					WriteMem 	= 1'b0;
					ReadMem  	= 1'b0;
				end
				`mips_bne: begin
					WriteReg 	= 1'b0;
					WriteMem 	= 1'b0;
					ReadMem  	= 1'b0;
				end
				`mips_addi: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_addiu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_slti: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_andi: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_ori: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_xori: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_lui: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= 1'b1;
					ReadMem  	= 1'b0;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_lb: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
					Byte = 1'b1;
                    Half = 1'b0;
				end
				`mips_lh: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
					Half = 1'b1;
					Byte = 1'b0;
				end
				`mips_lw: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
					Half = 1'b0;
                    Byte = 1'b0;
				end
				`mips_lbu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
					Byte = 1'b1;
                    Half = 1'b0;
				end
				`mips_lhu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= 1'b0;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
					Half = 1'b1;
                    Byte = 1'b0;					
				end
				`mips_sb: begin
					WriteReg 	= 1'b0;
					WriteMem 	= `WriteEnable;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
					Byte = 1'b1;
                    Half = 1'b0;
				end
				`mips_sh: begin
					WriteReg 	= 1'b0;
					WriteMem 	= `WriteEnable;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
					Half = 1'b1;
					Byte = 1'b0;
				end
				`mips_sw: begin
					WriteReg 	= 1'b0;
					WriteMem 	= `WriteEnable;
					ReadMem  	= 1'b0;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
					Byte = 1'b0;
                    Half = 1'b0;
				end
				default: begin
					WriteReg	= 1'b0;
					WriteMem	= 1'b0;
					ReadMem		= 1'b0;
					Byte = 1'b0;
					Half = 1'b0;
				end
			endcase // opcode
		end
	end
	
always @(*) begin
            if (reset)
                ALUOp <= `AluOp_Addu;  // Any Op that doesn't write HILO or cause exceptions
            else begin
                case (Opcode)
                    `Op_Type_R  :
                        begin
                            case (Funct)
                                `Funct_Add     : ALUOp <= `AluOp_Add;
                                `Funct_Addu    : ALUOp <= `AluOp_Addu;
                                `Funct_And     : ALUOp <= `AluOp_And;
                                `Funct_Div     : ALUOp <= `AluOp_Div;
                                `Funct_Divu    : ALUOp <= `AluOp_Divu;
                                `Funct_Jalr    : ALUOp <= `AluOp_Addu;
                                `Funct_Mfhi    : ALUOp <= `AluOp_Mfhi;
                                `Funct_Mflo    : ALUOp <= `AluOp_Mflo;
                                `Funct_Movn    : ALUOp <= `AluOp_Addu;
                                `Funct_Movz    : ALUOp <= `AluOp_Addu;
                                `Funct_Mthi    : ALUOp <= `AluOp_Mthi;
                                `Funct_Mtlo    : ALUOp <= `AluOp_Mtlo;
                                `Funct_Mult    : ALUOp <= `AluOp_Mult;
                                `Funct_Multu   : ALUOp <= `AluOp_Multu;
                                `Funct_Nor     : ALUOp <= `AluOp_Nor;
                                `Funct_Or      : ALUOp <= `AluOp_Or;
                                `Funct_Sll     : ALUOp <= `AluOp_Sll;
                                `Funct_Sllv    : ALUOp <= `AluOp_Sllv;
                                `Funct_Slt     : ALUOp <= `AluOp_Slt;
                                `Funct_Sltu    : ALUOp <= `AluOp_Sltu;
                                `Funct_Sra     : ALUOp <= `AluOp_Sra;
                                `Funct_Srav    : ALUOp <= `AluOp_Srav;
                                `Funct_Srl     : ALUOp <= `AluOp_Srl;
                                `Funct_Srlv    : ALUOp <= `AluOp_Srlv;
                                `Funct_Sub     : ALUOp <= `AluOp_Sub;
                                `Funct_Subu    : ALUOp <= `AluOp_Subu;
                                `Funct_Syscall : ALUOp <= `AluOp_Addu;
                                `Funct_Teq     : ALUOp <= `AluOp_Subu;
                                `Funct_Tge     : ALUOp <= `AluOp_Slt;
                                `Funct_Tgeu    : ALUOp <= `AluOp_Sltu;
                                `Funct_Tlt     : ALUOp <= `AluOp_Slt;
                                `Funct_Tltu    : ALUOp <= `AluOp_Sltu;
                                `Funct_Tne     : ALUOp <= `AluOp_Subu;
                                `Funct_Xor     : ALUOp <= `AluOp_Xor;
                                default        : ALUOp <= `AluOp_Addu;
                            endcase
                        end
                    `Op_Type_R2 :
                        begin
                            case (Funct)
                                `Funct_Clo   : ALUOp <= `AluOp_Clo;
                                `Funct_Clz   : ALUOp <= `AluOp_Clz;
                                `Funct_Madd  : ALUOp <= `AluOp_Madd;
                                `Funct_Maddu : ALUOp <= `AluOp_Maddu;
                                `Funct_Msub  : ALUOp <= `AluOp_Msub;
                                `Funct_Msubu : ALUOp <= `AluOp_Msubu;
                                `Funct_Mul   : ALUOp <= `AluOp_Mul;
                                default      : ALUOp <= `AluOp_Addu;
                            endcase
                        end
                    
                    `Op_Type_CP0 : ALUOp <= `AluOp_Addu;
                    `Op_Addi     : ALUOp <= `AluOp_Add;
                    `Op_Addiu    : ALUOp <= `AluOp_Addu;
                    `Op_Andi     : ALUOp <= `AluOp_And;
                    `Op_Jal      : ALUOp <= `AluOp_Addu;
                    `Op_Lb       : ALUOp <= `AluOp_Addu;
                    `Op_Lbu      : ALUOp <= `AluOp_Addu;
                    `Op_Lh       : ALUOp <= `AluOp_Addu;
                    `Op_Lhu      : ALUOp <= `AluOp_Addu;
                    `Op_Ll       : ALUOp <= `AluOp_Addu;
                    `Op_Lui      : ALUOp <= `AluOp_Sllc;
                    `Op_Lw       : ALUOp <= `AluOp_Addu;
                    `Op_Lwl      : ALUOp <= `AluOp_Addu;
                    `Op_Lwr      : ALUOp <= `AluOp_Addu;
                    `Op_Ori      : ALUOp <= `AluOp_Or;
                    `Op_Sb       : ALUOp <= `AluOp_Addu;
                    `Op_Sc       : ALUOp <= `AluOp_Addu;  // XXX Needs HW implement
                    `Op_Sh       : ALUOp <= `AluOp_Addu;
                    `Op_Slti     : ALUOp <= `AluOp_Slt;
                    `Op_Sltiu    : ALUOp <= `AluOp_Sltu;
                    `Op_Sw       : ALUOp <= `AluOp_Addu;
                    `Op_Swl      : ALUOp <= `AluOp_Addu;
                    `Op_Swr      : ALUOp <= `AluOp_Addu;
                    `Op_Xori     : ALUOp <= `AluOp_Xor;
                    default      : ALUOp <= `AluOp_Addu;
                endcase
            end
        end
	
endmodule
