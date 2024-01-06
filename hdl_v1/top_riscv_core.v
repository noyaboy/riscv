// `include "Def.v"
module top_riscv_core 
#(
  parameter ADDR_WIDTH = 8,
  parameter ADDR_NUM = 256
) 
(
    input clk,
    input rst_n,
    input boot_up,
    input [ADDR_WIDTH-1:0] boot_addr,
    input [32-1 :0] boot_datai
);

    wire [32-1: 0] pc;
    wire [32-1: 0] pc_ID;
    wire [32-1: 0] pc_ID_org;
    wire [32-1 :0] pc_EX;
    wire [32-1: 0] pc_EX_org;
    wire [32-1 :0] pc_M;
    wire [32-1 :0] pc_RB;
    wire [32-1: 0] instr_IF;
    wire [32-1: 0] instr_ID;
    wire [32-1:0] instr_EX;
    wire [32-1:0] instr_M;
    wire [32-1: 0] pc_branch_M;
    wire [32-1 :0] alu_result_EX;
    wire [32-1: 0] alu_result_M;
    wire [32-1 :0] alu_result_RB;
    wire [32-1: 0] rd_wdata_RB;
    wire branch_valid;
    wire branch_equal;
    wire jalr_ID;
    wire jalr_EX;
    wire jalr_M;
    wire [32-1: 0] mem_rdata_M;
    wire [32-1: 0] mem_rdata_RB;
    wire [ADDR_WIDTH-1:0] icache_addr;
    wire alu_src_EX;
    wire alu_src_ID;
    wire [4-1: 0] alu_ctrl_ID;
    wire [4-1: 0] alu_ctrl_EX;
    wire [2-1: 0] PMAItoReg_ID;
    wire [2-1: 0] PMAItoReg_EX;
    wire [2-1: 0] PMAItoReg_M;
    wire [2-1: 0] PMAItoReg_RB;
    wire [32-1: 0] imm_ID;
    wire [32-1: 0] imm_EX;
    wire [32-1: 0] imm_M;
    wire [32-1: 0] imm_RB;
    wire [32-1: 0] rs1_rdata_ID;
    wire [32-1: 0] rs1_rdata_EX;
    wire [32-1: 0] rs2_rdata_ID;
    wire [32-1: 0] rs2_rdata_EX;
    wire [32-1: 0] rs2_rdata_M;
    wire [5-1: 0] rd_waddr_ID;
    wire [5-1: 0] rd_waddr_EX;
    wire [5-1: 0] rd_waddr_M;
    wire [5-1: 0] rd_waddr_RB;
    wire rd_wen_ID;
    wire rd_wen_EX;
    wire rd_wen_M;
    wire rd_wen_RB;
    wire branch_ID;
    wire branch_EX;
    wire branch_M;
    wire [32-1 :0] opr1; 
    wire [32-1 :0] opr2;
    wire [3-1: 0] funct3_M;
    wire zero_EX;
    wire zero_M;
    wire mem_write_ID;
    wire mem_write_EX;
    wire mem_write_M;
    wire jal_ID;
    wire jal_EX;
    wire jal_M;
    wire [5-1: 0] rs1_raddr_ID;
    wire [5-1: 0] rs1_raddr_EX;
    wire [5-1: 0] rs1_raddr_M;
    wire [5-1: 0] rs1_raddr_RB;
    wire [5-1: 0] rs2_raddr_ID;
    wire [5-1: 0] rs2_raddr_EX;
    wire [5-1: 0] rs2_raddr_M;
    wire [5-1: 0] rs2_raddr_RB;
    wire [32-1:0] instr_ID_mux;
    wire [2-1: 0] opr1_fwd;
    wire [2-1: 0] opr2_fwd;
    wire memstore_fwd;
    wire keep_pc;
    wire keep_instr;
    wire nop_sel;
    wire pc_running;
    wire [31:0] pc_branch_ID;
    wire beq_ID;
    wire bne_ID;
    wire auipc_EX;

    assign rd_wdata_RB = (PMAItoReg_RB == 2'd3)? pc_RB:
        (PMAItoReg_RB == 2'd2)? mem_rdata_RB:
        (PMAItoReg_RB == 2'd1)? alu_result_RB: imm_RB;

    assign opr1 = (auipc_EX) ? pc_EX_org : rs1_rdata_EX;
    assign opr2 = (alu_src_EX)? rs2_rdata_EX: imm_EX;

    assign beq_ID = (instr_ID[14:12] == 3'b000) && (rs1_rdata_ID == rs2_rdata_ID);
    assign bne_ID = (instr_ID[14:12] == 3'b001) && ~(rs1_rdata_ID == rs2_rdata_ID);
    assign branch_valid = ((beq_ID || bne_ID) && branch_ID) || jal_ID;
    assign pc_branch_ID = pc_ID_org + (imm_ID);

    ///////////// IF_STAGE && RB_STAGE /////////// 

    PC PC_U0 (
        .clk(clk),
        .rst_n(rst_n),
        .pc_branch_M(pc_branch_ID), // PC_branch_ID
        .alu_result_M(alu_result_M),
        .boot_up(boot_up),
        .keep_PC(keep_pc),
        .branch_valid(branch_valid),
        .jalr_M(jalr_M),
        .pc(pc),
        .pc_running(pc_running)
    );

    Icache Icache_U0 (
        .clk(clk),
        .rst_n(rst_n),
        .pc_running(pc_running),
        .pc(pc),
        .boot_addr(boot_addr),
        .wen(boot_up),
        .wdata(boot_datai),
        .rdata(instr_IF)
    );

    ///////////// IF_STAGE && RB_STAGE /////////// 
    
    IF_ID IF_ID_U0 (
        .clk(clk),
        .rst_n(rst_n),
        .pc_running(pc_running),
        .pc(pc),
        .instr_IF(instr_IF),
        .keep_instr(keep_instr),
        .PC_ID(pc_ID),
        .PC_ID_org(pc_ID_org),
        .instr_ID(instr_ID),
        .rs1_raddr(rs1_raddr_ID),
        .rs2_raddr(rs2_raddr_ID),
        .rd_waddr_ID(rd_waddr_ID)
    );

    ////////////////// ID_STAGE //////////////////


    control_unit control_unit_U0 (
        .instr_ID(instr_ID), .ALU_src(alu_src_ID), .ALU_ctrl(alu_ctrl_ID),
        .branch(branch_ID), .MemWrite(mem_write_ID), .jal(jal_ID),
        .jalr(jalr_ID), .PMAItoReg(PMAItoReg_ID), .rd_wen(rd_wen_ID)
    );

    imm_gen imm_gen_U0 (
        .instr(instr_ID), .imm(imm_ID)
    );

    regfile regfile_U0 (
        .clk(clk), .srst_n(rst_n), .raddr1(rs1_raddr_ID), .raddr2(rs2_raddr_ID),
        .wen(rd_wen_RB), .waddr(rd_waddr_RB), .wdata(rd_wdata_RB),
        .rdata1(rs1_rdata_ID), .rdata2(rs2_rdata_ID)
    );

    ////////////////// ID_STAGE ////////////////// 

    ID_EX ID_EX_U0 (
        .clk(clk), 
        .rst_n(rst_n),
        .PC_ID(pc_ID),
        .PC_ID_org(pc_ID_org),
        .imm_ID(imm_ID),
        .rs1_rdata_ID(rs1_rdata_ID),
        .rs2_rdata_ID(rs2_rdata_ID),
        .rd_waddr_ID(rd_waddr_ID),
        .ALU_src_ID(alu_src_ID),
        .ALU_ctrl_ID(alu_ctrl_ID),
        .branch_ID(branch_ID),
        .MemWrite_ID(mem_write_ID),
        .jal_ID(jal_ID),
        .jalr_ID(jalr_ID),
        .PMAItoReg_ID(PMAItoReg_ID),
        .rd_wen_ID(rd_wen_ID),
        .PC_EX(pc_EX),
        .PC_EX_org(pc_EX_org),
        .imm_EX(imm_EX),
        .rs1_rdata_EX(rs1_rdata_EX),
        .rs2_rdata_EX(rs2_rdata_EX),
        .rd_waddr_EX(rd_waddr_EX),
        .ALU_src_EX(alu_src_EX),
        .ALU_ctrl_EX(alu_ctrl_EX),
        .branch_EX(branch_EX),
        .MemWrite_EX(mem_write_EX),
        .jal_EX(jal_EX),
        .jalr_EX(jalr_EX),
        .PMAItoReg_EX(PMAItoReg_EX),
        .rd_wen_EX(rd_wen_EX),
        .rs1_raddr_ID(rs1_raddr_ID), .rs2_raddr_ID(rs2_raddr_ID),
        .rs1_raddr_EX(rs1_raddr_EX), .rs2_raddr_EX(rs2_raddr_EX),
        .instr_ID(instr_ID), .instr_EX(instr_EX),
        .auipc_EX(auipc_EX)
    );

    ////////////////// EX_STAGE ////////////////// 

    ALU ALU_U0 (
        .opr1(opr1), .opr2(opr2), 
        .alu_ctrl(alu_ctrl_EX), .zero(zero_EX), 
        .alu_out(alu_result_EX)
    );

    ////////////////// EX_STAGE ////////////////// 

    EX_M EX_M_U0(
        .clk(clk),
        .rst_n(rst_n),
        .PC_EX(pc_EX),
        .imm_EX(imm_EX),
        .rs2_rdata_EX(rs2_rdata_EX),
        .rd_waddr_EX(rd_waddr_EX),
        .ALU_ctrl_EX(alu_ctrl_EX),
        .zero_EX(zero_EX),
        .alu_result_EX(alu_result_EX),
        .branch_EX(branch_EX),
        .MemWrite_EX(mem_write_EX),
        .jal_EX(jal_EX),
        .jalr_EX(jalr_EX),
        .PMAItoReg_EX(PMAItoReg_EX),
        .rd_wen_EX(rd_wen_EX),
        .PC_M(pc_M),
        .PC_branch_M(pc_branch_M),
        .imm_M(imm_M),
        .rs2_rdata_M(rs2_rdata_M),
        .rd_waddr_M(rd_waddr_M),
        .funct3_M(funct3_M),
        .alu_result_M(alu_result_M),
        .branch_M(branch_M),
        .MemWrite_M(mem_write_M),
        .jal_M(jal_M),
        .jalr_M(jalr_M),
        .PMAItoReg_M(PMAItoReg_M),
        .rd_wen_M(rd_wen_M),
        .rs1_raddr_EX(rs1_raddr_EX),
        .rs2_raddr_EX(rs2_raddr_EX),
        .rs1_raddr_M(rs1_raddr_M),
        .rs2_raddr_M(rs2_raddr_M),
        .instr_EX(instr_EX),
        .instr_M(instr_M)
    );

    ////////////////// M_STAGE /////////////////// 

    Dcache Dcache_U0(
        .clk(clk),
        .rst_n(rst_n),
        .MemWrite(mem_write_M), 
        .alu_result_M(alu_result_M), 
        .rs2_rdata_M(rs2_rdata_M),
        .funct3(funct3_M),
        .mem_rdata(mem_rdata_M)
    );

    ////////////////// M_STAGE /////////////////// 

    M_RB M_RB_U0(
        .clk(clk),
        .rst_n(rst_n),
        .PMAItoReg_M(PMAItoReg_M),
        .rd_wen_M(rd_wen_M),
        .imm_M(imm_M),
        .mem_rdata_M(mem_rdata_M),
        .alu_result_M(alu_result_M),
        .PC_M(pc_M),
        .rd_waddr_M(rd_waddr_M),
        .PMAItoReg_RB(PMAItoReg_RB),
        .rd_wen_RB(rd_wen_RB),
        .imm_RB(imm_RB),
        .mem_rdata_RB(mem_rdata_RB),
        .alu_result_RB(alu_result_RB),
        .PC_RB(pc_RB),
        .rd_waddr_RB(rd_waddr_RB),
        .rs1_raddr_RB(rs1_raddr_RB),
        .rs2_raddr_RB(rs2_raddr_RB),
        .rs1_raddr_M(rs1_raddr_M),
        .rs2_raddr_M(rs2_raddr_M)
    );

    ////////////////// STALL_UNIT /////////////////// 

    assign keep_instr = 0;
    assign keep_pc = 0;
/*
    stall_unit stall_unit_U0(
        .instr_ID(instr_ID),
        .instr_EX(instr_EX),
        .instr_M(instr_M),
        .keep_PC(keep_pc),
        .keep_instr(keep_instr),
        .nop_sel(nop_sel)
    );

    nop_mux nop_mux_U0(
        .instr_ID(instr_ID),
        .nop_sel(nop_sel),
        .instr_ID_mux(instr_ID_mux)
    );

    ////////////////// STALL_UNIT ///////////////////      

    forward_unit forward_unit(
        .rs1_raddr_EX(rs1_raddr_EX),
        .rs2_raddr_EX(rs2_raddr_EX),
        .rd_waddr_EX(rd_waddr_EX),
        .rs1_raddr_M(rs1_raddr_M),
        .rs2_raddr_M(rs2_raddr_M),
        .rd_waddr_M(rd_waddr_M),
        .rs1_raddr_RB(rs1_raddr_RB),
        .rs2_raddr_RB(rs2_raddr_RB),
        .rd_waddr_RB(rd_waddr_RB),

        .opr1_fwd(opr1_fwd),
        .opr2_fwd(opr2_fwd),
        .memstore_fwd(memstore_fwd)
    );
*/

endmodule
