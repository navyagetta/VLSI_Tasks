module alu #(parameter WIDTH = 8)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [2:0]       op,
    output reg  [WIDTH-1:0] y,
    output reg              carry_out,
    output reg              zero
);
    always @* begin
        carry_out = 1'b0;
        case (op)
            3'b000: {carry_out, y} = a + b;   // ADD
            3'b001: {carry_out, y} = a - b;   // SUB
            3'b010: y = a & b;                // AND
            3'b011: y = a | b;                // OR
            3'b100: y = ~a;                  // NOT
            default: y = {WIDTH{1'b0}};
        endcase
        zero = (y == {WIDTH{1'b0}});
    end
endmodule

