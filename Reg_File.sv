
module reg_file(
	input logic Clk,
	input logic Reset,
	input logic LD_REG,
	input logic [15:0] BusIn,
	input logic [2:0] IR_8_to_6,
	input logic [2:0] IR_11_to_9,
	input logic [2:0] SR2_code,
	input logic SR1MUX,
	input logic DRMUX,
	output logic [15:0] SR2_out,
	output logic [15:0] SR1_out
);

	logic [15:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out;
	logic ld_r0, ld_r1, ld_r2, ld_r3, ld_r4, ld_r5, ld_r6, ld_r7;  // One-hot encoding - load signal determined by DRMUX code
	
	reg_16 r0(.*, .D(BusIn), .Data_Out(r0_out), .Load(ld_r0));
	reg_16 r1(.*, .D(BusIn), .Data_Out(r1_out), .Load(ld_r1));
	reg_16 r2(.*, .D(BusIn), .Data_Out(r2_out), .Load(ld_r2));
	reg_16 r3(.*, .D(BusIn), .Data_Out(r3_out), .Load(ld_r3));
	reg_16 r4(.*, .D(BusIn), .Data_Out(r4_out), .Load(ld_r4));
	reg_16 r5(.*, .D(BusIn), .Data_Out(r5_out), .Load(ld_r5));
	reg_16 r6(.*, .D(BusIn), .Data_Out(r6_out), .Load(ld_r6));
	reg_16 r7(.*, .D(BusIn), .Data_Out(r7_out), .Load(ld_r7));

	//DRMUX
	logic [2:0] DR_code;
	mux_2_to_1 #(3) (.a(IR_11_to_9), .b(3'b111), .select(DRMUX), .out(DR_code));
	
	//SR1MUX
	logic [2:0] SR1_code;
	mux_2_to_1 #(3) (.a(IR_8_to_6), .b(IR_11_to_9), .select(SR1MUX), .out(SR1_code));
	
	always_comb
	
		// Output / SR combinational logic
		SR1_out = 16'hXXXX;
		unique case (SR1_code)
			3'b000:
				SR1_out = r0_out;
			3'b001:
				SR1_out = r1_out;
			3'b010:
				SR1_out = r2_out;
			3'b011:
				SR1_out = r3_out;
			3'b100:
				SR1_out = r4_out;
			3'b101:
				SR1_out = r5_out;
			3'b110:
				SR1_out = r6_out;
			3'b111:
				SR1_out = r7_out;
		endcase
	
		// Output / SR2 combinational logic
		SR2_out = 16'hXXXX;
		unique case (SR2_code)
			3'b000:
				SR2_out = r0_out;
			3'b001:
				SR2_out = r1_out;
			3'b010:
				SR2_out = r2_out;
			3'b011:
				SR2_out = r3_out;
			3'b100:
				SR2_out = r4_out;
			3'b101:
				SR2_out = r5_out;
			3'b110:
				SR2_out = r6_out;
			3'b111:
				SR2_out = r7_out;
		endcase
	
		// Loading / DR combinational logic
		ld_r0 = 1'b0; 
		ld_r1 = 1'b0;
		ld_r2 = 1'b0;
		ld_r3 = 1'b0;
		ld_r4 = 1'b0;
		ld_r5 = 1'b0;
		ld_r6 = 1'b0;
		ld_r7 = 1'b0;
		unique case (DR_code)
			3'b000:
				ld_r0 = 1'b1;
			3'b001:
				ld_r1 = 1'b1;
			3'b010:
				ld_r2 = 1'b1;
			3'b011:
				ld_r3 = 1'b1;
			3'b100:
				ld_r4 = 1'b1;
			3'b101:
				ld_r5 = 1'b1;
			3'b110:
				ld_r6 = 1'b1;
			3'b111:
				ld_r7 = 1'b1;
		endcase
	end

endmodule
