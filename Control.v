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
	output Jump,
	output Jal,
	output [2:0]ALUOp
	
	
);
localparam R_Type = 0;
//localparam R_Type_JR = 0;
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
//localparam R_Type_JR     = 9'b0111_001000;


reg [13:0] ControlValues;

always@(OP) begin
	casex(OP)
	   R_Type:       ControlValues= 13'b0_01_001_00_00_111;
		
		//R_Type_JR:    ControlValues= 13'b10_01_001_00_00_111;
		
		
		I_Type_ADDI:  ControlValues= 13'b0_00_101_00_00_100;
		I_Type_ORI:   ControlValues= 13'b0_00_100_00_00_001;
	   I_Type_LUI:   ControlValues= 13'b0_00_101_01_00_101;
 		
		
		I_Type_BEQ:   ControlValues= 13'b0_00_000_00_01_001;
		I_Type_BNE:   ControlValues= 13'b0_00_000_00_10_001;
		I_Type_LW:	  ControlValues= 13'b0_00_111_10_00_011;
		I_Type_SW:	  ControlValues= 13'b0_00_100_01_00_011;
		
		J_Type_J:	  ControlValues= 13'b0_10_000_00_00_000;
		J_Type_JAL:	  ControlValues= 13'b1_11_001_00_00_000;
		
		default:
			ControlValues= 13'b0000000000000;
		endcase
end	
//assign JR = ControlValues[13];

assign Jal = ControlValues[12];	
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


