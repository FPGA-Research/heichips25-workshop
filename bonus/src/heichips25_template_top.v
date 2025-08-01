// SPDX-FileCopyrightText: © 2025 Leo Moser
// SPDX-License-Identifier: Apache-2.0

module heichips25_template_top (
    inout  wire       ena_PAD,
    inout  wire       clk_PAD,
    inout  wire       rst_n_PAD,
    inout  wire [7:0] ui_PAD,
    inout  wire [7:0] uo_PAD,
    inout  wire [7:0] uio_PAD
);

    wire       ena_PAD2CORE;
    wire       clk_PAD2CORE;
    wire       rst_n_PAD2CORE;
    wire [7:0] ui_PAD2CORE;
    wire [7:0] uo_CORE2PAD;
    wire [7:0] uio_PAD2CORE;
    wire [7:0] uio_CORE2PAD;
    wire [7:0] uio_CORE2PAD_EN;

    // Power/Ground IO pad instances
    
    (* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_east ();

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_east ();

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_east ();

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_east ();

    (* keep *)
    sg13g2_IOPadVdd sg13g2_IOPadVdd_west ();

    (* keep *)
    sg13g2_IOPadVss sg13g2_IOPadVss_west ();

    (* keep *)
    sg13g2_IOPadIOVss sg13g2_IOPadIOVss_west ();

    (* keep *)
    sg13g2_IOPadIOVdd sg13g2_IOPadIOVdd_west ();

    // Signal IO pad instances

    sg13g2_IOPadIn sg13g2_IOPadIn_ena (
        .p2c (ena_PAD2CORE),
        .pad (ena_PAD)
    );
    
    sg13g2_IOPadIn sg13g2_IOPadIn_clk (
        .p2c (clk_PAD2CORE),
        .pad (clk_PAD)
    );
    
    sg13g2_IOPadIn sg13g2_IOPadIn_rst_n (
        .p2c (rst_n_PAD2CORE),
        .pad (rst_n_PAD)
    );

    generate
    for (genvar i=0; i<8; i++) begin : sg13g2_IOPadIn_ui
        sg13g2_IOPadIn ui (
            .p2c (ui_PAD2CORE[i]),
            .pad (ui_PAD[i])
        );
    end
    endgenerate

    generate
    for (genvar i=0; i<8; i++) begin : sg13g2_IOPadOut30mA_uo
        sg13g2_IOPadOut30mA uo (
            .c2p (uo_CORE2PAD[i]),
            .pad (uo_PAD[i])
        );
    end
    endgenerate

    generate
    for (genvar i=0; i<8; i++) begin : sg13g2_IOPadInOut30mA_uio
        sg13g2_IOPadInOut30mA uio (
            .c2p    (uio_CORE2PAD[i]),
            .c2p_en (uio_CORE2PAD_EN[i]),
            .p2c    (uio_PAD2CORE[i]),
            .pad    (uio_PAD[i])
        );
    end
    endgenerate

    (* keep *) heichips25_template heichips25_template (
        .ui_in      (ui_PAD2CORE),
        .uo_out     (uo_CORE2PAD),
        .uio_in     (uio_PAD2CORE),
        .uio_out    (uio_CORE2PAD),
        .uio_oe     (uio_CORE2PAD_EN),
        .ena        (ena_PAD2CORE),
        .clk        (clk_PAD2CORE),
        .rst_n      (rst_n_PAD2CORE)
    );

endmodule
