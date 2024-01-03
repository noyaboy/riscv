module regfile(
	input clk,
	input srst_n,
	input [4:0] raddr1,
	input [4:0] raddr2,
	input wen,
	input [4:0]  waddr,
	input [31:0] wdata,
	output [31:0] rdata1,
	output [31:0] rdata2
	// output [31:0] sw_data
);

reg [31:0] gpr   [31:0];
reg [31:0] gpr_n [31:0];
integer i;
assign rdata1 = gpr[raddr1];
assign rdata2 = gpr[raddr2];
// assign sw_data = gpr[raddr2];

always @(posedge clk) begin
    if (~srst_n) begin
        for(i = 0; i < 32; i = i + 1) begin
		    gpr[i] <= 0;
	    end
    end
    else begin
	    for(i = 0; i < 32; i = i + 1) begin
	    	gpr[i] <= gpr_n[i];
	    end
    end
end

always @(*) begin
	for(i = 0; i < 32; i = i + 1) begin
		gpr_n[i] = (wen && (i == waddr)) ? wdata : gpr[i];
	end
end


endmodule