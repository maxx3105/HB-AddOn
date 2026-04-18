# HB-AddOn

Homematic/OpenCCU Addon für den **HB-UNI-Sen-POOL-WP** Pool-Wärmepumpen-Controller.

Basiert auf [AskSin++](https://github.com/pa-pa/AskSinPP) von jp112sdl.

## Unterstützte Geräte

| Gerät | Modell-ID | Beschreibung |
|-------|-----------|--------------|
| HB-UNI-Sen-POOL-WP | 0xFC60 | Pool-Wärmepumpen-Controller mit 3× NTC, pH, ORP, Druck, Durchfluss, 4× Relais, 3× Shutter-Contact |

## Hardware

- ATmega1284P + CC1101 868 MHz
- 3× NTC-Temperatursensor (Pool, Vorlauf/Rücklauf, Luft/Frostschutz)
- pH- und ORP-Sensor
- Drucksensor (0–0.5 MPa)
- Durchflussmessung via PCF8583
- 4× Relais (Pumpe, Wärmepumpe, Ventile etc.)
- 3× Shutter-Contact-Eingänge
- 20×4 I²C LCD-Display

## Kompatibilität

✅ OpenCCU / RaspberryMatic / CCU3 ab Firmware 3.47.x

## Installation

1. Aktuelles Release-tgz von der [Releases-Seite](../../releases/latest) herunterladen
2. OpenCCU WebUI → **Einstellungen** → **Systemsteuerung** → **Zusatzsoftware**
3. tgz hochladen → nach automatischem Neustart ist das Addon aktiv

## Addon-Inhalt

Das Addon bringt folgende Anpassungen an der OpenCCU-WebUI mit:

- **rftypes XML**: Gerätebeschreibung (`0xFC60`)
- **webui.js**: DEV_LIST/DEV_PATHS-Eintrag, `elvST`-Übersetzungen für HB_GENERIC-Kanal
- **ic_deviceparameters.cgi**: Korrekte Kanal-Index-Auflösung für interne Tastenprogrammierung
- **stringtable_de.txt**: Parameter-ID → stringTable-Key Mappings
- **translate.lang.extension.js** (de/en): Lesbare Parameternamen
- **translate.lang.stringtable.js** (de/en): Parameternamen für Kanalparameter-Ansicht
- **DEVDB.tcl**: Gerätebild-Eintrag

## Neues Gerät hinzufügen

1. XML nach `src/addon/firmware/rftypes/` hinzufügen
2. `src/addon/devdb.csv` um eine Zeile ergänzen:
   ```
   HB-NEUES-GERAET;hb-neues-geraet
   ```
3. `src/addon/inst_strings.sh` → `do_install()` und `do_uninstall()` um neue Keys erweitern
4. `src/rc.d/hb-addon` → `webui_apply()` um neue `elvST`-Einträge und DEV_LIST-Eintrag erweitern
5. Gerätebild (50px + 250px) nach `src/addon/www/config/img/devices/` legen
6. Neuen Git-Tag pushen → GitHub Actions baut automatisch das tgz:
   ```bash
   git tag v1.1
   git push origin v1.1
   ```

## Bauen (lokal)

```bash
cd src
tar -czf ../hb-addon-1.0.tgz rc.d addon update_script
```

## Lizenz

Creative Commons BY-NC-SA 4.0
