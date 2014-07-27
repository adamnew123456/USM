# USM - The User Software Manager

## Motivation

USM seeks to fill a hole that exists because of the way that software is stored under Linux and other Unix-like systems. Typically, there are two storage locations:

 - `/usr` and `/usr/local` are well-specified, and almost every tool recognizes these as locations where programs are stored. Typically, only administrative users can access these directories.
 - Users have access to their home directories, but software they compile for themselves is typically stored in `~/bin`. It lacks the organization of the `/usr` and `/usr/local` hierarchies, and it is difficult to manage (`dpkg` knows what file `/usr/share/foo/bar/baz` belongs to - do you know what program created the file `~/bin/this/that/the-other`?).

USM is meant to make organizing your personal software easier. __It is not a package manager__ - there are no repositories, no automatic updates, no dependency tracking, etc.
USM will, however, configure you `$PATH` and other variables to make running these programs easy.
It also provides a location to store you programs, which is sensibly organized, rather than stuffing everything under `~/bin`.

## Installation

Before starting, you need to have a Bourne-compatible shell (`zsh`, `bash`, `dash`, etc.) since that is the dialect of shell script that the USM startup script uses. This experimental branch removes the need for a Python installation, since the core utilities are written purely in POSIX shell script.

First, you need to clone the USM source tree:

    git clone git://github.com/adamnew123456/USM

Next, figure out where you want to put your USM applications directory - the default is `~/Apps`.
If not using the default, you'll need to pass it as an argument to the bootstrap script.

    cd USM
    sh boostrap.sh 
    # You can also add the applications directory, if not ~/Apps
    ## sh boostrap.sh usm-apps-directory

At this point, you'll want to add the line `source ~/.usm-env` to load the USM startup script, which configures `$PATH` and other variables.
You should also add the `source ~/.usm-env` line to the end of your shell's RC file, so these variables will be set every time your shell starts.

## Example Usage

The best source of documentation for USM is meant to be the man page - you should be able to run `man usm` (after sourcing `~/.usm-env`, which updates `$MANPATH`).
The man page is mean to be comprehensive, yet understandable - if something is not clear there, raise an issue on GitHub and I'll do my best to fix any ambiguities.

USM also has some built-in documentation, which can be accessed by running `usm help`.

With that in mind, let's walk through installing a very simple program - [GNU Hello](http://www.gnu.org/software/hello).

1. Download the source tarball for GNU Hello, version 2.9, and unpack it in `/tmp/hello`; then, `cd /tmp/hello`.
2. Run `usm add hello 2.9` - this creates a place where GNU Hello can be installed, and also makes 2.9 the default version.
3. Run `./configure --prefix "$(usm path hello 2.9)"` - this tells GNU Hello to install itself into USM.
4. Run `make && make install` to install GNU Hello.
5. Finally, `source ~/.usm-env` and type in `hello`. You should see GNU Hello run.

## Other Tools

USM also comes with `usm-lib-helper`, which help you run programs in USM which need shared libraries.
`man usm-lib-helper` should give you an idea on how to use this tool.

## Contributing

I am always willing to look over any issues or pull requests, so feel free to send them via GitHub (preferably, not by email).

_adamnew123456_
