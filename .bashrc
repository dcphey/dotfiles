#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias conda-init='source ~/.conda.bashrc'

# Primary prompt
#PS1='[\u@\h \W]\$ '
PS1='\W \$ '

# Early exit of uwsm check
[[ $(tty) != /dev/tty1 ]] && return

# Start Hyprland
if uwsm check may-start -q; then
	exec uwsm start hyprland-uwsm.desktop
fi
