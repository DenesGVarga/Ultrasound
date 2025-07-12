module fpga_receiver (
    input wire clk,          // Rendszerórajel
    input wire reset,        // Reset jel
    input wire [3:0] data_in, // Beérkező 4 bites adat
    input wire valid,        // Adat érvényesség jelzése
    output reg ack,          // Acknowledge jel a küldő felé
    output reg LED0,         // P4 - 1. LED
    output reg LED1,         // N5 - 2. LED
    output reg LED2,         // P5 - 3. LED
    output reg LED3,         // M6 - 4. LED
    output reg [15:0] decoded_data // Hibajavított 16 bites adat
);

    reg [15:0] counter;       // Számláló a magas bemenetekhez
    reg valid_prev;           // Előző valid állapot

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 16'b0; // Számláló nullázása
            decoded_data <= 16'b0;    // Dekódolt 16 bites adat
            ack <= 0;
            LED0 <= 0;
            LED1 <= 0;
            LED2 <= 0;
            LED3 <= 0;
            valid_prev <= 0;
        end else begin
            ack <= 0; // Alapértelmezés szerint az ACK le van tiltva

            // Csak akkor növeljük a számlálót, ha a valid jel felfutó élre vált és minden bemenet magas (4'b1111)
            if (valid && !valid_prev && data_in == 4'b1111) begin
                // Növeljük a számlálót, ha minden bemenet magas
                if (counter <= 5000) begin
                    counter <= counter + 10;
                end else if (counter >= 5000 && counter <= 9000) begin
                    counter <= 10000; // Ha elérte az 5000-et, ugrunk 10000-re
                end else if (counter >= 10000) begin
                    counter <= counter + 10;
                end else if (counter >= 15000) begin
                    counter <= 0; // Ha elérte a 15000-et, nullázzuk
                end
            end

            // Ha a valid magas, bekapcsoljuk az ACK jelet
            if (valid) begin
                ack <= 1;
            end

            // A számláló értékét a decoded_data változóba helyezzük
            decoded_data <= counter;

            // A LED-ek a bemeneti adatot mutatják
            LED0 <= counter[0];
            LED1 <= counter[1];
            LED2 <= counter[2];
            LED3 <= counter[3];

            // Előző valid állapot frissítése
            valid_prev <= valid;
        end
    end
endmodule
