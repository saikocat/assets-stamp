#!/usr/bin/env bash

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
