#!/usr/bin/env bash

VERSION='0.0.1'
BASH_VERSION=`bash --version | grep -ohE 'version [[:digit:]]\.[[:digit:]]' | awk '{print $2}'`

# TODO support build prop location using arg
BUILD_PROP='./buildprop'
OUTPUT_STAMP='./assets.cfg'

# TODO
# explain this
WALK_HOOK='GIT'
FILE_TYPE='CFG'     # | PROPERTIES
STAMP_TYPE='HASH'   # | TIMESTAMP
BUILD_MODE='CLEAN'  # | APPEND | REPLACE

# Compare 2 floating point
# Print 1 if arg1 > arg2 else print 0
compare_float() {
    if [ $(echo "${1} > ${2}" | bc) -eq 1 ]; then
        echo 1
    else
        echo 0
    fi
}

# TODO
# temporary exit function on error
exit_error() {
  echo -e "$1"
  exit 1
}

#source ./variables.sh
#source ./utils.sh

# Requirement Checking
# --------------------
#

check_requirements() {
    echo -ne "* Checking requirements:\n"
    echo -ne "--- bash(>=4): "
    if [[ $(compare_float ${BASH_VERSION} 4) -eq 1 ]]; then
        echo "[ PASSED ] Bash version is [${BASH_VERSION}]"
    else
        echo "[ FAILED ]"
        echo "* Exiting..."
        exit
    fi
}

# TODO
# assume the first argument is the path to buildprop
check_buildprop() {
    BUILD_PROP=$1
    [[ ${BUILD_PROP} ]] || BUILD_PROP='./buildprop'

    echo -ne "--- buildprop: "

    if [ ! -f ${BUILD_PROP} ]; then
        echo "[ FAILED ] Properties file [buildprop] doesn't exist"
        exit
    else
        echo "[ PASSED ] Using ${BUILD_PROP} path"
    fi
}

# Usage manual
usage() {
  echo 'usage: TODO'
  echo
  echo '    -h           - outputs this message'
  exit
}

# source ./variables.sh

FILE_WALKER='git_walk' # no pun intended
SECTION_OPEN='section_open'
SECTION_CLOSE='section_close'
FILE_TYPE='CFG'
GIT_AWK='$2' # $1 for hash | $2 for unix timestamp

bootstrap() {
    # Check output file type
    case "${FILE_TYPE}" in
    'CFG')
        SECTION_OPEN='cfg_section_open'
      ;;
    'PROPERTIES')
        SECTION_OPEN='noop'
      ;;
    *)
      echo "Unknown filetype [${FILE_TYPE}]"; exit 5
      ;;
    esac

    # Check stamp type
    case "${STAMP_TYPE}" in
    'HASH')
        GIT_AWK='$1'
      ;;
    'TIMESTAMP')
        GIT_AWK='$2'
      ;;
    *)
      echo "Unknown stamp type [${STAMP_TYPE}]"; exit 5
      ;;
    esac

    # Check walk function
    case "${WALK_HOOK}" in
    'GIT')
        FILE_WALKER='git_walk'
      ;;
    *)
      echo "Unknown walk function [${WALK_HOOK}]"; exit 5
      ;;
    esac
}

noop() {
    echo ' ' > /dev/null
}

section_open() {
    echo -ne "\n" >> ${OUTPUT_STAMP}
}

section_close() {
    echo -ne "\n" >> ${OUTPUT_STAMP}
}

cfg_section_open() {
    echo "[${1}]" | tee -a ${OUTPUT_STAMP}
}

write_stamp() {
    filename=$1
    ref=$2
    asset_type=$3

    case "${FILE_TYPE}" in
    'CFG')
        echo "${filename}=${ref}" | tee -a ${OUTPUT_STAMP}
      ;;
    'PROPERTIES')
        echo "'${asset_type}.${filename}'='${ref}'" | tee -a ${OUTPUT_STAMP}
      ;;
    *)
      echo "Unknown filetype [${FILE_TYPE}]"; exit 5
      ;;
    esac
}

clean_output_config() {
    rm -f "${OUTPUT_STAMP}"
    touch "${OUTPUT_STAMP}"
}

# Git Walk Generator
git_walk() {
    path=$1
    asset_type=$2

    git ls-tree -r --name-only HEAD:${path} | while read filename; do
        # echo "$(git log -1 --format="%h %at" -- ${1}${filename}) ${filename}"
        ref="$(git log -1 --format="%h %at" -- ${path}${filename} | awk {print\ $GIT_AWK})"

        write_stamp ${filename} ${ref} ${asset_type}
    done
}




walk() {
    path=$1
    asset_type=$2

    ${SECTION_OPEN} ${asset_type}
    ${FILE_WALKER} ${path} ${asset_type}
    ${SECTION_CLOSE}
}

build() {
    clean_output_config
    bootstrap

    for asset_type in "${!ASSETS[@]}"; do
        IFS=';' read -a paths <<< "${ASSETS["${asset_type}"]}"
        for path in "${paths[@]}"; do
            echo "* Walking: ${asset_type} - ${path}"
            walk ${path} ${asset_type}
        done
    done
}

# TODO
# Argument passing

# Hardcoded till arg passing is done
# Load Build Properties Variables
source ${BUILD_PROP}

# Sanity check
[[ ${BUILD_PROP} ]] || BUILD_PROP='./buildprop'
[[ ${OUTPUT_STAMP} ]] || OUTPUT_STAMP='./assets.cfg'

main() {
    check_requirements
    check_buildprop

    echo '* Building stamps...'
    build
    echo "* Generated output is at [${OUTPUT_STAMP}] path"
}

main
