`include "Def.v"

module forward_unit (
        input [32-1: 0] instr_IF,
        input [32-1: 0] instr_ID,
        input [32-1:0] instr_EX,
        input [32-1:0] instr_M,
        input [5-1: 0] rs1_raddr_ID,
        input [5-1: 0] rs2_raddr_ID,
        input [5-1: 0] rs1_raddr_EX,
        input [5-1: 0] rs2_raddr_EX,
        input [5-1: 0] rd_waddr_EX,
        input [5-1: 0] rs1_raddr_M,
        input [5-1: 0] rs2_raddr_M,
        input [5-1: 0] rd_waddr_M,
        input [5-1: 0] rs1_raddr_RB,
        input [5-1: 0] rs2_raddr_RB,
        input [5-1: 0] rd_waddr_RB,
        output reg [2-1: 0] rs1_ID_fwd, // 0,  1: EX_alu_result-> ID_rs1_rdata 2: M_alu_result-> ID_rs1_rdata, 3: M_memrdata-> ID_rs1_rdata
        output reg [2-1: 0] rs2_ID_fwd, // 0,  1: EX_alu_result-> ID_rs2_rdata 2: M_alu_result-> ID_rs2_rdata, 3: M_memrdata-> ID_rs2_rdata
        output reg rs2_EX_fwd // 0, 1: M_alu_result-> EX_rs2_rdata, 2: M_memrdata-> EX_rs2_rdata
);

    wire [6:0] op_IF;
    wire [6:0] op_ID;
    wire [6:0] op_EX;
    wire [6:0] op_M;

    assign op_IF = instr_IF[6:0];
    assign op_ID = instr_ID[6:0];
    assign op_EX = instr_EX[6:0];
    assign op_M = instr_M[6:0];

    always @(*) begin
        rs1_ID_fwd = 0;
        rs2_ID_fwd = 0;
        rs2_EX_fwd = 0;
        
        case (1'b1)
            (op_EX==`R_TYPE && op_ID==`R_TYPE && rd_waddr_EX == rs1_raddr_ID): rs1_ID_fwd = 1;
            (op_EX==`R_TYPE && op_ID==`R_TYPE && rd_waddr_EX == rs2_raddr_ID): rs2_ID_fwd = 1;
            (op_EX==`R_TYPE && op_ID==`I_TYPE_LOAD && rd_waddr_EX == rs1_raddr_ID): rs1_ID_fwd = 1;
            (op_EX==`R_TYPE && op_ID==`S_TYPE && rd_waddr_EX == rs1_raddr_ID): rs1_ID_fwd = 1;
            (op_M==`R_TYPE && op_EX==`S_TYPE && rd_waddr_M == rs2_raddr_EX): rs2_EX_fwd = 1;
            (op_M==`R_TYPE && op_ID==`B_TYPE && rd_waddr_M == rs1_raddr_ID): rs1_ID_fwd = 2;
            (op_M==`R_TYPE && op_ID==`B_TYPE && rd_waddr_M == rs2_raddr_ID): rs2_ID_fwd = 2;
            (op_M==`I_TYPE_LOAD && op_ID==`R_TYPE && rd_waddr_M == rs1_raddr_ID): rs1_ID_fwd = 3;
            (op_M==`I_TYPE_LOAD && op_ID==`R_TYPE && rd_waddr_M == rs2_raddr_ID): rs2_ID_fwd = 3;
            (op_M==`I_TYPE_LOAD && op_ID==`I_TYPE_LOAD && rd_waddr_M == rs1_raddr_ID): rs1_ID_fwd = 3;
            (op_M==`I_TYPE_LOAD && op_ID==`S_TYPE && rd_waddr_M == rs1_raddr_ID): rs1_ID_fwd = 3;
            (op_M==`I_TYPE_LOAD && op_EX==`S_TYPE && rd_waddr_M == rs2_raddr_EX): rs2_EX_fwd = 2;
            (op_M==`I_TYPE_LOAD && op_ID==`S_TYPE && rd_waddr_M == rs2_raddr_ID): rs2_ID_fwd = 3;
        endcase
    end

endmodule