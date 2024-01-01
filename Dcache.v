
module Dcache (
    input clk,
    input MemWrite,
    input [32-1: 0] alu_result_M,
    input [32-1: 0] rs2_rdata_M,
    output reg [32-1: 0] mem_rdata
        );

    wire [8-1: 0] addr;
    reg [32-1: 0] mem [256-1: 0];

    assign addr = alu_result_M [8-1: 0];
    
    always @(*) begin
        mem_rdata = mem [addr];
    end

    always @(posedge clk) begin
        if (MemWrite) begin
            mem [addr] <= rs2_rdata_M;
        end
    end
endmodule










