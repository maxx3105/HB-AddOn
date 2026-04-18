#!/bin/sh
# Stellt sicher, dass SHUTTER_CONTACT easymode-Lokalisierungsverzeichnisse vorhanden sind.
# Benoetigt von der CCU fuer die Kanalkonfiguration der Alarmkanaele.

EASYMODES_DIR="/www/config/easymodes"
SOURCE_DIR="${EASYMODES_DIR}/BLIND"

case "$1" in
    ""|install)
        echo "easymodes install SHUTTER_CONTACT"
        for LANG in de en; do
            TARGET_DIR="${EASYMODES_DIR}/SHUTTER_CONTACT/localization/${LANG}"
            mkdir -p ${TARGET_DIR}
            if [ ! -e "${TARGET_DIR}/GENERIC.txt" ]; then
                if [ -f "${SOURCE_DIR}/localization/${LANG}/GENERIC.txt" ]; then
                    cp "${SOURCE_DIR}/localization/${LANG}/GENERIC.txt" "${TARGET_DIR}/"
                    echo "  - copied GENERIC.txt [${LANG}]"
                fi
            fi
            if [ ! -e "${TARGET_DIR}/SHUTTER_CONTACT.txt" ]; then
                if [ -f "${SOURCE_DIR}/localization/${LANG}/BLIND.txt" ]; then
                    cp "${SOURCE_DIR}/localization/${LANG}/BLIND.txt" "${TARGET_DIR}/SHUTTER_CONTACT.txt"
                    echo "  - created SHUTTER_CONTACT.txt [${LANG}]"
                fi
            fi
            chmod -R 755 "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/" 2>/dev/null
        done
        ;;
    uninstall)
        echo "easymodes uninstall SHUTTER_CONTACT"
        rm -f "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/de/GENERIC.txt"
        rm -f "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/de/SHUTTER_CONTACT.txt"
        rm -f "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/en/GENERIC.txt"
        rm -f "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/en/SHUTTER_CONTACT.txt"
        rmdir "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/de" 2>/dev/null
        rmdir "${EASYMODES_DIR}/SHUTTER_CONTACT/localization/en" 2>/dev/null
        rmdir "${EASYMODES_DIR}/SHUTTER_CONTACT/localization"    2>/dev/null
        rmdir "${EASYMODES_DIR}/SHUTTER_CONTACT"                 2>/dev/null
        ;;
esac
