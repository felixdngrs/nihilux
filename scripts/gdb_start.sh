#!/bin/sh

if [ $# -ge 1 ]; then
	gdb_script=$1
fi

if [ -z "${gdb_script}" ]; then
	echo "error: no filename/pathname passed!"
	exit 1
elif [ ! -f "${gdb_script}" ]; then
	echo "error: the file ${gdb_script} doesn't exist!"
	exit 1
fi

gdb -q -x ${gdb_script}

