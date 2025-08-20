# Aliases: editor
alias e="$EDITOR"
alias E="sudo -e"

# Aliases: ls
alias l='eza -1A --group-directories-first --color=always --git-ignore'
alias ls='l'
alias la='l -l --time-style="+%Y-%m-%d %H:%M" --no-permissions --octal-permissions'
alias tree='l --tree'

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

gcm() { git commit --message "$*" }

# Aliases: docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dl='docker logs --tail=100'
alias dc='docker compose'

# Aliases: tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

# Aliases: rg
alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim --colors=line:fg:black --colors=line:style:bold --colors=path:fg:magenta --colors=match:style:nobold"

# Aliases: pass
alias pa='pass'
alias pac='pass -c'
alias po='pass otp'
alias poc='pass otp -c'
alias pg='openssl rand -base64 33'

# Aliases: systemd
alias sd='sudo systemctl'
alias sdu='systemctl --user'
alias jd='journalctl --no-pager'

# Aliases: human-readable
alias cal='TZ=Asia/Bangkok cal --monday'
alias du='du --human-readable'
alias free='free --human'

# Aliases: safety
alias cp='cp --interactive'
alias mv='mv --interactive'

# Aliases: misc
mk() {
  mkdir --parents "$1" && cd "$1"
}
alias rf='rm -rf'
alias py='python3'
alias ipy='ipython'
alias ping='ping -A'

alias -g p='2>&1 | less'
alias sudo='sudo '  # allow aliases with sudo

# Aliases: package managers
if [[ -n "$TERMUX_VERSION" ]]; then
  alias pi='pkg install'
  alias pf='pkg search'
  alias pr='pkg uninstall'
else
  alias pi='sudo pacman -S --needed'
  alias pf='pacman -Ss'
  alias pr='sudo pacman -Rs'
fi

# Recommended kind of update with reduced keyring-related problems
alias pu='sudo pacman -Sy --needed archlinux-keyring && sudo pacman -Su'

# Aliases: ledger
alias lg='ledger'
alias lga='ledger accounts'
alias lgb='ledger balance'
alias lgr='ledger register'

# Aliases: when
alias wi='TZ=Asia/Bangkok when ci --future=30'

# Aliases: editors
alias ew='when eci'
alias en='e ~/notes/'
alias el='e ~/.ledger/journal.ldg'

# Aliases: git
alias git-notes='git -C ~/notes'
alias git-when='git -C ~/.when'
alias git-ledger='git -C ~/.ledger'

alias sync-commit-notes='git-notes add --all; git-notes commit --message sync; git-notes pull; git-notes push'

alias cj-pull='pass git pull; git-notes pull; git-when pull; git-ledger pull'
alias cj-status='pass git status; git-notes status; git-when status; git-ledger status'

# Man colors
man() {
  GROFF_NO_SGR=1 \
  LESS_TERMCAP_mb=$'\e[31m' \
  LESS_TERMCAP_md=$'\e[34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[35m' \
  command man "$@"
}

# Prompt
PROMPT=$'%{\033[34m%} %2~ %{\033[0m%}'
PROMPT2=$'%{\033[33m%} ... %{\033[0m%}'
RPROMPT=$'%(0?..%(130?..%{\033[31m%}%?%{\033[0m%}))'

# ZLE
KEYTIMEOUT=1  # 10ms for grouping escape sequences
WORDCHARS='-_:'

setopt interactive_comments

# Jobs
setopt auto_continue  # continue jobs on disown
setopt check_jobs  # do not exit shell with jobs
setopt check_running_jobs

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST="$HISTSIZE"

setopt extended_history
setopt inc_append_history
setopt inc_append_history_time
setopt share_history
setopt hist_fcntl_lock

setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store  # ignore fc command

HISTORY_IGNORE='(rm *|rf *)'

# History: interactive search
__history() {
  LBUFFER="$(fc -ln 0 | fzf --query="${LBUFFER}")"
  zle redisplay
}

zle -N __history

# Completion
LISTMAX=10000  # do not show warning if there is too much items in completion

setopt glob_dots  # include dotfiles into completion by default
setopt hash_cmds  # hash command locations
setopt list_packed

autoload -Uz compinit
compinit -C  # -C disables security checks on dump file

# _complete is base completer
# _approximate will fix completion if there is no matches
# _extensions will complete glob patters with extensions
zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*' menu select  # menu with selection
zstyle ':completion:*' increment yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' squeeze-slashes yes  # replace // with /

zstyle ':completion:*' file-sort modification  # show recently used files first
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colored files and directories, blue selection box
zstyle ':completion:*' ignored-patterns '.git'

zstyle ':completion:*' rehash false  # improves performance
zstyle ':completion:*' use-cache true


# Keyboard
unsetopt flow_control  # disable ^S / ^Q

bindkey -e  # Zsh default keybindings are vim, because EDITOR is set to vim, use emacs ones

bindkey '^I' complete-word  # Tab, complete instead of expand-and-complete
bindkey '^[[3~' delete-char  # Delete
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab
bindkey '^[[1;5D' backward-word  # Control-Left
bindkey '^[[1;5C' forward-word  # Control-Right

bindkey '^R' __history

# Line editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^S' edit-command-line

# Super Ctrl-Z
fg-ctrl-z () {
  fg 2> /dev/null
}
zle -N fg-ctrl-z
bindkey '^Z' fg-ctrl-z

# Plugin: zoxide
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --no-tac --select-1 --exit-0"
eval "$(zoxide init zsh --no-cmd)"
alias z='__zoxide_zi'
alias ~='cd ~'
ze() {
  DIR=$(zoxide query -i "$@")
  [ -n "$DIR" ] && cd "$DIR" && e .
}

# Plugin: autosuggestions
if [[ -n "$TERMUX_VERSION" ]]; then
  source ~/third-party/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#606090'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

# Plugin: syntax highlighting
if [[ -n "$TERMUX_VERSION" ]]; then
  source ~/third-party/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=120

# Rainbow brackets in special order, easier for eyes
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-6]='fg=red'

# Custom styles
# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,underline'

# Keywords
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'

# Commands
ZSH_HIGHLIGHT_STYLES[precommand]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta'

# Strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'

# Redirections
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='none'
