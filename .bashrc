#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias conda-init='source ~/.conda.bashrc'

# User environment variable
export EDITOR=nvim

# Primary prompt
#PS1='[\u@\h \W]\$ '
PS1='\W \$ '

# Start Hyprland with different GPU order and tty number
if [[ -n "${WAYLAND_DISPLAY}" ]]; then
	return
elif [[ "${XDG_VTNR}" -eq 1 ]]; then
	export AQ_DRM_DEVICES="/dev/dri/card1"
	exec uwsm start hyprland-uwsm.desktop
elif [[ "${XDG_VTNR}" -eq 2 ]]; then
	export AQ_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"
	exec uwsm start hyprland-uwsm.desktop
fi
