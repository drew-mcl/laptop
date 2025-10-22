#!/usr/bin/env zsh
# Author: xezrunner (github.com/xezrunner)
# Credit: DustinGadal on r/Jai
# https://www.reddit.com/r/Jai/comments/jp0vjy/nocheckin_behavior_in_gitsourcetree/gbfhzd1/

# Required programs/utilities for default behavior (as-is):
# git, grep, xargs, awk

# This pre-commit hook/script checks for the existence of the word "$SEARCH_TARGET"
# in your *staged* source files, then aborts the commit if any matches were found.
# It also shows where you have them inside the file.

SEARCH_TARGET="nocheckin"

CL_RED='\e[31m'
CL_BRED='\e[1;31m'
CL_NONE='\e[0m'

MESSAGE_0="${CL_BRED}Error:${CL_NONE} $SEARCH_TARGET(s) were found in "
MESSAGE_1="file(s) - ${CL_BRED}ignoring commit:${CL_NONE}"

SEARCH_CMD="git diff --staged -i --diff-filter=d --name-only -G $SEARCH_TARGET --relative $PWD"

# Get the amount of files that we found the search target in.
# I use 'wc -l' (line count of command output) for this:
STATUS=$(eval $SEARCH_CMD | wc -l)

if ((STATUS > 0)); then
	printf "${MESSAGE_0} %d ${MESSAGE_1}\n" $STATUS;
	eval $SEARCH_CMD | xargs -I{} grep -H $SEARCH_TARGET -n --color=always {} | awk -F: 'BEGIN {OFS=" "} {print $1, $2, $3}';
	exit 1;
fi
