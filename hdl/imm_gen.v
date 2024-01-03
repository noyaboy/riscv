// `include "Def.v"
module imm_gen
(
    input [31:0] instr,
    output reg [31:0] imm
);

wire [6:0] opcode;
wire [31:0] i, s, b, j, u;
assign opcode = instr[6:0];
assign i = {{20{instr[31]}}, instr[31:20]};
assign s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign b = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
assign j = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
assign u = {instr[31:12], 12'd0};

always @(*) begin
    case(opcode)
        `R_TYPE:        imm = 0;
        `I_TYPE_OP_IMM: imm = i;
        `I_TYPE_LOAD:   imm = i;
        `S_TYPE:        imm = s;
        `B_TYPE:        imm = b;
        `J_TYPE:        imm = j;
        `I_TYPE_JALR:   imm = i;
        `U_TYPE_LUI:    imm = u;
        `U_TYPE_AUIPC:  imm = u;
        default:        imm = 0;
    endcase
end

endmodule