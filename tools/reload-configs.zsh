set -e -o pipefail

. "${CJ_DOTFILES}/settings.sh"

which termux-reload-settings > /dev/null && termux-reload-settings

if [[ -v DISPLAY ]]; then
  touch "${XDG_CONFIG_HOME}/xfce4/terminal/terminalrc"
  i3-msg reload
  pkill -USR1 polybar
  feh --no-fehbg --bg-tile "${CJ_WALLPAPER}"
fi
