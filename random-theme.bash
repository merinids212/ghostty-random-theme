# Ghostty Random Theme (bash)
# Source this from your .bashrc.
#
# https://github.com/ghostty-org/ghostty/discussions/3577

[[ "$TERM_PROGRAM" == "ghostty" ]] || return 0

# Find themes directory — GHOSTTY_RESOURCES_DIR is set by Ghostty on all platforms
_ghostty_themes_dir=""
if [[ -d "$GHOSTTY_RESOURCES_DIR/themes" ]]; then
  _ghostty_themes_dir="$GHOSTTY_RESOURCES_DIR/themes"
elif [[ -d "/Applications/Ghostty.app/Contents/Resources/ghostty/themes" ]]; then
  _ghostty_themes_dir="/Applications/Ghostty.app/Contents/Resources/ghostty/themes"
elif [[ -d "/usr/share/ghostty/themes" ]]; then
  _ghostty_themes_dir="/usr/share/ghostty/themes"
elif [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/ghostty/themes" ]]; then
  _ghostty_themes_dir="${XDG_DATA_HOME:-$HOME/.local/share}/ghostty/themes"
fi

[[ -d "$_ghostty_themes_dir" ]] || return 0

# Pick a random theme
shopt -s nullglob
_ghostty_themes=("$_ghostty_themes_dir"/*)
shopt -u nullglob
(( ${#_ghostty_themes[@]} )) || return 0
_theme_file="${_ghostty_themes[RANDOM % ${#_ghostty_themes[@]}]}"
_theme="${_theme_file##*/}"

[[ -f "$_theme_file" ]] || return 0

# Apply colors via OSC escape sequences
while IFS='= ' read -r key value; do
  [[ -z "$key" || "$key" == \#* ]] && continue
  value="${value## }"
  case "$key" in
    background)            printf '\e]11;%s\a' "$value" ;;
    foreground)            printf '\e]10;%s\a' "$value" ;;
    cursor-color)          printf '\e]12;%s\a' "$value" ;;
    selection-background)  printf '\e]17;%s\a' "$value" ;;
    selection-foreground)  printf '\e]19;%s\a' "$value" ;;
    palette)
      IFS='=' read -r idx color <<< "$value"
      printf '\e]4;%s;%s\a' "$idx" "$color"
      ;;
  esac
done < "$_theme_file"

echo "Theme: $_theme"

unset _ghostty_themes_dir _ghostty_themes _theme _theme_file
