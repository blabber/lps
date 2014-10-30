lps - local portscout
=====================

What is it?
-----------

This is a simple shell script that will display you all outdated (in the sense
that portscout.freebsd.org has found newer distfiles) ports on your machine that
are currently unmaintained.

How to use it?
--------------

Just execute `lps.sh`. It will print all found ports on stdout. The format is:

	<origin> <installed version> <newer version as reported by portscout>

On my machine executing `lps.sh` yields right now:

	> sh lps.sh
	sysutils/fusefs-smbnetfs 0.5.3b 0.5.3

You can use `lps.sh` to show all outdated ports (in the sense  that
portscout.freebsd.org has found newer distfiles) on your machine by executing
`lps.sh -a`.
