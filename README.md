# dotfiles

A macOS dotfiles repository organized with GNU Stow for easy management and deployment.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/thieung/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Complete setup (dotfiles + tools + submodules)
./install.sh all

# Or install components separately
./install.sh install       # Install dotfiles only
./install.sh tools         # Install development tools with mise
./install.sh fish          # Install Fish shell and Fisher plugin manager
./install.sh submodules    # Update git submodules
./install.sh backup        # Backup existing dotfiles only
./install.sh uninstall     # Remove dotfiles
./install.sh restow        # Reinstall dotfiles

# Install with options
./install.sh install --with-tools    # Install dotfiles + tools
./install.sh install --update-subs   # Install dotfiles + update submodules
./install.sh install --no-backup     # Install without backing up existing files
./install.sh install --interactive   # Interactive mode with guided prompts
./install.sh install --simulate      # Dry run - see what would be done

# Safe installation workflow (recommended)
./install.sh install --simulate      # Preview changes first
./install.sh install --interactive   # Then install interactively
```

## 🛠️ Current Setup

This dotfiles configuration is optimized for the following tools:

**Terminal & Shell:**
- **Ghostty** - Modern, fast terminal emulator
- **Fish** - User-friendly shell with auto-suggestions

**Window Management:**
- **FlashSpace** - Quick workspace switching
- **Rectangle** - Window snapping and management

**Development Tools:**
- **Neovim** - Highly customizable text editor
- **Git** - Version control with custom configuration
- Various CLI tools managed via mise (.tool-versions)

## 📁 Repository Structure

```
dotfiles-optimized/
├── common/                    # Cross-platform configurations
│   └── .config/
│       ├── fish/             # Fish shell configuration
│       ├── git/              # Git configuration
│       ├── nvim/             # Neovim configuration
│       └── ...               # Other cross-platform tools
├── macos/                     # macOS-specific configurations
│   ├── .config/
│   │   ├── ghostty/          # Ghostty terminal configuration
│   │   └── ...               # Other macOS-specific tools
├── scripts/                   # Installation and setup scripts
│   ├── install-tools.sh      # Development tools installation
│   ├── setup-fish-plugins.sh # Fish plugin setup
│   └── update-submodules.sh  # Git submodules management
└── install.sh                # Main installation script
```

## 🛠️ Manual Installation

If you prefer manual installation or want to install specific packages:

```bash
# Install GNU Stow first
brew install stow

# Stow common configs (cross-platform tools)
stow common

# Stow macOS-specific configs
stow macos

# Unstow (remove symlinks)
stow -D common macos
```

> 📖 **New to GNU Stow?** Read our comprehensive [Stow Documentation](docs/STOW.md) to understand how it works, why we use it, and how to test and verify your setup.

## 📦 Adding New Configurations

When adding new dotfiles, organize them by platform:

### Cross-platform tools (common/)
```bash
# Add to common/.config/ for tools that work on multiple platforms
mkdir -p common/.config/new-tool
cp ~/.config/new-tool/* common/.config/new-tool/
```

### macOS-specific tools (macos/)
```bash
# For macOS-specific applications and system configs
mkdir -p macos/.config/macos-app
cp ~/.config/macos-app/* macos/.config/macos-app/

# For root-level dotfiles (if needed)
cp ~/.some-config macos/.some-config
```

### Testing configurations
```bash
# Test stowing new config
stow --simulate common  # Dry run to see what would be linked
stow common            # Actually create symlinks

# Remove if something goes wrong
stow -D common
```

### Neovim Configuration

```sh
git clone https://github.com/thieung/my-nvim ~/.config/nvim
```

## 🔧 Development Tools Management

### Automated Tool Installation

The repository includes automated tool installation using [mise](https://mise.jdx.dev/):

```bash
# Install all development tools defined in .tool-versions
./install.sh tools

# Or use the helper script directly
./scripts/install-tools.sh
```

### Managed Tools (.tool-versions)

Development tools automatically installed by mise:
- **Languages**: Node.js, Python, Go, Rust, Deno, Bun
- **CLI Tools**: ripgrep, fd, bat, fzf, jq, delta, lazygit, gh

### Git Submodules Management

Update editor configurations (Neovim, Zed, VSCode):

```bash
# Update all submodules
./install.sh submodules

# Or use the helper script directly
./scripts/update-submodules.sh

# Update specific submodule
./scripts/update-submodules.sh update-specific nvim

# List all submodules
./scripts/update-submodules.sh list
```

### Manual Prerequisites

Some tools need manual installation:

```bash
# Install GNU Stow (required)
brew install stow

# Install mise (automatically handled by install-tools.sh)
curl https://mise.run | sh
```

### Shell Setup (Optional)

### Fish Shell Setup

Install and configure Fish shell (recommended):
```bash
# Install Fish shell and set as default
./install.sh fish

# Setup Fish plugins (Fisher, Pure theme, etc.)
./install.sh fish-plugins
```

### Zsh Setup (Alternative)

If using Zsh with Oh My Zsh:
```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install plugins
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
```
