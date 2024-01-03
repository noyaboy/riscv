module ID_EX(
    input clk,
    input rst_n,

    input [31:0] instr_ID,
    output reg [31:0] instr_EX,

    input [31:0] PC_ID,
    input [31:0] imm_ID,
    input [31:0] rs1_rdata_ID,
    input [31:0] rs2_rdata_ID,
    input [4:0] rd_waddr_ID,
    
    input ALU_src_ID,
    input [3:0] ALU_ctrl_ID,

    input branch_ID,
    input MemWrite_ID,
    input jal_ID,
    input jalr_ID,

    input [1:0] PMAItoReg_ID,
    input rd_wen_ID,

    input [5-1: 0] rs1_raddr_ID,
    input [5-1: 0] rs2_raddr_ID,
    output reg [5-1: 0] rs1_raddr_EX,
    output reg [5-1: 0] rs2_raddr_EX,

    output reg [31:0] PC_EX,
    output reg [31:0] imm_EX,
    output reg [31:0] rs1_rdata_EX,
    output reg [31:0] rs2_rdata_EX,
    output reg [4:0] rd_waddr_EX,
    
    output reg ALU_src_EX,
    output reg [3:0] ALU_ctrl_EX,
    
    output reg branch_EX,
    output reg MemWrite_EX,
    output reg jal_EX,
    output reg jalr_EX,

    output reg [1:0] PMAItoReg_EX,
    output reg rd_wen_EX
);

always@(posedge clk) begin
    if(!rst_n) begin
        rd_wen_EX <= 0;
        MemWrite_EX <= 0;
    end
    else begin
        rd_wen_EX <= rd_wen_ID;
        MemWrite_EX <= MemWrite_ID;
    end
end

always@(posedge clk) begin
    PC_EX <= PC_ID;
    imm_EX <= imm_ID;
    rs1_rdata_EX <= rs1_rdata_ID;
    rs2_rdata_EX <= rs2_rdata_ID;
    rd_waddr_EX <= rd_waddr_ID;

    ALU_src_EX <= ALU_src_ID;
    ALU_ctrl_EX <= ALU_ctrl_ID;

    branch_EX <= branch_ID;
    jal_EX <= jal_ID;
    jalr_EX <= jalr_ID;

    PMAItoReg_EX <= PMAItoReg_ID;
    rs1_raddr_EX <= rs1_raddr_ID;
    rs2_raddr_EX <= rs2_raddr_ID;

    instr_EX <= instr_ID;
end








endmodule