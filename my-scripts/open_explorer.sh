echo "$1"

file=$(~/my-scripts/convert_path_to_windows.sh "$*")

echo "$file"
# open explorer.bat "$file"

# cygwin works for below
explorer.exe /Select, "$file"

