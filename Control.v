/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	
	output RegDst,
	output BranchEQ,
	output BranchNE,
	output MemRead,
	output MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output J,
	output JR,
	output Jal,
	output [2:0]ALUOp
	
);
localparam R_Type = 0;
localparam R_Type_JR = 6'h08;
localparam I_Type_ADDI = 6'h08;
localparam I_Type_ORI  = 6'h0d;
localparam I_Type_LUI  = 6'hf;
localparam I_Type_ANDI = 6'h0c;
localparam I_Type_LW   = 6'h23;
localparam I_Type_SW	  = 6'h2b;
localparam I_Type_BEQ  = 6'h04;
localparam I_Type_BNE  = 6'h05;
localparam J_Type_J    = 6'h02;
localparam J_Type_JAL  = 6'h03;



reg [13:0] ControlValues;

always@(OP) begin
	casex(OP)
	   R_Type:       ControlValues= 14'b00_01_001_00_00_111;
		
		R_Type_JR:    ControlValues= 14'b01_01_001_00_00_111;
		I_Type_ADDI:  ControlValues= 14'b00_00_101_00_00_100;
		I_Type_ORI:   ControlValues= 14'b00_00_101_00_00_101;
	   I_Type_LUI:   ControlValues= 14'b00_00_101_01_00_101;
 		
		
		I_Type_BEQ:   ControlValues= 14'b00_00_000_00_01_001;
		I_Type_BNE:   ControlValues= 14'b00_00_000_00_10_001;
		I_Type_LW:	  ControlValues= 14'b00_00_111_10_00_011;
		I_Type_SW:	  ControlValues= 14'b00_00_100_01_00_011;
		
		J_Type_J:	  ControlValues= 14'b00_10_000_00_00_000;
		J_Type_JAL:	  ControlValues= 14'b10_11_001_00_00_000;
		
		default:
			ControlValues= 14'b0000000000000;
		endcase
end	

assign Jal = ControlValues[13];	
assign JR = ControlValues[12];	
assign Jump = ControlValues[11];	
assign RegDst = ControlValues[10];
assign ALUSrc = ControlValues[9];
assign MemtoReg = ControlValues[8];
assign RegWrite = ControlValues[7];
assign MemRead = ControlValues[6];
assign MemWrite = ControlValues[5];
assign BranchNE = ControlValues[4];
assign BranchEQ = ControlValues[3];
assign ALUOp = ControlValues[2:0];	

endmodule


