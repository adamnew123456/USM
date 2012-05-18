#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
python2 bin/usm init
cp -R bin ~/Apps/install
cp -R man ~/Apps/install
python2 bin/usm add usm 1.0
