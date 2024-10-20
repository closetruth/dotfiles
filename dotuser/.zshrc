#环境变量

# 配置
#PROMPT='%F{5}[%n@%m %~]%# %f'
PROMPT='%F{13}[%n@%m %~]%# %f'

# 历史记录
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS

# 快捷键
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# 别名
alias th="trash"

# 设置标题
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- '\e]2; %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2; %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# 插件
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 高亮颜色
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF0000' #'fg=#CC0000'
ZSH_HIGHLIGHT_STYLES[command]='fg=#00FF00'  #'fg=#008800'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ED80FF'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#CD70DC'
ZSH_HIGHLIGHT_STYLES[path]='fg=#67C7D7'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#D3DB6E'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#DAB46C'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#FFFF00'


