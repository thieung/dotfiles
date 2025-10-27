# Fish Shell Configuration

if status is-interactive
    # Commands to run in interactive sessions can go here
    # mise activate fish | source
end

if test -f ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
    set -x _ZO_DATA_DIR "$HOME/.local/share/zoxide"
    set -x _ZO_ECHO 1
    set -x _ZO_RESOLVE_SYMLINKS 1
end

if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

if test -f ~/.cmdk/cmdk.fish
    source ~/.cmdk/cmdk.fish
end

# Install https://github.com/tobi/try if available
if test -f ~/.local/try.rb
    ~/.local/try.rb init ~/src/tries | string collect | source
end

# Disable greeting
set fish_greeting

# Set default editor
set -gx EDITOR vim

# Add common paths
# fish_add_path /usr/local/bin
# fish_add_path /opt/homebrew/bin
# fish_add_path ~/.local/bin

# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# Load aliases if they exist
if test -f ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end

# Load functions if they exist
if test -f ~/.config/fish/functions.fish
    source ~/.config/fish/functions.fish
end
