`timescale 1ns / 1ps

module top_module (
    input wire clk_p,         // CLK_125_P -> G21 (differenciális órajel P)
    input wire clk_n,         // CLK_125_N -> F21 (differenciális órajel N)
    input wire reset,         // Reset bemenet
    input wire [3:0] data_in, // Beérkező 4 bites adat
    input wire valid,         // Adat érvényesség jelzése     
    output wire signal_a,     // Kimeneti órajel
    output wire signal_b,     // Kimeneti adatjel
    output wire signal_c,     // Kimenet
    output wire ack,          // Acknowledge jel a küldő felé
    output wire LED0,         // LED kimenetek
    output wire LED1,
    output wire LED2,
    output wire LED3
);

    wire clk_125MHz_buf;    // Differenciális órajel bufferezve
    wire clk_400MHz;        // 400 MHz-es órajel

    // ========== 125 MHz differenciális órajel buffere ==========
    IBUFDS #(
    ) ibufds_inst (
        .I(clk_p),
        .IB(clk_n),
        .O(clk_125MHz_buf)
    );

    // ========== Órajel generátor (125 → 400 MHz) ==========
    clock_generator clkgen_inst (
        .clk_in(clk_125MHz_buf),
        .clk_out(clk_400MHz)
    );

    // ========== Adatfeldolgozás ==========
    wire [15:0] decoded_data;

    fpga_receiver u1 (
        .clk(clk_125MHz_buf),
        .reset(reset),
        .data_in(data_in),
        .valid(valid),
        .ack(ack),
        .decoded_data(decoded_data),
        .LED0(LED0),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3)
    );

    // ========== Jelgenerálás ==========
    dual_signal_generator u2 (
        .clk(clk_400MHz),
        .reset(reset),
        .delay_value(decoded_data),
        .signal_a(signal_a),
        .signal_b(signal_b),
        .signal_c(signal_c)
    );

endmodule
