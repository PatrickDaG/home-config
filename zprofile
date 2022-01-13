# Environment
export MAKEFLAGS="-j$(($(nproc || echo 2) + 1))"
# PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/npm-global/bin:$PATH:$HOME/scripts"
# EDITOR
export EDITOR="nvim"
# Firefox touch support
export MOZ_USE_XINPUT2=1
# Firefox Hardware render
export MOZ_WEBRENDER=1
#xdg config and data weil die hurensöhne von taskwarrior zu dumm sind specififations zu lesen
#meine fresse fuck you
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share/"

# GPG as ssh agent
[[ -z "$SSH_AUTH_SOCK" ]] \
	&& export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export GPG_TTY="$(tty)"
