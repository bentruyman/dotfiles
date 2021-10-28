source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/plugins/zsh-z/zsh-z.plugin.zsh

# allow small letters to match capital letters in autocomplete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -U compinit && compinit

eval "$(starship init zsh)"
