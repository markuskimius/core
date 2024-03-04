#!/usr/bin/env bash

##############################################################################
# CORE: Essential unix utilities
# https://github.com/markuskimius/core
#
# Copyright (c)2020-2024 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/core/blob/main/LICENSE
##############################################################################

declare -F settitle >/dev/null && return


function settitle() {
    TITLE="${*-}"

    if (( ! $# )); then
        TITLE="${USER-$(whoami)}@${HOSTNAME-$(hostname)}"
    fi

    printf "\e]0;%s\a" "$TITLE"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    settitle "$@"
fi


# vim:ft=bash
