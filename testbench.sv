module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns; // This is the amount of time represented by #1 

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [1:0] PCMUX;
logic [15:0] MAR, PC, MDR, IR, Readout, PC_plus_1; 
logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

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
//assign state = test0.slc.state_controller.State;
//assign next_state = test0.slc.state_controller.Next_state;
                   
initial begin      


Clk = 0;
Run = 1;
Continue = 1;
SW = 10'b0000000011;

#2
//Reset 
Run = 0;
Continue = 0;

#4 //Start the processor
Continue = 1;

#4 //simulate button press
Run = 1;

#20
Continue = 0;
#2
Continue = 1;

#20
Continue = 0;
#2
Continue = 1;

#20
Continue = 0;
#2
Continue = 1;



end


endmodule
