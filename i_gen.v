module i_gen (
    input [31:0] instr,
    output reg [31:0] imm 
);

always @(*) begin
    case(instr[6:0])
    7'b0100011: begin
    imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-Type
    end

    7'b1100011: begin
    imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-Type
    end

    7'b1101111: begin
     imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-Type
    end

    7'b0110111: begin
        imm = {instr[31:12], 12'b0}; // U-Type
    end

    7'b0010011,           // addi
    7'b0000011: begin     // lw
        imm = {{20{instr[31]}}, instr[31:20]};
    end

    default: imm = 32'b0;
    endcase
end

endmodule

