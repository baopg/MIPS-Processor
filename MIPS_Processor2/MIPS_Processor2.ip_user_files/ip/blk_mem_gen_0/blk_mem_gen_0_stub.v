// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Wed May 03 22:54:11 2017
// Host        : Yukinonb-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               e:/Education/DOAN/BaoCao/MIPS_Processor2/MIPS_Processor2.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_stub.v
// Design      : blk_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_4,Vivado 2016.3" *)
module blk_mem_gen_0(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[3:0],dina[15:0],douta[15:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [3:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule
