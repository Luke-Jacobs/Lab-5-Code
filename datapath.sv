
module datapath(
	input logic Clk, Reset,
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic SR2MUX, ADDR1MUX, MARMUX,
	input logic BEN, MIO_EN,
	input logic [1:0] PCMUX,
	input logic [15:0] MDR_In, // This is the same thing as Data_to_CPU
	output logic [3:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] MAR
);
	// WEEK 1 CODE - Reconnect Mem2IO to the hex drivers after week 1 demo

	// "Special" registers
	
	logic [15:0] Bus_out;
	
	// ===== Address Adder =====
	logic [15:0] AddrAdder_out;	
	

	// ===== PC =====
	logic [15:0] PC_out, PC_d;
	reg_16 PC_reg(.Clk(Clk), .D(PC_d), .Data_Out(PC_out), .Load(LD_PC), .Reset(Reset));
	// PC Operations
	PC_operations op_PC(.PC_out(PC_out), .PCMUX_sig(PCMUX), .AddrAdder_out(AddrAdder_out), .Bus_out(Bus_out), 
							  .PC_in(PC_d));
	
	// ===== MDR =====
	logic [15:0] MDR_out, MDR_d;
	reg_16 MDR_reg(.Clk(Clk), .D(MDR_d), .Data_Out(MDR_out), .Load(LD_MDR), .Reset(Reset));
	// MDR Operations
	mux_2_to_1 mux_mio_en(.a(MDR_In), .b(Bus_out), .select(MIO_EN));
	
	// ===== IR ======
	logic [15:0] IR_out, IR_d;
	reg_16 IR_reg(.Clk(Clk), .D(IR_d), .Data_Out(IR_out), .Load(LD_IR), .Reset(Reset));
	
	
	// ===== MAR ======
	reg_16 MAR_reg(.Clk(Clk), .D(Bus_out)/*MAR_REG is always connected to the bus */, 
						.Data_Out(MAR)/*Direct connection*/, .Load(LD_MAR), .Reset(Reset)
						);
	

	// ===== ALU =====
	logic [15:0] ALU_out;

	// ALU wiring [insert module here]
	

	
	// Wire up the bus

	Bus bus0(.select_1hot({GateMDR, GateMARMUX, GateALU, GatePC}),
				.In_PC(PC_out), .In_ALU(ALU_out), .In_MARMUX(AddrAdder_out), .In_MDR(MDR_out),
				.bus_out(Bus_out));
				
	// Wire up the register file [insert module]
	assign   HEX0 = IR_out[3:0];
	assign	HEX1 = IR_out[7:4];
	assign	HEX2 = IR_out[11:8];
	assign	HEX3 = IR_out[15:12];

endmodule
