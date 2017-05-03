// `include "../define.v"
module rom (
	input							rst,
	input 							ce,
	input[31:0]		addr,

	output reg[31:0]	inst
);

	parameter InstMemNum 	 = 2048;

	reg[31:0]		rom_data[InstMemNum-1:0];

	always @(*) begin : proc_reset
		integer i;
		if (rst == 1'b1) begin
			for (i = 0; i < InstMemNum; i = i + 1)
				rom_data[i] <= 32'b0;
		end
	end
	always @(*) begin : proc_read_inst
		if (ce == 1'b1 && rst == 1'b0)
			inst <= rom_data[addr >> 2];
		else
			inst <= 32'b0;
	end
endmodule