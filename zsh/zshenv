# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install
skip_global_compinit=1

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env";
elif [ -d "$HOME/.cargo/bin" ]; then
  PATH=$HOME/.cargo/bin:$PATH
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH=$HOME/.local/bin:$PATH
fi

if [ -d "$HOME/.local/share/bob/nvim-bin" ]; then
  PATH=$HOME/.local/share/bob/nvim-bin:$PATH
fi
