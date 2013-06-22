#!/usr/bin/env zsh

local -a bin_dirs
bin_dirs=(
	~/.bin
)

path=(${(Oa)bin_dirs} $path)

local app_dir=~/.app
if [[ -d $app_dir ]]; then
	for dir in $app_dir/*; do
		path+=$dir/bin
	done
fi

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
