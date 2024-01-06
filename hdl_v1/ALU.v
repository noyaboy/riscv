// `include "Def.v"
module ALU
(
    input [31:0] opr1,
    input [31:0] opr2,
    input [3:0]  alu_ctrl,
    output zero,
    output reg [31:0] alu_out
);

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

always @(*) begin
    case(1'b1)
        (alu_ctrl == {1'b0, `FUNCT3_ADD}):  alu_out = $signed(opr1) + $signed(opr2);
        (alu_ctrl == {1'b1, `FUNCT3_SUB}):  alu_out = $signed(opr1) - $signed(opr2);
        (alu_ctrl == {1'b0, `FUNCT3_XOR}):  alu_out = opr1 ^ opr2;
        (alu_ctrl == {1'b0, `FUNCT3_OR}):   alu_out = opr1 | opr2;
        (alu_ctrl == {1'b0, `FUNCT3_AND}):  alu_out = opr1 & opr2;
        (alu_ctrl == {1'b0, `FUNCT3_SLL}):  alu_out = opr1 << opr2[4:0];
        (alu_ctrl == {1'b0, `FUNCT3_SRL}):  alu_out = opr1 >> opr2;
        (alu_ctrl == {1'b1, `FUNCT3_SRA}):  alu_out = $signed(opr1) >>> opr2;
        (alu_ctrl == {1'b0, `FUNCT3_SLT}):  alu_out = ($signed(opr1) < $signed(opr2)) ? 1 : 0;
        (alu_ctrl == {1'b0, `FUNCT3_SLTU}): alu_out = (opr1 < opr2) ? 1 : 0;
        default:                            alu_out = 0;
    endcase
end

endmodule


// reg [31:0] alu_out;
// wire ext;

// assign alu_out_ = alu_out;

// assign alu_out_ = (opr2 > 31 && alu_ctrl[2:0] == `FUNCT3_SRA)? {32{ext}} : alu_out;
// assign ext = (~alu_ctrl[3]) ? 1'b0 : opr1[31];
        // "<<"
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd00): alu_out = opr1;
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd01): alu_out = {opr1[30:0], 1'b0};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd02): alu_out = {opr1[29:0], {2{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd03): alu_out = {opr1[28:0], {3{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd04): alu_out = {opr1[27:0], {4{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd05): alu_out = {opr1[26:0], {5{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd06): alu_out = {opr1[25:0], {6{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd07): alu_out = {opr1[24:0], {7{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd08): alu_out = {opr1[23:0], {8{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd09): alu_out = {opr1[22:0], {9{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd10): alu_out = {opr1[21:0], {10{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd11): alu_out = {opr1[20:0], {11{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd12): alu_out = {opr1[19:0], {12{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd13): alu_out = {opr1[18:0], {13{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd14): alu_out = {opr1[17:0], {14{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd15): alu_out = {opr1[16:0], {15{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd16): alu_out = {opr1[15:0], {16{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd17): alu_out = {opr1[14:0], {17{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd18): alu_out = {opr1[13:0], {18{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd19): alu_out = {opr1[12:0], {19{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd20): alu_out = {opr1[11:0], {20{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd21): alu_out = {opr1[10:0], {21{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd22): alu_out = {opr1[9:0],  {22{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd23): alu_out = {opr1[8:0],  {23{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd24): alu_out = {opr1[7:0],  {24{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd25): alu_out = {opr1[6:0],  {25{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd26): alu_out = {opr1[5:0],  {26{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd27): alu_out = {opr1[4:0],  {27{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd28): alu_out = {opr1[3:0],  {28{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd29): alu_out = {opr1[2:0],  {29{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd30): alu_out = {opr1[1:0],  {30{1'b0}}};
        // (alu_ctrl == {1'b0, `FUNCT3_SLL} && opr2[4:0] == 5'd31): alu_out = {opr1[0],    {31{1'b0}}};
        
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd0):  alu_out = {{0{ext}}, opr1[31:0]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd1):  alu_out = {{1{ext}}, opr1[31:1]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd2):  alu_out = {{2{ext}}, opr1[31:2]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd3):  alu_out = {{3{ext}}, opr1[31:3]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd4):  alu_out = {{4{ext}}, opr1[31:4]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd5):  alu_out = {{5{ext}}, opr1[31:5]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd6):  alu_out = {{6{ext}}, opr1[31:6]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd7):  alu_out = {{7{ext}}, opr1[31:7]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd8):  alu_out = {{8{ext}}, opr1[31:8]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd9):  alu_out = {{9{ext}}, opr1[31:9]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd10):  alu_out = {{10{ext}}, opr1[31:10]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd11):  alu_out = {{11{ext}}, opr1[31:11]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd12):  alu_out = {{12{ext}}, opr1[31:12]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd13):  alu_out = {{13{ext}}, opr1[31:13]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd14):  alu_out = {{14{ext}}, opr1[31:14]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd15):  alu_out = {{15{ext}}, opr1[31:15]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd16):  alu_out = {{16{ext}}, opr1[31:16]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd17):  alu_out = {{17{ext}}, opr1[31:17]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd18):  alu_out = {{18{ext}}, opr1[31:18]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd19):  alu_out = {{19{ext}}, opr1[31:19]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd20):  alu_out = {{20{ext}}, opr1[31:20]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd21):  alu_out = {{21{ext}}, opr1[31:21]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd22):  alu_out = {{22{ext}}, opr1[31:22]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd23):  alu_out = {{23{ext}}, opr1[31:23]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd24):  alu_out = {{24{ext}}, opr1[31:24]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd25):  alu_out = {{25{ext}}, opr1[31:25]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd26):  alu_out = {{26{ext}}, opr1[31:26]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd27):  alu_out = {{27{ext}}, opr1[31:27]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd28):  alu_out = {{28{ext}}, opr1[31:28]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd29):  alu_out = {{29{ext}}, opr1[31:29]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd30):  alu_out = {{30{ext}}, opr1[31:30]};
        // ((alu_ctrl[2:0] == `FUNCT3_SRA) & opr2[4:0] == 5'd31):  alu_out = {{31{ext}}, opr1[31]};
        