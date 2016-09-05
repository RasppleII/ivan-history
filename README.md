# ivan-history

Ivan Drucker did not originally intend for his Raspple II build process to
be used by anyone else but him.  Moreover, he did not have anything like
pi-gen to produce a customized Raspbian distribution with his changes baked
in when he designed it.

He used a custom bash history file which is not the most readable thing ever.
The goal of this repository is to slowly transform these history files into
usable scripts which can be inserted into a bootstrap system like pi-gen or
the live image builder for Debian.


## October 2015 to September 2016

In October 2015 when Ivan wrote his email explaining the Raspbian and
VirtualBox build processes, the history files were quite different than they
are today.  Functionally they do the same thing, however in 2015 they were
written for Debian/Raspbian Wheezy.  They did not support Jessie or systemd in
the slightest.  Fast forward and these scripts now assume and require systemd
and are written for Jessie.  These are for the release feature-completed at
KansasFest 2016.  They could be used with a current Raspbian Jessie release
and dropped into NOOBS, which Ivan should be doing soon.

What we're working on is that release + 1.
