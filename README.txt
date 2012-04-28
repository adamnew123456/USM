USM - The User Software Manager

MOTIVATION
----------

When compiling software for my Linux systems, I've always had two basic issues:

o The default installation point, /usr/local, requires root permissions.
o There is no good way to keep tabs on what you software you have compiled, at what version the software is, and what files it owns.

The first one is easy - compile everything into ~/bin or something of that nature.

The second one is harder - the way that the directory structure is designed under the FHS makes knowing who owns what file and what programs there are tricky.

People have tried to solve this issue before - GoboLinux, for example. However, my experience with Rootless GoboLinux has been... less than stellar. It requires extensive bootstrapping, when all I really wanted to do was to organize the stuff I compile.

Thus, the User Software Manager.

DESIGN
------

The User Software Manager is exactly what it sounds like - it structures all of the software you compile by hand so that it is easy to inspect what software is installed, to install new software into the system, and to remove existing software.

USM, when run for the first time (`usm init`) creates a directory called ~/Apps, as well as a directory below it called ~/Apps/install.

~/Apps/install, is equivalent to a "prefix" in autoconf scripts and Makefiles. So, to compile for the USM, just do  "./configure --prefix=~/Apps/install && make && make install". Autoconf scripts create the correct directory heirarchy, so the USM has to do no work when it creates ~/Apps/install.

When the software is done compiling, run "usm add <software-name> <software-version>". USM takes the directory ~/Apps/install, and moves it to ~/Apps/name-version. USM then creates ~/Apps/install for the installation of more software.

This directory based structure (conceptually taken from GoboLinux) allows for a dramatic reduction in complexity. Instead of having a database listing what packages are installed, the filesystem keeps track. Want to search for a particular peice of software? "usm ls *foo*" simply looks for a directory under ~/Apps which matches the glob *foo*. Removing software? "usm del bar"; again, this deletes a directory under ~/Apps while touching nothing else.
