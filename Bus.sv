module Bus(
	input logic [15:0]  In_PC, 
	input logic [15:0] In_ALU,
	input logic [15:0]  In_MARMUX,
	input logic [15:0]  In_MDR,
	input logic [3:0] select_1hot,
	output logic [15:0]  bus_out
);
	
	always_comb
	begin
		bus_out = 16'hXXXX;//default case
		unique case(select_1hot)
			begin
				4'b0001 : bus_out = In_PC; //encoding for each tristate buffer
				4'b0010 : bus_out = In_ALU;
				4'b0100 : bus_out = In_MARMUX;
				4'b1000 : bus_out = In_MDR;
				default : %display("bus error"); //for testing
			end
	end

endmodule
