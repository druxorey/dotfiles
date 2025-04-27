#!/bin/bash

CONFIG_DIR="/etc"
TLP_CONF="$CONFIG_DIR/tlp.conf"

runRofi='rofi -dmenu -p -i -config ~/.config/rofi/styles/powerplan-rofi.rasi'

function main() {
    rofiOption=$(echo -e "powersave\nnormal\nperformance" | $runRofi)

	# Determinar el archivo según la opción seleccionada
	case "$rofiOption" in
		"powersave")
			CONFIG_FILE="$CONFIG_DIR/tlp.d/1-powersave.conf"
			;;
		"performance")
			CONFIG_FILE="$CONFIG_DIR/tlp.d/2-performance.conf"
			;;
		"normal")
			CONFIG_FILE="$CONFIG_DIR/tlp.d/3-normal.conf"
			;;
		*)
			echo "Opción inválida. Saliendo."
			exit 1
			;;
	esac

	# Verificar si el archivo existe
	if [[ -f "$CONFIG_FILE" ]]; then
		# Crear enlace simbólico
		sudo ln -sf "$CONFIG_FILE" "$TLP_CONF"
		echo "Configuración cambiada a: $CONFIG_FILE"

		# Reiniciar TLP
		sudo tlp start
		echo "TLP reiniciado con la nueva configuración."
	else
		echo "Error: El archivo de configuración '$CONFIG_FILE' no existe."
		exit 1
	fi
}

main $@
