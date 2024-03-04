#!/usr/bin/env bash

##############################################################################
# CORE: Essential unix utilities
# https://github.com/markuskimius/core
#
# Copyright (c)2020-2024 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/core/blob/main/LICENSE
##############################################################################

function core-doc() {
    local -a filelist=( ${DPM}/*/etc/${1} )
    local filename

    # Local file override
    if   (( "$#" == 0   )); then
        filelist=( /dev/stdin )
    elif [[ "$1" == */* ]]; then
        filelist=( "$1" )
    fi

    # Process the files
    for filename in "${filelist[@]}"; do
        if [[ -r "$filename" ]]; then
            local line

            (
                eval "
                    while IFS= read -r line; do
                        printf '%s\\n' \"\$line\"
                    done <<__COREDOC_EOF_$$__
$(< "$filename")
__COREDOC_EOF_$$__
                "
            )

            # Add a gap to the next document, if any
            printf "\n"
        fi
    done
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        local file

        if (( $# == 0 )); then
            core-doc
        fi

        for file in "$@"; do
            core-doc "$file"
        done
    }

    main "$@"
fi


# vim:ft=bash
