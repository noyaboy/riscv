`include "Def.v"
module control_unit(
    input clk, 
    input rst,
    input [31:0] instr_ID,

    // EX ouput
    output ALU_src, // 1: read rs2, 0: read imm
    output ALU_ctrl,

    // M
    output branch,
    output MemWrite,
    output MemRead,
    output jal,
    output jalr,

    // RB
    output PMAItoReg, // 11: PC, 10: Mem, 01: Alu, 00: Imm
    ouput rd_wen
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = instr_ID[6:0];
assign funct3 = instr_ID[14:12];
assign funct7 = instr_ID[31:25];

reg state, state_n;

assign r_type		= (opcode == `R_TYPE);
assign i_type		= (opcode == `I_TYPE_OP_IMM);
assign i_type_load	= (opcode == `I_TYPE_LOAD);
assign i_type_jalr	= (opcode == `JALR);
assign s_type		= (opcode == `STORE);
assign b_type		= (opcode == `BRANCH);
assign u_type_lui	= (opcode == `LUI);
assign u_type_auipc	= (opcode == `AUIPC);
assign j_type		= (opcode == `JAL);

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
            MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b1;
        end
        i_type: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7[5];
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b1;
        end
        i_type_load: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b1;
            PMAItoReg = 2'b10;
            rd_wen = 1'b1;
        end
        i_type_jalr: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = 0;
            branch = 1'b1;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b01;
            rd_wen = 1'b0;
        end
        s_type: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = `FUNCT3_ADD;
            ALU_ctrl[3] = 0;
            branch = 1'b0;
            MemWrite = 1'b1;
            MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
        b_type: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = `FUNCT3_SUB;
            ALU_ctrl[3] = 0;
            branch = 1'b1;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
        u_type_lui: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b1;
        end
        u_type_auipc: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b11;
            rd_wen = 1'b1;
        end
        j_type: begin 
            ALU_src = 1'b1;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
        default: begin 
            ALU_src = 1'b0;
            ALU_ctrl[2:0] = funct3;
            ALU_ctrl[3] = funct7;
            branch = 1'b0;
            MemWrite = 1'b0;
            MemRead = 1'b0;
            PMAItoReg = 2'b00;
            rd_wen = 1'b0;
        end
    endcase
end


endmodule


