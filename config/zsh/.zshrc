# === PATH ===
__path-prepend() {
  [[ -z "$1" ]] && return
  [[ "$PATH" =~ "$1" ]] && return

  export PATH="$1:$PATH"
}

__path-prepend "${GOPATH}/bin"
__path-prepend "${CJ_DOTFILES}/bin"

# === X autostart ===
if [[ "${CJ_X_AUTOSTART}" == "yes" ]] && tty | command grep tty1 > /dev/null; then
  exec xinit -- vt1 :0 -allowMouseOpenFail -nolisten tcp -disableVidMode -ignoreABI -nosilk -novtswitch > /dev/null 2>&1
fi

# === Removing 256color suffix ===
export TERM=${TERM:s/-256color/}

# === Autoload ===
if [[ -o login ]]; then
  if [[ "${TERM}" = 'linux' ]]; then
    zsh "${CJ_DOTFILES}/tools/tty-colors.zsh"
    # In case we don't have root configs installed
    setfont '/usr/share/kbd/consolefonts/ter-c20n.psf.gz'
    clear
  fi

  if [[ -z "$SUDO_UID" ]]; then
    python3 "${CJ_DOTFILES}/tools/motd.py"
  fi
fi

# === Misc options ===
KEYTIMEOUT=1
WORDCHARS='-_'

setopt interactive_comments

export GPG_TTY=$(tty)

# === Aliases ===
alias :q='exit'
alias cal='cal -m'
alias curl='curl -sJL#'

alias cb='cargo build'
alias ch='cargo bench'
alias cr='cargo run'
alias ct='cargo test'

alias diff='diff --color=auto'

alias dmesg='sudo dmesg -H'

alias df='df -h -x devtmpfs'
alias du='du -h -c'

alias dops='docker ps --format="table {{.Names}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}"'

alias e='${=EDITOR}'
alias E='sudo -e'

alias exa='exa --all --binary --group-directories-first'
alias exa-all='exa'
alias exa-ignore='exa --git-ignore --git --ignore-glob ".git|__pycache__|.expo|.expo-shared|.mypy_cache"'

alias free='free -h'

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gi='git init'
alias gl='git log --graph'
alias gm='git merge'
alias gp='git push'
alias gr='git reset'
alias gs='git status -s'
alias gu='git pull'

alias gap='git add -p'
alias gbi='git bisect'
alias gca='git commit --amend --no-edit'
alias gcl='git clone'
alias gco='git checkout'
alias gds='gd --staged'
alias gdt='git difftool'
alias gra='git remote add'
alias grb='git rebase'
alias grg='git remote get-url'
alias grl='git remote show'
alias grm='git rm'
alias grs='git remote set-url'
alias gsa='git stash apply'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash save'
alias gst='git diff --stat --color | cat'

# Git prune command, clears and resets all in repo
alias gpr='git reset -- . && git checkout -- . && git clean -xfd'

alias grep="grep --color=auto --binary-files=without-match --exclude-dir={.bzr,.git,.hg,.svn}"

alias ixio="\curl -F 'f:1=<-' ix.io"

alias ls='ls -vAh --color=auto --group-directories-first --file-type --quoting-style=literal'
alias ll='ls -lo --time-style=iso'

alias m='make'
mk() { mkdir -p "$1"; cd "$1" }

alias nf='npm s'
alias ni='npm install --prefer-offline --save'
alias nid='npm install --prefer-offline --save-dev'
alias nig='npm install -g --prefer-offline'
alias nit='npm init -y'
alias nr='npm run'
alias ns='npm s'
alias nt='npm t -s'

alias rg='rg --hidden --ignore-vcs --require-git --glob "!.git"'
alias rsync!='\rsync --info=progress2 --archive --update --human-readable --partial --compress --compress-choice=zstd --compress-level=1 --verbose --acls --one-file-system --xattrs'
alias rsync='rsync! --dry-run'

alias tmux='tmux -2 -f "${XDG_CONFIG_HOME}/tmux/config"'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session'
alias tmw='tmux move-window'

alias t-meta='transmission-remote tv.m:2000'
alias t-add='t-meta --add'
alias t-active='t-meta -t active --list'
alias t-alt='t-meta --alt-speed'
alias t-no-alt='t-meta --no-alt-speed'
alias t-list='t-meta --list'
t-remove() { t-meta -t "$1" --remove }
t-magnet() { t-add "magnet:?xt=urn:btih:$1" "${@:2}" }

alias rf='rm -rf'

alias ping='ping -4AUO'
alias pg='openssl rand -base64 33'

alias ss='ss -raopuwtn'

alias sd='sudo systemctl'
alias sdu='systemctl --user'

alias sudo='sudo '
alias watch='watch '

alias cp='cp -i'
alias mv='mv -i'

alias xclip='xclip -selection clipboard'
alias vim='e'

# === Colors ===
man() {
  LESS_TERMCAP_mb=$'\E[31m' \
  LESS_TERMCAP_md=$'\E[34m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[1;33m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[36m' \
  command man "$@"
}

__pty() {
  zpty "pty-${UID}" "${1+$@}"
  if [[ ! -t 1 ]]; then
    setopt local_traps
    trap '' INT
  fi
  zpty -r "pty-${UID}"
  zpty -d "pty-${UID}"
}

p() {
  zmodload zsh/zpty
  __pty $@ | "${=PAGER}"
}

# === Functions ===
function countdown(){
  date1=$((`date +%s` + $1));
  while [ "$date1" -ge `date +%s` ]; do
    echo -ne "\r$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)"
    sleep 0.1
  done
}

function stopwatch(){
  date1=`date +%s`;
  while true; do
    echo -ne "\r$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)";
    sleep 0.1
  done
}

function notify(){
  if (( $+commands[termux-vibrate] )); then
    termux-vibrate -f -d 1500
    termux-notification -c "$2" -t "$1"
  elif (( $+commands[powershell.exe] )); then
    powershell.exe "New-BurntToastNotification -Text \"$1: $2\""
  elif (( $+commands[notify-send] )); then
    notify-send "$1" "$2"
  else
    echo "$1: $2"
  fi

  echo -e '\a'
}

function pomo(){
  countdown $(printf '%.0f' $(( $1 * 60 )))
  notify "Pomo" "${2:-Countdown finished}"
}

# === Completion ===
LISTMAX=1000

setopt glob_dots
setopt no_nomatch
setopt hist_verify
setopt complete_in_word
setopt always_to_end

ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/compdump"
zmodload -i zsh/complist
autoload -Uz compinit
compinit -C -i -d "${ZSH_COMPDUMP}"

__recompile() { [[ "${1}.zwc" -nt "${1}" ]] || zcompile "${1}" }
__recompile "${ZSH_COMPDUMP}"

zstyle ':completion:*' completer _complete _expand
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-dirs-first true

zstyle ':completion:*' rehash false
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:users' ignored-patterns adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp usbmux uucp vcsa wwwrun xfs cron mongodb nullmail portage redis shoutcast tcpdump '_*'

# === History ===
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=100000
SAVEHIST="${HISTSIZE}"

setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

if unsetopt | grep incappendhistorytime > /dev/null; then
  setopt inc_append_history_time
fi

# === Keybindings (preparations) ===
unsetopt flow_control

typeset -A key
key=(
  BackSpace    "${terminfo[kbs]}"
  Delete       "${terminfo[kdch1]}"

  ShiftTab     "${terminfo[kcbt]}"
  Tab          "${terminfo[ht]}"

  Home         "${terminfo[khome]}"
  End          "${terminfo[kend]}"

  PageUp       "${terminfo[kpp]}"
  PageDown     "${terminfo[knp]}"

  Left         "${terminfo[kcub1]}"
  Right        "${terminfo[kcuf1]}"

  ControlLeft  '^[[1;5D'
  ControlRight '^[[1;5C'
)

__map() {
  bindkey "${key[$1]}" "$2"
}

autoload -Uz edit-command-line
zle -N edit-command-line

__interactive-history() {
  LBUFFER="$(fc -ln 0 | fzf --tac --no-sort -q "${LBUFFER}")"
  zle redisplay
}
zle -N __interactive-history

__interactive-find-current() {
  local found=$(${=FZF_DEFAULT_COMMAND} | fzf)
  [[ -n "$found" ]] && LBUFFER="${LBUFFER}${found}"
}

__interactive-find-in-dir() {
  local init="${LBUFFER%% *}"
  local last="${LBUFFER##* }"
  local found=$(${=FZF_DEFAULT_COMMAND} . "$last" | fzf)
  [[ -n "$found" ]] && LBUFFER="${init} ${found}"
}

__interactive-find() {
  case "$LBUFFER" in
    */) __interactive-find-in-dir
        ;;
    *)  __interactive-find-current
        ;;
  esac

  zle redisplay
}
zle -N __interactive-find

__interactive-open() {
  local found=$(${=FZF_DEFAULT_COMMAND} | fzf)
  [[ -n "$found" ]] && LBUFFER="e ${found}"

  zle accept-line
}
zle -N __interactive-open

__exit() {
  exit
}
zle -N __exit

# === Keybindings (terminfo keys) ===
__map Delete       delete-char
__map ShiftTab     reverse-menu-complete

__map Home         beginning-of-line
__map End          end-of-line

__map PageUp       up-line-or-history
__map PageDown     down-line-or-history

__map ControlLeft  backward-word
__map ControlRight forward-word

# === Keybindings (C-L keys) ===
bindkey '^A' beginning-of-line
bindkey '^D' __exit
bindkey '^E' end-of-line
bindkey '^Q' push-line
bindkey '^K' kill-line
bindkey '^Y' yank

bindkey '^S' edit-command-line
bindkey '^R' __interactive-history
bindkey '^F' __interactive-find
bindkey '^O' __interactive-open

# === Unbindings ===
bindkey -r '^['

# === Prompt ===
setopt prompt_subst

typeset -A fg
fg=(
  red     $'\033[31m'
  green   $'\033[32m'
  yellow  $'\033[33m'
  blue    $'\033[34m'
  cyan    $'\033[35m'
  electro $'\033[36m'
)
reset_color=$'\033[0m'

__utf-mode() {
  [[ "${LANG}" =~ "UTF|utf" ]]
}

if __utf-mode; then
  PROMPT_SEPARATOR=' » '
  RPROMPT_SEPARATOR=' « '
else
  PROMPT_SEPARATOR=' > '
  RPROMPT_SEPARATOR=' < '
fi

__in-git-repo() {
  if ! df . -x fuse.sshfs > /dev/null 2>&1; then
    return 1
  fi

  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

__git-path() {
  if ! git diff-index --quiet HEAD -- > /dev/null 2>&1; then
    print -rn "%{$fg[red]%}"
  elif { git status --porcelain | command grep '^?? ' } > /dev/null 2>&1; then
    print -rn "%{$fg[yellow]%}"
  else
    print -rn "%{$fg[green]%}"
  fi

  local git_root="$(basename "$(git rev-parse --show-toplevel 2> /dev/null)")"
  local git_prefix="$(git rev-parse --show-prefix 2> /dev/null)"
  local git_path="$(print -rn "$git_root/$git_prefix" | sed 's/.$//g')"
  print -rn "$git_path"

  local git_branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  case "$git_branch" in
    master) ;;
    HEAD) print -rn " %{$fg[red]%}(detached)" ;;
    *)    print -rn " %{$fg[electro]%}($git_branch)" ;;
  esac

  print -rn "${PROMPT_SEPARATOR}"
}

__prompt() {
  if __in-git-repo; then
    __git-path
  else
    case "${PWD}" in
      ${HOME}*) print -rn "%{$fg[blue]%}%~" ;;
      *) print -rn "%{$fg[red]%}%/" ;;
    esac
    print -rn "${PROMPT_SEPARATOR}"
  fi
}

PROMPT=' '
PROMPT+='$(__prompt)'
PROMPT+="%(1j.%{$fg[yellow]%}%j${PROMPT_SEPARATOR}.)"
PROMPT+="%(0?..%{$fg[red]%}%?${PROMPT_SEPARATOR})"
PROMPT+="%(!.%{$fg[yellow]%}!${PROMPT_SEPARATOR}.)"
PROMPT+="%{$reset_color%}"

PROMPT2="%{$fg[yellow]%}...${PROMPT_SEPARATOR}"

RPROMPT=''

if [[ "_${PREFIX}" =~ "/data/data/com.termux" ]]; then
  RPROMPT+="%{$fg[blue]%}${RPROMPT_SEPARATOR}termux"
else
  RPROMPT+="%{$fg[blue]%}${RPROMPT_SEPARATOR}%n"
  RPROMPT+="%{$fg[electro]%}${RPROMPT_SEPARATOR}%m"
fi

if [[ -n "$SSH_CONNECTION" ]]; then
  RPROMPT+="%{$fg[red]%}${RPROMPT_SEPARATOR}SSH"
fi

RPROMPT+="%{$reset_color%}"

# === Command time report ===
zmodload zsh/datetime

__ctr-show() {
  local text="$(printf "${RPROMPT_SEPARATOR}%.2f${PROMPT_SEPARATOR}" "${CTR_TOTAL_TIME}")"
  local tlen="$(wc -m <<< "$text")"
  local llen="$(( (${COLUMNS} - $tlen) / 2 ))"
  local lind="$(printf ' %.0s' {1..$llen})"

  print "$lind\e[36m$text\a\e[0m"
}

__ctr-update-start() {
  CTR_START_TIME=${EPOCHREALTIME}
}

__ctr-update-total() {
  [[ -z ${CTR_START_TIME} ]] && return 0
  [[ ${CTR_START_TIME} == NONE ]] && return 0
  CTR_TOTAL_TIME=$(( ${EPOCHREALTIME} - ${CTR_START_TIME} ))
  CTR_START_TIME=NONE

  (( ${CTR_TOTAL_TIME} >= 1 )) || return 0

  __ctr-show
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd  __ctr-update-total

# === Third-party additions ===
source "${CJ_DOTFILES}/third-party/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0,bold'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=300
ZSH_AUTOSUGGEST_MANUAL_REBIND=y

source "${CJ_DOTFILES}/third-party/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source "${CJ_DOTFILES}/third-party/zsh/alias-tips/alias-tips.plugin.zsh"
ZSH_PLUGINS_ALIAS_TIPS_TEXT=$'\E[31mAlias tip: '

add-zsh-hook preexec __ctr-update-start

# === Version managers ===
__load-rustup() {
  __path-prepend "${CARGO_HOME}/bin"
}
__load-rustup

# === Dynamic aliases / alias-like functions ===
if (( $+commands[exa] )); then
  alias l='exa-ignore --long'
  alias la='exa-all --long'
  alias s='exa-ignore -1'
  alias sa='exa-all -1'
else
  alias l='ll'
  alias la='ll -a'
  alias s='ll -1'
  alias sa='ll -a1'
fi

node() { if [[ -z ${1} ]]; then command node "${CJ_DOTFILES}/bin/node-repl"; else command node "$@"; fi }

if (( $+commands[exa] )); then
  alias tree='exa-ignore --tree'
  alias tree-all='exa-all --tree'
  alias t='tree'
fi

# === Void linux ===
if (( $+commands[xbps-install] )); then
  alias f='xbps-query -Rs'
  alias i='sudo xbps-install'
  alias u='sudo xbps-install -Su'
  alias r='sudo xbps-remove -R'

  alias o='xdg-open'

  command_not_found_handler() {
    print "$fg[red]zsh: command not found: $fg[blue]'$1'$reset_color" 1>&2

    if ! [[ -d "${XLOCATE_GIT}" ]] && (( $+commands[xlocate] )); then
      print "$fg[red]To get command-not-found feature install xtools and sync xbps database (xlocate -S)$reset_color" 1>&2
      return 127
    fi

    local pkgs=$(xlocate "$1" | command grep --color=never -P "/bin/$1\$")
    [[ -z "$pkgs" ]] && return 127

    print "$fg[blue]$1 $fg[green]may be found in the following packages:$reset_color" 1>&2
    awk '{print $1}' <<< "$pkgs" 1>&2

    return 127
  }
fi

# === Arch linux ===
if (( $+commands[pacman] )); then
  alias f='pacman -Ss'
  alias i='sudo pacman -S'
  alias u='sudo pacman -Syyuu'
  alias r='sudo pacman -Rs'

  alias o='xdg-open'

  . '/usr/share/doc/pkgfile/command-not-found.zsh'
fi

# === Termux ===
if (( $+commands[pkg] )) && [[ "_$PREFIX" =~ "_/data/data" ]]; then
  alias f='pkg search'
  alias i='pkg install'
  alias u='pkg upgrade'
  alias r='pkg uninstall'

  alias o='termux-open'

  command_not_found_handler() {
    $PREFIX/libexec/termux/command-not-found "$1"
  }
fi

# === Ubuntu ===
if (( $+commands[apt-get] )) && ! [[ "_$PREFIX" =~ "_/data/data" ]]; then
  alias f='apt-cache search'
  alias i='sudo apt-get install'
  alias u='sudo apt-get update && sudo apt-get upgrade'
  alias r='sudo apt-get remove'

  alias o='xdg-open'

  . '/etc/zsh_command_not_found'
fi
