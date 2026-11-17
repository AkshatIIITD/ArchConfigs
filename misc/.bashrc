#
# ~/.bashrc (versioned in archConfigs/misc, stowed to ~/.bashrc)
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- History ---
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups # skip duplicates and space-prefixed commands
shopt -s histappend              # append instead of overwriting across terminals

# --- Aliases ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- Theme: starship/fastfetch use this machine's palette (~/.config/theme) ---
[ -f ~/.config/theme/shell.sh ] && . ~/.config/theme/shell.sh

# --- Prompt: starship, with a plain fallback if it isn't installed ---
PS1='[\u@\h \W]\$ '
command -v starship >/dev/null && eval "$(starship init bash)"

# --- Version managers ---
# mise manages Node (~/.config/mise/config.toml)
command -v mise >/dev/null && eval "$(mise activate bash)"

# SDKMAN manages Java. THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
