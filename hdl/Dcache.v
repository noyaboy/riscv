
module Dcache 
#(
  parameter ADDR_WIDTH = 8,
  parameter ADDR_NUM = 256
) 
(
    input clk,
    input rst_n,
    input MemWrite,
    input [32-1: 0] alu_result_M,
    input [32-1: 0] rs2_rdata_M,
    input [2:0] funct3,
    output reg [32-1: 0] mem_rdata
);

wire [ADDR_WIDTH-1: 0] addr;
reg [32-1: 0] mem [ADDR_NUM-1: 0];
reg [32-1: 0] mem_n [ADDR_NUM-1: 0];
integer i;

wire ext;
wire mask_b;
wire mask_h;

assign ext = (funct3[0])? mem[addr][7]:
             (funct3[1])? mem[addr][15]:
             1'b0;

assign mask_b = (funct3[0])? 1'b1:
                (funct3[1])? 1'b0:
                1'b0;

assign mask_h = (funct3[0])? 1'b1:
                (funct3[1])? 1'b1:
                1'b0;

assign addr = alu_result_M [ADDR_WIDTH - 1: 0];

always @ (posedge clk) 
    if (~rst_n) begin
        for(i = 0; i < ADDR_NUM; i = i + 1) mem[i] <= 0;
    end
    else begin
        for(i = 0; i < ADDR_NUM; i = i + 1) mem[i] <= mem_n[i];
    end

always @(*) begin
    mem_rdata = 
    (mem[addr] & {{16{~(mask_b | mask_h)}}, {8{~mask_b}}, {8{1'b1}}}) |
    (ext       & {{16{(mask_b | mask_h)}}, {8{mask_b}}, {8{1'b0}}});
end

always @(*) begin
	for(i = 0; i < ADDR_NUM; i = i + 1) begin
        case(1'b1)
            funct3[0]: 
		        mem_n[i] = (MemWrite && (i == addr)) ? {mem[i][31:8], rs2_rdata_M[7:0]} : mem[i];
            funct3[1]: 
		        mem_n[i] = (MemWrite && (i == addr)) ? {mem[i][31:16], rs2_rdata_M[15:0]} : mem[i];
            funct3[2]: 
		        mem_n[i] = (MemWrite && (i == addr)) ? rs2_rdata_M : mem[i];
            default:
                mem_n[i] = (MemWrite && (i == addr)) ? rs2_rdata_M : mem[i];
        endcase
	end
end

endmodule










