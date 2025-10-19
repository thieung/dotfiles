# Claude Code Configuration

## Project Overview
This is a dotfiles management project using GNU Stow to symlink configurations across macOS.

## Tech Stack
- Shell: bash
- Package Manager: Homebrew (macOS)
- Config Manager: GNU Stow
- Target Configs: nvim, fish, tmux, git, etc.

## Repository Structure
- `common/` - Cross-platform configurations
- `macos/` - macOS-specific configurations
- `scripts/` - Helper scripts for installation
- `.claude/` - Claude Code configuration
- `install.sh` - Main installation script

## Key Commands
- `./install.sh install` - Install dotfiles
- `./install.sh stow-app <app>` - Install specific app config
- `./install.sh status` - Show installation status
- `./install.sh cleanup` - Clean orphaned symlinks

## Development Rules
1. Always backup existing configs before stowing
2. Use simulation mode (`--simulate`) before actual changes
3. Follow bash best practices: set -euo pipefail
4. Use stow --adopt flag for conflicts
5. Keep scripts modular and reusable
6. Test with both common/ and macos/ directories

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
- `.gitignore` - Carefully managed
- Home directory structure - Should only symlink
- System-critical shell config like /etc/shells

## Style Guide
- Use 4 spaces for indentation
- Use meaningful function names
- Add comments for complex logic
- Use color codes for output clarity

## Testing Strategy
1. Test install.sh in simulation mode first
2. Create backup before running actual installation
3. Verify symlinks after stowing
4. Test rollback with unstow commands

## Common Development Tasks
- Add new app config: Place in common/.config/ or macos/.config/
- Modify install script: Update both install.sh and documentation
- Test configuration: Use --simulate flag
- Verify symlinks: Run ./install.sh status
