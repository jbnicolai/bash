OS=$(uname)

if [ "$OS" = "Linux" ]; then
    if [ "$SHLVL" = 1 ]; then
        [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
    fi
elif [ "$OS" = "Darwin" ]; then
    /usr/bin/clear
fi
