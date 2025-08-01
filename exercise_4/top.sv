// A simple 8-bit counter

module top (
	input  logic       clk_i,
	input  logic       rst_ni,
	
	// BIST Port
    input  logic       bist_en_i,
    input  logic       bist_men_i,
    input  logic       bist_wen_i,
    input  logic       bist_ren_i,
    input  logic [9:0] bist_addr_i,
    input  logic [7:0] bist_din_i,
    input  logic [7:0] bist_bm_i,
    
    // Output
    output logic [7:0] dout_i
);

    // Some logic to initialize the SRAM with 0xDEADBEEF
    logic [9:0] mem_addr;
    	always_ff @(posedge clk_i) begin
        	if (!rst_ni) begin
            	mem_addr <= '0;
        	end else begin
            	mem_addr <= mem_addr + 1;
        	end
	end
	
	logic mem_din;
	always_comb begin
	    case (mem_addr[1:0])
	        2'b00: mem_din = 8'hDE;
	        2'b01: mem_din = 8'hAD;
	        2'b10: mem_din = 8'hBE;
	        2'b11: mem_din = 8'hEF;
	    endcase
	end

    RM_IHPSG13_1P_1024x8_c2_bm_bist sram (
        // Memory Port
        .A_CLK  (clk_i),
        .A_MEN  (1'b1),
        .A_WEN  (1'b1),
        .A_REN  (1'b1),
        .A_ADDR (mem_addr),
        .A_DIN  (mem_din),
        .A_BM   (8'hFF),
        
        // BIST Port
        .A_BIST_CLK     (clk_i),
        .A_BIST_EN      (bist_en_i),
        .A_BIST_MEN     (bist_men_i),
        .A_BIST_WEN     (bist_wen_i),
        .A_BIST_REN     (bist_ren_i),
        .A_BIST_ADDR    (bist_addr_i),
        .A_BIST_DIN     (bist_din_i),
        .A_BIST_BM      (bist_bm_i),
        
        // Output
        .A_DOUT (dout_i),
        
        // Setting
        .A_DLY (1'b1) // Important: tie high!
    );

endmodule
