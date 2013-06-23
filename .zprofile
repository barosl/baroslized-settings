#!/usr/bin/env zsh

local -a bin_dirs
bin_dirs=(
	~/.bin
)

path=($bin_dirs $path)

local -a app_dirs
app_dirs=(~/.app/*(N/))
for dir in $app_dirs; do
	if [[ -d $dir/bin ]]; then
		path+=$dir/bin
	else
		path+=$dir
	fi
done

if [[ "$UID" != 0 ]]; then
	umask 002
else
	umask 022
fi

export EDITOR='vim'
export PAGER='less'

export UNZIP='-O cp949 -q'
export ZIPINFO='-O cp949'

export MAKEFLAGS='-j5'
