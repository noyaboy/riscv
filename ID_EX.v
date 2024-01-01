module ID_EX(
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

    output [31:0] PC_EX,
    output [31:0] imm_EX,
    output [31:0] rs1_rdata_EX,
    output [31:0] rs2_rdata_EX,
    output [4:0] rd_waddr_EX,
    
    output ALU_src_EX,
    output [3:0] ALU_ctrl_EX,
    
    output branch_EX,
    output MemWrite_EX,
    output jal_EX,
    output jalr_EX,

    output [1:0] PMAItoReg_EX,
    output rd_wen_EX
);

always@(posedge clk) begin
    PC_EX <= PC_ID;
    imm_EX <= imm_ID;
    rs1_rdata_EX <= rs1_rdata_ID;
    rs2_rdata_EX <= rs2_rdata_ID;
    rd_waddr_EX <= rd_waddr_ID;

    ALU_src_EX <= ALU_src_ID;
    ALU_ctrl_EX <= ALU_ctrl_ID;

    branch_EX <= branch_ID;
    MemWrite_EX <= MemWrite_ID;
    jal_EX <= jal_ID;
    jalr_EX <= jalr_ID;

    PMAItoReg_EX <= PMAItoReg_ID;
    rd_wen_EX <= rd_wen_ID;
end








endmodule