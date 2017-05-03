`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2017 04:38:01 PM
// Design Name: 
// Module Name: CPU_Test
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


module CPU_Test;
reg 						clk;
	reg 						rst;

	wire[31:0]		data_from_mem;
	wire[31:0]		mem_addr;
	wire[3:0]					mem_byte_slct;
	wire[31:0]		data_to_write_mem;
	wire						mem_we;
	wire						mem_re;
	wire[31:0] 	inst_from_rom;
	wire[31:0] 	rom_addr;
	wire						rom_ce;

	supply1 					vcc;
	supply0 					gnd;

	CPU CPU(
		.clock (clk),
		.reset(rst),
		.MemData_In(data_from_mem),
		.MemAddr(mem_addr),
		.WriteEnable(mem_byte_slct),
		.Data_Out(data_to_write_mem),
		.MemWrite(mem_we),
		.MemRead(mem_re),
		.Instruction_In(inst_from_rom),
		.Instruction_Addr(rom_addr),
		.Instruction_Read(rom_ce)
	);
	
	rom ROM(
		.rst(gnd),
		.ce(rom_ce),
		.addr(rom_addr),
		.inst(inst_from_rom)
	);

	memory RAM(
		.rst(gnd),
		.ce(mem_re),
		.data_i(data_to_write_mem),
		.addr_i(mem_addr),
		.we(mem_we),
		.byte_slct(mem_byte_slct),
		.data_o(data_from_mem)
	);
	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end
	initial begin
		$dumpfile("test_info/yamin/yamin.vcd");
		$dumpvars;
		$readmemh("yamin.data", ROM.rom_data, 0, 25);
		$readmemh("ram.data", RAM.mem_data);
		rst = 1'b1;
		#3 rst = 1'b0;
		#200 $finish;
	end
endmodule
