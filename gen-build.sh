#!/usr/bin/env bash
OUTPUT='./assets-stamp.sh'
FILES=(
    'variables.sh'
    'utils.sh'
    'requirements.sh'
    'usage.sh'
    'generators.sh'
    'main.sh'
)


clean() {
    rm -f "${OUTPUT}"
    touch "${OUTPUT}"
}

build() {
    echo "* Generating a new build..."
    echo "#!/usr/bin/env bash" >> ${OUTPUT}

    # Always remove the first line of each file basically #!/usr/bin/env bash
    for file in "${FILES[@]}"; do
        tail -n +2 "./src/${file}" >> ${OUTPUT}
    done

    echo "* Build completed at '${OUTPUT}'"
    exit
}

# Runtime
clean
build
