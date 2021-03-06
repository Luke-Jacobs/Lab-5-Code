
module ALU(
	input logic [15:0] A,
	input logic [15:0] B,
	input logic [1:0] aluk,
	output logic [15:0] out
);

always_comb
	begin
		out = 16'h0000;
		unique case (aluk)
			// ADD operation
			2'b00:
				out = A + B;
			// AND operation
			2'b01:
				out = A & B;
			// NOT operation
			2'b10:
				out = ~A;
			2'b11:
				out = A;
		endcase
	end

endmodule
