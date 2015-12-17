#!/bin/bash

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
testpath="test"; 
rootPath="$path/$testpath"

#Create files and folders for test
function createTestFiles() {
    
    rm -fr "$rootPath";
    [ -d "$rootPath" ] || mkdir -p "$rootPath";
    touch "$rootPath/a.a";
    touch "$rootPath/b.a";
    touch "$rootPath/c.a";
    touch "$rootPath/d.a";
    touch "$rootPath/e.a";
    touch "$rootPath/f.a";
    touch "$rootPath/.e.a";
    touch "$rootPath/.i.a";
    touch "$rootPath/ot1.txt";
    touch "$rootPath/ot2.txt";
    touch "$rootPath/ot3.txt";
    [ -d "$rootPath/foo" ] || mkdir "$rootPath/foo";
    touch "$rootPath/foo/d.a";
    touch "$rootPath/foo/e.a";
    touch "$rootPath/foo/f.a";
    touch "$rootPath/foo/.e.a";
    touch "$rootPath/foo/.i.a";
    [ -d "$rootPath/foo1/foo" ] || mkdir -p "$rootPath/foo1/foo";
    touch "$rootPath/foo1/.e.a";
    touch "$rootPath/foo1/.i.a";
    touch "$rootPath/foo1/foo/d.a";
    touch "$rootPath/foo1/foo/e.a";
    touch "$rootPath/foo1/foo/f.a";
    touch "$rootPath/foo1/foo/.e.a";
    touch "$rootPath/foo1/foo/.i.a";
    [ -d "$rootPath/foo1/foo2" ] || mkdir -p "$rootPath/foo1/foo2"; 
    touch "$rootPath/foo1/foo2/.i.a";
}

function testFunc() {
    createTestFiles;
    eval "${1}";
    is_fail=0;
    result=$(find "${ROOT_DIR}" -print0 | xargs -0);
    if [ "${2}" == "$result" ]; then
        printf "\033[0;32mPASS TEST\033[0m\n"
    else 
        printf "\033[0;31mFAIL TEST\033[0m\n";
        printf "Command:\t\t"${1}"\n";    
        printf "Find command:\t\t$FIND\n";
        printf "Result:\t\t\t$result\n";
        printf "Expected result:\t${2}\n";
        is_fail=1;
    fi

}

testFunc ". $path/rme.sh './${testpath}' './${testpath}/foo1/foo/.i.a'" "./$testpath ./$testpath/foo1 ./$testpath/foo1/foo ./$testpath/foo1/foo/.i.a";
testFunc ". $path/rme.sh './${testpath}' './${testpath}/foo1/foo/.i.a,./${testpath}/foo1/.e.a'" "./$testpath ./$testpath/foo1 ./$testpath/foo1/foo ./$testpath/foo1/foo/.i.a ./$testpath/foo1/.e.a"; 
testFunc ". $path/rme.sh './${testpath}' './${testpath}/a.a,./${testpath}/foo'" "./$testpath ./$testpath/foo ./$testpath/a.a"; 
testFunc ". $path/rme.sh './${testpath}/foo' './${testpath}/foo/d.a'" "./$testpath/foo ./$testpath/foo/d.a";

if [ "$is_fail" == 1 ]; then 
    printf "\n\nDetails\n";
    uname -mrs; 
    lsb_release -a;
fi

rm -fr "$rootPath";
