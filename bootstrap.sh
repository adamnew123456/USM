#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
VERSION=2.2-sh
USM="bin/usm"

if [ -n "$1" ]; then
    export USM_PATH="$1"
elif [ -n "$USM_PATH" ]; then
    # No use copying an already-existing environment variable
    :
else
    export USM_PATH="$HOME/Apps"
fi

if [ -e "$USM_PATH/usm" ]; then
    # The user is updating in this case. Copy everthing over, including the
    # (possibly changed) startup script and then use the new version by default.
    sh $USM add usm $VERSION
    USM_INSTALL_PATH="$(sh $USM path usm $VERSION)"
    cp -R bin "$USM_INSTALL_PATH"
    mkdir "$USM_INSTALL_PATH/man"
    cp -R man1 "$USM_INSTALL_PATH/man"
    sh $USM set-current usm $VERSION

    chmod +x "$USM_INSTALL_PATH/bin/usm"
    chmod +x "$USM_INSTALL_PATH/bin/usm-lib-helper"

    sh $USM copy-script
    echo "**********"
    echo 'You may want to `source ~/.usm-env` in your current shell'
elif [ -e "$USM_PATH" ]; then
    # If we can't find our previous installation, then assume that the user is 
    # using $USM_PATH for something other than USM.
    echo "If you would like to use another directory, please pass it as an option"
    echo "to this script. Otherwise, pleace rename or remove $USM_PATH to allow"
    echo "USM to use $USM_PATH for storing its applications. Aborting."
    exit 1
else
    # Fresh installation, without any issues
    echo "Installing USM to $USM_PATH..."
    sh $USM init
    sh $USM add usm $VERSION
    USM_INSTALL_PATH="$(sh $USM path usm $VERSION)"
    cp -R bin "$USM_INSTALL_PATH"
    mkdir "$USM_INSTALL_PATH/man"
    cp -R man1 "$USM_INSTALL_PATH/man"

    chmod +x "$USM_INSTALL_PATH/bin/usm"
    chmod +x "$USM_INSTALL_PATH/bin/usm-lib-helper"

    echo "**********"
    echo 'The USM startup script is now located in $HOME/.usm-env - you should add '
    echo '`source ~/.usm-env` to the end of your shell RC file. If you wish to'
    echo 'begin using USM in this shell, you may source it now.'
fi
