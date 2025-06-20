# Source system-wide bashrc if it exists
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

bind -x '"\C-f":find.sh'
bind -x '"\C-x":lazygit'
bind -x '"\C-p":project.sh'
bind -x '"\C-g":tmux_sessionizer.sh'
bind -x '"\C-n":yazi'
