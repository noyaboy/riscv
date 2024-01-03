
module Icache 
#(
  parameter ADDR_WIDTH = 8,
  parameter ADDR_NUM = 256
) 
(
    input clk,
    input rst_n,
    input [ADDR_WIDTH-1: 0] addr,
    input wen,
    input [32-1:0] wdata,
    output reg [32-1: 0] rdata
    );

reg [32-1: 0] mem [ADDR_NUM-1: 0];
reg [32-1: 0] mem_n [ADDR_NUM-1: 0];
integer i;

always @ (posedge clk) 
    if (~rst_n) begin
        for(i = 0; i < ADDR_NUM; i = i + 1) mem[i] <= 0;
    end
    else begin
        for(i = 0; i < ADDR_NUM; i = i + 1) mem[i] <= mem_n[i];
    end

always@* 
    rdata = mem[addr];

always @(*) begin
	for(i = 0; i < ADDR_NUM; i = i + 1) begin
		mem_n[i] = (wen && (i == addr)) ? wdata : mem[i];
	end
end

endmodule










