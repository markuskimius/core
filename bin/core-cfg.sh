#!/usr/bin/env bash

##############################################################################
# CORE: Essential unix utilities
# https://github.com/markuskimius/core
#
# Copyright (c)2020-2024 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/core/blob/main/LICENSE
##############################################################################

source "core-doc.sh" || exit 1


function core-cfg() {
    local -a selector=()
    local -a hrow=()
    local -a row=()
    local -a file
    local delim=,
    local expr

    # Options
    while getopts "d:f:" o; do
        case "$o" in
            d)  delim=$OPTARG ;;
            f)  expr=$OPTARG ;;
            *)  return 1 ;;
        esac
    done
    shift $((OPTIND-1))

    file=$1 && shift
    selector=( "$@" )

    # Process the file
    while IFS=, read -a row; do
        local -A rec=()
        local i

        # File break
        if (( ${#row[@]} == 0 )); then
            hrow=()
            continue
        fi

        # Header
        if (( ${#hrow[@]} == 0 )); then
            hrow=( "${row[@]}" )
            continue
        fi

        # Select all with header if none requested
        if (( ${#selector[@]} == 0 )); then
            selector=( "${hrow[@]}" )

            {
                IFS=$delim
                printf "%s\n" "${selector[*]}"
            }
        fi

        # Index by name
        for((i=0; i<${#hrow[@]}; i++)); do
            rec[${hrow[i]}]=${row[i]}
        done

        # Output
        if [[ -z "$expr" ]] || eval "[[ $expr ]]"; then
            local -a out=()
            local k=""

            for k in "${selector[@]}"; do
                out+=( "${rec[$k]}" )
            done

            {
                IFS=$delim
                printf "%s\n" "${out[*]}"
            }
        fi
    done < <(core-doc "$file")
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        core-cfg "$@"
    }

    main "$@"
fi


# vim:ft=bash
