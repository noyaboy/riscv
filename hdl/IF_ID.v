module IF_ID(
    input clk,
    input rst_n,
    input [31:0] PC_IF,
    input [31:0] instr_IF,

    input keep_instr,

    output reg [31:0] PC_ID,
    output reg [31:0] instr_ID,
    output [4:0] rs1_raddr,
    output [4:0] rs2_raddr,
    output [4:0] rd_waddr_ID
);

wire [31:0] instr_ID_n;
assign instr_ID_n = (keep_instr) ? instr_ID : instr_IF;

assign rs1_raddr = instr_ID[19:15];
assign rs2_raddr = instr_ID[24:20];
assign rd_waddr_ID = instr_ID[11:7];

always@(posedge clk) begin
    if(~rst_n)begin
        PC_ID <= 0;
        instr_ID <= 0;
    end
    else begin
        PC_ID <= PC_IF;
        instr_ID <= instr_ID_n;
    end
end

endmodule