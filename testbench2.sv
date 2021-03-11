module testbench2();

timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns; // This is the amount of time represented by #1 

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [1:0] PCMUX;
logic [15:0] MAR, PC, MDR, IR, Readout, PC_plus_1, ADDR, bus_out, hex_data, Data_from_CPU; 
logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
logic [2:0] DRCODE; 
logic ld_r0, ld_r1;



always begin : CLOCK
	#1 Clk = ~Clk;
end

slc3_testtop test0(.*);
assign MAR = test0.slc.d0.MAR;
assign PC = test0.slc.d0.PC_out;
assign MDR = test0.slc.d0.MDR_out;
assign IR = test0.slc.d0.IR_out;
assign Readout = test0.mem.readout;
assign PC_plus_1 = test0.slc.d0.op_PC.PC_plus_1;
assign PCMUX = test0.slc.d0.op_PC.PCMUX_sig;
assign R0 = test0.slc.d0.reg_file0.r0_out;
assign R1 = test0.slc.d0.reg_file0.r1_out;
assign R2 = test0.slc.d0.reg_file0.r2_out;
assign R3 = test0.slc.d0.reg_file0.r3_out;
assign R4 = test0.slc.d0.reg_file0.r4_out;
assign R5 = test0.slc.d0.reg_file0.r5_out;
assign R6 = test0.slc.d0.reg_file0.r6_out;
assign R7 = test0.slc.d0.reg_file0.r7_out;
assign ADDR = test0.slc.memory_subsystem.ADDR;
assign DRCODE = test0.slc.d0.reg_file0.DR_code;
assign ld_r0 = test0.slc.d0.reg_file0.ld_r0;
assign ld_r1 = test0.slc.d0.reg_file0.ld_r1;
assign bus_out = test0.slc.d0.bus0.bus_out;
assign hex_data = test0.slc.memory_subsystem.hex_data;
assign Data_from_CPU = test0.slc.memory_subsystem.Data_from_CPU;

initial  begin
Clk = 0;
Run = 1; //off
Continue = 1; //off

//Basic IO test 1

SW = 10'h005A;


#2
//Reset 
Run = 0;
Continue = 0;

#2 //Start
Continue = 1;
Run = 1;

#2
Run = 0;

#2
Run = 1;

#80
SW = 10'h0003;
Continue = 0;

#2
Continue = 1;

#2
Continue = 0;

#2
Continue = 1;

#80
Continue = 0;

#2
Continue = 1;

#2
Continue = 0;

#2
Continue = 1;

end

endmodule






