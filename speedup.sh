#!/bin/sh

speedup=15.0

while [ "$1" != "" ]; do
	case $1 in 
		-s | --speedup )
			shift
			speedup="$1"
			;;
		-t | --tiny )
			profile="-profile=atsc_720p_2997"
			;;
		--teensy )
			profile="-profile=vcd_ntsc"
			;;
		-d | --dest )
			shift
			dstdir="$1"
			;;
		* )
			srcdir="$1"
			;;
	esac
	shift
done

if [ -z "$dstdir" ]; then
	dstdir="$srcdir-x$speedup"
fi

if [ ! -d "$dstdir" ]; then
	mkdir -p "$dstdir"
fi

if [ ! -d "$srcdir" ]; then
	echo "You must provide a source directory of video files to convert."
	exit 1
fi

for srcfile in "$srcdir"/*; do
	dstfile="${srcfile##*/}"
	dstfile="${dstfile%.*}.mp4"
	echo Converting $srcfile to $dstdir/$dstfile...
	echo melt $profile -consumer "avformat:$dstdir/$dstfile" "timewarp:$speedup:$srcfile"
done

