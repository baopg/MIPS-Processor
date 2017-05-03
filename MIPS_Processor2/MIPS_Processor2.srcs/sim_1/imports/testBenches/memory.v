//`include "define.v"
module memory (
	input							rst,
	input							ce,
	input[31:0]		data_i,
	input[31:0]		addr_i,
	input							we,
	input[3:0]		byte_slct,

	`ifdef DEBUG
	output reg[31:0]	data_o,

	output[31:0]		mem20,
	output[31:0]		mem21,
	output[31:0]		mem22,
	output[31:0]		mem23,
	output[31:0]		mem24
	`endif
	`ifndef DEBUG
	output reg[31:0]	data_o
	`endif
);
	`ifdef DEBUG
	assign mem20 = mem_data[20];
	assign mem21 = mem_data[21];
	assign mem22 = mem_data[22];
	assign mem23 = mem_data[23];
	assign mem24 = mem_data[24];
	`endif
	parameter					MemoryDataNum = 2048;
	reg[31:0]		mem_data[MemoryDataNum-1:0];

	wire[7:0]					mem_byte_0;
	wire[7:0]					mem_byte_1;
	wire[7:0]					mem_byte_2;
	wire[7:0]					mem_byte_3;
	wire[31:0]		data_temp;

	assign mem_byte_3 = (byte_slct[3] == 1'b1) ? data_i[31:24] : mem_data[addr_i >> 2][31:24];
	assign mem_byte_2 = (byte_slct[2] == 1'b1) ? data_i[23:16] : mem_data[addr_i >> 2][23:16];
	assign mem_byte_1 = (byte_slct[1] == 1'b1) ? data_i[15:8] : mem_data[addr_i >> 2][15:8];
	assign mem_byte_0 = (byte_slct[0] == 1'b1) ? data_i[7:0] : mem_data[addr_i >> 2][7:0];
	// always @(*) begin
	// 	mem_byte_3 <= (byte_slct[3] == 1'b1) ? data_i[31:24] : mem_data[addr_i >> 2][31:24];
	// 	mem_byte_2 <= (byte_slct[2] == 1'b1) ? data_i[23:16] : mem_data[addr_i >> 2][23:16];
	// 	mem_byte_1 <= (byte_slct[1] == 1'b1) ? data_i[15:8] : mem_data[addr_i >> 2][15:8];
	// 	mem_byte_0 <= (byte_slct[0] == 1'b1) ? data_i[7:0] : mem_data[addr_i >> 2][7:0];
	// end
	assign data_temp  = {mem_byte_3, mem_byte_2, mem_byte_1, mem_byte_0};
	// reset
	always @(*) begin : proc_reset
		integer i;
		if (rst == 1'b1) begin
			for (i = 0; i < MemoryDataNum; i = i + 1)
				mem_data[i] <= 31'b0;
		end
	end

	// write operation
	always @ (*) begin
		if (rst == 1'b0 && we == 1'b1)
			#0.1 mem_data[addr_i >> 2] <= data_temp;
	end

	// read operation
	always @ (*) begin
		if (rst == 1'b0 && ce == 1'b1)
			data_o <= mem_data[addr_i >> 2];
		else
			data_o <= 32'b0;
	end
endmodule