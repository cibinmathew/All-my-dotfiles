# https://stackoverflow.com/questions/41046558/bashrc-how-to-check-in-what-terminal-the-shell-is-running
# bind only in terminals , not in emacs
if [[ ! -v INSIDE_EMACS ]]; then
    
    
bind -x '"\C-o"':"ls -lh"
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB: menu-complete"
bind "set blink-matching-paren on"
bind "set colored-completion-prefix on"
bind "set completion-map-case on"
bind "set mark-directories on"
# bind "set show-all-if-unmodified on"
# bind "set show-mode-in-prompt on"

#bind -x '"|C-i": cd -\n"'
#bind -x '"|C-i"\C-asudo \C-e"'
#bind -x '"|C-u":"cd ..\n"'
bind '"\C-p":history-search-backward'
bind '"\C-q":"exit\r"'

bind '"\C-o":"\C-asudo \C-e"' # move to alt
bind '"\C-8":"re\r"'
bind '"\C-l":"!!|fzf|clip\r"'
#bind '"\C-l":"cat $Universal_home/Downloads/all_files.db |fzf|clip\r"'
bind '"\C-o":"cat $Universal_home/Downloads/all_files.db |/usr/local/bin/fzy -l 20|clip\r"'
#bind -x '"|C-q":"exit\n"'
bind -x '"\e0":ranger'
# c-u kill the beg
# C-k kill to end
bind '"\C-l":"cd ..\r"'
bind -x '"\el":cd -\\r'

# bind -x '"|C-l": clear:echo "cleared"'
# for f12
bind '"\e[24~":"pwd\n"'
# binds Alt 0
bind -x '"\e0":re'
# This makes it unnecessary to press Tab twice when there is more than one match.
# set show-all-if-ambiguous on


# Ctrl+C kills the current process and that Ctrl+D will quit current shell and log you out. I like to put this in my .bashrc to prevent that last thing happening by accident:

# Ctrl+D must be pressed twice
export IGNOREEOF=1



# C-u=kill till beginning
# emacs bindings
# reverse-search-history (C-r)
# Search backward starting at the current line and moving `up' through the history as necessary.  This is an incremental search.
# man bash | grep -A294 'Commands for' 
# Set Vi Mode in bash:
# set -o vi 

# Set Emacs Mode in bash:
set -o emacs 
fi
