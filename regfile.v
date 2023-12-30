module regfile(
	input clk,
	input srst_n,
	input [4:0] raddr1,
	input [4:0] raddr2,
	input write,
	input [4:0]  waddr,
	input [31:0] wdata,
	output reg [31:0] rdata1,
	output reg [31:0] rdata2,
	output [31:0] sw_data
);

reg [31:0] reg   [31:0];
reg [31:0] reg_n [31:0];
integer i;
assign sw_data = reg[raddr2];

always @(posedge clk) begin
    if (~srst_n) begin
        for(i = 0; i < 32; i = i + 1) begin
		    reg[i] <= 0;
	    end
	    rdata1 <= 0;
	    rdata2 <= 0;
    end
    else begin
	    for(i = 0; i < 32; i = i + 1) begin
	    	reg[i] <= reg_n[i];
	    end
	    rdata1 <= reg[raddr1];
	    rdata2 <= reg[raddr2];
    end
end

always@* begin
	for(i = 0; i < 32; i = i + 1) begin
		reg_n[i] = (write && (i == waddr)) ? wdata : reg[i];
	end
end


endmodule