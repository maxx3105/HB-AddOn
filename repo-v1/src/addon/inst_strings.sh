#!/bin/sh
# ============================================================
# inst_strings.sh – HB-UNI-Sen-POOL-WP Stringtable Integration
#
# stringtable_de.txt      -> Mapping ParameterID -> stringTable-Key
# translate.lang.extension.js (de+en) -> stringTable-Key -> lesbarer Text
#
# Anker fuer add_tr: letzte Zeile "  }" im de/en-Block
# (direkt vor der schliessenden Klammer des Sprach-Objekts)
# ============================================================

STRINGTABLE=/www/config/stringtable_de.txt
EXTENSION_DE=/www/webui/js/lang/de/translate.lang.extension.js
EXTENSION_EN=/www/webui/js/lang/en/translate.lang.extension.js
STRINGTABLE_JS_DE=/www/webui/js/lang/de/translate.lang.stringtable.js
STRINGTABLE_JS_EN=/www/webui/js/lang/en/translate.lang.stringtable.js
JP_ADDON_DIR=/usr/local/addons/jp-hb-devices-addon

# -------------------------------------------------------
# Fuegt Zeile in stringtable_de.txt ein, falls nicht vorhanden.
# -------------------------------------------------------
add_st() {
    local KEY="$1"
    local VALKEY="$2"
    if ! grep -qF "${KEY}	" "${STRINGTABLE}"; then
        HB_INS=$(printf '%s\t${%s}' "${KEY}" "${VALKEY}")
        export HB_INS
        awk 'BEGIN { ins=ENVIRON["HB_INS"]; done=0 }
             index($0,"CAPACITIVE_FILLING_LEVEL_SENSOR|FILL_LEVEL\t")==1 && !done {
                 print ins; done=1
             }
             { print }
             END { if (!done) { print ins } }' \
            "${STRINGTABLE}" > "${STRINGTABLE}.tmp" \
            && mv "${STRINGTABLE}.tmp" "${STRINGTABLE}"
        echo "  stringtable: +${KEY}"
    fi
}

del_st() {
    local KEY="$1"
    HB_DEL="${KEY}	"
    export HB_DEL
    awk 'BEGIN { del=ENVIRON["HB_DEL"] }
         index($0, del) != 1 { print }' \
        "${STRINGTABLE}" > "${STRINGTABLE}.tmp" \
        && mv "${STRINGTABLE}.tmp" "${STRINGTABLE}"
}

# -------------------------------------------------------
# Fuegt Eintrag in translate.lang.extension.js ein.
# Anker: die letzte Zeile die nur "  }" enthaelt
# (= schliessende Klammer des Sprach-Objekts)
# -------------------------------------------------------
add_tr() {
    local FILE="$1"
    local KEY="$2"
    local VAL="$3"
    if ! grep -qF "\"${KEY}\"" "${FILE}"; then
        HB_INS="    \"${KEY}\" : \"${VAL}\","
        export HB_INS
        # Fuege vor der letzten "  }"-Zeile ein.
        # Stellt sicher dass die Zeile davor ein Komma hat (JSON-Syntax).
        awk 'BEGIN { ins=ENVIRON["HB_INS"] }
             { lines[NR]=$0 }
             END {
                 last=0
                 for(i=NR;i>=1;i--) {
                     if(lines[i]=="  }") { last=i; break }
                 }
                 # Sicherstellen dass Zeile vor dem Einfuegepunkt mit Komma endet
                 prev=last-1
                 if(prev>=1 && lines[prev] !~ /,$/ && lines[prev] !~ /^[[:space:]]*\/\//) {
                     lines[prev] = lines[prev] ","
                 }
                 for(i=1;i<=NR;i++) {
                     if(i==last) print ins
                     print lines[i]
                 }
             }' \
            "${FILE}" > "${FILE}.tmp" \
            && mv "${FILE}.tmp" "${FILE}"
        echo "  translation: +${KEY} in $(basename ${FILE})"
    fi
}

del_tr() {
    local FILE="$1"
    local KEY="$2"
    HB_DEL="\"${KEY}\""
    export HB_DEL
    awk 'BEGIN { del=ENVIRON["HB_DEL"] }
         index($0, del) == 0 { print }' \
        "${FILE}" > "${FILE}.tmp" \
        && mv "${FILE}.tmp" "${FILE}"
}

# -------------------------------------------------------
# INSTALL
# -------------------------------------------------------
do_install() {
    echo "=== inst_strings.sh: install ==="

    # stringtable_de.txt
    add_st "HB_FLOW_RATE"                                  "stringTableHbFlowrate"
    add_st "HB_FLOWRATE_QFACTOR"                           "stringTableHbFlowrateQFactor"
    add_st "HB_GENERIC|HB_PH"                             "stringTableHbPh"
    add_st "HB_GENERIC|HB_ORP"                            "stringTableHbOrp"
    add_st "HB_GENERIC|HB_ORPOFFSET"                      "stringTableHbOrpOffset"
    add_st "HB_GENERIC|HB_TOGGLEWAITTIME"                 "stringTableHbToggleWaitTime"
    add_st "HB_GENERIC|INFO_MSG=HB_OPERATION_NORMAL"      "stringTableHBOperationNormal"
    add_st "HB_GENERIC|INFO_MSG=HB_OPERATION_CALIBRATION" "stringTableHBOperationCalibration"
    add_st "HB_GENERIC|INFO_MSG=HB_CALIBRATION_INVALID"   "stringTableHBCalibrationInvalid"
    add_st "HB_MEASURE_INTERVAL"                           "stringTableHBMeasureInterval"
    add_st "HBWEA_TRANSMIT_INTERVAL"                       "stringTableHbWeaTransmitInterval"
    add_st "HB_GENERIC|TEMPERATURE_OFFSET_1"              "stringTableHbTemperatureOffset1"
    add_st "HB_GENERIC|TEMPERATURE_OFFSET_2"              "stringTableHbTemperatureOffset2"
    add_st "TEMPERATURE_OFFSET_1"                          "stringTableHbTemperatureOffset1"
    add_st "TEMPERATURE_OFFSET_2"                          "stringTableHbTemperatureOffset2"
    add_st "UNI_PRESSURE"                                  "stringTableUniPressure"
    add_st "HB_GENERIC|TEMPERATURE_OFFSET_3"              "stringTableHbTemperatureOffset3"
    add_st "TEMPERATURE_OFFSET_3"                          "stringTableHbTemperatureOffset3"

    # Deutsch – in extension.js UND stringtable.js
    # (extension.js = Statusansicht, stringtable.js = Kanalparameter-Ansicht)
    for F in "${EXTENSION_DE}" "${STRINGTABLE_JS_DE}"; do
        add_tr "${F}" "stringTableHbFlowrate"             "Durchflussrate"
        add_tr "${F}" "stringTableHbFlowrateQFactor"      "Flow-Sensor Q-Faktor"
        add_tr "${F}" "stringTableHbPh"                   "PH-Wert"
        add_tr "${F}" "stringTableHbOrp"                  "ORP-Wert"
        add_tr "${F}" "stringTableHbOrpOffset"            "ORP-Offset"
        add_tr "${F}" "stringTableHbToggleWaitTime"       "Umschalt-Wartezeit"
        add_tr "${F}" "stringTableUniPressure"            "Druck"
        add_tr "${F}" "stringTableHBMeasureInterval"      "Messintervall"
        add_tr "${F}" "stringTableHbWeaTransmitInterval"  "Sendeintervall"
        add_tr "${F}" "stringTableHBOperationNormal"      "Normalbetrieb"
        add_tr "${F}" "stringTableHBOperationCalibration" "Kalibriermodus"
        add_tr "${F}" "stringTableHBCalibrationInvalid"   "Kalibrierdaten ung%FCltig"
        add_tr "${F}" "stringTableHbTemperatureOffset1"   "Temperatur-Offset Sensor 1"
        add_tr "${F}" "stringTableHbTemperatureOffset2"   "Temperatur-Offset Sensor 2"
        add_tr "${F}" "stringTableHbTemperatureOffset3"   "Temperatur-Offset Sensor 3"
    done
    # infoStatusControlLbl: nur in extension.js (dort bereits als Standard vorhanden,
    # wird durch den Komma-Fix jetzt korrekt aufgeloest)
    add_tr "${EXTENSION_DE}" "infoStatusControlLblOpen"   "Offen"
    add_tr "${EXTENSION_DE}" "infoStatusControlLblClosed" "Verschlossen"

    # Englisch – in extension.js UND stringtable.js
    for F in "${EXTENSION_EN}" "${STRINGTABLE_JS_EN}"; do
        add_tr "${F}" "stringTableHbFlowrate"             "Flow rate"
        add_tr "${F}" "stringTableHbFlowrateQFactor"      "Flow sensor Q-factor"
        add_tr "${F}" "stringTableHbPh"                   "pH value"
        add_tr "${F}" "stringTableHbOrp"                  "ORP value"
        add_tr "${F}" "stringTableHbOrpOffset"            "ORP offset"
        add_tr "${F}" "stringTableHbToggleWaitTime"       "Relay switching delay"
        add_tr "${F}" "stringTableUniPressure"            "Pressure"
        add_tr "${F}" "stringTableHBMeasureInterval"      "Measurement interval"
        add_tr "${F}" "stringTableHbWeaTransmitInterval"  "Transmit interval"
        add_tr "${F}" "stringTableHBOperationNormal"      "Normal operation"
        add_tr "${F}" "stringTableHBOperationCalibration" "Calibration mode"
        add_tr "${F}" "stringTableHBCalibrationInvalid"   "Calibration data invalid"
        add_tr "${F}" "stringTableHbTemperatureOffset1"   "Temperature offset sensor 1"
        add_tr "${F}" "stringTableHbTemperatureOffset2"   "Temperature offset sensor 2"
        add_tr "${F}" "stringTableHbTemperatureOffset3"   "Temperature offset sensor 3"
    done
    add_tr "${EXTENSION_EN}" "infoStatusControlLblOpen"   "Open"
    add_tr "${EXTENSION_EN}" "infoStatusControlLblClosed" "Closed"

    echo "=== inst_strings.sh: install done ==="
}

# -------------------------------------------------------
# UNINSTALL
# -------------------------------------------------------
do_uninstall() {
    echo "=== inst_strings.sh: uninstall ==="

    # WP-exklusiv immer entfernen – aus allen 4 JS-Dateien
    del_st "HB_GENERIC|TEMPERATURE_OFFSET_3"
    del_st "TEMPERATURE_OFFSET_3"
    for F in "${EXTENSION_DE}" "${EXTENSION_EN}" "${STRINGTABLE_JS_DE}" "${STRINGTABLE_JS_EN}"; do
        del_tr "${F}" "stringTableHbTemperatureOffset3"
    done
    del_tr "${EXTENSION_DE}" "infoStatusControlLblOpen"
    del_tr "${EXTENSION_DE}" "infoStatusControlLblClosed"
    del_tr "${EXTENSION_EN}" "infoStatusControlLblOpen"
    del_tr "${EXTENSION_EN}" "infoStatusControlLblClosed"

    if [ ! -d "${JP_ADDON_DIR}" ]; then
        echo "  jp nicht installiert – entferne auch gemeinsame Eintraege"
        del_st "HB_FLOW_RATE"
        del_st "HB_FLOWRATE_QFACTOR"
        del_st "HB_GENERIC|HB_PH"
        del_st "HB_GENERIC|HB_ORP"
        del_st "HB_GENERIC|HB_ORPOFFSET"
        del_st "HB_GENERIC|HB_TOGGLEWAITTIME"
        del_st "HB_GENERIC|INFO_MSG=HB_OPERATION_NORMAL"
        del_st "HB_GENERIC|INFO_MSG=HB_OPERATION_CALIBRATION"
        del_st "HB_GENERIC|INFO_MSG=HB_CALIBRATION_INVALID"
        del_st "HB_MEASURE_INTERVAL"
        del_st "HBWEA_TRANSMIT_INTERVAL"
        del_st "HB_GENERIC|TEMPERATURE_OFFSET_1"
        del_st "HB_GENERIC|TEMPERATURE_OFFSET_2"
        del_st "TEMPERATURE_OFFSET_1"
        del_st "TEMPERATURE_OFFSET_2"
        del_st "UNI_PRESSURE"

        for F in "${EXTENSION_DE}" "${EXTENSION_EN}" "${STRINGTABLE_JS_DE}" "${STRINGTABLE_JS_EN}"; do
            del_tr "${F}" "stringTableHbFlowrate"
            del_tr "${F}" "stringTableHbFlowrateQFactor"
            del_tr "${F}" "stringTableHbPh"
            del_tr "${F}" "stringTableHbOrp"
            del_tr "${F}" "stringTableHbOrpOffset"
            del_tr "${F}" "stringTableHbToggleWaitTime"
            del_tr "${F}" "stringTableUniPressure"
            del_tr "${F}" "stringTableHBMeasureInterval"
            del_tr "${F}" "stringTableHbWeaTransmitInterval"
            del_tr "${F}" "stringTableHBOperationNormal"
            del_tr "${F}" "stringTableHBOperationCalibration"
            del_tr "${F}" "stringTableHBCalibrationInvalid"
            del_tr "${F}" "stringTableHbTemperatureOffset1"
            del_tr "${F}" "stringTableHbTemperatureOffset2"
        done
    else
        echo "  jp installiert – gemeinsame Eintraege bleiben"
    fi

    echo "=== inst_strings.sh: uninstall done ==="
}

case "$1" in
    ""|install)   do_install   ;;
    uninstall)    do_uninstall ;;
    *)
        echo "Usage: $(basename $0) {install|uninstall}"
        exit 1
        ;;
esac
