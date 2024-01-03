`include "Def.v"
module stall_unit
(
    input [31:0] instr_ID,
    input [31:0] instr_EX,
    input [31:0] instr_M,
    output reg keep_PC,
    output reg keep_instr,
    output reg nop_sel
);

wire [6:0] opcode_ID;
wire [6:0] opcode_EX;
wire [6:0] opcode_M;
wire [4:0] rd_ID;
wire [4:0] rd_EX;
wire [4:0] rd_M;
wire [4:0] rs1_ID;
wire [4:0] rs1_EX;
wire [4:0] rs1_M;
wire [4:0] rs2_ID;
wire [4:0] rs2_EX;
wire [4:0] rs2_M;
assign opcode_ID = instr_ID[6:0];
assign opcode_EX = instr_EX[6:0];
assign opcode_M  = instr_M[6:0];
assign rd_ID = instr_ID[11:7];
assign rd_EX = instr_EX[11:7];
assign rd_M  = instr_M[11:7];
assign rs1_ID = instr_ID[19:15];
assign rs1_EX = instr_EX[19:15];
assign rs1_M  = instr_M[19:15];
assign rs2_ID = instr_ID[24:20];
assign rs2_EX = instr_EX[24:20];
assign rs2_M  = instr_M[24:20];

always @(*) begin
    case(1'b1)
        // lw cases
        (opcode_EX == `I_TYPE_LOAD && opcode_ID == `R_TYPE): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                (rd_EX == rs2_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        (opcode_EX == `I_TYPE_LOAD && opcode_ID == `I_TYPE_OP_IMM): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        (opcode_EX == `I_TYPE_LOAD && opcode_ID == `S_TYPE): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        // branch cases
        (opcode_EX == `R_TYPE && opcode_ID == `B_TYPE): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                (rd_EX == rs2_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        (opcode_EX == `I_TYPE_OP_IMM && opcode_ID == `B_TYPE): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                (rd_EX == rs2_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        (opcode_EX == `I_TYPE_LOAD && opcode_ID == `B_TYPE): begin
            case(1'b1)
                (rd_EX == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                (rd_EX == rs2_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:           {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        (opcode_M == `I_TYPE_LOAD && opcode_ID == `B_TYPE): begin
            case(1'b1)
                (rd_M == rs1_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                (rd_M == rs2_ID): {keep_PC, keep_instr, nop_sel} = 3'b111;
                default:          {keep_PC, keep_instr, nop_sel} = 3'b000;
            endcase
        end
        // jal case
        (opcode_EX == `J_TYPE): begin
            {keep_PC, keep_instr, nop_sel} = 3'b111;
        end
        /*
        (opcode_M == `J_TYPE): begin
            {keep_PC, keep_instr, nop_sel} = 3'b111;
        end
        */
        default: {keep_PC, keep_instr, nop_sel} = 3'b000;
    endcase
end

endmodule