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
	elif [[ -d $app_dir/sbin ]]; then
		bin_dirs+=$app_dir/sbin
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

export LANG='en_US.UTF-8'
export LC_COLLATE='C.UTF-8'
export LC_TIME='en_DK.UTF-8'

export EDITOR='vim'
export PAGER='less'

export UNZIP='-O cp949 -q'
export ZIPINFO='-O cp949'

export MAKEFLAGS='-j5'
