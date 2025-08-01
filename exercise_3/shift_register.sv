module shift_register (
    input  logic    clk_i,
    input  logic    in_i,
    input  logic    rst_ni,
    output logic    out_o
);

    localparam BITS = 256;

    logic [BITS-1:0] shift_reg;
    
    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
            shift_reg <= '0;
        end else begin
            for (int i=0; i<BITS; i++) begin
                if (i==0) begin
                    shift_reg[i] <= in_i;
                end else begin
                    shift_reg[i] <= shift_reg[i-1];
                end
            end
        end
    end
    
    assign out_o = shift_reg[BITS-1]; 

endmodule

