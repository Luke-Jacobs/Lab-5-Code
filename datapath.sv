
module datapath(
	input logic Clk, Reset,
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic SR2MUX, ADDR1MUX, MARMUX,
	input logic BEN, MIO_EN,
	input logic [1:0] PCMUX,
	input logic [15:0] MDR_In, // This is the same thing as Data_to_CPU
	output logic [6:0] HEX0, HEX1, HEX2, HEX3
);
	// WEEK 1 CODE - Reconnect Mem2IO to the hex drivers after week 1 demo
	always_comb begin
		HEX0 = IR[3:0];
		HEX1 = IR[7:4];
		HEX2 = IR[11:8];
		HEX3 = IR[15:12];
	end

	// "Special" registers
	
	// ===== PC =====
	logic [15:0] PC_out, PC_d;
	reg_16 PC_reg(.Clk(Clk), .D(PC_d), .Data_out(PC_out), .Load(LD_PC), .Reset(Reset));
	// PC Operations
	PC_operations op_PC(.PC_out(PC_out), .PCMUX_sig(PCMUX), .AddrAdder_out(AddrAdder_out), .Bus_out(Bus_out), 
							  .PC_in(PC_d));
	
	// ===== MDR =====
	logic [15:0] MDR_out, MDR_d;
	reg_16 MDR_reg(.Clk(Clk), .D(MDR_d), .Data_out(MDR_out), .Load(LD_MDR), .Reset(Reset));
	// MDR Operations
	mux_2_to_1 mux_mio_en(.a(MDR_In), .b(Bus_out), .select(MIO_EN));
	
	// ===== IR ======
	logic [15:0] IR_out, IR_d;
	reg_16 IR_reg(.Clk(Clk), .D(IR_d), .Data_out(IR_out), .Load(LD_IR), .Reset(Reset));

	// ===== ALU =====
	logic [15:0] ALU_out;

	// ALU wiring [insert module here]
	
	// ===== Address Adder =====
	logic [15:0] AddrAdder_out;
	
	// Wire up the bus
	logic [15:0] Bus_out;
	Bus bus0(.select_1hot({GateMDR, GateMARMUX, GateALU, GatePC}),
				.In_PC(PC), .In_ALU(ALU_out), .In_MARMUX(AddrAdder_out), .In_MDR(MDR),
				.bus_out(Bus_out));
				
	// Wire up the register file [insert module]
	

endmodule
