#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
VERSION=1.17

if [ -e "$HOME/Apps" ]; then
    # The user is updating in this case. Copy everthing over, including the
    # (possibly changed) startup script and then use the new version by default.
    cp -R bin ~/Apps/install
    cp -R man ~/Apps/install
    python3 bin/usm add usm $VERSION
    python3 bin/usm copy-script
    python3 bin/usm link usm $VERSION
else
    # Fresh installation - no problems.
    python3 bin/usm init
    cp -R bin ~/Apps/install
    cp -R man ~/Apps/install
    python3 bin/usm add usm $VERSION
fi
