module IF_stage(
    input clk,
    input rst_n,

    input boot_up,
    input [7:0] boot_addr,
    input [31:0] boot_datai,
    input boot_web,

    output [15:0] PC_add
    input [15:0] Branch_in,
    input PCSrc,
    output PC_run,
    output [31:0] instn,
);





