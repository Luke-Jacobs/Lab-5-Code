
module address_adder(
	input logic [15:0] sext_11bit,
	input logic [15:0] sext_9bit,
	input logic [15:0] sext_6bit,
	input logic [15:0] PC,
	input logic [1:0] ADDR2MUX,
	input logic ADDR1MUX,
	input logic [15:0] SR1_out,
	output logic [15:0] ADDR_NEW
);

logic [15:0] Adder2Mux_out, Adder1Mux_out;

always_comb begin
		Adder2Mux_out = 16'hXXXX;
		Adder1Mux_out = 16'hXXXX;
		
		unique case (ADDR2MUX)
			2'b00:
				Adder2Mux_out = 16'h0000;
			2'b01:
				Adder2Mux_out = sext_6bit;
			2'b10:
				Adder2Mux_out = sext_9bit;
			2'b11:
				Adder2Mux_out = sext_11bit;
		endcase
		
		unique case (ADDR1MUX)
			1'b0:
				Adder1Mux_out = PC;
			1'b1:
				Adder1Mux_out = SR1_out;
		endcase
		
		ADDR_NEW = Adder2Mux_out + Adder1Mux_out;
end
	
	
endmodule

