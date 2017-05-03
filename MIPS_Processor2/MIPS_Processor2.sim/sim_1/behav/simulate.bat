@echo off
set xv_path=E:\\Xilinx\\Vivado\\2016.3\\bin
call %xv_path%/xsim CPU_Test_behav -key {Behavioral:sim_1:Functional:CPU_Test} -tclbatch CPU_Test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
