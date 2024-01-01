module EX_M(
    input [31:0] PC_EX,
    input [31:0] PC_branch_EX,
    input [31:0] imm_EX,
    input [31:0] rs2_rdata_EX,
    input [4:0] rd_waddr_EX,
    
    input zero_EX,
    input [31:0] alu_result_EX,

    input branch_EX,
    input MemWrite_EX,
    input jal_EX,
    input jalr_EX,

    input [1:0] PMAItoReg_EX,
    input rd_wen_EX,

    output [31:0] PC_M,
    output [31:0] PC_branch_M,
    output [31:0] imm_M,
    output [31:0] rs2_rdata_M,
    output [4:0] rd_waddr_M,
    
    output zero_M,
    output [31:0] alu_result_M,

    output branch_M,
    output MemWrite_M,
    output jal_M,
    output jalr_M,

    output [1:0] PMAItoReg_M,
    output rd_wen_M
);

always@(posedge clk) begin
    PC_M <= PC_EX;
    PC_branch_M <= PC_branch_EX;
    imm_M <= imm_EX;
    rs2_rdata_M <= rs2_rdata_EX;
    rd_waddr_M <= rd_waddr_EX;
    
    zero_M <= zero_EX;
    alu_result_M <= alu_result_EX;

    branch_M <= branch_EX;
    MemWrite_M <= MemWrite_EX;
    jal_M <= jal_EX;
    jalr_M <= jalr_EX;

    PMAItoReg_M <= PMAItoReg_EX;
    rd_wen_M <= rd_wen_EX;
end

endmodule
