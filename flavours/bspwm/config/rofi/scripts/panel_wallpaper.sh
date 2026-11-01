#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/panel_wallpaper.rasi"
declare -r WALLPAPERS_PATH="$HOME/Pictures/Wallpapers"
declare -r SYMLINK_ACTUAL="$HOME/.local/share/wallpaper_actual"

main() {
    local theme=$(cat "$HOME/.cache/actual_theme" 2>/dev/null)

    case "$theme" in
        dark)  local dir="Dracula"; local prefix="D" ;;
        *)     local dir="Alucard"; local prefix="A" ;;
    esac

    local themePath="$WALLPAPERS_PATH/$dir"
    printf "Loading wallpapers from: %s\n" "$themePath"

    local selection=$(for img in "$WALLPAPERS_PATH/.Thumbnails/$prefix"*.webp; do
        [ -e "$img" ] || continue
        echo -en "$(basename "$img" .webp).jxl\0icon\x1f$img\n"
    done | rofi -dmenu -m -1 -show-icons -mesg "Wallpapers for $dir" -config "$ROFI_CONFIG")

    [[ -z "$selection" ]] && { printf "%b No wallpaper selected\n" "$FORMAT_WARNING"; return 0; }

    local id=$(echo "$selection" | grep -oP '\d+')

    ln -sf "$WALLPAPERS_PATH/Dracula/D$id.jxl" "$HOME/.local/share/wallpaper_dark"
    ln -sf "$WALLPAPERS_PATH/Alucard/A$id.jxl" "$HOME/.local/share/wallpaper_light"
    ln -sf "$themePath/$selection" "$SYMLINK_ACTUAL"

    if feh --bg-fill "$SYMLINK_ACTUAL"; then
        printf "%b Wallpaper set to: %s\n" "$FORMAT_SUCCESS" "$selection"
        notify-send "New wallpaper: $selection" -i "$SYMLINK_ACTUAL" --app-name "Wallpaper Manager" -u low
    else
        printf "%b Failed to set wallpaper: %s\n" "$FORMAT_ERROR" "$selection"
        notify-send "Failed to set wallpaper" -u critical
        return 1
    fi
}

main "$@"
