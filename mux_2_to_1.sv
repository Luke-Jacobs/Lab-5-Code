module mux_2_to_1(
	input logic [15:0] a,
	input logic [15:0] b,
	input logic select,
	output logic [15:0] out
);

always_comb
	begin	
		if (select)
			out = b;
		else
			out = a;
		
	end

endmodule
