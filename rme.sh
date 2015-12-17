#!/bin/bash

function rme_help() {
    cat << EOF

rme script delete folders and files except some of them
Options:
 - v  - version
 - h  - help
 - d  - dry run
 
EOF
}


DRY_RUN=0
while getopts ":hvd" OPTION
do
     case $OPTION in
         h)
             rme_help
             exit 1
             ;;
         v)
             echo "1.1";
             exit 1
             ;;
         d)
             DRY_RUN=1
             ;;
         esac
done

shift $(($OPTIND - 1))
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

if [ $DRY_RUN == 0 ]; then
    FIND="$FIND -print0 | xargs -0 rm -rf --";
fi
eval $FIND;
