# === PATH ===
__path-prepend() {
  [[ -z "$1" ]] && return
  [[ "$PATH" =~ "$1" ]] && return

  export PATH="$1:$PATH"
}

__path-prepend "${CJ_DOTFILES}/bin"

# === X autostart ===
if [[ "${CJ_X_AUTOSTART}" == "yes" ]] && tty | command grep tty1 > /dev/null; then
  exec xinit -- vt1 :0 -allowMouseOpenFail -nolisten tcp -disableVidMode -ignoreABI -nosilk -novtswitch
fi

# === Removing 256color suffix ===
export TERM=${TERM:s/-256color/}

# === Autoload ===
if [[ -o login ]]; then
  if [[ "${TERM}" = 'linux' ]]; then
    zsh "${CJ_DOTFILES}/tools/tty-colors.zsh"
    setfont '/usr/share/kbd/consolefonts/ter-i20n.psf.gz'
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

# === Aliases ===
alias ag='ag --hidden --ignore-dir .git'

alias cal='cal -m'
alias curl='curl -JOL#'

alias diff='diff --color=auto'

alias dmesg='sudo dmesg -H'

alias df='df -h -x devtmpfs'
alias du='du -h -d 1 -c'

alias e='${=EDITOR}'
E() { sudo zsh -lc "${EDITOR} $@" }

alias exa='exa --all --binary --group-directories-first'
alias exa-all='exa'
alias exa-ignore='exa --git-ignore --git --ignore-glob .git'

alias free='free -h'

alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --stat'
alias gdt='git difftool'
alias gi='git init'
alias gl='git log --graph'
alias gp='git push'
alias gr='git rebase'
alias gs='git status -s'
alias gu='git pull'

alias gbi='git bisect'
alias gca='git commit --amend --no-edit'
alias gcl='git clone'
alias gco='git checkout'
alias gss='git stash save'
alias gsp='git stash pop'

alias grep="grep --color=auto --binary-files=without-match --exclude-dir={.bzr,.git,.hg,.svn}"

alias ixio="\curl -F 'f:1=<-' ix.io"

alias ls='ls -vAh --color=auto --group-directories-first --file-type --quoting-style=literal'
alias ll='ls -lo --time-style=iso'

if (( $+commands[exa] )); then
  alias l='exa-ignore --long'
  alias la='exa-all --long'
  alias s='exa-all -1'
else
  alias l='ll'
  alias la='ll -a'
  alias s='ll -1'
fi

alias ni='npm install --prefer-offline --save'
alias nid='npm install --prefer-offline --save-dev'
alias nig='npm install -g --prefer-offline'
alias nit='npm init -y'
alias ns='npm s'
alias nf='npm s'
alias nt='npm t -s'

node() { if [[ -z ${1} ]]; then command node "${CJ_DOTFILES}/bin/node-repl"; else command node "$@"; fi }

alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/config"'
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

if (( $+commands[exa] )); then
  alias tree='exa-ignore --tree'
  alias tree-all='exa-all --tree'
fi

alias rf='rm -rf'

alias ping='ping -AUO'

alias ss='ss -raopuwtn'

alias sudo='sudo '
alias watch='watch '

alias cp='cp -i'
alias mv='mv -i'

alias xclip='xclip -selection clipboard'

# === Colors ===
man() {
  LESS_TERMCAP_mb=$'\E[31m' \
  LESS_TERMCAP_md=$'\E[34m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[1;30m' \
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

pp() {
  __pty $@ | "${=PAGER}"
}

# === Completion ===
LISTMAX=1000

setopt glob_dots
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
zstyle ':completion:*' menu yes select
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-dirs-first true

zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:users' ignored-patterns adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp usbmux uucp vcsa wwwrun xfs cron mongodb nullmail portage redis shoutcast tcpdump '_*'

# === History ===
HISTSIZE=100000
SAVEHIST=100000

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history
setopt inc_append_history

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

__fzf-history() {
  LBUFFER="$(fc -ln 0 | fzf --tac --no-sort -q "${LBUFFER}")"
  zle redisplay
}
zle -N __fzf-history

__fzf-find-current() {
  local found=$(${=FZF_DEFAULT_COMMAND} | fzf)
  [[ -n "$found" ]] && LBUFFER="${LBUFFER}${found}"
}

__fzf-find-in-dir() {
  local init="${LBUFFER%% *}"
  local last="${LBUFFER##* }"
  local found=$(${=FZF_DEFAULT_COMMAND} . "$last" | fzf)
  [[ -n "$found" ]] && LBUFFER="${init} ${found}"
}

__fzf-find() {
  case "$LBUFFER" in
    */) __fzf-find-in-dir
        ;;
    *)  __fzf-find-current
        ;;
  esac

  zle redisplay
}
zle -N __fzf-find

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
bindkey '^E' end-of-line
bindkey '^Q' push-line
bindkey '^K' kill-line
bindkey '^Y' yank

bindkey '^S' edit-command-line
bindkey '^R' __fzf-history
bindkey '^F' __fzf-find

# === Prompt ===
setopt prompt_subst

typeset -A fg
fg=(
  red     $'\033[31m'
  green   $'\033[32m'
  yellow  $'\033[33m'
  blue    $'\033[34m'
  orange  $'\033[35m'
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
  [[ -e .git ]] || git rev-parse --git-dir > /dev/null 2>&1
}

__git-path() {
  if ! git diff-index --quiet HEAD -- > /dev/null 2>&1; then
    print -rn "%{$fg[orange]%}"
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
    HEAD) print -rn " %{$fg[red]%}($git_branch)" ;;
    *)    print -rn " %{$fg[electro]%}($git_branch)" ;;
  esac

  print -rn "${PROMPT_SEPARATOR}"
}

__prompt() {
  local exit_code="$?"

  print -rn ' '
  if __in-git-repo; then
    __git-path
  else
    case "${PWD}" in
      ${HOME}*) print -rn "%{$fg[blue]%}%~" ;;
      *) print -rn "%{$fg[orange]%}%/" ;;
    esac
    print -rn "${PROMPT_SEPARATOR}"
  fi

  local job_count=$(jobs -l | wc -l | awk '{$1=$1};1')
  if [[ "$job_count" != 0 ]]; then
    print -rn "%{$fg[yellow]%}{$job_count}"
    print -rn "${PROMPT_SEPARATOR}"
  fi

  if   [[ "$exit_code" != 0 ]]; then
    print -rn "%{$fg[red]%}$exit_code"
    print -rn "${PROMPT_SEPARATOR}"
  elif [[ "${UID}" == 0 ]]; then
    print -rn "%{$fg[yellow]%}!"
    print -rn "${PROMPT_SEPARATOR}"
  fi

  print -rn "%{$reset_color%}"
}

PROMPT='$(__prompt)'

__prompt2() {
  local orig_prompt="$(__prompt)"
  print -rn "%{$fg[yellow]%}"
  print -Pn "$(print -rn "$orig_prompt" | sed 's/%{[^%]*%}//g')" \
    | sed 's/./\./g' \
    | sed 's/....$/\./'

  print -rn "${PROMPT_SEPARATOR}%{$reset_color%}"
}

PROMPT2='$(__prompt2)'

__user-host() {
  local colors=(red yellow orange green blue electro)
  local ids=( $(shuf -i 1-6 -n 3) )

  local user_color=$colors[$ids[1]]
  local host_color=$colors[$ids[2]]
  local remote_color=$colors[$ids[3]]

  print -rn "%{$fg[$user_color]%}${RPROMPT_SEPARATOR}$1"
  print -rn "%{$fg[$host_color]%}${RPROMPT_SEPARATOR}$2"

  if [[ -n "$SSH_CONNECTION" ]]; then
    print -rn "%{$fg[$remote_color]%}${RPROMPT_SEPARATOR}via SSH"
  fi

  print -rn "%{$reset_color%}"
}

__rprompt() {
  if [[ "_${PREFIX}" =~ "/data/data/com.termux" ]]; then
    __user-host 'termux' 'android'
  else
    __user-host '%n' '%m'
  fi
}

RPROMPT="$(__rprompt)"

# === Command time report ===
zmodload zsh/datetime

__ctr-show() {
  local text=$(printf "${RPROMPT_SEPARATOR}%.2f${PROMPT_SEPARATOR}" "${CTR_TOTAL_TIME}")
  local tlen=$(wc -m <<< "$text")
  local llen=$(( (${COLUMNS} - $tlen) / 2 ))
  local lind=$(printf ' %.0s' {1..$llen})

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
add-zsh-hook preexec __ctr-update-start
add-zsh-hook precmd  __ctr-update-total

# === Third-party additions ===
source "${CJ_DOTFILES}/third-party/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_USE_ASYNC='y'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0,bold'

source "${CJ_DOTFILES}/third-party/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

source "${CJ_DOTFILES}/third-party/zsh/alias-tips/alias-tips.plugin.zsh"
ZSH_PLUGINS_ALIAS_TIPS_TEXT=$'\E[31mAlias tip: '

# === Version managers ===
__load-nvm() {
  source "${NVM_DIR}/nvm.sh" --no-use
  local lastnode="$(find "${NVM_DIR}/versions/node/" -maxdepth 1 2> /dev/null | tail -1)"
  __path-prepend "$lastnode/bin"
}
__load-nvm

__load-rustup() {
  __path-prepend "${CARGO_HOME}/bin"
}
__load-rustup

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
