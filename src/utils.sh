#!/usr/bin/env bash

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
