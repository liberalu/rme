#!/bin/bash

ROOT_DIR="${1}";
EXCLUDES="${2}";
IFS=',' read -r -a EXCL <<< "$EXCLUDES"

function createFindConditions() {
    IFS='/' read -ra ARR <<< "${1}"
    OPTS="";
    COMMAND="";
    for i in "${ARR[@]}"; do
        if [ "$OPTS" == "" ]; then
            OPTS="$i";
        else
            OPTS="$OPTS/$i";
        fi
        COMMAND="${COMMAND} -o -path \"$OPTS\""
    done
    echo "${COMMAND}";
}
folders="-path '.'";
for DIRF in "${EXCL[@]}"; do
    folders=$folders$(createFindConditions "${DIRF}");
done

FIND="find ${ROOT_DIR} -not \( ${folders} \)";
eval "$FIND -print0 | xargs -0 rm -rf --"; 
