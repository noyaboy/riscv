`include "Def.v"

module regfile (
            input clk,
            input srst_n,
            input reg_wen,
            input [5-1: 0] reg1_raddr,
            input [5-1: 0] reg2_raddr,
            input [5-1: 0] reg_waddr,
            input [32-1: 0] reg_wdata,
            output reg [32-1: 0] reg1_rdata,
            output reg [32-1: 0] reg2_rdata
        );

    integer i = 0;

    reg [32-1: 0] reg_file [32-1: 0];
    reg [32-1: 0] reg_file_next [32-1: 0];

    always @(*) begin
        reg1_rdata = 0;
        case (reg1_raddr)
            5'd0: reg1_rdata = reg_file[0];
            5'd1: reg1_rdata = reg_file[1];
            5'd2: reg1_rdata = reg_file[2];
            5'd3: reg1_rdata = reg_file[3];
            5'd4: reg1_rdata = reg_file[4];
            5'd5: reg1_rdata = reg_file[5];
            5'd6: reg1_rdata = reg_file[6];
            5'd7: reg1_rdata = reg_file[7];
            5'd8: reg1_rdata = reg_file[8];
            5'd9: reg1_rdata = reg_file[9];
            5'd10: reg1_rdata = reg_file[10];
            5'd11: reg1_rdata = reg_file[11];
            5'd12: reg1_rdata = reg_file[12];
            5'd13: reg1_rdata = reg_file[13];
            5'd14: reg1_rdata = reg_file[14];
            5'd15: reg1_rdata = reg_file[15];
            5'd16: reg1_rdata = reg_file[16];
            5'd17: reg1_rdata = reg_file[17];
            5'd18: reg1_rdata = reg_file[18];
            5'd19: reg1_rdata = reg_file[19];
            5'd20: reg1_rdata = reg_file[20];
            5'd21: reg1_rdata = reg_file[21];
            5'd22: reg1_rdata = reg_file[22];
            5'd23: reg1_rdata = reg_file[23];
            5'd24: reg1_rdata = reg_file[24];
            5'd25: reg1_rdata = reg_file[25];
            5'd26: reg1_rdata = reg_file[26];
            5'd27: reg1_rdata = reg_file[27];
            5'd28: reg1_rdata = reg_file[28];
            5'd29: reg1_rdata = reg_file[29];
            5'd30: reg1_rdata = reg_file[30];
            5'd31: reg1_rdata = reg_file[31];
        endcase
    end

    always @(*) begin
        reg2_rdata = 0;
        case (reg2_raddr)
            5'd0: reg2_rdata = reg_file[0];
            5'd1: reg2_rdata = reg_file[1];
            5'd2: reg2_rdata = reg_file[2];
            5'd3: reg2_rdata = reg_file[3];
            5'd4: reg2_rdata = reg_file[4];
            5'd5: reg2_rdata = reg_file[5];
            5'd6: reg2_rdata = reg_file[6];
            5'd7: reg2_rdata = reg_file[7];
            5'd8: reg2_rdata = reg_file[8];
            5'd9: reg2_rdata = reg_file[9];
            5'd10: reg2_rdata = reg_file[10];
            5'd11: reg2_rdata = reg_file[11];
            5'd12: reg2_rdata = reg_file[12];
            5'd13: reg2_rdata = reg_file[13];
            5'd14: reg2_rdata = reg_file[14];
            5'd15: reg2_rdata = reg_file[15];
            5'd16: reg2_rdata = reg_file[16];
            5'd17: reg2_rdata = reg_file[17];
            5'd18: reg2_rdata = reg_file[18];
            5'd19: reg2_rdata = reg_file[19];
            5'd20: reg2_rdata = reg_file[20];
            5'd21: reg2_rdata = reg_file[21];
            5'd22: reg2_rdata = reg_file[22];
            5'd23: reg2_rdata = reg_file[23];
            5'd24: reg2_rdata = reg_file[24];
            5'd25: reg2_rdata = reg_file[25];
            5'd26: reg2_rdata = reg_file[26];
            5'd27: reg2_rdata = reg_file[27];
            5'd28: reg2_rdata = reg_file[28];
            5'd29: reg2_rdata = reg_file[29];
            5'd30: reg2_rdata = reg_file[30];
            5'd31: reg2_rdata = reg_file[31];
        endcase
    end

    always @(posedge clk ) begin
        for (i=0; i<32; i=i+1) reg_file [i] <= reg_file_next [i];
    end

    always @(*) begin
        for (i=0; i<32; i=i+1) reg_file_next [i] = reg_file [i];
        case (1'b1)
            (~srst_n): reg_file_next [0] = 0;
            (reg_wen): begin
                case (reg_waddr)
                    5'd0: reg_file_next [0] = reg_wdata;
                    5'd1: reg_file_next [1] = reg_wdata;
                    5'd2: reg_file_next [2] = reg_wdata;
                    5'd3: reg_file_next [3] = reg_wdata;
                    5'd4: reg_file_next [4] = reg_wdata;
                    5'd5: reg_file_next [5] = reg_wdata;
                    5'd6: reg_file_next [6] = reg_wdata;
                    5'd7: reg_file_next [7] = reg_wdata;
                    5'd8: reg_file_next [8] = reg_wdata;
                    5'd9: reg_file_next [9] = reg_wdata;
                    5'd10: reg_file_next [10] = reg_wdata;
                    5'd11: reg_file_next [11] = reg_wdata;
                    5'd12: reg_file_next [12] = reg_wdata;
                    5'd13: reg_file_next [13] = reg_wdata;
                    5'd14: reg_file_next [14] = reg_wdata;
                    5'd15: reg_file_next [15] = reg_wdata;
                    5'd16: reg_file_next [16] = reg_wdata;
                    5'd17: reg_file_next [17] = reg_wdata;
                    5'd18: reg_file_next [18] = reg_wdata;
                    5'd19: reg_file_next [19] = reg_wdata;
                    5'd20: reg_file_next [20] = reg_wdata;
                    5'd21: reg_file_next [21] = reg_wdata;
                    5'd22: reg_file_next [22] = reg_wdata;
                    5'd23: reg_file_next [23] = reg_wdata;
                    5'd24: reg_file_next [24] = reg_wdata;
                    5'd25: reg_file_next [25] = reg_wdata;
                    5'd26: reg_file_next [26] = reg_wdata;
                    5'd27: reg_file_next [27] = reg_wdata;
                    5'd28: reg_file_next [28] = reg_wdata;
                    5'd29: reg_file_next [29] = reg_wdata;
                    5'd30: reg_file_next [30] = reg_wdata;
                    5'd31: reg_file_next [31] = reg_wdata;
                endcase
            end
        endcase
    end

endmodule