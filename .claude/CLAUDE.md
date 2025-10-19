# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a GNU Stow-based dotfiles management system for macOS with modular architecture supporting cross-platform configurations and automated development tool management via mise.

## Architecture
- **Stow-Based Symlink Management**: Uses GNU Stow to create symlinks from `~/.config` to repository
- **Platform Separation**: `common/` for cross-platform configs, `macos/` for platform-specific
- **Modular Scripts**: Specialized scripts in `scripts/` directory for focused functionality
- **Development Tools Integration**: Automated tool management via mise (config in `common/.config/mise/config.toml`)

## Key Commands

### Installation Commands
```bash
# Complete setup (recommended for new systems)
./install.sh all

# Incremental installation
./install.sh install              # Dotfiles only
./install.sh install --with-tools # Dotfiles + development tools
./install.sh install --simulate   # Dry run preview
./install.sh install --interactive # Guided installation

# Individual app management
./install.sh stow-app <app>       # Install specific app config
./install.sh unstow-app <app>     # Remove specific app config
```

### Development & Maintenance Commands
```bash
# Status and verification
./install.sh status              # Comprehensive system status
./scripts/check-stow.sh         # Detailed stow verification

# Tool management
./install.sh tools              # Install development tools via mise
./install.sh fish               # Setup Fish shell
./install.sh fish-plugins       # Install Fisher and plugins

# Maintenance
./install.sh cleanup            # Remove orphaned symlinks
./install.sh backup             # Backup existing dotfiles
./install.sh restow             # Reinstall all dotfiles
./install.sh submodules         # Update git submodules
```

### Safe Development Workflow
```bash
# Always test changes first
./install.sh install --simulate     # Preview all changes
./install.sh install --interactive  # Install with prompts
./install.sh status                  # Verify installation
./scripts/check-stow.sh             # Detailed verification
```

## Development Tools Stack

### Managed via Mise (`common/.config/mise/config.toml`)
- **Languages**: Node.js (22.20.0), Python, Go, Rust, Deno, Bun
- **CLI Tools**: ripgrep, fd, bat, fzf, jq, delta, lazygit, gh, zoxide, shellcheck
- **Editors**: neovim (nightly)

Tools auto-install when missing. Use `mise install` for manual installation.

## Architecture Patterns

### Script Design
- All scripts use `set -euo pipefail` for strict error handling
- Color-coded logging functions: `log_info`, `log_success`, `log_warning`, `log_error`
- Modular functions with single responsibilities
- Interactive prompts with sensible defaults

### Stow Management
- Package-based organization (common/macos separation)
- Uses `--adopt` flag for automatic conflict resolution
- Comprehensive `.stow-local-ignore` for clean symlinking
- Built-in status checking and broken symlink cleanup

### Testing Strategy
- **Simulation Mode**: Use `--simulate` flag for dry-run testing
- **Status Verification**: `./install.sh status` and `./scripts/check-stow.sh`
- **Interactive Installation**: Step-by-step installation with confirmations
- **Backup Strategy**: Automatic backup with timestamped directories

## Adding New Configurations

### Cross-platform tools (common/)
```bash
mkdir -p common/.config/new-tool
# Add config files
stow --simulate common  # Test first
stow common            # Apply
```

### macOS-specific tools (macos/)
```bash
mkdir -p macos/.config/macos-app
# Add config files
stow --simulate macos  # Test first
stow macos            # Apply
```

## Development Rules
1. Always backup existing configs before stowing
2. Use simulation mode (`--simulate`) before actual changes
3. Follow bash best practices: `set -euo pipefail`
4. Use `stow --adopt` flag for conflicts
5. Keep scripts modular and reusable
6. Test with both `common/` and `macos/` directories

### Pre-commit/Push Rules
- Run linting before commit
- Run tests before push (DO NOT ignore failed tests just to pass the build or github actions)
- Keep commits focused on the actual code changes
- **DO NOT** commit and push any confidential information (such as dotenv files, API keys, database credentials, etc.) to git repository!
- NEVER automatically add AI attribution signatures like:
  "🤖 Generated with [Claude Code]"
  "Co-Authored-By: Claude noreply@anthropic.com"
  Any AI tool attribution or signature
- Create clean, professional commit messages without AI references. Use conventional commit format.

## Don't Touch
- `.gitignore` - Carefully managed ignore patterns
- Home directory structure - Should only symlink, never modify directly
- System-critical shell config like `/etc/shells`
