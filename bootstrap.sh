#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
VERSION=1.1

if [ -e "$HOME/Apps" ]; then
    # The user is updating in this case. Just copy everything over.
    echo "You have an older version of USM installed - answer Y at the next prompt to remove it."
    python2 bin/usm del usm
    rm -f "$OME/Apps/usm--$VERSION"
    cp -R bin ~/Apps/install
    cp -R man ~/Apps/install
    python2 bin/usm add usm $VERSION
else
    # Fresh installation - no problems.
    python2 bin/usm init
    cp -R bin ~/Apps/install
    cp -R man ~/Apps/install
    python2 bin/usm add usm $VERSION
fi
