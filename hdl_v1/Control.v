// `include "Def.v"
module control_unit(
    input [31:0] instr_ID,

    // EX ouput
    output reg ALU_src, // 1: read rs2, 0: read imm
    output reg [3:0] ALU_ctrl,

    // M
    output reg branch,
    output reg MemWrite,
    // output MemRead,
    output reg jal,
    output reg jalr,

    // RB
    output reg [1:0] PMAItoReg, // 11: PC, 10: Mem, 01: Alu, 00: Imm
    output reg rd_wen
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = instr_ID[6:0];
assign funct3 = instr_ID[14:12];
assign funct7 = instr_ID[31:25];

reg state, state_n;

wire r_type;
wire i_type;
wire i_type_load;
wire i_type_jalr;
wire s_type;
wire b_type;
wire u_type_lui;
wire u_type_auipc;
wire j_type;

assign r_type		= (opcode == `R_TYPE);
assign i_type		= (opcode == `I_TYPE_OP_IMM);
assign i_type_load	= (opcode == `I_TYPE_LOAD);
assign i_type_jalr	= (opcode == `I_TYPE_JALR);
assign s_type		= (opcode == `S_TYPE);
assign b_type		= (opcode == `B_TYPE);
assign u_type_lui	= (opcode == `U_TYPE_LUI);
assign u_type_auipc	= (opcode == `U_TYPE_AUIPC);
assign j_type		= (opcode == `J_TYPE);

always@* begin
    case(1'b1) 
        i_type_jalr: begin
            jal = 0;
            jalr = 1;
        end
        j_type: begin
            jal = 1;
            jalr = 0;
        end
        default: begin
            jal = 0;
            jalr = 0;
        end
    endcase
end

always@* begin
    case(1'b1) 
        r_type: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7[5];
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b1;
        end
        i_type: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = (funct3 == `FUNCT3_SLLI | funct3 == `FUNCT3_SRLI | funct3 == `FUNCT3_SRAI)? funct7[5]:
                          0;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b1;
        end
        i_type_load: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b1;
            PMAItoReg = 2'b10;
            rd_wen = 1'b1;
        end
        i_type_jalr: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = 0;
            branch = 1'b1;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b11;
            rd_wen = 1'b1;
        end
        s_type: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b1;
            // MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
        b_type: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = `FUNCT3_SUB;
            ALU_ctrl[3] = 1;
            branch = 1'b1;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
        u_type_lui: begin // no ALU passing
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b1;
        end
        u_type_auipc: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b1;
        end
        j_type: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b11;
            rd_wen = 1'b1;
        end
        default: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            // MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
    endcase
end

endmodule