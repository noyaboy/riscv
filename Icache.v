
module Icache (
    input [32-1: 0] pc,
    output reg [32-1: 0] instr_IF
        );

    wire [8-1: 0] addr;
    reg [32-1: 0] mem [256-1: 0];

    assign addr = pc [8-1: 0];
    
    always @(*) begin
        instr_IF = mem [addr];
    end

endmodule










