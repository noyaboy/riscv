`include "Def.v"

module alu (
            input [32-1: 0] oprnd1,
            input [32-1: 0] oprnd2,
            input [4-1: 0] opr,
            output reg [32-1: 0] rslt
        );

    reg signed [32-1: 0] oprnd1_sgd;
    reg signed [32-1: 0] oprnd2_sgd;

    always @(*) begin
        oprnd1_sgd = oprnd1;
        oprnd2_sgd = oprnd2;
    end

    always @(*) begin
        rslt = 32'h0000_0000;
        case(opr)
            `ADD:
                out = oprnd1 + oprnd2;
            `SUB:
                out = oprnd1 - oprnd2;
            `XOR:
                out = oprnd1 ^ oprnd2;
            `OR:
                out = oprnd1 | oprnd2;
            `AND:
                out = oprnd1 & oprnd2;
            `SLL:
                out = oprnd1 << oprnd2[4:0];
            `SRL:
                out = oprnd1 >> oprnd2[4:0];
            `SRA:
                out = oprnd1_sgd >>> oprnd2[4:0];
            `SLT:
                out = {31'd0, (oprnd1_sgd < oprnd2_sgd)};
            `SLTU:
                out = {31'd0, (oprnd1 < oprnd2)};
        endcase
    end 

endmodule