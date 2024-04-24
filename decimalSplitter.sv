module decimalSplitter 
#(decb=8, splitb=4)
(
    input [decb-1:0] decimal_number,
    output reg [splitb-1:0] tens,
    output reg [splitb-1:0] ones
);

    assign tens = decimal_number / 10;
    assign ones = decimal_number % 10;

endmodule