#!/usr/bin/env zsh

local -a bin_dirs
bin_dirs=(
	~/.bin
)

local -a app_dirs
app_dirs=(~/.app/*(N-/))
for app_dir in $app_dirs; do
	if [[ -d $app_dir/bin ]]; then
		bin_dirs+=$app_dir/bin
	elif [[ -d $app_dir/.bin ]]; then
		bin_dirs+=$app_dir/.bin
	else
		bin_dirs+=$app_dir
	fi
done

path=($bin_dirs $path)

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
