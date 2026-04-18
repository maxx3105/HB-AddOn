# HB-AddOn

[![Build Addon](https://github.com/maxx3105/HB-AddOn/actions/workflows/build.yml/badge.svg)](https://github.com/maxx3105/HB-AddOn/actions/workflows/build.yml)
[![Releases](https://img.shields.io/github/v/release/maxx3105/HB-AddOn)](https://github.com/maxx3105/HB-AddOn/releases/latest)

Homematic/OpenCCU Addon für AskSin++-basierte Selbstbaugeräte.

Basiert auf [AskSin++](https://github.com/pa-pa/AskSinPP) von [pa-pa](https://github.com/pa-pa) und [jp112sdl](https://github.com/jp112sdl).

---

## Unterstützte Geräte

| Gerät | Modell-ID | Beschreibung |
|-------|-----------|--------------|
| [HB-UNI-Sen-POOL-WP](https://github.com/maxx3105/HB-UNI-Sen-POOL-WP) | 0xFC60 | Pool-Wärmepumpen-Controller |

---

## Kompatibilität

✅ OpenCCU / RaspberryMatic / CCU3 ab Firmware **3.47.x**

---

## Endbenutzer-Anleitung

### Installation

1. Aktuelles Release-tgz von der [Releases-Seite](https://github.com/maxx3105/HB-AddOn/releases/latest) herunterladen
2. OpenCCU WebUI öffnen → **Einstellungen** → **Systemsteuerung** → **Zusatzsoftware**
3. Heruntergeladenes `hb-addon-x.x.tgz` hochladen
4. Die CCU startet automatisch neu — danach ist das Addon aktiv

> ⚠️ Bei einer bestehenden Installation zuerst das alte Addon **deinstallieren**, dann das neue installieren.

### Gerät anlernen

1. OpenCCU WebUI → **Einstellungen** → **Geräte anlernen**
2. Anlernmodus am Gerät aktivieren (Config-Taste kurz drücken)
3. Das Gerät erscheint automatisch in der Geräteliste

### Kanalübersicht HB-UNI-Sen-POOL-WP

| Kanal | Typ | Funktion |
|-------|-----|----------|
| 1 | HB_GENERIC | Messwerte: Temp1/2/3, pH, ORP, Druck, Durchfluss |
| 2 | WEATHER | Temperatur Sensor 2 |
| 3 | WEATHER | Temperatur Sensor 3 (Luft/Frostschutz) |
| 4–6 | SHUTTER_CONTACT | Digitaleingänge (z.B. Strömungswächter, Druckschalter) |
| 7–10 | SWITCH | Relaisausgänge (Pumpe, Wärmepumpe, Ventile etc.) |

### Geräteparameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|---------|
| HB_MEASURE_INTERVAL | Messintervall in Sekunden | 10 s |
| HBWEA_TRANSMIT_INTERVAL | Sendeintervall (alle X Messungen) | 18 |
| Beleuchtungsdauer | LCD-Backlight Einschaltdauer | 60 s |

### Kanalparameter (Kanal 1)

| Parameter | Beschreibung | Standard |
|-----------|--------------|---------|
| ORP-Offset | Kalibrieroffset für ORP-Sensor in mV | 0 mV |
| Temperatur-Offset Sensor 1–3 | Feinabgleich der NTC-Sensoren | 0.0K |
| Flow-Sensor Q-Faktor | Kalibrierungsfaktor für Durchflussmesser | 1.0 |
| Umschalt-Wartezeit | Wartezeit beim Umschalten pH/ORP-Sensor | 200 ms |

### pH-Sensor Kalibrierung

1. Langen Tastendruck auf den Config-Button → Kalibriermodus startet
2. Schritt 1: pH 7.0 Pufferlösung einlegen → kurzen Tastendruck
3. Schritt 2: pH 4.0 Pufferlösung einlegen → kurzen Tastendruck
4. Kalibrierung wird automatisch gespeichert
5. Zum Beenden: langen Tastendruck oder automatischer Timeout nach 15 Minuten

### Versionsprüfung

Das Addon prüft beim Aufruf der Info-Seite in der WebUI automatisch ob eine neue Version auf GitHub verfügbar ist:

- **Installierte Version = Verfügbare Version** → alles aktuell
- **Verfügbare Version neuer** → Update-Hinweis mit Download-Link erscheint

### Deinstallation

OpenCCU WebUI → **Einstellungen** → **Systemsteuerung** → **Zusatzsoftware** → **HB-AddOn** → **Deinstallieren**

---

## Entwickler-Anleitung

### Repository-Struktur

```
HB-AddOn/
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions: automatischer Build & Release
├── src/
│   ├── addon/
│   │   ├── firmware/
│   │   │   └── rftypes/       # Geräte-XML-Dateien (eine pro Gerät)
│   │   ├── patch/
│   │   │   └── common/
│   │   │       └── ic_deviceparameters.cgi.patch
│   │   ├── www/
│   │   │   └── config/img/devices/
│   │   │       ├── 50/        # Gerätebilder 50×50px (thumb)
│   │   │       └── 250/       # Gerätebilder 250×250px
│   │   ├── devdb.csv          # Gerät → Bildname Mapping
│   │   ├── inst_devdb.sh      # DEVDB.tcl Install/Uninstall
│   │   ├── inst_easymodes.sh  # Easymodes Install/Uninstall
│   │   ├── inst_strings.sh    # Übersetzungen Install/Uninstall
│   │   └── VERSION            # Versionsnummer (wird von CI gesetzt)
│   ├── rc.d/
│   │   └── hb-addon           # Haupt-Startscript (Install/Uninstall/Info)
│   └── update_script          # CCU-Installationsscript
└── README.md
```

### Neues Gerät hinzufügen

#### 1. Geräte-XML anlegen

```
src/addon/firmware/rftypes/hb-neues-geraet.xml
```

Die XML beschreibt Kanäle, Parameter und Frames des Geräts nach dem Homematic-Geräteformat.

#### 2. Gerät in devdb.csv eintragen

```csv
HB-NEUES-GERAET;hb-neues-geraet
```

Format: `GERAETE-ID;bildname` (ohne Dateiendung)

#### 3. Gerätebilder hinzufügen

```
src/addon/www/config/img/devices/50/hb-neues-geraet_thumb.png   (50×50px)
src/addon/www/config/img/devices/250/hb-neues-geraet.png        (250×250px)
```

#### 4. WebUI-Einträge in rc.d ergänzen

In `src/rc.d/hb-addon` → Funktion `webui_apply()`:

```sh
# DEV_LIST Eintrag (nach dem letzten bestehenden Eintrag)
WEBUI_INSERT_2='DEV_HIGHLIGHT['"'"'HB-NEUES-GERAET'"'"'] = new Object();\
DEV_LIST.push('"'"'HB-NEUES-GERAET'"'"');\
DEV_DESCRIPTION['"'"'HB-NEUES-GERAET'"'"']='"'"'Mein neues Geraet'"'"';\
DEV_PATHS['"'"'HB-NEUES-GERAET'"'"'] = new Object();\
DEV_PATHS['"'"'HB-NEUES-GERAET'"'"']['"'"'50'"'"'] = '"'"'/config/img/devices/50/hb-neues-geraet_thumb.png'"'"';\
DEV_PATHS['"'"'HB-NEUES-GERAET'"'"']['"'"'250'"'"'] = '"'"'/config/img/devices/250/hb-neues-geraet.png'"'"';'

# elvST Einträge für HB_GENERIC Kanal (falls verwendet)
elvST['MEIN_KANALTYP'] = 'Mein Kanaltyp';
elvST['MEIN_KANALTYP|MEIN_PARAM'] = '${stringTableMeinParam}';
```

#### 5. Übersetzungen in inst_strings.sh ergänzen

In `src/addon/inst_strings.sh` → `do_install()`:

```sh
# stringtable_de.txt Einträge
add_st "MEIN_KANALTYP|MEIN_PARAM"   "stringTableMeinParam"

# Übersetzungen Deutsch
for F in "${EXTENSION_DE}" "${STRINGTABLE_JS_DE}"; do
    add_tr "${F}" "stringTableMeinParam" "Mein Parameter"
done

# Übersetzungen Englisch
for F in "${EXTENSION_EN}" "${STRINGTABLE_JS_EN}"; do
    add_tr "${F}" "stringTableMeinParam" "My parameter"
done
```

Und in `do_uninstall()` spiegelbildlich mit `del_st` / `del_tr` entfernen.

#### 6. Release erstellen

```bash
# Lokal
git add .
git commit -m "Add HB-NEUES-GERAET"
git tag v1.1
git push origin main
git push origin v1.1
```

GitHub Actions baut automatisch `hb-addon-1.1.tgz` und veröffentlicht einen neuen Release.

Alternativ direkt auf GitHub: **Releases** → **Draft a new release** → Tag `v1.1` anlegen → **Publish release**.

### Lokaler Build

```bash
cd src
tar -czf ../hb-addon-1.0.tgz rc.d addon update_script
```

### Technische Hintergründe

#### Übersetzungssystem der OpenCCU WebUI

Die WebUI nutzt drei Ebenen für Parameterübersetzungen:

| Datei | Verwendung |
|-------|-----------|
| `stringtable_de.txt` | Mapping `KANALTYP\|PARAM_ID` → `${stringTableKey}` |
| `translate.lang.extension.js` | `stringTableKey` → lesbarer Text (Statusansicht) |
| `translate.lang.stringtable.js` | `stringTableKey` → lesbarer Text (Kanalparameter-Ansicht) |
| `webui.js` → `elvST[]` | `KANALTYP\|PARAM_ID` → `${stringTableKey}` (Status-Grid) |

Alle vier müssen befüllt sein damit Übersetzungen in allen WebUI-Ansichten funktionieren.

#### webui.js Modifikation

Da `/www` auf OpenCCU read-only gemountet ist, verwendet das Addon `sed` mit Marker-basierter Erkennung statt `patch`. Das verhindert Probleme mit abweichenden Zeilennummern zwischen CCU-Firmware-Versionen.

---

## Lizenz

[Creative Commons BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
