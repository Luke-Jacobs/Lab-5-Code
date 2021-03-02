module mux_2_to_1(
	input logic [15:0] a,
	input logic [15:0] b,
	input logic select,
	output logic out
);

always_comb
	
	if (select)
		out = b;
	else
		out = a;
	
end

endmodule
