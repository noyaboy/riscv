`include "Def.v"
module ALU
(
    input [31:0] opr1,
    input [31:0] opr2,
    input [3:0]  alu_ctrl,
    // input [6:0]  opcode,
    // input [2:0]  funct3,
    // input [6:0]  funct7,
    output zero,
    output reg [31:0] alu_out
);

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

always @(*) begin
    case(alu_ctrl)
        {1'b0, `FUNCT3_ADD}:  alu_out = opr1 + opr2;
        {1'b1, `FUNCT3_SUB}:  alu_out = opr1 - opr2;
        {1'b0, `FUNCT3_XOR}:  alu_out = opr1 ^ opr2;
        {1'b0, `FUNCT3_OR}:   alu_out = opr1 | opr2;
        {1'b0, `FUNCT3_AND}:  alu_out = opr1 & opr2;
        {1'b0, `FUNCT3_SLL}:  alu_out = opr1 << opr2;
        {1'b0, `FUNCT3_SRL}:  alu_out = opr1 >> opr2;
        {1'b1, `FUNCT3_SRA}:  alu_out = opr1 >>> opr2;
        {1'b0, `FUNCT3_SLT}:  alu_out = (opr1 < opr2) ? 1 : 0;
        {1'b0, `FUNCT3_SLTU}: alu_out = (opr1 < opr2) ? 1 : 0;
        default:              alu_out = 0;
    endcase
end

endmodule

// always @(*) begin
//     case(opcode)
//         `R_TYPE: begin
//             case(funct3)
//                 `FUNCT3_ADD:  alu_out = (funct7 == `FUNCT7_ADD) ? opr1 + opr2 : opr1 - opr2;
//                 `FUNCT3_XOR:  alu_out = opr1 ^ opr2;
//                 `FUNCT3_OR:   alu_out = opr1 | opr2;
//                 `FUNCT3_AND:  alu_out = opr1 & opr2;
//                 `FUNCT3_SLL:  alu_out = opr1 << opr2;
//                 `FUNCT3_SRL:  alu_out = (funct7 == `FUNCT7_SRL) ? opr1 >> opr2 : opr1 >>> opr2;
//                 `FUNCT3_SLT:  alu_out = (opr1 < opr2) ? 1 : 0;
//                 `FUNCT3_SLTU: alu_out = (opr1 < opr2) ? 1 : 0;
//                 default:      alu_out = 0;
//             endcase
//         end
//         `I_TYPE_OP_IMM: begin
//             case(funct3)
//                 `FUNCT3_ADDI:  alu_out = opr1 + opr2;
//                 `FUNCT3_XORI:  alu_out = opr1 ^ opr2;
//                 `FUNCT3_ORI:   alu_out = opr1 | opr2;
//                 `FUNCT3_ANDI:  alu_out = opr1 & opr2;
//                 `FUNCT3_SLLI:  alu_out = (funct7 == `FUNCT7_SLLI) ? opr1 << opr2 : 0;
//                 `FUNCT3_SRLI:  alu_out = (funct7 == `FUNCT7_SRLI) ? opr1 >> opr2 : opr1 >>> opr2;
//                 `FUNCT3_SLTI:  alu_out = (opr1 < opr2) ? 1 : 0;
//                 `FUNCT3_SLTIU: alu_out = (opr1 < opr2) ? 1 : 0;
//                 default:       alu_out = 0;
//             endcase
//         end
//         `I_TYPE_LOAD: begin
//             alu_out = opr1 + opr2;
//         end
//         `S_TYPE: begin
//             alu_out = opr1 + opr2;
//         end
//         `B_TYPE: begin
//             alu_out = 0;
//         end

//         default: alu_out = 0;
//     endcase
// end

// endmodule