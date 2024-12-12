function nv -d "My config based on AstroNvim"
    unset XDG_CONFIG_HOME
    unset XDG_DATA_HOME
    unset XDG_CACHE_HOME
    nvim $argv
end

function lv -d "My config based on LazyVim"
    set -x XDG_CONFIG_HOME ~/.custom_xdg/config
    set -x XDG_DATA_HOME ~/.custom_xdg/data
    set -x XDG_CACHE_HOME ~/.custom_xdg/cache
    nvim $argv
end

function nc -d "My config based on NvChad"
    set -x XDG_CONFIG_HOME ~/.custom_xdg/config_other
    set -x XDG_DATA_HOME ~/.custom_xdg/data_other
    set -x XDG_CACHE_HOME ~/.custom_xdg/cache_other
    nvim $argv
end

function mkd -d "Create a directory and set CWD"
    command mkdir $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

function load_env_vars -d "Load variables in a .env file"
    for i in (cat $argv)
        set arr (echo $i |tr = \n)
        set -gx $arr[1] $arr[2]
    end
end
