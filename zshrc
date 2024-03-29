

# REQUIRES (execute as root):
# umask 022

# powerlevel10k
source /usr/share/zsh/repos/romkatv/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/repos/romkatv/powerlevel10k/config/p10k-lean-8colors.zsh

# zsh histdb
typeset -g HISTDB_FILE="$HOME/.zsh_history.db"
source /usr/share/zsh/repos/larkery/zsh-histdb/sqlite-history.zsh

# zsh histdb-skim
source /usr/share/zsh/repos/m42e/zsh-histdb-skim/zsh-histdb-skim.zsh

# Use emacs-like key bindings by default:
bindkey -e

# Autoloading
autoload colors && colors
autoload add-zsh-hook
autoload zmv
autoload zed
if autoload history-search-end; then
	zle -N history-beginning-search-backward-end history-search-end
	zle -N history-beginning-search-forward-end  history-search-end
fi

# fzf keybindings
source /usr/share/fzf/key-bindings.zsh

function bind2maps() {
	local i sequence widget
	local -a maps

	while [[ "$1" != "--" ]]; do
		maps+=( "$1" )
		shift
	done
	shift

	if [[ "$1" == "-s" ]]; then
		shift
		sequence="$1"
	else
		sequence="${key[$1]}"
	fi
	widget="$2"

	[[ -z "$sequence" ]] && return 1

	for i in "${maps[@]}"; do
		bindkey -M "$i" "$sequence" "$widget"
	done
}

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-smkx() {
		emulate -L zsh
		printf '%s' ${terminfo[smkx]}
	}
	function zle-rmkx() {
		emulate -L zsh
		printf '%s' ${terminfo[rmkx]}
	}
	function zle-line-init() {
		zle-smkx
	}
	function zle-line-finish() {
		zle-rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

typeset -A key
key=(
	Home     "${terminfo[khome]}"
	End      "${terminfo[kend]}"
	Insert   "${terminfo[kich1]}"
	Delete   "${terminfo[kdch1]}"
	Up       "${terminfo[kcuu1]}"
	Down     "${terminfo[kcud1]}"
	Left     "${terminfo[kcub1]}"
	Right    "${terminfo[kcuf1]}"
	PageUp   "${terminfo[kpp]}"
	PageDown "${terminfo[knp]}"
	BackTab  "${terminfo[kcbt]}"
)

bind2maps emacs             -- Home     beginning-of-line
bind2maps emacs             -- End      end-of-line
bind2maps       viins vicmd -- Home     vi-beginning-of-line
bind2maps       viins vicmd -- End      vi-end-of-line
bind2maps emacs viins       -- Insert   overwrite-mode
bind2maps             vicmd -- Insert   vi-insert
bind2maps emacs             -- Delete   delete-char
bind2maps       viins vicmd -- Delete   vi-delete-char
bind2maps emacs viins vicmd -- Up       up-line-or-search
bind2maps emacs viins vicmd -- Down     down-line-or-search
bind2maps emacs             -- Left     backward-char
bind2maps       viins vicmd -- Left     vi-backward-char
bind2maps emacs             -- Right    forward-char
bind2maps       viins vicmd -- Right    vi-forward-char
bind2maps emacs viins       -- -s '^xp' history-beginning-search-backward-end
bind2maps emacs viins       -- -s '^xP' history-beginning-search-forward-end
bind2maps emacs viins       -- PageUp   history-beginning-search-backward-end
bind2maps emacs viins       -- PageDown history-beginning-search-forward-end
bind2maps emacs viins       -- -s ' ' magic-space

# Use Ctrl-left-arrow and Ctrl-right-arrow for jumping to word-beginnings on
# the command line.
# kitty: Shift-Left/Right
bind2maps emacs viins vicmd -- -s '\e[1;2C' forward-word
bind2maps emacs viins vicmd -- -s '\e[1;2D' backward-word
# kitty: Alt-Left/Right
bind2maps emacs viins vicmd -- -s '\e[1;3C' forward-word
bind2maps emacs viins vicmd -- -s '\e[1;3D' backward-word
# kitty: Ctrl-Del
bind2maps emacs viins vicmd -- -s '\e[3;5~' kill-line
# Key bindings
bind2maps emacs viins vicmd -- -s '^H' backward-kill-line
bind2maps emacs viins vicmd -- -s '^P' expand-or-complete-prefix

# Enable partial search using up and down keys for completion
bind2maps emacs viins vicmd -- -s '^[[A' history-beginning-search-backward-end
bind2maps emacs viins vicmd -- -s '^[[B' history-beginning-search-forward-end
bind2maps emacs viins vicmd -- -s '\eOA' history-beginning-search-backward-end
bind2maps emacs viins vicmd -- -s '\eOB' history-beginning-search-forward-end


typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
# The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	# os_icon               # os identifier
	context                 # user@hostname
	dir                     # current directory
	vcs                     # git status
	prompt_char             # prompt symbol
)

# The list of segments shown on the right. Fill it with less important segments.
# Right prompt on the last prompt line (where you are typing your commands) gets
# automatically hidden when the input line reaches it. Right prompt above the
# last prompt line gets hidden if it would overlap with left prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
	status                  # exit code of the last command
	command_execution_time  # duration of the last command
	background_jobs         # presence of background jobs
	direnv                  # direnv status (https://direnv.net/)
	asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
	virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
	anaconda                # conda environment (https://conda.io/)
	pyenv                   # python environment (https://github.com/pyenv/pyenv)
	goenv                   # go environment (https://github.com/syndbg/goenv)
	nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
	nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
	nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
	# node_version          # node.js version
	# go_version            # go version (https://golang.org)
	# rust_version          # rustc version (https://www.rust-lang.org)
	# dotnet_version        # .NET version (https://dotnet.microsoft.com)
	# php_version           # php version (https://www.php.net/)
	# laravel_version       # laravel php framework version (https://laravel.com/)
	# java_version          # java version (https://www.java.com/)
	# package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
	rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
	rvm                     # ruby version from rvm (https://rvm.io)
	fvm                     # flutter version management (https://github.com/leoafarias/fvm)
	luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
	jenv                    # java version from jenv (https://github.com/jenv/jenv)
	plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
	phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
	scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
	haskell_stack           # haskell version from stack (https://haskellstack.org/)
	kubecontext             # current kubernetes context (https://kubernetes.io/)
	terraform               # terraform workspace (https://www.terraform.io)
	aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
	aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
	azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
	gcloud                  # google cloud cli account and project (https://cloud.google.com/)
	google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
	#context                 # user@hostname
	nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
	ranger                  # ranger shell (https://github.com/ranger/ranger)
	nnn                     # nnn shell (https://github.com/jarun/nnn)
	vim_shell               # vim shell indicator (:sh)
	midnight_commander      # midnight commander shell (https://midnight-commander.org/)
	nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
	# vpn_ip                # virtual private network indicator
	# load                  # CPU load
	# disk_usage            # disk usage
	# ram                   # free RAM
	# swap                  # used swap
	todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
	timewarrior             # timewarrior tracking status (https://timewarrior.net/)
	# taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
	time                    # current time
	# ip                    # ip address and bandwidth usage for a specified network interface
	# public_ip             # public IP address
	# proxy                 # system-wide http/https/ftp proxy
	# battery               # internal battery
	# wifi                  # wifi speed
	# example               # example user-defined segment (see prompt_example function below)
)

# No color prompt symbol
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=
# Default prompt symbol.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='$'
# Prompt symbol in command vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION=':'
# Prompt symbol in visual vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
# Prompt symbol in overwrite vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

# Default context color without privileges
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=6
# Context color when running with privileges.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1
# Context color in SSH without privileges.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=2
# Context color in SSH with privileges.
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=1

# Context format when running with privileges: user@(bold)hostname.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n%B@%m'
# Context format when in SSH without privileges: user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='ssh://%n%B@%m'
# Default context format (no privileges, no SSH): user@hostname.
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n%B@%m'

# No directory icons
typeset -g POWERLEVEL9K_DIR_{,NOT_WRITABLE_}VISUAL_IDENTIFIER_EXPANSION=""
# Disable instant prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Don't show context unless running with privileges or in SSH.
# Tip: Remove the next line to always show context.
unset POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION

# Completion
autoload -Uz compinit
compinit

# Make sure the completion system is initialised
(( ${+_comps} )) || return 1

# Don't insert tabs when there is no completion (e.g. beginning of line)
zstyle ':completion:*' insert-tab false

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'\e[0;31mcompleting \e[1m%d\e[0m'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

if [[ "$NOMENU" -eq 0 ]] ; then
	# if there are more than 5 options allow selecting from a menu
	zstyle ':completion:*'             menu select=5
else
	# don't use any menus at all
	setopt no_auto_menu
fi

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path \
	/usr/local/sbin \
	/usr/local/bin  \
	/usr/sbin       \
	/usr/bin        \
	/sbin           \
	/bin

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# run rehash on completion so new installed program are found automatically:
function _force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1
}

# No correction
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv pal stow uname ; do
	[[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# see upgrade function in this file
compdef _hosts upgrade

# Load external plugins
source /usr/share/zsh/repos/Aloxaf/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh/repos/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1005000

# Append history when zsh exits
setopt append_history
# Also save timestamp and duration
setopt extended_history
# Ignore commands beginning with a space
setopt hist_ignore_space
# Remove repeated duplicates
setopt hist_ignore_dups
# Remove trailing whitespace from history
setopt hist_reduce_blanks
# Save history after each command
setopt inc_append_history
# If history is full, delete oldest duplicate commands first
setopt hist_expire_dups_first
# When a history line is selected from expansion, don't execute but fill line buffer
setopt hist_verify

# Emit an error when a glob has no match
setopt nomatch
# Allow extended globbing
setopt extendedglob
# * shouldn't match dotfiles. ever.
setopt noglobdots
# Whenever a command completion is attempted, make sure the entire
# command path is hashed first.
setopt hash_list_all

# Change directory by typing the directory name
setopt auto_cd
# Automatically pushd on cd to have a directory stack
setopt auto_pushd
# Don't push the same dir twice
setopt pushd_ignore_dups
# Display PID when suspending processes as well
setopt longlistjobs
# Don't send SIGHUP to background processes when the shell exits
setopt nohup
# Report the status of background jobs immediately
setopt notify
# Allow comments in interactive shells
setopt interactive_comments
# Don't beep
setopt nobeep

# Don't try to correct inputs
setopt nocorrect
# Allow in-word completion
setopt completeinword
# Don't autocorrect commands
setopt no_correct_all
# Allow completion from within a word/phrase
setopt complete_in_word
# List choices on ambiguous completions
setopt auto_list
# Use menu completion if requested explicitly
setopt auto_menu
# Move cursor to end of word if there was only one match
setopt always_to_end

# Ignore certain commands in history
HISTORY_IGNORE_REGEX='^(.|. |..|.. |rm .*|rmd .*|git fixup.*|git unstash|git stash.*|git checkout -f.*|l .*|ll .*|ls .*)$'
function zshaddhistory() {
	emulate -L zsh
	[[ ! $1 =~ "$HISTORY_IGNORE_REGEX" ]]
}

# Start ssh-agent if not already running
# if ! pgrep -c -u "$USER" ssh-agent &>/dev/null; then
#     ssh-agent -t 4h -s | grep -Fv 'echo' > ~/.ssh/ssh-agent-env \
#         && source ~/.ssh/ssh-agent-env
# elif [[ -e ~/.ssh/ssh-agent-env ]]; then
#     source ~/.ssh/ssh-agent-env
# else
#     echo "error: could not start 'ssh-agent'" >&2
# fi

# Aliases
alias l="ls -lahF --group-directories-first --show-control-chars --quoting-style=escape --color=auto"
alias ll="ls -lahF --group-directories-first --show-control-chars --quoting-style=escape --color=auto"
alias t="tree -F --dirsfirst -L 2"
alias tt="tree -F --dirsfirst -L 3 --filelimit 16"
alias ttt="tree -F --dirsfirst -L 6 --filelimit 16"

alias md="mkdir"
alias rmd="rm -d"

#because 2 less keys is still only half the work
alias ta="task"
alias tat="taskwarrior-tui"

#what the fuck is going on here????
alias cpr="rsync -axHAWXS --numeric-ids --info=progress2"

alias cp="cp -vi"
alias mv="mv -vi"
alias rm="rm -I"
alias chmod="chmod -c --preserve-root"
alias chown="chown -c --preserve-root"
alias -s {md,txt,cpp,hpp,h,c}=vim

alias ip="ip --color"
alias tmux="tmux -2"
alias rg="rg -S"

#tar any number of given filen and compress them
alias comptar="tar -c -f archive.tar.xz -v -I 'pixz -9'"

#random functions
#compress all files in current directory excluding folders and already compressed files
function compressAll() {
	for i in $(ls -p | grep -E -v "/|(.xz|.gz|.zip)")
	do
		echo "compressing: " $i
		pixz -9 $i
	done
}

#extract random file
function ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
	  *.tar.xz)	   tar xfJ $1	;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1	;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


# Aliases when X is running
if xset q &>/dev/null; then
	alias zf="zathura --fork"  #pdf viewer
fi
alias vi="nvim"
alias vim="nvim"

# Set umask
umask 077

alias luamake=/home/patrick/.local/share/nvim/lua-language-server/3rd/luamake/luamake
