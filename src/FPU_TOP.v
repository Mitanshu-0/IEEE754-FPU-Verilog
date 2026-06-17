`include "FPU_addsub.v"
`include "FPU_mul.v"
`include "FPU_div.v"

module FPU_TOP (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0]  op,
    output reg  [31:0] result,
    output reg         overflow,
    output reg         underflow,
    output reg         div_by_zero,
    output reg         invalid,
    output reg         inexact
);

wire en_addsub = (op == 2'b00) || (op == 2'b01);
wire en_mul    = (op == 2'b10);
wire en_div    = (op == 2'b11);

wire [31:0] addsub_result;
wire        addsub_ovf;
wire        addsub_unf;
wire        addsub_invalid;
wire        addsub_inexact;

wire [31:0] mul_result;
wire        mul_ovf;
wire        mul_unf;
wire        mul_invalid;
wire        mul_inexact;

wire [31:0] div_result;
wire        div_ovf;
wire        div_unf;
wire        div_dbz;
wire        div_invalid;
wire        div_inexact;

fpu_addsub u_addsub (
    .a         (a),
    .b         (b),
    .op        (op[0]),
    .enable    (en_addsub),
    .result    (addsub_result),
    .overflow  (addsub_ovf),
    .underflow (addsub_unf),
    .invalid   (addsub_invalid),
    .inexact   (addsub_inexact)
);

fpu_mul u_mul (
    .a         (a),
    .b         (b),
    .enable    (en_mul),
    .result    (mul_result),
    .overflow  (mul_ovf),
    .underflow (mul_unf),
    .invalid   (mul_invalid),
    .inexact   (mul_inexact)
);

fpu_div u_div (
    .a           (a),
    .b           (b),
    .enable      (en_div),
    .result      (div_result),
    .overflow    (div_ovf),
    .underflow   (div_unf),
    .div_by_zero (div_dbz),
    .invalid     (div_invalid),
    .inexact     (div_inexact)
);

always @(*) begin
    case (op)

        2'b00: begin
            result      = addsub_result;
            overflow    = addsub_ovf;
            underflow   = addsub_unf;
            invalid     = addsub_invalid;
            inexact     = addsub_inexact;
            div_by_zero = 1'b0;
        end

        2'b01: begin
            result      = addsub_result;
            overflow    = addsub_ovf;
            underflow   = addsub_unf;
            invalid     = addsub_invalid;
            inexact     = addsub_inexact;
            div_by_zero = 1'b0;
        end

        2'b10: begin
            result      = mul_result;
            overflow    = mul_ovf;
            underflow   = mul_unf;
            invalid     = mul_invalid;
            inexact     = mul_inexact;
            div_by_zero = 1'b0;
        end

        2'b11: begin
            result      = div_result;
            overflow    = div_ovf;
            underflow   = div_unf;
            invalid     = div_invalid;
            inexact     = div_inexact;
            div_by_zero = div_dbz;
        end

        default: begin
            result      = 32'b0;
            overflow    = 1'b0;
            underflow   = 1'b0;
            invalid     = 1'b0;
            inexact     = 1'b0;
            div_by_zero = 1'b0;
        end

    endcase
end

endmodule
