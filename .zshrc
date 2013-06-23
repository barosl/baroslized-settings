#!/usr/bin/env zsh

autoload -U compinit && compinit
zstyle -e ':completion:*' completer '
	local -a default_reply
	default_reply=(_expand _complete _approximate)

	local cur_try="$HISTNO:$CURSOR:$BUFFER"
	if [[ "$_comp_last_try" != "$cur_try" ]]; then
		_comp_last_try="$cur_try"

		reply=($default_reply)
	else
		reply=($default_reply)
	fi
'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format '%B%F{yellow}-- %d --%f%b'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*:messages' format '%F{cyan}%d%f'
zstyle ':completion:*:default' menu yes=long select=1
eval $(dircolors -b)
zstyle ':completion:*' list-colors ${(s@:@)LS_COLORS}
zstyle ':completion:*' list-prompt '%SListing at %p (%l)%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt '%SSeleting at %p (%m)%s'
zstyle ':completion:*' verbose true
zstyle -e ':completion:*:approximate:*' max-errors '
	local default_max_errors=2

	local max_errors=$(( ($#PREFIX+$#SUFFIX)/3 ))

	if (( $max_errors < $default_max_errors )) max_errors=$default_max_errors
	reply=($max_errors numeric)
'

zstyle ':completion:*:*:*:*:processes' command 'ps -u $EUID -o pid,user,args -ww'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle -e ':completion:*' file-sort '
	if [[ $PWD/$PREFIX == */down/* ]]; then
		reply=(time)
	fi
'

exit_status() {
	local err=$?
	[[ $err -ne 0 ]] && echo "%B%F{166} ✘ $err %f%b"
}

precmd() {
	if [[ $? -eq 0 ]]; then
		prompt_fmt1=''
		prompt_fmt2=';49'
	else
		prompt_fmt1='%{[38;5;236;22m%}%{[38;5;247;48;5;236m%}'
		prompt_fmt2=';48;5;236'
	fi

	if [[ "$USER" == "$DEFAULT_USER" ]]; then prompt_fmt3=''
	elif (( $EUID == 0 )); then prompt_fmt3='%F{166}%n@%f';
	else prompt_fmt3='%n@'; fi
}

autoload -U vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' %{[1m%}%b%{[22m%}' '%s'

vcs_prompt() {
	vcs_info

	if [[ -n $vcs_info_msg_0_ ]]; then
		if [[ $vcs_info_msg_1_ == 'git' && -n $(git status -s) ]]; then
			local color_fg=94
			local color_bg=214
		else
			local color_fg=22
			local color_bg=148
		fi

		echo "%{[38;5;31;48;5;$color_bg;22m%} %F{$color_fg}$vcs_info_msg_0_%f %{[38;5;$color_bg;49;22m%}"
	else
		echo '%{[38;5;31;49;22m%}'
	fi
}

PROMPT='%{[38;5;252;48;5;240m%} $prompt_fmt3%{[38;5;106;48;5;240;1m%}%m %{[38;5;240;48;5;31;22m%} %{[38;5;231;48;5;31;1m%}%~ $(vcs_prompt)%{[m%} '
RPROMPT='$prompt_fmt1$(exit_status)%{[38;5;254${prompt_fmt2};22m%}%{[38;5;16;48;5;254m%} ⌚ %D{%H:%M:%S} %{[m%}'

HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE

setopt CORRECT
setopt HIST_IGNORE_ALL_DUPS EXTENDED_HISTORY APPEND_HISTORY HIST_IGNORE_SPACE
setopt AUTO_CD AUTO_PUSHD PUSHD_MINUS PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CLOBBER
setopt INTERACTIVE_COMMENTS
setopt BG_NICE NOTIFY
setopt GLOB_DOTS EXTENDED_GLOB AUTO_NAME_DIRS
setopt AUTO_PARAM_KEYS
unsetopt AUTO_REMOVE_SLASH
setopt PROMPT_SUBST
unsetopt LIST_AMBIGUOUS
unsetopt HUP
setopt CASE_GLOB
unsetopt CASE_MATCH
unsetopt RM_STAR_SILENT
setopt NOMATCH

alias -- -='cd -1'
alias _='sudo'

alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias d='dirs -v | head -10'

alias j='jobs -l'
alias history='history -d 1'
alias hs='builtin history -d -2000'

autoload -U zmv
alias zmv='noglob zmv -Wn'
alias zcp='noglob zmv -Wn -C'
alias zln='noglob zmv -Wn -Ls'

if [[ -x /usr/lib/command-not-found ]]; then
	command_not_found_handler() {
		/usr/lib/command-not-found --no-failure-msg -- $1
	}
fi

WORDCHARS="${WORDCHARS//[\/<>]/}"

KEYTIMEOUT=1

typeset -A keys
keys=(
	Up "$terminfo[kcuu1]"
	Down "$terminfo[kcud1]"
	Left "$terminfo[kcub1]"
	Right "$terminfo[kcuf1]"
	Home "$terminfo[khome]"
	End "$terminfo[kend]"
	Insert "$terminfo[kich1]"
	Delete "$terminfo[kdch1]"
	PageUp "$terminfo[kpp]"
	PageDown "$terminfo[knp]"
	Enter "$terminfo[kent]"
	Backspace "$terminfo[kbs]"
	Tab "$terminfo[ht]"
	Escape '^['

	# Modifier keys
	C-Up "$terminfo[kUP5]"
	C-Down "$terminfo[kDN5]"
	C-Left "$terminfo[kLFT5]"
	C-Right "$terminfo[kRIT5]"
	C-Delete "$terminfo[kDC5]" # does not work on PuTTY
	M-Up '^[[1;3A'
	M-Down '^[[1;3B'
	M-Left '^[[1;3D'
	M-Right '^[[1;3C'
	M-Delete "$terminfo[kDC3]"
	M-Enter '^[^J'
	M-Backspace "^[$terminfo[kbs]"
	S-Up "$terminfo[kUP]"
	S-Down "$terminfo[kDN]"
	S-Left "$terminfo[kLFT]"
	S-Right "$terminfo[kRIT]"
	S-Tab '^[[Z'
)

APP_KEY_MODE=0

if (( !${+terminfo[rmkx]} )); then
	APP_KEY_MODE=0
fi

# Use raw mode key sequences rather than application mode key sequences
if (( !$APP_KEY_MODE )); then
	keys[Up]='^[[A'
	keys[Down]='^[[B'
	keys[Left]='^[[D'
	keys[Right]='^[[C'
	keys[Enter]='^M'
fi

# Alternative control sequences used by PuTTY
keys[Home2]='^[[1~'
keys[End2]='^[[4~'
keys[M-Delete2]='^[^[[3~'
keys[M-Enter2]='^[^M'

if (( !$APP_KEY_MODE )); then
	keys[C-Up2]='^[OA'
	keys[C-Down2]='^[OB'
	keys[C-Left2]='^[OD'
	keys[C-Right2]='^[OC'
	keys[M-Up2]='^[^[[A'
	keys[M-Down2]='^[^[[B'
	keys[M-Left2]='^[^[[D'
	keys[M-Right2]='^[^[[C'
else
	keys[C-Up2]='^[[A'
	keys[C-Down2]='^[[B'
	keys[C-Left2]='^[[D'
	keys[C-Right2]='^[[C'
	keys[M-Up2]='^[^[OA'
	keys[M-Down2]='^[^[OB'
	keys[M-Left2]='^[^[OD'
	keys[M-Right2]='^[^[OC'
fi

# Manual configuration for tmux and screen, which have some missing terminfo entries
if [[ -z "$keys[C-Up]" ]]; then
	keys[C-Up]='^[[1;5A'
	keys[C-Down]='^[[1;5B'
	keys[C-Left]='^[[1;5D'
	keys[C-Right]='^[[1;5C'
	keys[M-Delete]='^[[3;3~'
	keys[S-Up]='^[[1;2A'
	keys[S-Down]='^[[1;2B'
	keys[S-Left]='^[[1;2D'
	keys[S-Right]='^[[1;2C'

	if (( $APP_KEY_MODE )); then
		keys[Enter]='^[OM'
	fi
fi

bindkey -e

bindkey "$keys[Home]" beginning-of-line
bindkey "$keys[End]" end-of-line
bindkey "$keys[Insert]" overwrite-mode
bindkey "$keys[Delete]" delete-char
bindkey "$keys[Up]" up-line-or-history
bindkey "$keys[Down]" down-line-or-history
bindkey "$keys[Left]" backward-char
bindkey "$keys[Right]" forward-char
bindkey "$keys[C-Left]" backward-word
bindkey "$keys[C-Right]" forward-word
bindkey "$keys[M-Enter]" self-insert-unmeta
bindkey "$keys[Backspace]" backward-delete-char
bindkey "$keys[M-Backspace]" backward-kill-word
bindkey "$keys[M-Delete]" kill-word
bindkey '^[u' undo

bindkey "$keys[Home2]" beginning-of-line
bindkey "$keys[End2]" end-of-line
bindkey "$keys[C-Left2]" backward-word
bindkey "$keys[C-Right2]" forward-word
bindkey "$keys[M-Enter2]" self-insert-unmeta
bindkey "$keys[M-Delete2]" kill-word

ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;' # excludes '&|'

accept-line-without-suffix-removal() { zle auto-suffix-retain; zle .accept-line }
zle -N accept-line accept-line-without-suffix-removal

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^[^E' edit-command-line

zman() {
	PAGER="less '+/^       "$1"'" man zshall
}

bindkey "$keys[PageUp]" history-beginning-search-backward
bindkey "$keys[PageDown]" history-beginning-search-forward
bindkey "$keys[C-Up]" history-beginning-search-backward
bindkey "$keys[C-Up2]" history-beginning-search-backward
bindkey "$keys[C-Down]" history-beginning-search-forward
bindkey "$keys[C-Down2]" history-beginning-search-forward

REPORTTIME=10
TIMEFMT=$'\nreal\t%*E\nuser\t%U\nsys\t%S\ncpu\t%P'

zmodload zsh/complist
bindkey -M listscroll -s "$keys[Escape]" '^[^[^[0brs^[^[^[1brs'
bindkey -M listscroll -s "$keys[Backspace]" '^[^[^[0brs^[^[^[1brs'
bindkey -M listscroll '^[^[^[0brs' send-break
bindkey '^[^[^[1brs' menu-complete
bindkey -M listscroll "$keys[PageDown]" menu-complete
bindkey -M listscroll -s "$keys[PageUp]" ''
bindkey -M menuselect "$keys[Escape]" send-break
bindkey -M menuselect "$keys[Backspace]" undo
bindkey -M menuselect "$keys[M-Right]" accept-and-infer-next-history
bindkey -M menuselect "$keys[M-Right2]" accept-and-infer-next-history
bindkey -M menuselect "$keys[M-Down]" accept-and-infer-next-history
bindkey -M menuselect "$keys[M-Down2]" accept-and-infer-next-history
bindkey -M menuselect / accept-and-infer-next-history
bindkey -M menuselect "$keys[M-Left]" undo
bindkey -M menuselect "$keys[M-Left2]" undo
bindkey -M menuselect "$keys[M-Up]" undo
bindkey -M menuselect "$keys[M-Up2]" undo
bindkey -M menuselect "$keys[M-Enter]" accept-and-hold
bindkey -M menuselect "$keys[M-Enter2]" accept-and-hold
bindkey -M menuselect "$keys[PageUp]" backward-word
bindkey -M menuselect "$keys[C-Up]" backward-word
bindkey -M menuselect "$keys[C-Up2]" backward-word
bindkey -M menuselect "$keys[PageDown]" forward-word
bindkey -M menuselect "$keys[C-Down]" forward-word
bindkey -M menuselect "$keys[C-Down2]" forward-word
bindkey -M menuselect "'" history-incremental-search-forward
bindkey -M menuselect "$keys[Home]" beginning-of-history
bindkey -M menuselect "$keys[Home2]" beginning-of-history
bindkey -M menuselect "$keys[End]" end-of-history
bindkey -M menuselect "$keys[End2]" end-of-history
bindkey -M menuselect "$keys[C-Left]" beginning-of-line
bindkey -M menuselect "$keys[C-Left2]" beginning-of-line
bindkey -M menuselect "$keys[C-Right]" end-of-line
bindkey -M menuselect "$keys[C-Right2]" end-of-line
bindkey -M menuselect "$keys[S-Tab]" reverse-menu-complete
bindkey -M menuselect "$keys[Enter]" .accept-line
bindkey -M menuselect "$keys[S-Up]" vi-backward-blank-word
bindkey -M menuselect "$keys[S-Left]" vi-backward-blank-word
bindkey -M menuselect "$keys[S-Down]" vi-forward-blank-word
bindkey -M menuselect "$keys[S-Right]" vi-forward-blank-word

autoload -U colors && colors

expand-or-complete-with-dots() {
	echo -n "$fg[red]...$reset_color"
	zle expand-or-complete
	zle redisplay
}

zle -N expand-or-complete-with-dots
bindkey "$keys[Tab]" expand-or-complete-with-dots

if (( ${+terminfo[rmkx]} )); then
	if (( !$APP_KEY_MODE )); then
		zle-line-init() { echoti rmkx }
		zle -N zle-line-init
	else
		zle-line-init() { echoti smkx }
		zle-line-finish() { echoti rmkx }
		zle -N zle-line-init
		zle -N zle-line-finish
	fi
fi

bindkey '^D' delete-char

rationalize-dots() {
	if [[ "$LBUFFER" == *... ]]; then
		LBUFFER="${LBUFFER%.}/.$KEYS/"
	elif [[ "$LBUFFER" == */. ]]; then
		LBUFFER+=$KEYS/
	else
		LBUFFER+=$KEYS
	fi
}

zle -N rationalize-dots
bindkey . rationalize-dots

[[ "$TERM" == 'xterm' ]] && TERM=xterm-256color

alias mv='nocorrect mv -i'
alias cp='nocorrect cp -i'
alias rm='nocorrect rm -i'
alias mkdir='nocorrect mkdir'
alias ls='ls --color=always'
alias la='ls -a'
alias g='grep --color=always'
alias l='less -R'
alias h='head'
alias t='tail'
alias c='cat'

alias -g G='| g'
alias -g L='| l'
alias -g H='| h'
alias -g T='| t'
alias -g V='| v -'

alias -s txt='v'
alias -s mp3='mp'

alias v='vim'
alias py='python'
alias mp='mplayer'
alias sc='screen'
alias tm='tmux'
alias p='ps -eo user,pid,ppid,%cpu,start,time,args --sort start_time'
alias k='kill'
alias ka='killall'
alias mk='make'
alias f='find'
alias s='sudo su -'
alias ht='htop -d10 -sPERCENT_CPU'

if [[ -n "$DISPLAY" ]]; then
	alias e='gedit'
	alias go='xdg-open'
	alias rd='rdesktop -k ko -g 1024x768 -r sound:local'
fi

DEFAULT_USER='barosl'
