# === Misc options ===
KEYTIMEOUT=1
WORDCHARS='-'

setopt interactive_comments

# === Aliases ===
alias cal='cal -m'

alias diff='diff --color=auto'

alias dmesg='sudo dmesg -H'

alias df='df -h -x devtmpfs'
alias du='du -h -d 1 -c'

alias e='${=EDITOR}'
alias E='sudo ${=EDITOR}'

alias free='free -h'

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gi='git init'
alias gl='git log --graph'
alias gp='git push'
alias gs='git status -s'
alias gu='git pull'

alias gbi='git bisect'
alias gcl='git clone'
alias gco='git checkout'

alias grep="grep --color=auto --binary-files=without-match --exclude-dir={.bzr,.git,.hg,.svn}"

alias ls='ls -Ah --color=auto --group-directories-first --file-type --quoting-style=literal'
alias l='ls -lo --time-style=iso'

alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/config"'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session'
alias tmw='tmux move-window'

alias rf='rm -rf'

alias ping='ping -AUO'

alias ss='ss -raopuwtn'

alias sudo='sudo '
alias watch='watch '

alias cp='cp -i'
alias mv='mv -i'

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

# === Functions ===

# === Completion ===
LISTMAX=1000
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/compdump"

setopt glob_dots
setopt hist_verify
setopt complete_in_word
setopt always_to_end

zmodload -i zsh/complist
autoload -U compinit
compinit -C -i -d "${ZSH_COMPDUMP}"

zstyle ':completion:*' completer _complete _expand
zstyle ':completion:*' menu yes select
zstyle ':completion:*' verbose true
zstyle ':completion:*' list-dirs-first true

zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:processes' command "ps -u '${USER}' -o pid,user,args -w -w"
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:users' ignored-patterns \
  adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
  clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
  gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
  ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
  operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
  usbmux uucp vcsa wwwrun xfs cron mongodb nullmail portage redis \
  shoutcast tcpdump '_*'

# === History ===
HISTSIZE=100000
SAVEHIST=100000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# === Keybindings ===
unsetopt flow_control
bindkey -e

bindkey '^[[Z' reverse-menu-complete

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


bindkey -M menuselect '^^' accept-and-menu-complete

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^S' edit-command-line

__fzf-sized() {
  fzf --height="$(( ${LINES} * 2 / 3 ))" "$@"
}

__fzf-history() {
  LBUFFER="$(fc -ln 0 | __fzf-sized --tac --no-sort -q "${LBUFFER}")"
  zle redisplay
}
zle -N __fzf-history
bindkey '^R' __fzf-history

__fzf-open() {
  ${=FZF_DEFAULT_COMMAND} | __fzf-sized --multi | xargs -r "${=EDITOR}"
  zle redisplay
}
zle -N __fzf-open
bindkey '^O' __fzf-open

__fzf-go() {
  local dir="$( ${=FZF_DEFAULT_COMMAND//-t f -t l -S-10M/-t d} | __fzf-sized )"
  [[ "$dir" = '' ]] || cd "$dir"
  zle reset-prompt
}
zle -N __fzf-go
bindkey '^G' __fzf-go

__sudo-buffer-or-last() {
  if [[ "${LBUFFER}" = '' ]]; then
    LBUFFER="sudo $history[$((${HISTCMD} - 1))]"
  else
    LBUFFER="sudo ${LBUFFER}"
  fi
}
zle -N __sudo-buffer-or-last
bindkey '^[^[' __sudo-buffer-or-last

# === Prompt ===
setopt prompt_subst

autoload -U colors
colors

if uname -m | grep i686 > /dev/null; then
  PROMPT_SEPARATOR=' > '
  RPROMPT_SEPARATOR=' < '
else
  PROMPT_SEPARATOR=' » '
  RPROMPT_SEPARATOR=' « '
fi

__in-git-repo() {
  [[ -e .git ]] || git rev-parse --git-dir > /dev/null 2>&1
}

__git-path() {
  if ! git diff-index --quiet HEAD -- > /dev/null 2>&1; then
    print -rn "%{$fg[magenta]%}"
  elif { git status --porcelain | grep '^?? ' } > /dev/null 2>&1; then
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
    *)    print -rn " %{$fg[cyan]%}($git_branch)" ;;
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
      /home/*) print -rn "%{$fg[blue]%}%~" ;;
      *) print -rn "%{$fg[magenta]%}%/" ;;
    esac
    print -rn "${PROMPT_SEPARATOR}"
  fi

  local job_count="$(jobs -l | wc -l)"
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
  local orig_prompt="$(prompt)"
  print -rn "%{$fg[yellow]%}"
  print -Pn "$(print -rn "$orig_prompt" | sed 's/%{[^%]*%}//g')" \
    | sed 's/./\./g' \
    | sed 's/....$/\./'

  print -rn "${PROMPT_SEPARATOR}%{$reset_color%}"
}

PROMPT2='$(__prompt2)'

RPROMPT="%{$fg[blue]%}${RPROMPT_SEPARATOR}%n%{$fg[cyan]%}${RPROMPT_SEPARATOR}%m%{$reset_color%}"

# === Command time report ===
zmodload zsh/datetime

__ctr-show() {
  local text=$(printf "${RPROMPT_SEPARATOR}%.2f${PROMPT_SEPARATOR}" "${CTR_TOTAL_TIME}")
  local tlen=$(wc -m <<< "$text")
  local llen=$(( (${COLUMNS} - $tlen) / 2 ))
  local lind=$(printf ' %.0s' {1..$llen})

  print "$lind\e[36m$text\e[0m"
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
source "${DOTFILES_DIR}/third-party/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0,bold'

source "${DOTFILES_DIR}/third-party/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

source "${DOTFILES_DIR}/third-party/zsh/alias-tips/alias-tips.plugin.zsh"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT=$'\E[31mAlias tip: '

# === Void linux ===
if (( $+commands[xbps-install] )); then
  f() {
    xbps-query -Rs "$@"
  }

  i() {
    sudo xbps-install "$@"
  }

  u() {
    sudo xbps-install -Su
    # TODO: update rustup
  }

  command_not_found_handler() {
    print "\033[31mzsh: command not found: \033[34m'$1'\033[0m" 1>&2

    if ! [[ -d "${XLOCATE_GIT}" ]] && (( $+commands[xlocate] )); then
      print "\033[31mTo get command-not-found feature install xtools and sync xbps database (xlocate -S)\033[0m" 1>&2
      return 127
    fi

    local pkgs=$(xlocate "$1" | grep --color=never -P "/bin/$1\$")
    [[ -z "$pkgs" ]] && return 127

    print "\033[34m$1 \033[32mmay be found in the following packages:\033[0m" 1>&2
    awk '{print $1}' <<< "$pkgs" 1>&2

    return 127
  }
fi

# === Arch linux ===
# TODO

# === Windows (cygwin) ===
# TODO
