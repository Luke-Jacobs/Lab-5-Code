module reg_3 (input  logic Clk, Reset, Load,
              input  logic [2:0]  D,
              output logic [2:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 3'h0;
		 else if (Load)
			  Data_Out <= D; //set output
		end
endmodule
