set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

### PATH
#
set -gx PATH /usr/local/sbin $PATH
set -gx PATH /usr/local/opt/python/libexec/bin $PATH # python
set -gx PATH /usr/local/opt/openssl/bin $PATH # openssl
set -gx PATH ~/neovim/bin $PATH # neovim
set -gx PATH /opt/local/bin $PATH # macports
set -gx PATH ~/.emacs.d/bin $PATH # emacs

### Editor
#
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim

### Fzf
#
set -gx FZF_COMPLETION_TRIGGER '**'
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden'
set -gx FZF_DEFAULT_OPTS '--height 90% --layout reverse --border --color "border:#b877db" --preview="bat --color=always {}"'

### TLDR
#
set -gx TLDR_OS osx

### Yabai
#
set -gx YABAI_CERT yabai-cert

### Bat
#
set -gx BAT_THEME TwoDark

# ### Fisher
# #
# set -U fisher_path ~/.dotfiles/config/fish/fisherman

### ZK Notes
set -gx ZK_NOTEBOOK_DIR ~/personal-notes

### Rust
#
set -gx RUST_WITHOUT rust-docs

### Neovim colorsheme
set -gx NVIM_COLORSCHEME onedark

set -gx SSH_AUTH_SOCK "$(colima ssh env | grep SSH_AUTH_SOCK | cut -d = -f 2)"
