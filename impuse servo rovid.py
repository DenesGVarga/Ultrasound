from machine import Pin, ADC, PWM
import time

# GPIO beállítások
data_pins = [Pin(13, Pin.OUT), Pin(12, Pin.OUT), Pin(11, Pin.OUT), Pin(10, Pin.OUT), Pin(9, Pin.OUT)]  # FPGA vezérlés
valid_pin = Pin(15, Pin.OUT)  # Validáló jel FPGA-nak
adc_pin = ADC(26)  # Ultrahangos vevő bemenete
servo_pin = PWM(Pin(16))  # Szervó vezérlés
servo_pin.freq(50)  # MG90S szervó működési frekvenciája

# Szervó paraméterek
min_angle = 0      # Minimum szög
max_angle = 180    # Maximum szög
step = 5           # Lépésköz

pulse_count = 0  # Impulzus számláló

def set_servo_angle(angle):
    """ Beállítja a szervó szögét megfelelő PWM jellel. """
    duty = int((angle / 180) * 5000 + 2500)  # 2.0% - 10.0% kitöltési arány
    servo_pin.duty_u16(duty)
    time.sleep(0.5)  # Szervó stabilizálódási idő

time.sleep(10)  # Kezdeti várakozás

while True:
    # FPGA impulzus küldése (2 impulzus)
    for i in range(2):
        for pin in data_pins:
            pin.value(1)
        valid_pin.value(1)
        time.sleep(0.1)  # 100 ms validálás
        valid_pin.value(0)
        for pin in data_pins:
            pin.value(0)
        time.sleep(0.1)  # Késleltetés a következő ciklus előtt
    # Impulzus számláló növelése
        pulse_count += 1
    print(f"Impulzus: {pulse_count}")
    time.sleep(0.5)

    # Szervó mozgatása és jelszint mérése
    for angle in range(min_angle, max_angle + 1, step):
        set_servo_angle(angle)  # Szervó mozgatása
        time.sleep(0.1)  # Stabilizálódási idő
        adc_values = [] 

        for _ in range(10):
            adc_values.append(adc_pin.read_u16())
            time.sleep(0.005)  
        avg_value = sum(adc_values) // len(adc_values)  # Átlag kiszámítása

        print(f"Szög: {angle}, Átlagos jelszint: {avg_value}")

