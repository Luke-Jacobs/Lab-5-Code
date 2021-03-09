
module mux_2_to_1 #(parameter width = 16) (
	input logic [width-1:0] a,
	input logic [width-1:0] b,
	input logic select,
	output logic [width-1:0] out
);

always_comb
	begin	
		if (select)
			out = b;
		else
			out = a;
	end

endmodule
