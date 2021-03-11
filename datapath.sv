
module datapath(
	input logic Clk, Reset,
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED, // TODO: Figure out how to wire the LED's straight to the IR register
	input logic GatePC, GateMDR, GateALU, GateMARMUX, 
	input logic SR2MUX, SR1MUX, ADDR1MUX, DRMUX,
	input logic MIO_EN,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In, // This is the same thing as Data_to_CPU
	output logic [15:0] MAR,
	output logic [15:0] MDR,
	output logic [15:0] IR,
	output logic BEN
);


	logic [15:0] SR2_out, SR1_out, Bus_out, AddrAdder_out, PC_out, PC_d, MDR_out, MDR_d, IR_out, 
					 ALU_out;
	assign IR = IR_out; //assigns IR output
	assign MDR = MDR_out;
	logic [15:0] sext_sr2_ir, SR2mux_out;
	logic [15:0] sext_ir_11, sext_ir_9, sext_ir_6;
	
	// ===== PC =====
	reg_16 PC_reg(.Clk(Clk), .D(PC_d), .Data_Out(PC_out), .Load(LD_PC), .Reset(Reset));
	// PC Operations
	PC_operations op_PC(.PC_out(PC_out), .PCMUX_sig(PCMUX), .AddrAdder_out(AddrAdder_out), .Bus_out(Bus_out), 
							  .PC_in(PC_d));
	
	// ===== MDR =====
	 //Makes sure MDR gets to the MEM2IO
	reg_16 MDR_reg(.Clk(Clk), .D(MDR_d), .Data_Out(MDR_out), .Load(LD_MDR), .Reset(Reset));
	// MDR Operations
	mux_2_to_1 mux_mio_en(.a(Bus_out), .b(MDR_In), .select(MIO_EN), .out(MDR_d));
	
	// ===== IR ======
	reg_16 IR_reg(.Clk(Clk), .D(Bus_out), .Data_Out(IR_out), .Load(LD_IR), .Reset(Reset));
	
	
	// ===== MAR ======
	reg_16 MAR_reg(.Clk(Clk), .D(Bus_out)/*MAR_REG is always connected to the bus */, 
						.Data_Out(MAR)/*Direct connection*/, .Load(LD_MAR), .Reset(Reset)
						);
						
	// ===== Register File =====
	reg_file reg_file0(.Clk(Clk), .Reset(Reset), .LD_REG(LD_REG), .BusIn(Bus_out), 
							 .IR_8_to_6(IR_out[8:6]), .IR_11_to_9(IR_out[11:9]), .SR2_code(IR_out[2:0]),
							 .SR1MUX(SR1MUX), .DRMUX(DRMUX), .SR2_out(SR2_out), .SR1_out(SR1_out));

	// ===== ALU =====
	assign sext_sr2_ir = {{11{IR_out[4]}}, IR_out[4:0]};
	mux_2_to_1 mux_sr2mux(.a(SR2_out), .b(sext_sr2_ir), .select(SR2MUX), .out(SR2mux_out));
	
	ALU alu0(.A(SR1_out), .B(SR2mux_out), .aluk(ALUK), .out(ALU_out));
	
	// ===== Address Additions =====
	assign sext_ir_11 = {{5{IR_out[10]}}, IR_out[10:0]};
	assign sext_ir_9  = {{7{IR_out[8]}}, IR_out[8:0]};
	assign sext_ir_6  = {{10{IR_out[5]}}, IR_out[5:0]};
	address_adder address_adder0(.sext_11bit(sext_ir_11), .sext_9bit(sext_ir_9), .sext_6bit(sext_ir_6),
										  .PC(PC_out), .ADDR2MUX(ADDR2MUX), .ADDR1MUX(ADDR1MUX), .SR1_out(SR1_out),
										  .ADDR_NEW(AddrAdder_out));

	// ===== BUS =====
	Bus bus0(.select_1hot({GateMDR, GateMARMUX, GateALU, GatePC}),
				.In_PC(PC_out), .In_ALU(ALU_out), .In_MARMUX(AddrAdder_out), .In_MDR(MDR_out),
				.bus_out(Bus_out));
				
	// ===== Branch logic =====
	branch_logic branch_logic0(.Clk(Clk), .Reset(Reset), .Bus_In(Bus_out), .BEN_out(BEN),
										.LOAD_CC(LD_CC), .LOAD_BEN(LD_BEN), .IR_part(IR_out[11:9]));
				
//	// Wire up the register file [insert module]
//	assign   HEX0 = IR_out[3:0];
//	assign	HEX1 = IR_out[7:4];
//	assign	HEX2 = IR_out[11:8];
//	assign	HEX3 = IR_out[15:12];

endmodule
