module top_riscv_core (
    input clk,
    input rst
);

    ///////////// IF_STAGE && RB_STAGE /////////// 

    wire [32-1: 0] pc;
    wire [32-1: 0] pc_IF;
    wire [32-1: 0] instr_IF;
    wire [32-1: 0] PC_branch_M;
    wire [32-1: 0] alu_result_M;
    wire [32-1: 0] rd_wdata_RB;
    wire [31:0] imm_M;
    wire branch_valid;
    wire jalr_M;
    wire [31:0] pc_M;
    wire [32-1: 0] mem_rdata_M;
    wire [1:0] PMAItoReg_RB;
    wire [31:0] imm_RB;
    wire [31:0] mem_rdata_RB;
    wire [31:0] alu_result_RB;
    wire [31:0] pc_RB;

    assign pc_IF = pc + 4;
    assign rd_wdata_RB = (PMAItoReg_RB == 2'd3)? pc_RB:
        (PMAItoReg_RB == 2'd2)? mem_rdata_RB:
        (PMAItoReg_RB == 2'd1)? alu_result_RB: imm_RB;

    PC PC (
        .clk(clk),
        .rst(rst),
        .PC_IF(pc_IF),
        .PC_branch_M(PC_branch_M),
        .alu_result_M(alu_result_M),
        .branch_valid(branch_valid),
        .jalr_M(jalr_M),
        .PC(pc)
    );

    Icache (
        .pc(pc), .instr_IF(instr_IF)
    );

    ///////////// IF_STAGE && RB_STAGE /////////// 
    



    wire [32-1: 0] pc_ID;
    wire [32-1: 0] instr_ID;
    wire [5-1: 0] rs1_raddr;
    wire [5-1: 0] rs2_raddr;
    wire [5-1: 0] rd_waddr_ID;

    IF_ID (
        .clk(clk),
        .PC_IF(pc_IF),
        .instr_IF(instr_IF),
        .PC_ID(pc_ID),
        .instr_ID(instr_ID),
        .rs1_raddr(rs1_raddr),
        .rs2_raddr(rs2_raddr),
        .rd_waddr_ID(rd_waddr_ID)
    );




    ////////////////// ID_STAGE //////////////////

    wire ALU_src_ID;
    wire [4-1: 0] ALU_ctrl_ID;
    wire branch_ID;
    wire MemWrite_ID;
    wire jal_ID;
    wire jalr_ID;
    wire [2-1: 0] PMAItoReg_ID;
    wire rd_wen_ID;
    wire [32-1: 0] imm_ID;
    wire [32-1: 0] rs1_rdata_ID;
    wire [32-1: 0] rs2_rdata_ID;
    wire [5-1: 0] rd_waddr_RB;
    wire rd_wen_RB;

    control_unit control_unit (
        .instr_ID(instr_ID), .ALU_src(ALU_src_ID), .ALU_ctrl(ALU_ctrl_ID),
        .branch(branch_ID), .MemWrite(MemWrite_ID), .jal(jal_ID),
        .jalr(jalr_ID), .PMAItoReg(PMAItoReg_ID), .rd_wen(rd_wen_ID)
    );

    imm_gen imm_gen (
        .instr(instr_ID), .imm(imm_ID)
    );

    regfile regfile (
        .clk(clk), .srst_n(rst), .raddr1(rs1_raddr), .raddr2(rs2_raddr),
        .wen(rd_wen_RB), .waddr(rd_waddr_RB), .wdata(rd_wdata_RB), .rdata1(rs1_rdata_ID),
        .rdata2(rs2_rdata_ID)
    );

    ////////////////// ID_STAGE ////////////////// 




    wire ALU_src_EX;
    wire [3:0] ALU_ctrl_EX;
    wire [31:0] pc_EX;
    wire [31:0] imm_EX;
    wire [31:0] rs1_rdata_EX;
    wire [31:0] rs2_rdata_EX;
    wire [4:0] rd_waddr_EX;
    wire branch_EX;
    wire MemWrite_EX;
    wire jal_EX;
    wire jalr_EX;
    wire [1:0] PMAItoReg_EX;
    wire rd_wen_EX;

    ID_EX ID_EX (
        .clk(clk),
        .PC_ID(pc_ID),
        .imm_ID(imm_ID),
        .rs1_rdata_ID(rs1_rdata_ID),
        .rs2_rdata_ID(rs2_rdata_ID),
        .rd_waddr_ID(rd_waddr_ID),
        
        .ALU_src_ID(ALU_src_ID),
        .ALU_ctrl_ID(ALU_ctrl_ID),

        .branch_ID(branch_ID),
        .MemWrite_ID(MemWrite_ID),
        .jal_ID(jal_ID),
        .jalr_ID(jalr_ID),

        .PMAItoReg_ID(PMAItoReg_ID),
        .rd_wen_ID(rd_wen_ID),

        .PC_EX(pc_EX),
        .imm_EX(imm_EX),
        .rs1_rdata_EX(rs1_rdata_EX),
        .rs2_rdata_EX(rs2_rdata_EX),
        .rd_waddr_EX(rd_waddr_EX),
        
        .ALU_src_EX(ALU_src_EX),
        .ALU_ctrl_EX(ALU_ctrl_EX),
        
        .branch_EX(branch_EX),
        .MemWrite_EX(MemWrite_EX),
        .jal_EX(jal_EX),
        .jalr_EX(jalr_EX),

        .PMAItoReg_EX(PMAItoReg_EX),
        .rd_wen_EX(rd_wen_EX)
    );




    ////////////////// EX_STAGE ////////////////// 

    wire [32-1 :0] opr2;
    wire zero_EX;
    wire [32-1 :0] alu_result_EX;
    wire [31:0] PC_branch_EX;

    assign PC_branch_EX = pc_EX + (imm_EX << 2);
    assign opr2 = (ALU_src_EX)? rs2_rdata_EX: imm_EX;

    ALU ALU (
        .opr1(rs1_rdata_EX), .opr2(opr2), 
        .alu_ctrl(ALU_ctrl_EX), .zero(zero_EX), 
        .alu_out(alu_result_EX)
    );

    ////////////////// EX_STAGE ////////////////// 


    wire [32-1: 0] rs2_rdata_M;
    wire [4:0] rd_waddr_M;
    wire zero_M;
    wire branch_M;
    wire MemWrite_M;
    wire jal_M;
    wire rd_wen_M;
    wire [1:0] PMAItoReg_M;
    EX_M EX_M(
        .clk(clk),
        .PC_EX(pc_EX),
        .PC_branch_EX(PC_branch_EX),
        .imm_EX(imm_EX),
        .rs2_rdata_EX(rs2_rdata_EX),
        .rd_waddr_EX(rd_waddr_EX),
        
        .zero_EX(zero_EX),
        .alu_result_EX(alu_result_EX),

        .branch_EX(branch_EX),
        .MemWrite_EX(MemWrite_EX),
        .jal_EX(jal_EX),
        .jalr_EX(jalr_EX),

        .PMAItoReg_EX(PMAItoReg_EX),
        .rd_wen_EX(rd_wen_EX),

        .PC_M(pc_M),
        .PC_branch_M(PC_branch_M),
        .imm_M(imm_M),
        .rs2_rdata_M(rs2_rdata_M),
        .rd_waddr_M(rd_waddr_M),
        
        .zero_M(zero_M),
        .alu_result_M(alu_result_M),

        .branch_M(branch_M),
        .MemWrite_M(MemWrite_M),
        .jal_M(jal_M),
        .jalr_M(jalr_M),

        .PMAItoReg_M(PMAItoReg_M),
        .rd_wen_M(rd_wen_M)
    );

    ////////////////// M_STAGE /////////////////// 


    assign branch_valid = (branch_M && zero_M) || jal_M;

    Dcache Dcache(
        .clk(clk), .MemWrite(MemWrite_M), 
        .alu_result_M(alu_result_M), .rs2_rdata_M(rs2_rdata_M),
        .mem_rdata(mem_rdata_M)
    );

    ////////////////// M_STAGE /////////////////// 

    M_RB M_RB(
        .clk(clk),
        .PMAItoReg_M(PMAItoReg_M),
        .rd_wen_M(rd_wen_M),

        .imm_M(imm_M),
        .mem_rdata_M(mem_rdata_M),

        .alu_result_M(alu_result_M),
        .PC_M(PC_M),
        .rd_waddr_M(rd_waddr_M),

        .PMAItoReg_RB(PMAItoReg_RB),
        .rd_wen_RB(rd_wen_RB),

        .imm_RB(imm_RB),
        .mem_rdata_RB(mem_rdata_RB),

        .alu_result_RB(alu_result_RB),
        .PC_RB(pc_RB),
        .rd_waddr_RB(rd_waddr_RB)
    );

endmodule