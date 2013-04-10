#!/usr/bin/env bash

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
