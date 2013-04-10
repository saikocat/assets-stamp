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
