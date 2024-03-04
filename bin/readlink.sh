#!/usr/bin/env bash

##############################################################################
# CORE: Essential unix utilities
# https://github.com/markuskimius/core
#
# Copyright (c)2020-2024 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/core/blob/main/LICENSE
##############################################################################

function readlink-sh() {
    local last=""
    local next=$1

    # Use realpath or readlink -f if available
    if command -v realpath >/dev/null; then
        realpath "$next"
        return $?
    elif command -v readlink >/dev/null; then
        readlink -f "$next" 2>/dev/null
        return $?
    fi

    # Manual
    while [[ "$next" != "$last" ]]; do
        local realname=$(readlink "$next" || basename "$next")
        local realdir=$(cd "$(dirname "$next")" && pwd -P)
        local realfull="${realdir}/${realname}"

        # Validate
        [[ -n "$realdir" && -n "$realname" ]] || realfull=""
        [[ -e "$realfull" ]] || realfull=""

        last=$next
        next=$realfull
    done

    printf "%s" "$last"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    readlink-sh "$@"
fi


# vim:ft=bash
