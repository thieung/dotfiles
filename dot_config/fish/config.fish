set -u fish_greeting ""

# Variables
set -x GPG_TTY (tty)
set -x EDITOR nvim
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x HOMEBREW_NO_ANALYTICS 1
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
set -U fisher_path ~/.dotfiles/.config/fish/fisherman

set fish_color_param cyan
set fish_pager_color_completion blue --bold
set fish_color_normal black
set fish_color_error red
set fish_color_comment gray
set fish_color_autosuggestion gray

# Paths
fish_add_path /usr/local/bin/brew
fish_add_path /usr/local/sbin
fish_add_path "$HOME/.dotfiles/bin"

source $HOME/.config/fish/alias/init.fish
source $HOME/.config/fish/functions/init.fish
source $HOME/.config/fish/functions.fish

if status is-interactive
    starship init fish | source
end
fish_add_path /Users/thieunv/.spicetify
