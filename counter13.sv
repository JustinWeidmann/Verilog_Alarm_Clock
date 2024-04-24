/*
 * a modulo 13 up/down counter
 * (i..e. when going up, counts 0,1,2...12, 0, 1, 2, 3)
 *
 */

module counter13
  #(
    parameter int m=9,  // Maximum
    parameter int b=$clog2(m)  // Bitwidth 
    )
   (
    input  logic         inc,
    input  logic         dec,
    input  logic         clk,
    input  logic         rst,

    output logic [b-1:0] cnt
    );

	logic [b:0] nextCnt;
	logic [b:0] scnt;

	always_comb begin
		unique case(1'b1)
			inc && !dec: nextCnt = cnt+1;
			dec && !inc: nextCnt = cnt-1;
			default: nextCnt = cnt;
		endcase
	end

	mydff #(b+1)epicDff(.clk, .rst, .en(1'b1), .q(scnt), .d(nextCnt));

	always_comb begin
		unique case(1'b1)
			(scnt==((2**(b+1))-1)): cnt = (m-1);
			(scnt==m): cnt = 0;
			default: cnt = scnt[b-1:0];
		endcase
	end

endmodule 
