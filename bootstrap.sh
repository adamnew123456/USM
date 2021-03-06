#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
VERSION=2.4
USM="bin/usm"

FORCE_INSTALL=0

print_usage() {
    echo "Usage: $0 [-h] [-f] [-i PATH]"
    exit 1
}

print_help() {
    echo "Usage: $0 [-h] [-f] [-i PATH]
    Bootstrap script to do install or update the User Software Manager.

Arguments:
    -h
        Prints this page.

    -f
        By default, this bootstrap script will abort if the installation target
        exists. If you want to install USM into an existing directory, then pass
        the -f option to disable the checking.

    -i PATH
        Sets the installation path. By default, the script will first use the
        contents of the current \$USM_PATH variable; if that doesn't exist, then
        the path \$HOME/Apps is used. To use a different path, pass it to this
        script with the -i option.
"
    exit 0
}

while getopts "hfi:" opt; do
    case $opt in
        f)  FORCE_INSTALL=1 ;;
        i)  export USM_PATH="$OPTARG" ;;
        h)  print_help ;;
        \?) print_usage ;;
        :)  print_usage ;;
    esac
done

if [ -z "$USM_PATH" ]; then
    export USM_PATH="$HOME/Apps"
fi

copy_usm() {
    USM_INSTALL_PATH="$1"
    echo "Installing to $USM_INSTALL_PATH..."

    cp -R bin "$USM_INSTALL_PATH"
    mkdir "$USM_INSTALL_PATH/man"
    cp -R man1 "$USM_INSTALL_PATH/man"

    chmod +x "$USM_INSTALL_PATH/bin/usm"
    chmod +x "$USM_INSTALL_PATH/bin/usm-lib-helper"
}

update_install() {
    sh $USM add usm $VERSION
    USM_INSTALL_PATH="$(sh $USM path usm $VERSION)"
    copy_usm "$USM_INSTALL_PATH"

    echo "Setting $VERSION as the default version"
    sh $USM set-current usm $VERSION

    sh $USM copy-script
    echo "**********"
    echo 'You may want to `source ~/.usm-env` in your current shell'
}

fresh_install() {
    sh $USM init
    sh $USM add usm $VERSION
    USM_INSTALL_PATH="$(sh $USM path usm $VERSION)"
    copy_usm "$USM_INSTALL_PATH"

    echo "**********"
    echo 'The USM startup script is now located in $HOME/.usm-env - you should add '
    echo '`source ~/.usm-env` to the end of your shell RC file. If you wish to'
    echo 'begin using USM in this shell, you may source it now.'
}

if [ -e "$USM_PATH/usm/$VERSION" ]; then
    echo "Reinstalling USM $VERSION"
    sh $USM rm usm $VERSION

    update_install
elif [ -e "$USM_PATH/usm" ]; then
    # The user is updating in this case. Copy everything over, including the
    # (possibly changed) startup script and then use the new version by default.
    echo "Updating to USM $VERSION"
    update_install
elif [ -e "$USM_PATH" ]; then
    # If we can't find our previous installation, then assume that the user is 
    # using $USM_PATH for something other than USM.
    if [ $FORCE_INSTALL -eq 1 ]; then
        echo "$USM_PATH isn't empty, but you're forcing my hand here..."
        fresh_install
    else
        echo "Not installing USM into pre-existing directory. Please use"
        echo "the -f option if you really want to do this."
        exit 1
    fi
else
    # Fresh installation, without any issues
    echo "Installing USM to $USM_PATH..."
    fresh_install
fi
