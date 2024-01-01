`include "Def.v"
module PC(
    input clk,
    input rst,
    input [31:0] PC_IF,
    input [31:0] PC_branch_M,
    input [31:0] alu_result_M,
    input branch_valid,
    input jalr_M,
    output [31:0] PC
);

reg PC_temp;

always@(posedge clk) begin
    if(~rst)
        PC <= 0;
    else
        PC <= PC_temp;
end

always@* begin
    case(1'b1)
        branch_valid: PC_temp = PC_branch_M;
        jalr_M: PC_temp = alu_result_M;
        default: PC_temp = PC_IF;
    endcase
end

endmodule