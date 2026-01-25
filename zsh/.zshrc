# ----- oh my zsh config -----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="dracula/dracula"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ----- FZF -----
# set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# dracula color scheme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ----- Bat (better cat) -----
export BAT_THEME=Dracula
alias cat="bat"

# ----- Eza (better ls) ------
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-user --no-permissions'

function lst() { 
	eza --color=always --long --git --no-filesize --icons=always --no-user --no-permissions --tree --level="$1";
}

function contextdiff() {
    diff <(jq '.' "$1"-FixedContext.json) <(jq '.' "$1"-Context.json)
}

# ---- Oops ----
eval $(thefuck --alias oops)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd='z'


# Source .zshrc.local if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
