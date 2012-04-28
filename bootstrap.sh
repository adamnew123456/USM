#!/bin/sh
# Takes the USM that is distributed in the Git repo and
# copies it to the user's ~/Apps.
python bin/usm.py init
cp -R bin ~/Apps/install
cp -R share ~/Apps/install
python bin/usm.py add usm 1.0
