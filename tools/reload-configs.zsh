setopt ERR_EXIT NO_UNSET PIPE_FAIL

. "${CJ_DOTFILES}/settings.sh"

which termux-reload-settings > /dev/null && termux-reload-settings

if [[ -v DISPLAY ]]; then
  i3-msg reload
  pkill -USR1 polybar
  feh --no-fehbg --bg-tile "${CJ_WALLPAPER}"
fi
