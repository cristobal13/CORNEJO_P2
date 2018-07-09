/******************************************************************
* Description
*	This is the control unit for the ALU. It receves an signal called 
*	ALUOp from the control unit and a signal called ALUFunction from
*	the intrctuion field named function.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	01/03/2014
******************************************************************/
module ALUControl
(
	input [2:0] ALUOp,
	input [5:0] ALUFunction,
	output [3:0] ALUOperation,
	output JR
);

localparam R_Type_AND    = 9'b0111_100100;
localparam R_Type_OR     = 9'b0111_100101;
localparam R_Type_NOR    = 9'b0111_100111;
localparam R_Type_ADD    = 9'b0111_100000;
localparam R_Type_SUB    = 9'b0111_100010;
localparam R_Type_JR     = 9'b0111_001000;
localparam I_Type_ANDI   = 9'b0000_xxxxxx;	 
localparam I_Type_ADDI   = 9'b0100_xxxxxx;
localparam I_Type_ORI    = 9'b0001_xxxxxx;
localparam I_Type_LUI    = 9'b0101_xxxxxx;

localparam I_Type_BEQ    = 9'b1101_xxxxxx;
localparam I_Type_BNE    = 9'b1101_xxxxxx;

localparam R_Type_SLL 	 = 9'b0111_000000;
localparam R_Type_SRL	 = 9'b0111_000010;
localparam I_Type_LW     = 9'b1001_xxxxxx;
localparam I_Type_SW     = 9'b1010_xxxxxx;
localparam J_Type_J      = 9'b0101_xxxxxx;
localparam J_Type_JAL    = 9'b0101_xxxxxx;


reg [4:0] ALUControlValues;
wire [8:0] Selector;

assign Selector = {ALUOp, ALUFunction};

always@(Selector)begin
	casex(Selector)
		R_Type_AND:    ALUControlValues = 5'b00000;
		R_Type_OR: 		ALUControlValues = 5'b00001;
		R_Type_NOR:    ALUControlValues = 5'b00010;
		R_Type_ADD:    ALUControlValues = 5'b00011;
		R_Type_SUB:    ALUControlValues = 5'b00100;
		R_Type_SLL: 	ALUControlValues = 5'b00110;
		R_Type_SRL: 	ALUControlValues = 5'b00111;
		R_Type_JR:     ALUControlValues = 5'b11001; //jr
		I_Type_ADDI:   ALUControlValues = 5'b00011;
		I_Type_ORI:    ALUControlValues = 5'b00001;
		I_Type_ANDI:   ALUControlValues = 5'b00000;
		I_Type_LUI:    ALUControlValues = 5'b00101;
		I_Type_ANDI:   ALUControlValues = 5'b00000;
		I_Type_BEQ:    ALUControlValues = 5'b01000;
		I_Type_BNE:    ALUControlValues = 5'b01000;
		I_Type_LW:		ALUControlValues = 5'b00011;
		I_Type_SW:		ALUControlValues = 5'b00011;
		J_Type_J:     ALUControlValues  = 5'b00101;
		J_Type_JAL:   ALUControlValues  = 5'b00101;
		
		default: ALUControlValues = 5'b01001;
	endcase
end

assign JR = ALUControlValues[4];
assign ALUOperation = ALUControlValues;


endmodule
