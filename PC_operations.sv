module PC_operations(
	input logic [15:0] PC_out,  // This is the Q output from the PC register (instance in datapath)
	input logic [1:0] PCMUX_sig,  // This is taken from the state machine / control unit
	input logic [15:0] AddrAdder_out,  // The combinational logic output from the address adder
	input logic [15:0] Bus_out,
	output logic [15:0] PC_in  // This is the D input into the PC register 
);

logic [15:0] PC_plus_1;
always_comb begin
	// Incrementing combinational logic
	
	PC_plus_1 = PC_out +16'h0001;
	
	// Implements PCMUX
	unique case (PCMUX_sig)
		2'b00: PC_in = PC_plus_1; // This selects the option for PC++
		2'b01: PC_in = AddrAdder_out; // PC becomes the address adder result
		2'b10: PC_in = Bus_out; // PC becomes whatever is put into the bus
		default: PC_in = 16'hXXXX;
	endcase
	
end

endmodule
