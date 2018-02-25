#!/bin/sh
mkdir -p .cache
cd .cache
if [ ! -f checkstyle.jar ]
then
    curl -LJO "https://github.com/OmriShiv/java-checkstyle/raw/master/checkstyle.jar"
    chmod 755 checkstyle.jar
fi

if [ ! -f google-checkstyle.xml ]
then
    curl -LJO "https://github.com/OmriShiv/java-checkstyle/raw/master/google-checkstyle.xml"
fi

cd ..

changed_java_files=$(git diff --name-only --cached --diff-filter=ACMR | grep ".*java$" )
#echo $changed_java_files
output=$(echo $changed_java_files | grep ".*java$" | while read -r a; do java -jar .cache/checkstyle.jar -c .cache/google-checkstyle.xml $a ; done )
echo "$output">&2
if [[ $output = *"WARN"* ]] || [[ $output = *"INFO"* ]] || [[ $output = *"ERROR"* ]]; then 
    exit 1
fi