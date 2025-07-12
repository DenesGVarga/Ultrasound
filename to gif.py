import os
from PIL import Image

# --- Beállítások ---
INPUT_DIR = r"C:\Users\denes\polar_diagramok_V"  # PNG képeket tartalmazó mappa
OUTPUT_GIF = "ultrahang_animaciorovid.gif"              # Kimeneti GIF fájl neve
FRAME_DURATION = 100                                # Képkocka időtartama (ms)

def create_gif():
    # 1. PNG fájlok beolvasása és rendezése impulzus szám szerint
    impulse_dict = {}
    for file in os.listdir(INPUT_DIR):
        if file.endswith(".png") and file.startswith("impulzus_"):
            try:
                num = int(file.split("_")[1].split(".")[0])
                impulse_dict[num] = os.path.join(INPUT_DIR, file)
            except (IndexError, ValueError):
                continue

    # 2. Kép lista összeállítása a kívánt sorrendben
    images = []

    # 0 → 500
    for i in range(0, 501, 2):
        if i in impulse_dict:
            img = Image.open(impulse_dict[i]).convert("RGB").convert("P", palette=Image.ADAPTIVE)
            images.append(img)

    # 498 → 0
    for i in range(498, -1, -2):
        if i in impulse_dict:
            img = Image.open(impulse_dict[i]).convert("RGB").convert("P", palette=Image.ADAPTIVE)
            images.append(img)

    # 502 → 1000
    for i in range(502, 1001, 2):
        if i in impulse_dict:
            img = Image.open(impulse_dict[i]).convert("RGB").convert("P", palette=Image.ADAPTIVE)
            images.append(img)

    # 998 → 500
    for i in range(998, 499, -2):
        if i in impulse_dict:
            img = Image.open(impulse_dict[i]).convert("RGB").convert("P", palette=Image.ADAPTIVE)
            images.append(img)

    # 3. GIF mentése
    if not images:
        print("Nincsenek érvényes képek!")
        return

    images[0].save(
        OUTPUT_GIF,
        save_all=True,
        append_images=images[1:],
        duration=FRAME_DURATION,
        loop=0
    )
    print(f"GIF elkészült: {OUTPUT_GIF}")

# Futtatás
if __name__ == "__main__":
    create_gif()
