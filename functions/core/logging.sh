# printout formats and echoes a message with a colored prefix determined by the first argument (`error`, `info`, `warning`, `success`, `solution`); if the type is unrecognized it echoes the message unmodified.

function printout {
    local message="$2"
    
    case "$1" in
    error)
        echo -e "\e[30;41;1m\e[1;37m[ERROR]\e[0;31m ${message}\e[0m"
        ;;
    info)
        echo -e "\e[30;44;1m\e[1;37m[INFO]\e[0;38;5;250m ${message}\e[0m"
        ;;
    warning)
        echo -e "\e[30;43;1m\e[1;37m[WARNING]\e[0;38;5;250m ${message}\e[0m"
        ;;
    success)
        echo -e "\e[30;42;1m\e[1;37m[SUCCESS]\e[0;92m ${message}\e[0m"
        ;;
    solution)
        echo -e "\e[30;46;1m\e[1;37m[SOLUTION]\e[0;34m ${message}\e[0m"
        ;;
    *)
        echo "${message}"
        ;;
    esac
}