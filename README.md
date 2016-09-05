# ivan-history

Ivan Drucker did not originally intend for his Raspple II build process to
be used by anyone else but him.  Moreover, he did not have anything like
pi-gen to produce a customized Raspbian distribution with his changes baked
in when he designed it.

He used a custom bash history file which is not the most readable thing ever.
The goal of this repository is to slowly transform these history files into
usable scripts which can be inserted into a bootstrap system like pi-gen or
the live image builder for Debian.
