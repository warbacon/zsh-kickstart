#           _                       _      _        _             _
#   _______| |__         __ _ _   _(_) ___| | _____| |_ __ _ _ __| |_
#  |_  / __| '_ \ _____ / _` | | | | |/ __| |/ / __| __/ _` | '__| __|
#   / /\__ \ | | |_____| (_| | |_| | | (__|   <\__ \ || (_| | |  | |_
#  /___|___/_| |_|      \__, |\__,_|_|\___|_|\_\___/\__\__,_|_|   \__|
#                          |_|
#
## INITIALIZATION =============================================================
# By default zcompdump is created in the home directory, so we will create a
# directory for the zsh cache in a separate directory to clean things up a
# little bit.
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Creates the cache directory if doesn't exist, as compinit will fail if it
# doesn't find the directory in which .zcompdump is specified to be located.
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"

# The .zcompdump file is used to improve compinit's initialization time.
ZCOMPDUMP_PATH="$CACHE_DIR/.zcompdump"

## COMPLETIONS ================================================================
# Initializes completion system. Relevant documentation:
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit.
autoload -U compinit
compinit -d "$ZCOMPDUMP_PATH"

# Compiles the .zcompdump to load it faster next time.
# Search for zcompile in https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html.
[[ "$ZCOMPDUMP_PATH.zwc" -nt "$ZCOMPDUMP_PATH" ]] || zcompile "$ZCOMPDUMP_PATH"

# Marks the selected item in the completion menu.
zstyle ':completion:*' menu select

# Makes the completion case-insensitive unless a uppercase is used.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Enables cache. I have not found any real use for it but theoretically it is
# useful to improve the speed of some completions.
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$CACHE_DIR/.zcompcache"

## KEYBINDINGS ================================================================
# Forces the use of emacs keyboard shortcuts. By default uses the vim ones,
# but they are not very good by default and can be confusing for novice users.
bindkey -e

# These additional shortcuts only apply to emacs mode, since they have the
# `-M emacs` flag.

# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs "^[[1;5D" backward-word
# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs "^[[1;5C" forward-word

# [Alt-LeftArrow] - move backward one word
bindkey -M emacs "^[[1;3D" backward-word
# [Alt-RightArrow] - move forward one word
bindkey -M emacs "^[[1;3C" forward-word

# [Shift-Tab] - move through the completion menu backwards
bindkey -M emacs "^[[Z" reverse-menu-complete

# [Delete] - delete forward
bindkey -M emacs "^[[3~" delete-char
# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey -M emacs "^[[A" up-line-or-beginning-search

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M emacs "^[[B" down-line-or-beginning-search

# Makes zsh behave the same with words as bash. Recommended to leave it this
# way since by default it simply behaves badly.
autoload -U select-word-style
select-word-style bash

## PROMPT =====================================================================
# Prints a new line each time a command is executed.
precmd() { [ -z "$add_newline" ] && add_newline=true || echo; }

# Sets the prompt style.
PROMPT="%B%F{blue}%~%f%F{%(?.fg.red)}>%b%f "

## HISTORY ====================================================================
HISTFILE="$HOME/.zsh_history" # Location of the history file.
HISTSIZE=50000                # Maximum number of commands in the history.
SAVEHIST=10000                # Number of commands to save between sessions.
setopt share_history          # Share history between sessions.

## ALIASES ====================================================================
# Ls doesn't have color enabled by default, so this alias enables it.
# Additionally, you can include --group-directories-first if you prefer
# to see directories listed first.
alias ls="ls --color=auto"

# Grep doesn't have color enabled by default either.
alias grep="grep --color=auto"

# Useful aliases to list files. Take a look at https://github.com/eza-community/eza.
alias la="ls -A"
alias ll="ls -l"
alias lla="ls -lA"

# If trash-cli is installed, this creates an alias to use it instead of rm.
# Using trash-cli is recommended since rm deletes files almost permanently.
[[ -n "$commands[trash]" ]] && alias rm="trash"

## OTHER ======================================================================
# Disables highlighting of pasted text.
zle_highlight+=(paste:none)

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt autocd

# Makes the "command not found" message more beautiful and informative.
command_not_found_handler() {
    printf "%sERROR:%s command %s not found.\n" \
        "$(printf "\033[1;31m")" "$(printf "\033[0m")" \
        "$(printf "\033[4:3m\033[58:5:1m")$1$(printf "\033[0m")"
    return 127
}
