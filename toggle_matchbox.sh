#! /bin/sh

if ! (killall matchbox-keyboard >& /dev/null ) ; then
	matchbox-keyboard &
fi
