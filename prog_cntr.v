`include "DEF.v"

module prog_cntr (
            input clk,
            input srst_n,
            input stall_vald,
            input jalr_vald,
            input branch_vald,
            input wg_pred_vald,
            input [32-1: 0] imm,
            input [32-1: 0] jalr_addr,
            output reg [32-1: 0] prog_cntr
       );


reg [32-1: 0] prog_cntr_sto;

reg [32-1: 0] prog_cntr_next;
reg [32-1: 0] prog_cntr_sto_next;

always @(posedge clk ) begin
    prog_cntr <= prog_cntr_next;
    prog_cntr_sto <= prog_cntr_sto_next;
end

always @(*) begin
    prog_cntr_sto_next = prog_cntr;

    case (1'b1)
        stall_vald: prog_cntr_sto_next = prog_cntr_sto;
    endcase
end

always @(*) begin
    prog_cntr_next = prog_cntr + 4;

    case (1'b1)
        (~srst_n): prog_cntr_next = 32'h0000_0000;
        (stall_vald): prog_cntr_next = prog_cntr;
        (jalr_vald): prog_cntr_next = jalr_addr;
        (branch_vald): prog_cntr_next = prog_cntr_sto + imm;
    endcase
end

endmodule
