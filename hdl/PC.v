// `include "Def.v"
module PC(
    input clk,
    input rst_n,

    input [31:0] PC_IF,
    input [31:0] PC_branch_M, // PC_branch_ID
    input [31:0] alu_result_M,

    input boot_up,

    input branch_valid,
    input jalr_M,

    input keep_PC,

    output reg [31:0] PC,
    output PC_running
);

localparam  PC_IDLE = 2'b00,
            PC_LOAD = 2'b01,
            PC_RUN  = 2'b10;

reg [1:0] state, state_n;

reg [31:0] PC_temp;

assign PC_running = (state == PC_RUN);

always@(posedge clk)
    if(!rst_n)
        state <= PC_IDLE;
    else
        state <= state_n;

always@*
    case(state)
        PC_IDLE: state_n = boot_up ? PC_LOAD : PC_IDLE;
        PC_LOAD: state_n = ~boot_up ? PC_RUN : PC_LOAD;
        default   : state_n = PC_RUN;
    endcase

always@(posedge clk) begin
    if(~rst_n || (state != PC_RUN))
        PC <= 0;
    else
        PC <= PC_temp;
end

always@* begin
    case(1'b1)
        branch_valid: PC_temp = PC_branch_M; // PC_branch_ID
        jalr_M: PC_temp = alu_result_M;

        keep_PC: PC_temp = PC;

        default: PC_temp = PC_IF;
    endcase
end

endmodule