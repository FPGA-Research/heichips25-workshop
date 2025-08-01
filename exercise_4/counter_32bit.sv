// A 32-bit counter made up of 4 individual 8-bit counters as macros

module counter_32bit (
	input  logic        clk_i,
	input  logic        rst_ni,
	input  logic        en_i,
	
    output logic [31:0] count_o,
    output logic        ovf_o
);

    logic counter_0_ovf;
    logic counter_1_ovf;
    logic counter_2_ovf;

    counter_8bit counter_0 (
	    .clk_i,
	    .rst_ni,
	    .en_i       (en_i),
	    
        .count_o    (count_o[7:0]),
        .ovf_o      (counter_0_ovf)
    );
    
    counter_8bit counter_1 (
	    .clk_i,
	    .rst_ni,
	    .en_i       (counter_0_ovf),
	    
        .count_o    (count_o[15:8]),
        .ovf_o      (counter_1_ovf)
    );
    
    counter_8bit counter_2 (
	    .clk_i,
	    .rst_ni,
	    .en_i       (counter_1_ovf),
	    
        .count_o    (count_o[23:16]),
        .ovf_o      (counter_2_ovf)
    );
    
    counter_8bit counter_3 (
	    .clk_i,
	    .rst_ni,
	    .en_i       (counter_2_ovf),
	    
        .count_o    (count_o[31:24]),
        .ovf_o      (ovf_o)
    );

endmodule
