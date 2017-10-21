# convert if starting with /cygdrive
# convert cygdrive|convert slashes|remove single and double quotes
file=$(echo "$*"|sed -e "s/\\/cygdrive\\/\\(.\\)\\//\\1:\\\/"|sed 's/\//\\/g'|sed "s/'//g")
# file=$(echo "$file"|sed 's/~/C:\\Users/'|sed 's/\//\\/g'|sed "s/'//g")
echo "$file"