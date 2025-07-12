module dual_signal_generator (
    input wire clk,                // Órajel bemenet (400 MHz)
    input wire reset,              // Reset bemenet
    input wire [15:0] delay_value,  // Késleltetés értéke UART-ból
    output reg signal_a,            // A jel (K16)
    output reg signal_b,            // B jel (L16)
    output reg signal_c             // C jel (M15)
);

    reg [32:0] counter = 0;    // Számláló a ciklusokhoz
    localparam DELAY_12500NS = 5000;
    localparam DELAY_25000NS = DELAY_12500NS*2;
    reg jobbra = 0;
	 reg [32:0] de = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;       // Számláló alaphelyzetbe állítása
            signal_a <= 0;      // Jelek alaphelyzetbe állítása (alacsony)
            signal_b <= 0;
            signal_c <= 0;
				de <= 0;
				
        end else begin
				de <= delay_value - DELAY_25000NS;
				if(delay_value<(DELAY_12500NS*2))begin
					jobbra <= 1;
				end else begin
					jobbra <= 0;
				end
//jobbra	  
				if(jobbra == 1)begin
					if (counter < (DELAY_12500NS*2)) begin
						counter <= counter + 1;  // Számláló növelése
					end else begin
						counter <= 0;  // Számláló visszaállítása
					end
					// A jel kezelése (40 kHz négyszögjel)
					if (counter < DELAY_12500NS) begin
						signal_a <= 1;  // A jel magas
					end else begin
						signal_a <= 0;  // A jel alacsony
					end

					// B jel kezelése (késleltetés delay_value alapján)
					if (counter >= delay_value && counter < DELAY_12500NS + delay_value) begin
						signal_b <= 1;  // B jel magas
					end else begin
						signal_b <= 0;  // B jel alacsony
					end

					// C jel kezelése (kettős késleltetéssel)
					if ((counter >= delay_value + delay_value && counter < DELAY_12500NS + delay_value + delay_value) ||
						((counter <= ( (delay_value + delay_value)-DELAY_12500NS) || counter > (delay_value + delay_value)) && delay_value + delay_value > DELAY_12500NS )) begin
						signal_c <= 1;  // C jel magas
					end else begin
						signal_c <= 0;  // C jel alacsony
					end
				end else begin
//ballra

					if (counter < (DELAY_12500NS*2)) begin
						counter <= counter + 1;  // Számláló növelése
					end else begin
						counter <= 0;  // Számláló visszaállítása
					end

					// A jel kezelése (40 kHz négyszögjel)
					if (counter < DELAY_12500NS) begin
						signal_c <= 1;  // A jel magas
					end else begin
						signal_c <= 0;  // A jel alacsony
					end

					// B jel kezelése (késleltetés delay_value alapján)
					if (counter >= de && counter < DELAY_12500NS + de) begin
						signal_b <= 1;  // B jel magas
					end else begin
						signal_b <= 0;  // B jel alacsony
					end

					// C jel kezelése (kettős késleltetéssel)
					if ((counter >= de + de && counter < DELAY_12500NS + de + de) ||
						((counter <= ( (de + de)-DELAY_12500NS) || counter > (de + de)) && de + de > DELAY_12500NS )) begin
						signal_a <= 1;  // C jel magas
					end else begin
						signal_a <= 0;  // C jel alacsony
					end
				end
				
        end
    end
endmodule