function convert_to_cygdrive(){
	#also converts slashes
	sed -e "s/\\(.\\):/\\/cygdrive\\/\\1/"  -- "$@"|sed 's/\\/\//g'

}

function convert_forwardslash_windows_to_cygdrive(){
	#with/without colon
	#also converts slashes
	# /c/xyz or /c:/xyz -> /cygdrive.c/xyz
	sed -e "s/\\/\\(.\\):\?\\//\\/cygdrive\\/\\1\\//"  -- "$@"|sed 's/\\/\//g'

}

function clean_filepaths(){
	# remove quotes|remove trailing spaces
	sed 's/"//g'|sed 's/ *$//'| sed '/^ *$/d'

}
function escape_spaces(){
	sed 's/ /\\ /g'

}



function remove_color_code() {
# https://unix.stackexchange.com/questions/55546/removing-color-codes-from-output
	sed 's/\x1B\[[0-9;]*[JKmsu]//g' -- "$@"
}
function extract_filepath_linenum(){
# TODO extract linenum
# echo "/cygdrive/c/cygwin64/home/cibin/my.bashrc:23:342:adf"
read arg
echo -e "$arg"|remove_color_code|  sed -e 's/\x1b\[[0-9;]*m//g'|sed -e "s/\\([^:]*\\):\?\\([[:digit:]]\+\\)\\(.*\\)/\\1:\\2/"
# sed -e 's/\x1b\[[0-9;]*m//g'|sed -e "s/\\([^:]*\\):\?\\([[:digit:]]\+\\)\\(.*\\)/\\1:\\2/" -- "$@"

}