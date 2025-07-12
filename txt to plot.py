import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# --- Beállítások ---
INPUT_FILE = r"C:\Users\denes\Desktop\kiert\aktív\adatoknagy.xlsx"
OUTPUT_DIR = "polar_diagramok_nagy"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# --- Adatfeldolgozás ---
df = pd.read_excel(INPUT_FILE, header=None)
data = {}
current_impulse = None

for index, row in df.iterrows():
    row_str = str(row[0]).lower().strip() if pd.notna(row[0]) else ""
    
    if "impulzus" in row_str:
        try:
            current_impulse = int(float(row[1]))
            data[current_impulse] = {'angles': [], 'levels': []}
        except (ValueError, TypeError):
            continue
    
    elif "szög" in row_str and current_impulse is not None:
        try:
            angle = int(float(str(row[1]).split(",")[0].strip()))
            level = int(float(row[2])) if pd.notna(row[2]) else 0
            data[current_impulse]['angles'].append(angle)
            data[current_impulse]['levels'].append(level)
        except (ValueError, AttributeError):
            continue

# --- Polar diagram generálása ---
for impulse, values in data.items():
    if not values['angles']:
        continue

    angles = np.array(values['angles'])
    levels = np.array(values['levels'])
    
    # Keresd meg a legkisebb jelszintet
    min_level = levels.min()
    
    # Ha a minimum túl nagy vagy kicsi, akkor állítsuk be 0 vagy 0.1-re
    adjusted_levels = levels - min_level  # Kivonjuk a minimumot, hogy a legkisebb érték 0 legyen
    if adjusted_levels.max() == 0:
        adjusted_levels += 0.1  # Ha minden érték nulla lenne, adjunk hozzá 0.1-et
    
    # Normalizálás (0-1 tartományba)
    normalized_levels = adjusted_levels / adjusted_levels.max()
    
    # Átszámítás radiánba
    theta = np.deg2rad(angles)

    plt.figure(figsize=(10, 10))
    ax = plt.subplot(111, polar=True)
    
    # Fő ábra
    ax.plot(theta, normalized_levels, 'b-', linewidth=2, label='Jelszint')
    ax.fill(theta, normalized_levels, 'b', alpha=0.1)
    
    # Szögtengely beállítások
    ax.set_theta_zero_location('N')  # 0° felül
    ax.set_theta_direction(-1)       # Óramutató járásával megegyező irány
    ax.set_rlabel_position(90)       # Sugár feliratok elhelyezése
    
    # Cím és jelmagyarázat
    plt.title(f"Ultrahangos irányított mérés - Impulzus {impulse}", pad=20)
    plt.legend(loc='upper right')
    
    # Mentés
    output_path = os.path.join(OUTPUT_DIR, f"impulzus_{impulse}.png")
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Polar diagram mentve: {output_path}")
