# Differenciális 125 MHz-es órajel
set_property PACKAGE_PIN G21 [get_ports clk_p]
set_property PACKAGE_PIN F21 [get_ports clk_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_n]

# Órajel létrehozása (csak P ágra!)
create_clock -name clk_125 -period 8.000 [get_ports clk_125_p]
# ===============
# Reset bemenet
# ===============
set_property PACKAGE_PIN AM14 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# ========================
# Adat bemenetek (RP2040-től)
# ========================
set_property PACKAGE_PIN J15 [get_ports {data_in[0]}]
set_property PACKAGE_PIN J16 [get_ports {data_in[1]}]
set_property PACKAGE_PIN G16 [get_ports {data_in[2]}]
set_property PACKAGE_PIN H16 [get_ports {data_in[3]}]


# ====================
# Érvényesség és ACK
# ====================
set_property PACKAGE_PIN J14 [get_ports valid]
set_property IOSTANDARD LVCMOS33 [get_ports valid]
set_property PACKAGE_PIN H14 [get_ports ack]
set_property IOSTANDARD LVCMOS33 [get_ports ack]

# ===================
# LED kimenetek
# ===================
set_property PACKAGE_PIN AG14 [get_ports LED0]
set_property PACKAGE_PIN AF13 [get_ports LED1]
set_property PACKAGE_PIN AE13 [get_ports LED2]
set_property PACKAGE_PIN AJ14 [get_ports LED3]


# ================================
# 40 kHz-es kimeneti jelek (ellenőrizd pineket!)
# ================================
set_property PACKAGE_PIN G15 [get_ports signal_a]
set_property PACKAGE_PIN G13 [get_ports signal_b]
set_property PACKAGE_PIN H13 [get_ports signal_c]


set_property IOSTANDARD LVCMOS33 [get_ports LED0]
set_property IOSTANDARD LVCMOS33 [get_ports LED1]
set_property IOSTANDARD LVCMOS33 [get_ports LED2]
set_property IOSTANDARD LVCMOS33 [get_ports LED3]
set_property IOSTANDARD LVCMOS33 [get_ports signal_a]
set_property IOSTANDARD LVCMOS33 [get_ports signal_b]
set_property IOSTANDARD LVCMOS33 [get_ports signal_c]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]

set_property PACKAGE_PIN G21 [get_ports clk_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_p]
