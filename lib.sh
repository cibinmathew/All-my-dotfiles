#!/usr/bin/sh

# TODO
# functions: convert to linux path;windows path;cygwinpath;windowsubuntupath
# good tuts on arrays http://www.thegeekstuff.com/2010/06/bash-array-tutorial
# array:
# ${arr[*]} # All of the items in the array
# ${!arr[*]} # All of the indexes in the array
# ${#arr[*]} # Number of items in the array
# ${#arr[0]} # Length of item zero

# path ${0}
# parent path ${0%/*}
# filename ${0##*/}
# dir=$(dirname "$BASH_SOURCE[0]$$*/}")

# A=( foo bar "a  b c" 42 )
# B=("${A[@]:1:2}") # :1:2 takes a slice of length 2, starting at index 1.
# C=("${A[@]:1}")   # slice to the end of the array
# echo "${B[@]}"    # bar a  b c
# echo "${B[1]}"    # a b c
# echo "${C[@]}"    # bar a  b c 42

# for arguments
# echo "${@:1:2}"
# echo "$HOME"
# $HOME is different for cmd,bash,emacs terminals
#source /home/"$USERNAME"/myalias.sh

# BASH_SOURCE array, and how the first element in this array always points to the current source
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source ~/myalias.sh
source ~/set_defaults.sh

# script_name=$0
# echo $script_name
# script_full_path=$(dirname "$0")
# echo "$script_full_path/myalias.sh"
# source "$script_full_path/myalias.sh"
# source ./set_defaults.sh
# source $HOME/myalias.sh
# source $HOME/set_defaults.sh



function grephere() {

	search_term=$(make_wildcard_search_term "$@")
	cwd=$(pwd)
	echo "searching $1 in $cwd"

	echo "grep -Ein $search_term *.* --color=auto"
	grep -Ein $search_term *.* --color=auto

}
function rgrep() {

	search_term=$(make_wildcard_search_term "$@")
	cwd=$(pwd)
	echo "search  $1 in ,$cwdd"

	echo "grep -Eirn $search_term *.* --color=auto"
	grep -Eirn $search_term *.* --color=auto

}
function rrgrep() {

	cwd=$(pwd)
	echo "searching $1 in $cwd"
	search_term=$(make_wildcard_search_term "$@")
	echo "grep -Eirn $1 ../*.* --color=auto"
	grep -Eirn $search_term ../*.* --color=auto

}

function grepfind() {

	cwd=$(pwd)
	search_term=$(make_wildcard_search_term "$@")
	echo "searching $1 in $cwd"

	echo "lfind . -type f -exec grep -nH $1 {}  --color=auto\;"
	lfind . -type f -exec grep -nH $search_term {}  --color=auto\;

}
#extract function. This combines a lot of utilities to allow you to decompress just about any compressed file format. There are a number of variations, but this one comes from here:
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
 echo "print extract syntax for learning"
    if [ -f $1 ] ; then
        NAME=${1%.*}
        mkdir $NAME && cd $NAME
        echo "name is $NAME"

        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}


function rrfindhere() {

	if [ -z "$1" ]; then
	echo "Usage: cibin find all files "
	else
	cwd=$(pwd)
	search=""
	search_term=$(make_wildcard_search_term "$@")
	echo "lfind . -iname $search"
	lfind ../ -iname "$search_term"
	# lfind . -maxdepth $1 -iname "*" | grep -iP "(?=.*$2[^/]*$)(?=.*$3[^/]*$)"
	fi
}
function findhere() {

	if [ -z "$1" ]; then
	echo "Usage: cibin find all files "
	else
	cwd=$(pwd)
	search=""
	search_term=$(make_wildcard_search_term "$@")
	echo "lfind . -iname $search"
	lfind . -iname "$search_term"
	# lfind . -maxdepth $1 -iname "*" | grep -iP "(?=.*$2[^/]*$)(?=.*$3[^/]*$)"
	fi
}

function make_lookaround_search_term() {
	# prepare lookaround search term

	search=""
	for arg in $@; do
		search=$search\(?=.*$arg[^\\/]*$\)
	# search=$search.\*$arg
	# echo $arg
	# echo $search
	done
	# search=$search.\*
	echo "$search"
}

function make_wildcard_search_term() {
	# prepare wildcard search term

	search=""
	for arg in $@; do
		search=$search\*$arg
	done
	search=$search\*
	echo "$search"
}

function pcfind() {
echo "$*"
	if [ -z "$3" ]; then
		echo "Usage: cibin find $1"
	else
		maxdepth=100
		local search_term=""
		search_term=$(make_lookaround_search_term ${@:3})
		echo $search_term
		case "$1" in
			"all"			) files="~/all_files_unfiltered.db";;
			"common"		) files="~/all_files.db";;
			"all_fuzzy"		) files="~/all_files_unfiltered-fuzzy.db";;
			"common_fuzzy"	) files="~/all_files-fuzzy.db";;
			"h"|"here"		) files=("$(pwd)");maxdepth=1;;
			"hh"			) files=("$(pwd)");maxdepth=2;;
			"hhh"			) files=("$(pwd)");maxdepth=3;;
			"hhh"			) files=("$(pwd)");maxdepth=4;;
			"rhere"			) files=("$(pwd)");;
			"rrhere" 	) files=("$(dirname "$(pwd)")"/*);;
		esac
		echo "$files"

		case "$2" in
			"fuzzy_db"		)
					#extract line number; then print those lines from original file
					grep -rPIni "$search_term" --color=auto "$files" | cut -f1 -d:|print_nth_line |  remove_cygdrive|colourise_filenames;;
			"db"		)
					# echo "adfadsf"
					grep -rPIi "$search_term" --color=auto "$files" |  remove_cygdrive|colourise_filenames;;
			"live"		)
					# echo "adf"
					lfind "$files" -maxdepth "$maxdepth" -iname "*" | grep -Pi "$search_term" --color=auto|remove_cygdrive|colourise_filenames;;

		esac
	fi
}
function colourise_filenames(){
	# 'pattern|$' = colourise pattern but will show non matching lines as well
GREP_COLOR="1;32" grep -E --color '[^\\/]*$|$'
# $search\(?=.*$arg[^\\/]*$\)

}
function print_nth_line() {
while read -r line; do head -n "$line" /cygdrive/c/Users/cibin/Downloads/all_files_unfiltered.db| tail -n 1;done

}

function remove_cygdrive() {

# converts /cygdrive/c/abc to c:/abc

# http://stackoverflow.com/a/18766794
	# capture piped input only otherwise arguments
	# if read -t 0; then
        # arg=$(cat)
    # else
        # arg="$*"
    # fi
	# echo "$arg"

	sed -e "s/\\/cygdrive\\/\\(.\\)\\//\\1:\\//"  -- "$@"
}

function cron_jobs_cibin() {

	echo "other_indexes"
	echo "myindexemacs"
	echo "myindex"
	echo "updatedb"
	# TODO: separate the jobs or add interval info to it

	# locatedb update
	updatedb

	# Change mlocate Database Location
# The default database that locate utility reads is /var/lib/mlocate/mlocate.db, but if you wish to link the locate command with some other database kept at some other location, use the -d option.
# For example :
# $ locate -d <new db path> <filename>


	other_indexes
    # emacs indexing
	myindexemacs
    # all_files.db indexing
    myindex

	echo "TODO"

}

# TODO:
# pcfind searchTerm
# h=here
# hh=here maxdepth2
# hhh
# r=recurse
# pcfind hhh searchTerm


function grepfilelist_related() {
	tr -d '\r' < C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/emacs-tmp/filelist.txt > C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/emacs-tmp/filelist2.txt
	run_grepfilelist $1
}
function grepfilelist_common() {
sed -i "s/<username>/$USERNAME/g" C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/settings-files/all-common-filelist.txt
	tr -d '\r' < C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/settings-files/all-common-filelist.txt > C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/emacs-tmp/filelist2.txt
	run_grepfilelist $1
}

function run_grepfilelist() {
	while read filename; do
		  # echo "$filename"
      # TODO enable errors or will go missings unnoticed
		grep -PnIi $1 -s --color=auto  "$filename"  /dev/null;
	done <C:/cygwin64/home/"$USERNAME"/.emacs.d/my-files/emacs-tmp/filelist2.txt
}

# TODO: ag searchterm1 searchterm2 searchTerm3; here it shouldnot take searchTerm1 as locations to search

# common extensions txt,
# ag  all/common/downs/ahk/notes/here/hhere   common/code/txt   searchTerm
# ag all txt searchTerm
# ag all [common] searchTerm
# ag [common] [common] searchTerm
# agn(ag notes) searchTerm=cmd note-folder note-files-extensions searchTerm
# agn abc
function advgrep() {
echo "$1 $2 $3 $*"
while getopts ":ABC:" opt; do
  case $opt in
    C)
      echo "-a was triggered, Parameter: $OPTARG" >&2
	  arg=-C $OPTARG
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


	declare -a files=("$Universal_home/Downloads/*txt")
	ext=".*\.\(txt\|org\)"
	# TODO:
	# load notes filelist from settings.ini
	# all_notes=$(sed -n 's/.*all_notes *= *\([^ ]*.*\)/\1/p' < settings.ini)
	# all_notes=($all_notes)
	declare -a all_notes=("C:/cbn_gits/misc/*" "$Universal_home/Downloads/notes.txt" "$Universal_home/Downloads/notes3.txt" "$Universal_home/Downloads/todo.txt" "$Universal_home/Downloads/work-todo.txt" "$Universal_home/Downloads/work-notes.txt" "$Universal_home/Downloads/todo-notes.org" "$Universal_home/Downloads/clear these doubts.txt")

	echo "pwd= $(pwd)"
	if [ -z "$1" ]; then
		echo "cmd  all/common/downs/ahk/notes/here/hhere   common/code/txt   searchTerm"
	else
		if [ -z "$2" ]; then
			search_term="$1"
		else
			case "$1" in
				"a"|"all"		) declare -a files=("$Universal_home/Desktop/*" "$Universal_home/Downloads/*" "/cygdrive/d/Downloads/*" "/cygdrive/f/*");;
				"n"|"notes"		) files=("${all_notes[@]}");;
				"d"|"download" 	) declare -a files=("$Universal_home/Downloads/*");;
				"emacs"			) declare -a files=("$Universal_home/AppData/Roaming/.spacemacs" "$Universal_home/AppData/Roaming/.emacs.d/my-files/config/personal-configs/*el");;
				"ahk"			) declare -a files=("/cygdrive/c/cbn_gits/AHK/*");;
				"h"|"here"		) files=("$(pwd)");;
				"hhere" 	) files=("$(dirname "$(pwd)")"/*);;
				"rhere" 	) files=("$(pwd)"/*);;
			esac
			echo "searching in file $files"

			if [ -z "$3" ]; then
				search_term="$2"

			else
				ext=".*\.\($2\)"
				case "$2" in
				"code"                 ) ext=".*\.\(txt\|org\|py\|ini\|java\|ahk\|sh\|c\|cpp\)";;
				"."                 ) ext=".*";;
				"*"                 ) ext=".*";;

			   "common"  ) ext=".*\.\(txt\|org\)";;

				esac
				echo "extension is $ext"
				search_term="${@:3}"
			fi

		fi

	# declare -a files=("$Universal_home/Downloads/notes.txt" "$Universal_home/Downloads/notes3.txt" "$Universal_home/Downloads/todo.txt" "$Universal_home/Downloads/work-todo.txt" "$Universal_home/Downloads/work-notes.txt" "$Universal_home/Downloads/todo-notes.org" "$Universal_home/Downloads/clear these doubts.txt" )

		echo $ext
		# echo "searching: $search_term"
		search_term=$(make_lookaround_search_term $search_term)
		echo "searching: $search_term"
		echo "$1"
		if [ "$1" = "rhere" ]; then
			echo "using here handler"
					grep -PrnIi $search_term --color=auto *.$2 /dev/null
					# grep -rPIi "$search_term" --color=auto "$files" |  remove_cygdrive;;
			else
				echo "using find cmd"
					for pattern in "${files[@]}"; do
							# echo "$pattern"
						  echo "${pattern%/*}     ${pattern##*/}"

							lfind  "${pattern%/*}"  -iregex $ext -iname "${pattern##*/}" -type f -exec grep -PrnIi $search_term --color=auto {} /dev/null \;
					done
				# fi
		fi
	fi
# lfind  $files  -iregex $ext -type f -exec grep -PrnIi $search_term --color=auto {} /dev/null \;


	# lfind  "$Universal_home"/Desktop/l* "$Universal_home"/Downloads/* /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/*  -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -type f -exec grep -PrnIi "$1"  --color=auto {} /dev/null \;

# By using /dev/null as an extra input file grep "thinks" it dealing with multiple files, but /dev/null is of course empty, so it will not show up in the match list
echo "finished"
 }


# to use wildcard pattern files
# patterns=(-path "${files[0]}")
# for pattern in "${files[@]:0}"; do
	# patterns+=(-o -path "$pattern")
	# echo "$pattern"
	# echo "${pattern%/*}"
	# echo "${pattern##*/}"
# lfind "${pattern%/*}"   -type f -iname "${pattern##*/}" -exec grep -PrnIi rewa --color=auto {} /dev/null \;



function myallgrep() {
	if [ -z "$1" ]; then
		echo "Usage: cibin grepp for text files"
	 else
	lfind  "$Universal_home"/Desktop/l* "$Universal_home"/Downloads/* /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts  /cygdrive/d/*  -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -type f -exec grep -PrnIi "$1"  --color=auto {} /dev/null \;
	 fi
 }

function mygrep() {
	if [ -z "$1" ]; then
		# display usage if no parameters given
		echo "Usage: cibin grepp for text files"
	 else

	 grep -PrnIi "$1" --color=auto /cygdrive/f/july\ 2/text/* /cygdrive/f/july\ 2/Projects/python_scripts;
	 fi
 }


function ffd() {
  local dir
  #dir=$(cat *.txt | fzf +m) &&
  dir=$(lfind . -name "*.$1" -exec tail -n +1 -- {} + | fzf +m) &&
  echo "$dir"
}



### https://github.com/zhhz/vim-settings/blob/master/fzf.bash
##
##Changing directory
##
# fd - cd to selected directory
fda() {
  local dir
  dir=$(lfind ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fd - including hidden directories
fd() {
  local dir
  dir=$(lfind ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$(pwd)}") | fzf-tmux --tac)
  cd "$DIR"
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function
cf() {
echo  e"x: cf word1 word2 ... (even part of a file name)"
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# lfind /cygdrive/c/Users/cibin/Downloads/ -type f -iname *notes.org  -exec ag domain --color {} \;

function searchfiles () {

cat ~/all_files.db|fzy -l 20

}
function searchcommands() {
cat c:/cbn_gits/AHK/popular_commands.db|fzy -l 20

}
function searchnotes () {
# ag $* -G org$ /cygdrive/c/Users/cibin/Downloads/ --color

lfind "/cygdrive/c/Users/$USERNAME/Downloads/" -maxdepth 2 -iname "*notes*.org" -exec  echo {} +
lfind "/cygdrive/c/Users/$USERNAME/Downloads/" -maxdepth 2 -iname "*notes*.txt" -exec  echo {} +
lfind "/cygdrive/c/Users/$USERNAME/Downloads/" -maxdepth 2 -iname "*notes*.org" -exec  ag -i --noheading --numbers --filename --color --color-match "2;46" $* {} +
lfind "/cygdrive/c/Users/$USERNAME/Downloads/" -maxdepth 2 -iname "*notes*.txt" -exec  ag -i --noheading --numbers --filename --color --color-match "2;46" $* {} +

# ag $* -n -G org$ /cygdrive/c/Users/"$USERNAME"/Downloads/ --color
# # ag $* -n -G todo-notes.org$ /cygdrive/c/Users/"$USERNAME"/Downloads/ --color
# ag $* -n -G ^notes.txt$ /cygdrive/c/Users/"$USERNAME"/Downloads/ --color
# ag $* -n -G notes.org$ /cygdrive/c/Users/"$USERNAME"/Downloads/ --color
# ag $* -n -G work-notes.txt$ /cygdrive/c/"$USERNAME"/cibin/Downloads/ --color
# ag $* -n -G work-notes.org$ /cygdrive/c/Users/"$USERNAME"/Downloads/ --color
}

# extra option available https://jamesoff.net/2016/05/31/fzf-brew-upgrade.html
ask_searchterm () {
    if [ "$1" == "-r" ]; then
    recurse="-r"
     else
         recurse="-n"
         echo "no -n "
    fi

     #   echo "\$cmd extension searchTerm"
    if [ -z "$2" ]; then
		read -p "enter extension: " arg < /dev/tty
    else
        arg=$2
	fi
    if [ -z "$3" ]; then
        read -p "enter search_term: " searchtext < /dev/tty
	else
        searchtext=${@:3}
	fi

echo  search "$recurse" "$arg" "$searchtext"
search "$recurse" "$arg" "$searchtext"
}

searchtext() {
    ask_searchterm

}
search(){
	ag -i "$1" -G "$2$" "${@:3}"
	# CHOICE=$(ag -i -G $arg$ --color "$searchtext"| fzf -0 -1 --ansi)
	# echo "$CHOICE"|extract_filepath_linenum|open_in_app
}

searchall() {
	echo "\$cmd searchTerm."
	if [ -z "$1" ]; then
		read -p "enter search_term: " searchtext < /dev/tty
	else
		searchtext=${@:1}
	fi
	ag -i  --color "$searchtext"
	# CHOICE=$(ag -i  --color "$searchtext"| fzy)
	# CHOICE=$(ag -i  --color "$searchtext"| fzf -0 -1 --ansi)

}


function searchInRecentfiles(){
  recent_files>/tmp/filelist2.txt
  tr -d '\r' </tmp/filelist2.txt >/tmp/filelist.txt
  while read FILE  ; do
  	# echo " = $FILE";
    grep -PrnIi "$1" --color=auto "$FILE" /dev/null --no-messages;
  done </tmp/filelist.txt
}


function fzs(){
	read  arg
	echo "$arg"
# 	CHOICE=$(echo "$arg"|fzf -0 -1 --ansi)
# echo "$CHOICE"| escape_spaces

}
function searchproject () {
    read -p "enter extension: " arg < /dev/tty
    dir=$(ls "/cygdrive/c/Users/$USERNAME/Downloads/Project/"|fzy)
    dir="/cygdrive/c/Users/$USERNAME/Downloads/Project/$dir"
lfind "$dir" -iname "*.$arg" -exec  ag -i --noheading --numbers --filename --color --color-match "2;46" $* {} +

}
