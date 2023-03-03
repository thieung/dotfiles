function av -d AstroNvim
    set -x XDG_CONFIG_HOME ~/.custom_xdg/config
    set -x XDG_DATA_HOME ~/.custom_xdg/data
    set -x XDG_CACHE_HOME ~/.custom_xdg/cache
    nvim $argv
end

function lv -d "My config based on LazyVim"
    set -x XDG_CONFIG_HOME ~/.custom_xdg/config_other
    set -x XDG_DATA_HOME ~/.custom_xdg/data_other
    set -x XDG_CACHE_HOME ~/.custom_xdg/cache_other
    nvim $argv
end

function nv -d "My own nvim"
    unset XDG_CONFIG_HOME
    unset XDG_DATA_HOME
    unset XDG_CACHE_HOME
    nvim $argv
end
