#! /bin/sh

# "THE BEER-WARE LICENSE" (Revision 42):
# <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return.

AWK='/usr/bin/awk'
FETCH='/usr/bin/fetch'
GREP='/usr/bin/grep'
PKG='/usr/sbin/pkg'
RM='/bin/rm'
SORT='/usr/bin/sort'

PORTSCOUT='http://portscout.freebsd.org'
TMPFILE=$(mktemp -t $(basename $0)) || exit 1

usage() {
	exec >&2
	echo "usage: $0 [options]"
	echo "options:"
	echo "    -a	do not only list unmaintained ports"
	exit 1
}

FILTER="-e '%m = ports@FreeBSD.org'"
while getopts "a" option ; do
	case $option in
	a)
		FILTER="'-a'"
		;;
	*)	usage
		;;
	esac
done
shift $((OPTIND-1))

eval $PKG query "$FILTER" "'%m %o'" \
	| $AWK '{ print tolower($1), $2 }' \
	| $SORT \
	| while read MAINTAINER PORT ; do
		if [ ${last:-x} != "$MAINTAINER" ] ; then
			last="$MAINTAINER"
			$FETCH -qo - "$PORTSCOUT/${MAINTAINER}.html" 2> /dev/null \
				| $AWK -F '</td>' '
					BEGIN {
						tag_re = "[[:blank:]]*<[^>]*>[[:blank:]]*"
					}

					/class="resultsrowupdated"/ {
						gsub(tag_re, "", $1)
						gsub(tag_re, "", $2)
						gsub(tag_re, "", $3)
						gsub(tag_re, "", $4)
						printf "%s/%s %s %s\n", $2, $1, $3, $4
					}
				' > "$TMPFILE"
		fi

		$GREP "$PORT\>" "$TMPFILE"
	done

$RM "$TMPFILE"
