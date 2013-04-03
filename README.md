# USM - The User Software Manager #

## MOTIVATION ##

When compiling software for my Linux systems, I've always had two basic issues:

 - The default installation point, `/usr/local`, requires root permissions.
 - There is no good way to keep tabs on what you software you have compiled, at what version the software is, and what files it owns.

The first one is easy - compile everything into `~/bin` or something of that nature.

The second one is harder - the way that the directory structure is designed under the FHS makes knowing who owns what file and what programs are installed difficult. 
Package managers handle this on a system level, but all I really needed was an organizational tool that worked as a limited user.

Thus, the User Software Manager.

## DESIGN ##

The User Software Manager is exactly what it sounds like - it structures all of the software you compile by hand so that it is easy to inspect what software is installed, 
to install new software into the system, and to remove existing software.

USM uses the filesystem as an organizational tool - instead of keeping databases (like package managers) on what is installed, 
USM creates a directory which houses only a single piece of software. 
The USM is based somewhat on the ideas of GoboLinux, although USM doesn't handle versioning like GoboLinux does (or at all, really). 
This makes the process of finding out what is installed easy - just list all the directories in `~/Apps`; deletion is also easy - just delete the program's directory.

USM keeps all of the user's software under `~/Apps` - under apps, there are directories for installed software (e.g. foobar--1.2.3b), and a "staging area", called `~/Apps/install`.

When installing software, USM takes the directory `~/Apps/install`, and renames it to whatever the installed software and version is. 
USM then creates a blank `~/Apps/install`, ready for more software.

Finally, USM is __not__ a package manager - it does not install anything for you, and it does not handle updates. 
There are no remote repositories and no precompiled binaries. 
USM is purely an organizational tool. 
Although USM does do some configuration for ease of use (it sets the user's `PATH`, `MANPATH`, and `PKG_CONFIG_PATH`), it does not have any permanent configuration.

## WORKFLOW ##

1st Time: Run `bootstrap.sh` --- this creates `~/Apps`, installs USM under `~/Apps`, and adds a script to the end of your shell startup file to modify your `PATH`.

When Compiling: Set the prefix (e.g. `./configure --prefix ~/Apps/install`) to ensure that the software is installed to the correct location.

After Compiling: Run `usm add software version` to copy the installed software into its own directory.

To Remove Something: Run `usm del foo` - USM prompts you to remove anything that starts with foo.

## RUNNING UNCOOPERATIVE PROGRAMS ##

There are two helper scripts (installed by default with the main USM program) that help in this situation. 
Check out usm-lib-helper(1) and usm-prefix(1) (you have to have unionfs installed to use `usm-prefix`).

If you happen to notice that a shared library is not loading, use `usm-lib-helper`. 
It binds `LD_LIBRARY_PATH` to the lib subdirectory of whatever program you ask it to, allowing shared libraries to be loaded from the proper directory.

If a program cannot access a resource it expects (like a config file) because it is hardcoded into `~/Apps/install`, try usm-prefix. 
It uses a unionfs mount to allow a program's access to `~/Apps/install` to be "redirected" to its own directory.

## INTERESTING USES ##

* Keeping around old symlinks: When using binaries compiled for older systems (which aren't available in package managed form because they lack source code, usually), 
I've used USM to store an fake app called "outdated-libs" which stors all the symlinks which old programs need. 
So, if I need to fake an old version, `usm-lib-helper outdated-libs program` will do it automatically.
