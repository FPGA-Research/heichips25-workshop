// A simple 8-bit counter with enable and overflow

module counter_8bit (
	input  logic       clk_i,
	input  logic       rst_ni,
	input  logic       en_i,
	
    output logic [7:0] count_o,
    output logic       ovf_o
);

    	always_ff @(posedge clk_i) begin
        	if (!rst_ni) begin
            	count_o <= '0;
        	end else begin
        	    if (en_i) begin
            	    {ovf_o, count_o} <= count_o + 1;
            	end
        	end
	end

endmodule
