module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns; // This is the amount of time represented by #1 

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;


always begin : CLOCK
	#1 Clk = ~Clk;
end





slc3_testtop test0(.*);
                   
                   
initial begin      


Clk = 0;
Run = 1;
Continue = 1;

#2
//Reset 
Run = 0;
Continue = 0;

#2 //Start the processor
Continue = 1;

#2 //simulate button press
Run = 1;




end


endmodule
