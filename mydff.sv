
module mydff
  #(parameter int size = 1 ) // Our first module parameter! Now everything is squishy
   (
    input  logic [size-1:0] d, 
    input  logic 	    clk, 
    input  logic 	    rst, 
    input  logic 	    en, 
    output logic [size-1:0] q
    );
   
   logic [511:0] 	    rst_val ;     // To avoid assigning a constant of unspec length
   assign    rst_val     = 512'd0 ;
   
   always_ff @ (posedge clk) begin
      priority case ( 1'b1 )
	(~rst):  q[size-1:0]  <=  rst_val[size-1:0] ;  //Reset is active low
	( en):   q[size-1:0]  <=        d[size-1:0] ;  //Enable is active high
	default: q[size-1:0]  <=        q[size-1:0] ;  //Default case
      endcase    
   end

endmodule //dff	
