import serial
import csv
import time

# Soros port beállítása
ser = serial.Serial('COM9', 9600, timeout=1)

# CSV fájl megnyitása írásra
with open('output.csv', 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(['Timestamp', 'Counter', 'Binary'])  # Fejléc
    
    data_count = 0  # Adatok számlálása

    while data_count < 20:  # Csak 20 adat mentése
            line = ser.readline().decode('utf-8').strip()
            if line:  # Ha nem üres sor
                if line.startswith("Counter:"):
                    parts = line.split(" | Binary: ")
                    if len(parts) == 2:
                        counter = parts[0].split(": ")[1]
                        binary_output = parts[1]
                        
                        # Időbélyeg hozzáadása
                        timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
                        
                        # Adatok írása a CSV fájlba
                        csv_writer.writerow([timestamp, counter, binary_output])
                        csvfile.flush()  # Biztosítjuk az adatok azonnali mentését
                        
                        # Növeljük az adat számlálót
                        data_count += 1
                        
                        print(f"Saved: {timestamp}, {counter}, {binary_output}")
            
            else:
                # Ha 1 másodpercig nem érkezik adat, akkor kilépünk
                time.sleep(1)

    print("Program befejeződött. 20 adat mentésre került.")
