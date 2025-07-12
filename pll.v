`timescale 1ns / 1ps

module clock_generator (
    input wire clk_in,     // 125 MHz differenciális órajel már IBUFDS-en keresztül jön
    output wire clk_out    // 400 MHz kimenet
);

    wire clk_fb;
    wire clk_mmcm;
    wire locked;

    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKIN1_PERIOD(8.0),        // 125 MHz -> 8 ns
        .DIVCLK_DIVIDE(1),          // Előosztó: 125 / 1 = 125 MHz
        .CLKFBOUT_MULT_F(8.0),      // 125 * 8 = 1000 MHz belső VCO
        .CLKOUT0_DIVIDE_F(2.5),     // 1000 / 2.5 = 400 MHz kimenet
        .CLKOUT0_PHASE(0.0),
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKFBOUT_PHASE(0.0),
        .STARTUP_WAIT("FALSE")
    ) mmcm_inst (
        .CLKIN1(clk_in),
        .CLKOUT0(clk_mmcm),
        .CLKFBIN(clk_fb),
        .CLKFBOUT(clk_fb),
        .LOCKED(locked),
        .PWRDWN(1'b0),
        .RST(1'b0)
    );

    assign clk_out = clk_mmcm;

endmodule
