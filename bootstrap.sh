#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
python bin/usm init
cp -R bin ~/Apps/install
cp -R man ~/Apps/install
python bin/usm add usm 1.0
