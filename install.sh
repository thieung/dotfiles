#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect macOS
detect_platform() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos-$(uname -m)"
            ;;
        *)
            log_error "This script is for macOS only"
            log_error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
}

# Legacy compatibility function
detect_os() {
    echo "macos"
}

# Check if command exists
command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# Check package dependencies for specific applications
check_app_dependencies() {
    local app_name="$1"
    local missing_packages=()
    local install_cmd="brew install"

    case "$app_name" in
        kitty)
            command_exists kitty || missing_packages+=("kitty")
            ;;
        ghostty)
            command_exists ghostty || missing_packages+=("ghostty")
            ;;
        fish)
            command_exists fish || missing_packages+=("fish")
            ;;
        tmux)
            command_exists tmux || missing_packages+=("tmux")
            ;;
        zellij)
            command_exists zellij || missing_packages+=("zellij")
            ;;
        nvim)
            command_exists nvim || missing_packages+=("neovim")
            ;;
        zsh)
            command_exists zsh || missing_packages+=("zsh")
            ;;
        rofi)
            command_exists rofi || missing_packages+=("rofi")
            ;;
        files)
            # File manager options
            if ! command_exists finder; then
                missing_packages+=("Finder is built-in")
            fi
            ;;
        browser)
            # Browser options
            if ! command_exists firefox && ! command_exists google-chrome && ! command_exists chromium && ! command_exists brave; then
                missing_packages+=("firefox or google-chrome or chromium or brave")
            fi
            ;;
    esac

    # Report missing packages
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_warning "$app_name has missing dependencies:"
        for package in "${missing_packages[@]}"; do
            echo "  - $package"
        done
        if [[ -n "$install_cmd" ]]; then
            echo "  Install with: $install_cmd ${missing_packages[*]}"
        fi
        echo
        return 1
    fi

    return 0
}

# Validate stow prerequisites
validate_stow_environment() {
    local errors=0

    log_info "Validating stow environment..."

    # Check stow installation
    if ! command_exists stow; then
        log_error "GNU Stow is not installed"
        ((errors++))
    fi

    # Check dotfiles directory structure
    cd "$(dirname "$0")" || {
        log_error "Cannot access dotfiles directory"
        return 1
    }

    # Check required packages exist
    if [[ ! -d "common" ]]; then
        log_error "Package directory 'common' not found"
        ((errors++))
    fi

    if [[ ! -d "macos" ]]; then
        log_error "Package directory 'macos' not found"
        ((errors++))
    fi

    # Check write permissions
    if [[ ! -w "$HOME" ]]; then
        log_error "No write permission to HOME directory: $HOME"
        ((errors++))
    fi

    # Check for conflicting management systems
    if [[ -d "$HOME/.oh-my-zsh" ]] && [[ -d "common/.config/zsh" || -d "macos/.config/zsh" ]]; then
        log_warning "Oh-My-Zsh detected - may conflict with zsh dotfiles"
    fi

    if [[ -d "$HOME/.vim" ]] && [[ -L "$HOME/.vim" ]] && [[ -d "common/.config/nvim" ]]; then
        log_warning "Existing vim setup detected - may conflict with nvim config"
    fi

    # Ensure Claude directories exist with proper structure
    if [[ -d "common/.config/claude" ]] && [[ ! -d "common/.claude" ]]; then
        log_info "Setting up Claude configuration structure..."
        mkdir -p "common/.claude"
        # Copy Claude configs to .claude if they don't exist
        for file in common/.config/claude/*; do
            if [[ -e "$file" ]]; then
                basename_file=$(basename "$file")
                if [[ ! -e "common/.claude/$basename_file" ]]; then
                    cp -r "$file" "common/.claude/$basename_file"
                fi
            fi
        done
        # Create any missing subdirectories
        for dir in config ide local output-modes; do
            mkdir -p "common/.claude/$dir"
        done
    fi

    return $errors
}

# Cross-platform realpath implementation
portable_realpath() {
    local path="$1"

    if command_exists realpath; then
        realpath "$path" 2> /dev/null
    elif command_exists greadlink; then
        # macOS with GNU coreutils
        greadlink -f "$path" 2> /dev/null
    else
        # macOS native fallback
        perl -MCwd -e 'print Cwd::abs_path shift' "$path" 2> /dev/null
    fi
}

# Install stow via Homebrew
install_stow() {
    if command_exists stow; then
        log_info "GNU Stow is already installed"
        return 0
    fi

    log_info "Installing GNU Stow..."

    if command_exists brew; then
        brew install stow
    else
        log_info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi

        if command_exists brew; then
            log_success "Homebrew installed successfully"
            brew install stow
        else
            log_error "Failed to install Homebrew. Please install manually: https://brew.sh/"
            exit 1
        fi
    fi

    log_success "GNU Stow installed successfully"
}

# Interactive prompts
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response

    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$question [Y/n]: " response
            response=${response:-y}
        else
            read -p "$question [y/N]: " response
            response=${response:-n}
        fi

        case "$response" in
            [Yy] | [Yy][Ee][Ss])
                return 0
                ;;
            [Nn] | [Nn][Oo])
                return 1
                ;;
            *)
                echo "Please answer yes or no."
                ;;
        esac
    done
}

# Interactive backup selection
interactive_backup_choice() {
    local files_to_backup=(
        ".gitconfig"
        ".zshrc"
        ".bashrc"
        ".vimrc"
        ".tmux.conf"
        ".config/nvim"
        ".config/fish"
        ".config/ghostty"
        ".config/kitty"
        ".config/helix"
        ".config/lazygit"
        ".config/zellij"
        ".config/tmux"
        ".config/mise"
        ".config/claude"
        ".claude"
    )

    local existing_files=()

    # Check which files exist
    log_info "Checking for existing dotfiles..."
    for file in "${files_to_backup[@]}"; do
        local full_path="$HOME/$file"
        if [[ -e "$full_path" ]] && [[ ! -L "$full_path" ]]; then
            existing_files+=("$file")
        fi
    done

    if [[ ${#existing_files[@]} -eq 0 ]]; then
        log_info "No existing dotfiles found that would conflict."
        return 0
    fi

    echo ""
    log_warning "Found ${#existing_files[@]} existing dotfile(s) that would be overwritten:"
    for file in "${existing_files[@]}"; do
        echo "  - $file"
    done
    echo ""

    # Ask for backup choice
    if ask_yes_no "Do you want to backup these files before installation?" "y"; then
        return 0 # Yes, backup
    else
        if ask_yes_no "Are you sure you want to proceed WITHOUT backing up? This may overwrite your existing configs!" "n"; then
            return 1 # No backup, but proceed
        else
            log_info "Installation cancelled by user."
            exit 0
        fi
    fi
}

# Backup existing dotfiles
backup_existing_dotfiles() {
    local backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    local files_to_backup=(
        ".gitconfig"
        ".zshrc"
        ".bashrc"
        ".vimrc"
        ".tmux.conf"
        ".config/nvim"
        ".config/fish"
        ".config/ghostty"
        ".config/kitty"
        ".config/helix"
        ".config/lazygit"
        ".config/zellij"
        ".config/tmux"
        ".config/mise"
        ".config/claude"
        ".claude"
    )

    local backup_created=false

    log_info "Checking for existing dotfiles to backup..."

    for file in "${files_to_backup[@]}"; do
        local full_path="$HOME/$file"

        # Check if file/directory exists and is not a symlink managed by stow
        if [[ -e "$full_path" ]] && [[ ! -L "$full_path" ]]; then
            # Create backup directory on first file found
            if [[ "$backup_created" == "false" ]]; then
                mkdir -p "$backup_dir"
                backup_created=true
                log_info "Creating backup directory: $backup_dir"
            fi

            # Backup the file/directory
            local backup_path="$backup_dir/$file"
            mkdir -p "$(dirname "$backup_path")"

            if [[ -d "$full_path" ]]; then
                cp -r "$full_path" "$backup_path"
                rm -rf "$full_path"
                log_info "Backed up and removed directory: $file"
            else
                cp "$full_path" "$backup_path"
                rm "$full_path"
                log_info "Backed up and removed file: $file"
            fi
        fi
    done

    if [[ "$backup_created" == "true" ]]; then
        log_success "Backup completed: $backup_dir"
        log_info "Backed up files are hidden (start with .). Use 'ls -la $backup_dir' to see them."
        log_info "You can restore files with: cp -r $backup_dir/.* ~/ (be careful with . and ..)"
    else
        log_info "No existing dotfiles found to backup"
    fi
}

# Interactive package selection
interactive_package_choice() {
    local packages_to_install=()

    echo "" >&2
    log_info "Available package groups for installation:" >&2
    echo "  1. common     - Cross-platform configs (nvim, fish, git, etc.)" >&2
    echo "  2. macos      - macOS-specific configs" >&2
    echo "" >&2

    if ask_yes_no "Install common (cross-platform) configurations?" "y"; then
        packages_to_install+=("common")
    fi

    if ask_yes_no "Install macOS-specific configurations?" "y"; then
        packages_to_install+=("macos")
    fi

    if [[ ${#packages_to_install[@]} -eq 0 ]]; then
        log_warning "No packages selected for installation." >&2
        if ask_yes_no "Exit without installing anything?" "y"; then
            log_info "Installation cancelled by user." >&2
            exit 0
        else
            # Recurse to ask again
            interactive_package_choice
            return
        fi
    fi

    echo "${packages_to_install[@]}"
}

# Stow packages
stow_packages() {
    local skip_backup="${1:-false}"
    local interactive="${2:-false}"
    local simulate="${3:-false}"

    if [[ "$simulate" == "true" ]]; then
        log_info "SIMULATION MODE: Stowing packages for macOS (dry run)..."
    else
        log_info "Stowing packages for macOS..."
    fi

    # Change to dotfiles directory
    cd "$(dirname "$0")"

    # Validate environment before proceeding (skip in simulation mode)
    if [[ "$simulate" != "true" ]]; then
        if ! validate_stow_environment; then
            log_error "Environment validation failed. Aborting installation."
            return 1
        fi
    fi

    # Interactive backup choice if not skipped and interactive mode
    if [[ "$skip_backup" != "true" && "$interactive" == "true" && "$simulate" != "true" ]]; then
        if interactive_backup_choice; then
            backup_existing_dotfiles
        fi
    elif [[ "$skip_backup" != "true" && "$simulate" != "true" ]]; then
        backup_existing_dotfiles
    elif [[ "$simulate" == "true" ]]; then
        log_info "SIMULATION: Would backup existing dotfiles (skipped in dry run)"
    fi

    # Interactive package selection
    if [[ "$interactive" == "true" ]]; then
        local packages_string
        packages_string=$(interactive_package_choice)
        local packages=($packages_string)

        for package in "${packages[@]}"; do
            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION: Would stow $package configurations..."
                stow -t "$HOME" -nv --ignore='.*\.DS_Store.*' "$package"
            else
                log_info "Stowing $package configurations..."
                stow -t "$HOME" -v --ignore='.*\.DS_Store.*' --adopt "$package"
            fi
        done
    else
        # Non-interactive: install both common and macOS-specific
        if [[ "$simulate" == "true" ]]; then
            log_info "SIMULATION: Would stow common configurations..."
            stow -t "$HOME" -nv --ignore='.*\.DS_Store.*' common

            log_info "SIMULATION: Would stow macOS-specific configurations..."
            stow -t "$HOME" -nv --ignore='.*\.DS_Store.*' macos
        else
            log_info "Stowing common configurations..."
            stow -t "$HOME" -v --ignore='.*\.DS_Store.*' --adopt common

            log_info "Stowing macOS-specific configurations..."
            stow -t "$HOME" -v --ignore='.*\.DS_Store.*' --adopt macos
        fi
    fi

    log_success "All selected packages stowed successfully!"

    # Run stow verification check
    local script_dir="$(dirname "$0")"
    if [[ -x "$script_dir/scripts/check-stow.sh" && "$simulate" != "true" ]]; then
        echo ""
        log_info "Running stow verification check..."
        "$script_dir/scripts/check-stow.sh" || true # Don't fail install on check failure
    fi

    # Setup fish plugins if fish config was stowed
    if [[ "$simulate" != "true" ]]; then
        if [[ -f "$HOME/.config/fish/fish_plugins" ]] && command_exists fish; then
            echo ""
            log_info "Setting up fish plugins..."
            setup_fish_plugins || {
                log_warning "Fish plugins setup failed. You can run it manually later: $script_dir/scripts/setup-fish-plugins.sh"
            }
        fi
    fi
}

# Helper function to detect and clean orphaned dotfiles symlinks
cleanup_orphaned_symlinks() {
    log_info "Cleaning up orphaned dotfiles symlinks..."

    local orphans_found=false
    local dotfiles_dir="$(pwd)"

    # Function to check if a symlink points to our dotfiles directory
    is_dotfiles_symlink() {
        local symlink="$1"
        local target resolved_target

        target=$(readlink "$symlink" 2> /dev/null) || return 1

        # Convert to absolute path if relative
        if [[ "$target" == /* ]]; then
            # Already absolute
            resolved_target="$target"
        else
            # Convert relative to absolute using our portable function
            resolved_target="$(cd "$(dirname "$symlink")" 2> /dev/null && portable_realpath "$target")" || return 1
        fi

        # Check if target is within our dotfiles directory
        [[ "$resolved_target" == "$dotfiles_dir"* ]]
    }

    # Find and clean orphaned symlinks in common locations
    local search_paths=(
        "$HOME/.config"
        "$HOME"
    )

    for search_path in "${search_paths[@]}"; do
        if [[ -d "$search_path" ]]; then
            while IFS= read -r -d '' symlink; do
                if is_dotfiles_symlink "$symlink" && [[ ! -e "$symlink" ]]; then
                    log_info "Removing orphaned symlink: $symlink"
                    rm "$symlink" 2> /dev/null || true
                    orphans_found=true
                fi
            done < <(find "$search_path" -maxdepth 3 -type l -print0 2> /dev/null)
        fi
    done

    # Clean up empty directories
    find "$HOME/.config" -type d -empty 2> /dev/null | while read -r empty_dir; do
        if [[ "$empty_dir" != "$HOME/.config" ]]; then
            log_info "Removing empty directory: $empty_dir"
            rmdir "$empty_dir" 2> /dev/null || true
        fi
    done

    if [[ "$orphans_found" == "false" ]]; then
        log_info "No orphaned dotfiles symlinks found"
    fi
}

# Enhanced unstow packages with fallback cleanup
unstow_packages() {
    log_info "Unstowing packages for macOS..."
    cd "$(dirname "$0")"

    # First, try regular stow unstow for packages that exist
    local unstow_success=true

    # Unstow in reverse order with verbose output and explicit target
    log_info "Unstowing macOS-specific configurations..."
    if [[ -d "macos" ]]; then
        if stow -t "$HOME" -Dv --ignore='.*\.DS_Store.*' macos 2> /dev/null; then
            log_success "macOS configurations unstowed successfully"
        else
            log_warning "Some macOS configurations may not have been fully unstowed"
            unstow_success=false
        fi
    else
        log_warning "Package directory 'macos' not found, skipping stow unstow"
        unstow_success=false
    fi

    log_info "Unstowing common configurations..."
    if [[ -d "common" ]]; then
        if stow -t "$HOME" -Dv --ignore='.*\.DS_Store.*' common 2> /dev/null; then
            log_success "Common configurations unstowed successfully"
        else
            log_warning "Some common configurations may not have been fully unstowed"
            unstow_success=false
        fi
    else
        log_warning "Package directory 'common' not found, skipping stow unstow"
        unstow_success=false
    fi

    # Fallback: Clean up any orphaned symlinks that stow couldn't handle
    if [[ "$unstow_success" == "false" ]]; then
        log_info "Running fallback cleanup for orphaned symlinks..."
        cleanup_orphaned_symlinks
    fi

    log_success "Unstow process completed!"
}

# Get available apps for stowing
get_available_apps() {
    local apps=()

    # Check common apps
    if [[ -d "common/.config" ]]; then
        for app_dir in common/.config/*/; do
            if [[ -d "$app_dir" ]]; then
                local app_name=$(basename "$app_dir")
                apps+=("$app_name")
            fi
        done
    fi

    # Check macOS-specific apps
    if [[ -d "macos/.config" ]]; then
        for app_dir in macos/.config/*/; do
            if [[ -d "$app_dir" ]]; then
                local app_name=$(basename "$app_dir")
                apps+=("$app_name")
            fi
        done
    fi


    # Remove duplicates and sort
    printf '%s\n' "${apps[@]}" | sort -u
}

# Validate app name
validate_app() {
    local app_name="$1"
    local available_apps

    available_apps=($(get_available_apps))

    for available_app in "${available_apps[@]}"; do
        if [[ "$available_app" == "$app_name" ]]; then
            return 0
        fi
    done

    return 1
}

# Stow a specific app
stow_app() {
    local app_name="$1"
    local simulate="${2:-false}"

    # Change to dotfiles directory
    cd "$(dirname "$0")"

    # Check package dependencies before stowing
    if [[ "$simulate" != "true" ]]; then
        if ! check_app_dependencies "$app_name"; then
            log_warning "Consider installing missing dependencies before using $app_name"
        fi
    fi

    if [[ "$simulate" == "true" ]]; then
        log_info "SIMULATION: Would stow $app_name configuration..."
    else
        log_info "Stowing $app_name configuration..."
    fi

    local stowed=false

    # Helper function to create symlink directly for individual app
    stow_app_config() {
        local package="$1"
        local simulate_flag="$2"
        local app_config_path="$package/.config/$app_name"
        local target_path="$HOME/.config/$app_name"
        local dotfiles_dir="$(pwd)"

        if [[ ! -d "$app_config_path" ]]; then
            return 1
        fi

        # Calculate relative path from target to source
        local relative_path="../.dotfiles/$app_config_path"

        if [[ "$simulate_flag" == "true" ]]; then
            log_info "SIMULATION: Would create symlink $target_path -> $relative_path"
        else
            # Create .config directory if it doesn't exist
            mkdir -p "$(dirname "$target_path")"

            # Remove existing file/directory if it exists
            if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
                if [[ -d "$target_path" ]] && [[ ! -L "$target_path" ]]; then
                    log_info "Backing up existing directory: $target_path -> ${target_path}_backup_$(date +%Y%m%d_%H%M%S)"
                    mv "$target_path" "${target_path}_backup_$(date +%Y%m%d_%H%M%S)"
                else
                    log_info "Removing existing file/symlink: $target_path"
                    rm -rf "$target_path"
                fi
            fi

            # Create the symlink
            ln -s "$relative_path" "$target_path"
            log_info "LINK: .config/$app_name -> $relative_path"
        fi

        return 0
    }

    # Check if app exists in common
    if [[ -d "common/.config/$app_name" ]]; then
        if [[ "$simulate" == "true" ]]; then
            log_info "SIMULATION: Would stow common/$app_name..."
            stow_app_config "common" "true"
        else
            log_info "Stowing common/$app_name..."
            stow_app_config "common" "false"
        fi
        stowed=true
    fi

    # Check if app exists in macOS-specific (will override common if exists)
    if [[ -d "macos/.config/$app_name" ]]; then
        if [[ "$simulate" == "true" ]]; then
            log_info "SIMULATION: Would stow macos/$app_name..."
            stow_app_config "macos" "true"
        else
            log_info "Stowing macos/$app_name..."
            stow_app_config "macos" "false"
        fi
        stowed=true
    fi


    if [[ "$stowed" == "true" ]]; then
        log_success "$app_name configuration stowed successfully!"
    else
        log_error "$app_name configuration not found for macOS"
        return 1
    fi
}

# Unstow a specific app
unstow_app() {
    local app_name="$1"
    local simulate="${2:-false}"

    # Change to dotfiles directory
    cd "$(dirname "$0")"

    if [[ "$simulate" == "true" ]]; then
        log_info "SIMULATION: Would unstow $app_name configuration..."
    else
        log_info "Unstowing $app_name configuration..."
    fi

    local unstowed=false

    # Remove specific app symlinks from common
    if [[ -d "common/.config/$app_name" ]]; then
        local target_path="$HOME/.config/$app_name"
        if [[ -L "$target_path" ]]; then
            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION: Would remove $target_path"
            else
                log_info "Removing symlink: $target_path"
                rm "$target_path"
            fi
            unstowed=true
        fi
    fi

    # Remove specific app symlinks from macOS-specific
    if [[ -d "macos/.config/$app_name" ]]; then
        local target_path="$HOME/.config/$app_name"
        if [[ -L "$target_path" ]]; then
            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION: Would remove $target_path"
            else
                log_info "Removing symlink: $target_path"
                rm "$target_path"
            fi
            unstowed=true
        fi
    fi

    # Handle special macOS apps with root-level configs
    case "$app_name" in
        tmux)
            # Special handling for tmux which has multiple symlinks
            local tmux_files=("$HOME/.tmux.conf" "$HOME/.tmux.conf.local")
            for tmux_file in "${tmux_files[@]}"; do
                if [[ -L "$tmux_file" ]]; then
                    if [[ "$simulate" == "true" ]]; then
                        log_info "SIMULATION: Would remove $tmux_file"
                    else
                        log_info "Removing symlink: $tmux_file"
                        rm "$tmux_file"
                    fi
                    unstowed=true
                fi
            done
            ;;
    esac

    if [[ "$unstowed" == "true" ]]; then
        log_success "$app_name configuration unstowed successfully!"
    else
        log_warning "$app_name configuration was not found or already unstowed for macOS"

        # Check if config exists in filesystem and suggest manual removal
        local config_exists=false
        local manual_remove_paths=()

        # Check common config location
        if [[ -d "$HOME/.config/$app_name" ]] && [[ ! -L "$HOME/.config/$app_name" ]]; then
            config_exists=true
            manual_remove_paths+=("$HOME/.config/$app_name")
        fi


        if [[ "$config_exists" == "true" ]]; then
            log_info "Found non-symlink $app_name configuration in your home directory."
            log_info "To manually remove config files, run:"
            for path in "${manual_remove_paths[@]}"; do
                if [[ -d "$path" ]]; then
                    echo "  rm -rf \"$path\""
                else
                    echo "  rm \"$path\""
                fi
            done
        fi

        # Suggest package removal via Homebrew
        local pkg_name=""

        # Map app names to package names
        case "$app_name" in
            waybar) pkg_name="waybar" ;;
            nvim) pkg_name="neovim" ;;
            fish) pkg_name="fish" ;;
            tmux) pkg_name="tmux" ;;
            zellij) pkg_name="zellij" ;;
            kitty) pkg_name="kitty" ;;
            ghostty) pkg_name="ghostty" ;;
            rofi) pkg_name="rofi" ;;
        esac

        if [[ -n "$pkg_name" ]]; then
            if command_exists brew; then
                echo ""
                log_info "To remove the $app_name package, run:"
                echo "  brew uninstall $pkg_name"
            fi
        fi
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 [install|uninstall|restow|stow-app|unstow-app|tools|fonts|fish|fish-plugins|zellij|mcp|submodules|all|backup|cleanup|status]"
    echo ""
    echo "Commands:"
    echo "  install           - Install dotfiles only (default)"
    echo "  uninstall [app]   - Remove all dotfiles symlinks or specific app (e.g., nvim)"
    echo "  restow            - Remove and reinstall dotfiles"
    echo "  stow-app <app>    - Stow a specific app configuration (e.g., tmux, nvim)"
    echo "  unstow-app <app>  - Unstow a specific app configuration"
    echo "  tools             - Install development tools with mise"
    echo "  fonts             - Install Maple Mono Nerd Font and Font Awesome"
    echo "  fish              - Install Fish shell and set as default shell"
    echo "  fish-plugins      - Setup Fish shell plugins (Fisher and Pure theme)"
    echo "  zellij            - Install Zellij terminal multiplexer"
    echo "  mcp               - Setup MCP servers for Claude"
    echo "  submodules        - Update git submodules"
    echo "  all               - Install dotfiles, tools, and update submodules"
    echo "  backup            - Backup existing dotfiles only"
    echo "  cleanup           - Remove orphaned dotfiles symlinks"
    echo "  status            - Show current dotfiles installation status"
    echo ""
    echo "Options:"
    echo "  --with-tools     - Install tools along with dotfiles"
    echo "  --update-subs    - Update submodules along with dotfiles"
    echo "  --no-backup      - Skip backing up existing dotfiles"
    echo "  --interactive    - Interactive mode with prompts for choices"
    echo "  --simulate       - Dry run - show what would be done without doing it"
    echo ""
    echo "Examples:"
    echo "  $0 stow-app tmux                # Stow only tmux configuration"
    echo "  $0 uninstall nvim               # Remove nvim configuration symlinks"
    echo "  $0 unstow-app tmux              # Remove tmux configuration symlinks"
    echo "  $0 stow-app nvim --simulate     # Preview nvim stowing without changes"
    echo "  $0 uninstall nvim --simulate    # Preview nvim unstowing without changes"
    echo ""
    echo "This script will automatically detect macOS and install appropriate configs."
    echo "By default, existing dotfiles are backed up before installation."
    echo "Use --interactive for guided installation with user prompts."
    echo "Use --simulate to preview changes before applying them."
}

# Install fonts required for terminal applications
install_fonts() {
    log_info "Installing required fonts..."

    # Check if Homebrew is available
    if ! command_exists brew; then
        log_error "Homebrew is required for font installation on macOS"
        return 1
    fi

    # Install Maple Mono Nerd Font
    if brew list --cask font-maple-mono-nf > /dev/null 2>&1; then
        log_info "Maple Mono Nerd Font is already installed"
    else
        log_info "Installing Maple Mono Nerd Font via Homebrew..."
        if brew install --cask font-maple-mono-nf; then
            log_success "Maple Mono Nerd Font installed successfully"
        else
            log_error "Failed to install Maple Mono Nerd Font via Homebrew"
            return 1
        fi
    fi

    # Install Font Awesome
    if brew list --cask font-fontawesome > /dev/null 2>&1; then
        log_info "Font Awesome is already installed"
    else
        log_info "Installing Font Awesome via Homebrew..."
        if brew install --cask font-fontawesome; then
            log_success "Font Awesome installed successfully"
        else
            log_warning "Failed to install Font Awesome"
        fi
    fi
}

# Install development tools
install_tools() {
    log_info "Installing development tools..."
    local script_dir="$(dirname "$0")"

    if [[ -x "$script_dir/scripts/install-tools.sh" ]]; then
        "$script_dir/scripts/install-tools.sh"
    else
        log_error "install-tools.sh script not found or not executable"
        return 1
    fi
}

# Install Fish shell
install_fish() {
    # Check if fish is already installed
    if command_exists fish; then
        log_info "Fish shell is already installed"
    else
        log_info "Installing Fish shell..."
        if command_exists brew; then
            brew install fish
        else
            log_error "Homebrew is not installed. Please install Homebrew first:"
            log_error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            log_error "Then run: brew install fish"
            return 1
        fi
        log_success "Fish shell installed successfully"
    fi

    # Change default shell to fish
    local fish_path
    fish_path=$(command -v fish)

    if [[ -n "$fish_path" ]]; then
        # Check if fish is in /etc/shells
        if ! grep -q "^$fish_path$" /etc/shells 2> /dev/null; then
            log_info "Adding fish to /etc/shells..."
            echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
        fi

        # Check if fish is already the default shell
        if [[ "$SHELL" == "$fish_path" ]]; then
            log_info "Fish is already the default shell"
        else
            log_info "Changing default shell to fish..."
            if chsh -s "$fish_path"; then
                log_success "Default shell changed to fish"
                log_info "Please restart your terminal or log out and back in for the change to take effect"
            else
                log_warning "Failed to change default shell. You can manually run: chsh -s $fish_path"
            fi
        fi
    else
        log_error "Fish shell not found in PATH"
        return 1
    fi

    log_info "Fish plugins will be setup after dotfiles are stowed"
}

# Setup fish plugins after dotfiles installation
setup_fish_plugins() {
    log_info "Setting up fish plugins..."
    local script_dir="$(dirname "$0")"

    if [[ -x "$script_dir/scripts/setup-fish-plugins.sh" ]]; then
        "$script_dir/scripts/setup-fish-plugins.sh"
    else
        log_error "setup-fish-plugins.sh script not found or not executable"
        log_info "You can manually setup fish plugins after stowing fish config"
        return 1
    fi
}

# Install Zellij terminal multiplexer
install_zellij() {
    # Check if zellij is already installed
    if command_exists zellij; then
        log_info "Zellij is already installed"
        log_info "Version: $(zellij --version)"
        return 0
    fi

    log_info "Installing Zellij..."
    if command_exists brew; then
        brew install zellij
    else
        log_error "Homebrew is not installed. Please install Homebrew first:"
        log_error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        log_error "Then run: brew install zellij"
        return 1
    fi

    if command_exists zellij; then
        log_success "Zellij installed successfully"
        log_info "Version: $(zellij --version)"
    else
        log_error "Zellij installation failed"
        return 1
    fi
}

# Setup MCP servers for Claude
setup_mcp_servers() {
    log_info "Setting up MCP servers for Claude..."
    local script_dir="$(dirname "$0")"

    if [[ -x "$script_dir/scripts/setup-mcp-servers.sh" ]]; then
        "$script_dir/scripts/setup-mcp-servers.sh"
    else
        log_error "setup-mcp-servers.sh script not found or not executable"
        return 1
    fi
}

# Update git submodules
update_submodules() {
    log_info "Updating git submodules..."
    local script_dir="$(dirname "$0")"

    if [[ -x "$script_dir/scripts/update-submodules.sh" ]]; then
        "$script_dir/scripts/update-submodules.sh"
    else
        log_error "update-submodules.sh script not found or not executable"
        return 1
    fi
}

# Show comprehensive dotfiles status
show_dotfiles_status() {
    local platform="$1"

    cd "$(dirname "$0")" || {
        log_error "Cannot access dotfiles directory"
        return 1
    }

    echo "Dotfiles Status Report"
    echo "======================"
    echo "Platform: $platform"
    echo "Dotfiles directory: $(pwd)"
    echo "Timestamp: $(date)"
    echo ""

    # System information
    echo "System Information:"
    echo "  OS: $(uname -s) $(uname -r)"
    echo "  Architecture: $(uname -m)"
    echo "  Shell: $SHELL"
    echo "  User: $USER"
    echo "  Home: $HOME"
    echo ""

    # Stow availability
    echo "Tools Status:"
    if command_exists stow; then
        echo "  ✓ GNU Stow: $(stow --version | head -1)"
    else
        echo "  ✗ GNU Stow: Not installed"
    fi

    if command_exists git; then
        echo "  ✓ Git: $(git --version)"
    else
        echo "  ✗ Git: Not installed"
    fi
    echo ""

    # Font status
    echo "Font Status:"
    if command_exists fc-list; then
        local maple_check=$(fc-list 2> /dev/null | grep -i "maple" | grep -i "mono" | grep -i "nf" | wc -l)
        if [[ $maple_check -gt 0 ]]; then
            echo "  ✓ Maple Mono Nerd Font: Installed"
        else
            echo "  ✗ Maple Mono Nerd Font: Not installed"
            echo "     Run: ./install.sh fonts"
        fi
    else
        echo "  (font check unavailable)"
    fi
    echo ""

    # Package directories status
    echo "Package Directories:"
    for pkg in "common" "macos"; do
        if [[ -d "$pkg" ]]; then
            local app_count=$(find "$pkg/.config" -mindepth 1 -maxdepth 1 -type d 2> /dev/null | wc -l)
            echo "  ✓ $pkg: $app_count applications"
        else
            echo "  ✗ $pkg: Directory not found"
        fi
    done

    echo ""

    # Symlinks status
    echo "Symlinks Status:"
    local total_links=0 valid_links=0 broken_links=0

    # Check common config locations
    for config_dir in "$HOME/.config"/*; do
        if [[ -L "$config_dir" ]]; then
            ((total_links++))
            if [[ -e "$config_dir" ]]; then
                local target=$(portable_realpath "$config_dir")
                if [[ "$target" == "$(pwd)"* ]]; then
                    ((valid_links++))
                fi
            else
                ((broken_links++))
            fi
        fi
    done

    # Check root-level configs
    for config in .gitconfig .zshrc .bashrc .vimrc .claude; do
        if [[ -L "$HOME/$config" ]]; then
            ((total_links++))
            if [[ -e "$HOME/$config" ]]; then
                local target=$(portable_realpath "$HOME/$config")
                if [[ "$target" == "$(pwd)"* ]]; then
                    ((valid_links++))
                fi
            else
                ((broken_links++))
            fi
        fi
    done

    echo "  Total symlinks: $total_links"
    echo "  Valid dotfiles links: $valid_links"
    echo "  Broken links: $broken_links"

    if [[ $broken_links -gt 0 ]]; then
        echo ""
        echo "Recommendations:"
        echo "  - Run './install.sh cleanup' to remove broken symlinks"
        echo "  - Run './install.sh restow' to reinstall dotfiles"
    fi

    # Git status if in repo
    if [[ -d ".git" ]]; then
        echo ""
        echo "Git Repository Status:"
        if git status --porcelain | grep -q .; then
            echo "  (Uncommitted changes detected)"
        else
            echo "  ✓ Repository clean"
        fi

        local branch=$(git branch --show-current 2> /dev/null || echo "unknown")
        local commit=$(git rev-parse --short HEAD 2> /dev/null || echo "unknown")
        echo "  Branch: $branch"
        echo "  Commit: $commit"
    fi
}

# Parse command line arguments
parse_args() {
    local with_tools=false
    local update_subs=false
    local no_backup=false
    local interactive=false
    local simulate=false

    for arg in "$@"; do
        case "$arg" in
            --with-tools)
                with_tools=true
                ;;
            --update-subs)
                update_subs=true
                ;;
            --no-backup)
                no_backup=true
                ;;
            --interactive)
                interactive=true
                ;;
            --simulate)
                simulate=true
                ;;
        esac
    done

    echo "$with_tools $update_subs $no_backup $interactive $simulate"
}

# Get the app name from arguments (skipping command and options)
get_app_name() {
    local found_command=false

    for arg in "$@"; do
        case "$arg" in
            stow-app | unstow-app | uninstall)
                found_command=true
                ;;
            --*)
                # Skip options
                ;;
            *)
                if [[ "$found_command" == "true" ]]; then
                    echo "$arg"
                    return 0
                fi
                ;;
        esac
    done

    echo ""
}

# Main function
main() {
    local command="${1:-install}"
    local platform
    local args

    # Parse additional arguments
    args=($(parse_args "$@"))
    local with_tools="${args[0]}"
    local update_subs="${args[1]}"
    local no_backup="${args[2]}"
    local interactive="${args[3]}"
    local simulate="${args[4]}"

    case "$command" in
        stow-app)
            local app_name
            app_name=$(get_app_name "$@")

            if [[ -z "$app_name" ]]; then
                log_error "App name required for stow-app command"
                echo ""
                echo "Available apps:"
                get_available_apps | sed 's/^/  - /'
                echo ""
                show_usage
                exit 1
            fi

            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if ! validate_app "$app_name"; then
                log_error "App '$app_name' not found"
                echo ""
                echo "Available apps:"
                get_available_apps | sed 's/^/  - /'
                exit 1
            fi

            if [[ "$simulate" != "true" ]]; then
                install_stow
            fi

            stow_app "$app_name" "$simulate"
            ;;
        unstow-app)
            local app_name
            app_name=$(get_app_name "$@")

            if [[ -z "$app_name" ]]; then
                log_error "App name required for unstow-app command"
                echo ""
                echo "Available apps:"
                get_available_apps | sed 's/^/  - /'
                echo ""
                show_usage
                exit 1
            fi

            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if ! validate_app "$app_name"; then
                log_error "App '$app_name' not found"
                echo ""
                echo "Available apps:"
                get_available_apps | sed 's/^/  - /'
                exit 1
            fi

            unstow_app "$app_name" "$simulate"
            ;;
        install)
            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION MODE: No actual changes will be made"
            else
                install_stow
            fi

            # Interactive mode prompts
            if [[ "$interactive" == "true" ]]; then
                echo ""
                if [[ "$simulate" == "true" ]]; then
                    log_info "=== Simulation + Interactive Installation Mode ==="
                else
                    log_info "=== Interactive Installation Mode ==="
                fi

                # Ask about additional components in interactive mode
                if [[ "$with_tools" != "true" ]] && ask_yes_no "Install development tools with mise?" "n"; then
                    with_tools=true
                fi

                if [[ "$update_subs" != "true" ]] && ask_yes_no "Update git submodules (editor configs)?" "n"; then
                    update_subs=true
                fi
            fi

            stow_packages "$no_backup" "$interactive" "$simulate"

            # Handle additional options
            if [[ "$with_tools" == "true" ]]; then
                if [[ "$simulate" == "true" ]]; then
                    log_info "SIMULATION: Would install development tools with mise"
                else
                    install_tools
                fi
            fi
            if [[ "$update_subs" == "true" ]]; then
                if [[ "$simulate" == "true" ]]; then
                    log_info "SIMULATION: Would update git submodules"
                else
                    update_submodules
                fi
            fi
            ;;
        uninstall)
            # Check if an app name is provided for per-app uninstall
            local app_name
            app_name=$(get_app_name "$@")

            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if [[ -n "$app_name" ]]; then
                # Per-app uninstall
                if ! validate_app "$app_name"; then
                    log_error "App '$app_name' not found"
                    echo ""
                    echo "Available apps:"
                    get_available_apps | sed 's/^/  - /'
                    exit 1
                fi
                unstow_app "$app_name" "$simulate"
            else
                # Full uninstall
                unstow_packages
            fi
            ;;
        restow)
            platform=$(detect_platform)
            log_info "Detected platform: $platform"
            unstow_packages
            stow_packages "true" # Skip backup on restow
            ;;
        backup)
            backup_existing_dotfiles
            ;;
        cleanup)
            cd "$(dirname "$0")"
            cleanup_orphaned_symlinks
            ;;
        status)
            platform=$(detect_platform)
            show_dotfiles_status "$platform"
            ;;
        tools)
            install_tools
            ;;
        fonts)
            install_fonts
            ;;
        fish)
            log_info "Detected platform: macOS"
            install_fish
            log_info "Fish plugins will be setup automatically when you run './install.sh install'"
            ;;
        fish-plugins)
            setup_fish_plugins
            ;;
        zellij)
            log_info "Detected platform: macOS"
            install_zellij
            ;;
        mcp)
            setup_mcp_servers
            ;;
        submodules)
            update_submodules
            ;;
        all)
            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION MODE: Complete setup (dry run)"
                log_info "SIMULATION: Would install GNU Stow"
                stow_packages "$no_backup" "$interactive" "$simulate"
                log_info "SIMULATION: Would install development tools"
                log_info "SIMULATION: Would update git submodules"
            else
                install_stow
                stow_packages "$no_backup" "$interactive" "$simulate"
                install_tools
                update_submodules
            fi
            ;;
        -h | --help | help)
            show_usage
            exit 0
            ;;
        --simulate | --interactive | --no-backup | --with-tools | --update-subs)
            # Handle options passed as main command - default to install
            log_info "Detected option as command, defaulting to 'install'"
            platform=$(detect_platform)
            log_info "Detected platform: $platform"

            if [[ "$simulate" == "true" ]]; then
                log_info "SIMULATION MODE: No actual changes will be made"
            else
                install_stow
            fi

            # Interactive mode prompts
            if [[ "$interactive" == "true" ]]; then
                echo ""
                if [[ "$simulate" == "true" ]]; then
                    log_info "=== Simulation + Interactive Installation Mode ==="
                else
                    log_info "=== Interactive Installation Mode ==="
                fi

                # Ask about additional components in interactive mode
                if [[ "$with_tools" != "true" ]] && ask_yes_no "Install development tools with mise?" "n"; then
                    with_tools=true
                fi

                if [[ "$update_subs" != "true" ]] && ask_yes_no "Update git submodules (editor configs)?" "n"; then
                    update_subs=true
                fi
            fi

            stow_packages "$no_backup" "$interactive" "$simulate"

            # Handle additional options
            if [[ "$with_tools" == "true" ]]; then
                if [[ "$simulate" == "true" ]]; then
                    log_info "SIMULATION: Would install development tools with mise"
                else
                    install_tools
                fi
            fi
            if [[ "$update_subs" == "true" ]]; then
                if [[ "$simulate" == "true" ]]; then
                    log_info "SIMULATION: Would update git submodules"
                else
                    update_submodules
                fi
            fi
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
