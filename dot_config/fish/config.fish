set -u fish_greeting ""

# Variables
set -x GPG_TTY (tty)
set -x EDITOR nvim
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x HOMEBREW_NO_ANALYTICS 1
set -x GOPATH "$HOME/go"
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -x OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES
set -x ASDF_GOLANG_MOD_VERSION_ENABLED false
set -gx macOS_Theme (cat $HOME/.color_mode | string collect)
set -gx PATH /usr/local/bin /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/bin/rg $PATH

# Add OpenSSL to PATH
set -gx LDFLAGS "-L$(brew --prefix)/opt/openssl@3/lib" #"-L/opt/homebrew/Cellar/openssl@3/3.2.1/lib"
set -gx CPPFLAGS "-I$(brew --prefix)/opt/openssl@3/include" #"-I/opt/homebrew/Cellar/openssl@3/3.2.1/include"
set -gx PKG_CONFIG_PATH "$(brew --prefix)/opt/openssl@3/lib/pkgconfig" #"/opt/homebrew/Cellar/openssl@3/3.2.1/lib/pkgconfig"

set fish_color_command green --bold
set fish_color_param cyan
set fish_pager_color_completion blue --bold
set fish_color_normal black
set fish_color_error red
set fish_color_comment gray
set fish_color_autosuggestion gray

if [ "$macOS_Theme" = light ]
    set -x LS_COLORS "vivid generate $HOME/.config/vivid/onelight.yml"
else if [ "$macOS_Theme" = dark ]
    set -x LS_COLORS "vivid generate $HOME/.config/vivid/onedark.yml"
end

# Paths
fish_add_path /opt/homebrew/bin/brew
fish_add_path /opt/homebrew/sbin
fish_add_path "$HOME/.local/share/nvim/mason/bin"
fish_add_path $GOPATH/bin
fish_add_path /opt/homebrew/bin/bash

source $HOME/.config/fish/fzf.fish
source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/functions.fish

if type -q zoxide
    zoxide init fish | source
    set -x _ZO_DATA_DIR "$HOME/.local/share/zoxide"
    set -x _ZO_ECHO 1
    set -x _ZO_RESOLVE_SYMLINKS 1
end

if status is-interactive
    load_env_vars ~/.env
    thefuck --alias | source
    starship init fish | source
    mise activate fish | source
else
    starship init fish | source
    mise activate fish --shims | source
end
