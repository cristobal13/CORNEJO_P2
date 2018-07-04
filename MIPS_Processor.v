
module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 32
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire BranchNE_wire;
wire BranchEQ_wire;
wire J_wire;         //jump
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire mux4mux_wire;  //
wire RegWrite_wire;
wire Mem2Reg_wire; //
wire mem_reg_wire; //
wire MemWrite_wire;
wire Zero_wire;
wire bne_wire;
wire beq_wire;
wire branch_wire;  //branch
wire MemRead_wire;
wire jr_wire;   //jr
wire jal_wire; //jal
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] shamt_Wire;
wire [4:0] WriteRegister_wire;
wire [31:0] MUX_PC_wire;
wire [31:0] PC_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0]	Sl_Adder_to_mux; //check
wire [31:0] mux2mux_wire; //
wire [31:0]	shift2mux_wire;
wire [31:0]	add2add;
wire [31:0]	ReadDataMem_wire;
wire [31:0] mux2PC_wire;
wire [31:0]	jr2pc_wire;
wire [31:0] address;
wire [31:0] DataWriteBackOrPc_4;
integer ALUStatus;
wire [31:0] lwwire;
wire [31:0] jal_selector;
wire [31:0] adder2jal_wire;
wire [31:0] pc4_ReadDataMem_wire;
wire [31:0] ra_WriteRegister_wire;

assign JR_wire = ReadData1_wire;
assign adder2jal_wire = PC_4_wire;
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire),
	.MemtoReg(Mem2Reg_wire),
	.J(j_wire),
	.JR(jr_wire),
	.Jal(jal_wire)
);


Multiplexer2to1		//  MUX4jr
#(
	.NBits(32)
)
MUX_For_jr
(
	.Selector(jr_wire),
	.MUX_Data0(address),
	.MUX_Data1(JR_wire),
	
	.MUX_Output(jr2pc_wire)

);

PC_Register				//PC
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.PCValue(PC_wire),
	.NewPC(jr2pc_wire)
);


ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire) /////adder
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);




RegisterFile
Register_File							//regfile
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(ra_WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(pc4_ReadDataMem_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);



ShiftLeft2
ShiftLeft_PC			//
(
	.DataInput(InmmediateExtend_wire),
	.DataOutput(sll_to_add_wire)         
);


Adder32bits
Shiftl_Adder			//
(
	.Data0(PC_4_wire),
	.Data1(sll_to_add_wire),
	
	.Result(Sl_Adder_to_mux) 
);



 Multiplexer2to1		//  old one
#(
	.NBits(32)
)
MUX_For_Mux
(
	.Selector(branch_wire),
	.MUX_Data0(add2add),
	.MUX_Data1(Sl_Adder_to_mux),
	
	.MUX_Output(mux2mux_wire)

);





ShiftLeft2
ShiftLeft_Mux_Alu			//
(
	.DataInput(Instruction_wire[15:0]),
	.DataOutput(shift2mux_wire)         
);


Multiplexer2to1		// MUX JUMP
#(
	.NBits(32)
)
MUX_For_JUMP
(
	.Selector(jump),
	.MUX_Data0(shift2mux_wire),
	.MUX_Data1(mux2mux_wire),
	
	.MUX_Output(address)   //jump1
	

);







Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_JAL //jal1
(
	.Selector(jal_wire),
	.MUX_Data0(ReadDataMem_wire), 
	.MUX_Data1(adder2jal_wire), 
	
	.MUX_Output(pc4_ReadDataMem_wire)
	
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_JAL_31 //jal2
(
	.Selector(jal_wire),
	.MUX_Data0(WriteRegister_wire),
	.MUX_Data1(31), 
	
	.MUX_Output(ra_WriteRegister_wire)
	
);



ANDGate
BEQ			 // AND1
(
	.A(BranchEQ_wire),
	.B(Zero_wire),  //
	
	.C(beq_wire)

);


ANDGate
BNE			 // AND1
(
	.A(BranchNE_wire),
	.B(Zero_wire),  //
	
	.C(bne_wire)

);

ORGate		// Or
Beq_Or
(
	.A(beq_wire),
	.B(bne_wire),
	
	.C(branch_wire)
);

ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire)

);



DataMemory
#(
	.DATA_WIDTH(8),
	.MEMORY_DEPTH(1024)
)
RAM
(
	.WriteData(ReadData2_wire),
	.Address(ALUResult_wire),
	.clk(clk),
	.ReadData(mem_reg_wire),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_RAM_Register				//mux ram
(
	.Selector(Mem2Reg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(mem_reg_wire),
	
	.MUX_Output(ReadDataMem_wire)
);

ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire),
	.shamt(Instruction_wire[10:6])
);


assign ALUResultOut = ALUResult_wire;


endmodule
