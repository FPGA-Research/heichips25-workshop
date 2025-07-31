// A simple 8-bit counter

module counter (
	input  logic       clk_i,
	input  logic       rst_ni,
	output logic [7:0] count_o
);

	always_ff @(posedge clk_i) begin
        	if (!rst_ni) begin
            	count_o <= '0;
        	end else begin
            	count_o <= count_o + 1;
        	end
	end

endmodule
