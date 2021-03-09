
module branch_logic(
	input logic Clk,
	input logic Reset,
	input logic [15:0] Bus_In,
	input logic [2:0]  IR_part, // This is NZP in this order
	input logic LOAD_CC,
	input logic LOAD_BEN,
	output logic BEN_out
);

	logic N_out, Z_out, P_out, Bus_zero;
	logic N_in, Z_in, P_in, BEN_in;
	reg_16 nzp_reg(.Clk(Clk), .Load(LOAD_CC), .Reset(Reset), .D({13'b0, N_in, Z_in, P_in}), .Data_Out({13'b0, N_out, Z_out, P_out}));
	
	always_comb
	begin
		N_in = Bus_In[15];
	
		if (Bus_In == 16'h0000)
			Z_in = 1'b1;
		else
			Z_in = 1'b0;
		
		P_in = ~Bus_In[15];
		
		BEN_in = (IR_part[2]&N_out) | (IR_part[1]&Z_out) | (IR_part[0]&P_out);
	end
	
	// BEN Flip Flop
	always_ff @ (posedge Clk) begin
	if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
		BEN_out <= 1'h0;
	else if (LOAD_BEN)
		BEN_out <= BEN_in; //set output
	end

endmodule
