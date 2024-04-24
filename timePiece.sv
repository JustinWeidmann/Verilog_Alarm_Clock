module timePiece
#(cnt=60)
(
    input logic inc,
    input logic dec,

    input logic clk,
    input logic rst,

    input logic onceler,

    output logic [6:0] hex0,
    output logic [6:0] hex1,
	 output logic [7:0] masterCout
);
    logic masterDisInc;
    logic masterDisDec;
    //logic [7:0] masterCout;

    logic [3:0] preHex0;
    logic [3:0] preHex1;

    assign masterDisInc = (onceler && inc && !dec);
    assign masterDisDec = (onceler && dec && !inc);
    counter13 #(cnt+1)masterCouter(.clk, .rst(!rst), .inc(masterDisInc), .dec(masterDisDec), .cnt(masterCout));

    decimalSplitter spliter(.decimal_number(masterCout), .tens(preHex1), .ones(preHex0));
	 
    hdis dis0(.sw(preHex1), .dis(hex1));
    hdis dis1(.sw(preHex0), .dis(hex0));

endmodule