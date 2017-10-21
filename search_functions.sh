function recent_files(){
	# recent

	# linux ~/.config/sublime-text-2/Settings/Session.sublime_session, so look for such a file in the Settings folder in your user directory.
	# In Mac OS X this list is stored in a file called Session.sublime_session under ~/Library/Application Support/Sublime Text 2/Settings,
	sublime_file=C:/Users/"$USERNAME"/AppData/Roaming/Sublime\ Text\ 3/Local/Session.sublime_session
	notepadpp_file=/cygdrive/c/Users/"$USERNAME"/AppData/Roaming/Notepad++/session.xml
	notepadpp_file2=/cygdrive/c/Users/"$USERNAME"/AppData/Roaming/Notepad++/config.xml
	if [ -f ~/.viminfo ]; then
	grep "~?/.*" -E -o ~/.viminfo |sed 's/"//g'>~/cbn_history.txt
	fi
	if [ -f "$sublime_file" ]; then
		# TODO  below json parsing is not proper when multiple entries in the array ['windows'][0]
	cat "$sublime_file"|python -c "import sys, json; print('\n'.join(json.load(sys.stdin)['windows'][0]['file_history']))"|convert_forwardslash_windows_to_cygdrive>>~/cbn_history.txt
	cat "$sublime_file"|python -c "import sys, json; all=json.load(sys.stdin)['windows'][0]['buffers'];print('\n'.join([a['file'] if 'file' in a else '' for a in all]))"|convert_forwardslash_windows_to_cygdrive>>~/cbn_history.txt
	# grep "~?/.*\"" -E -o "$sublime_file" |sed 's/"//g'>>~/cbn_history.txt
	fi

	# TODO use python to properly extract xml data
	[ -f "$notepadpp_file" ] && grep "\\w:\\\[^\"]*\" " -E -o "$notepadpp_file">>~/cbn_history.txt
	[ -f "$notepadpp_file2" ] && grep "\\w:\\\[^\"]*\" " -E -o "$notepadpp_file2">>~/cbn_history.txt

	# if [ -f "$notepadpp_file" ]; then
	# 	grep "\\w:\\\[^\"]*\" " -E -o "$notepadpp_file">>~/cbn_history.txt
	# fi
	#remove ", trailing spaces
	echo  "$(cat ~/cbn_history.txt|convert_to_cygdrive|clean_filepaths|remove_color_code|lsort|uniq -i)"
	#C:\Users\cibin\AppData\Roaming\Notepad++\session.xml
}

function re() {
	file="$(recent_files|fzf|sed 's/ /\\ /g')"
	if [ -f "$file" ]; then
	    vim "$file"
	else
		echo "file:$file not found"
	fi
}

function red(){
	# recent d
	cd "$(recent_dirs|fzf|sed 's/ /\\ /g')"

}


function recent_dirs(){

	#remove ", trailing spaces
	# TODO get dires of recent_files in vim,ranger,sublime

	# echo  "$(cat ~/cbn_history.txt|convert_to_cygdrive|clean_filepaths|lsort|uniq -i)"
	cd_history=$(cat ~/.z|cut -d'|' -f1|convert_to_cygdrive)
	all_recent_files=$(recent_files|sed 's|/[^/]*$||')
	# all_dirs=$all_recent_files$cd_history

	# TODO \n not working
	all_dirs="${all_recent_files}zzzzzz${cd_history}"
	echo "$all_dirs" |sed 's=/[^\\/]*$=='|clean_filepaths| lsort|uniq -i

}


function recent_in_app(){
	# file="$(recent_files|escape_spaces|fzf|open_in_app)"
	recent_files|escape_spaces|fzf|open_in_app
	# echo "$file"
}


function smart_open(){
echo "current file=$1"
cd_to_directory "$1"
	cr=`echo $'\n.'`
	cr=${cr%.}
	textreset=$(tput sgr0) # reset the foreground colour
	yellow=$(tput setaf 2)
	echo "${yellow}cwd=$(pwd) ${textreset}"
	read -n 1 -p " [s] search $cr [o] open $cr [z] auto search$cr" pressedkey </dev/tty
	case $pressedkey in

	    s ) echo; prompt_for_s "$@";;
	    r ) echo "$filepath";open_in_ranger $(echo "$filepath");;
	    v ) echo "$filepath"|open_in_vim;;
	    z ) echo;ext="${1#*.}"; echo "ext=$ext";echo "$(ask_searchterm -r "$ext" .|fzy)"|extract_filepath_linenum|open_in_app;;
	    o ) echo "$filepath"|open_in_app;;
	esac


}




function prompt_for_s(){
echo "aaarg=$1"
# echo "${$1%%.*}"
while true; do
	read -n 1 -p " [a] all text $cr [c] commands $cr [f] files $cr [n] notes $cr [p] project $cr [r] recent $cr [t] ext text " pressedkey < /dev/tty;
	case $pressedkey in
		 n ) echo " searching...";snf|extract_filepath_linenum|open_in_app;break;;
		 p ) echo " searching...";spf|extract_filepath_linenum|open_in_app;break;;
		 c ) echo " searching...";scf;break;;
		 t ) echo;
				read -n 1 -p " [a] auto $cr [h] here $cr fuzzy $cr advanced " pressedkey2 < /dev/tty;
				case $pressedkey2 in
					h ) echo;echo "$(sth)"|extract_filepath_linenum|open_in_app;break;;
					a ) echo;ext="${1#*.}"; echo "ext=$ext";echo "$(ask_searchterm -r "$ext" .|fzy)"|extract_filepath_linenum|open_in_app;break;;
					f ) echo;echo "$(stf)"|extract_filepath_linenum|open_in_app;break;;
				esac
				break;;
		 r ) srf|extract_filepath_linenum|open_in_app;break;;
		 a ) saf|extract_filepath_linenum|open_in_app;break;;
		 f ) echo;sf;break;;
		 d ) echo "HHHHHHHHHHHHHHH $filepath"|clip;break;;
	     q ) echo;break;;
	esac
done
}


# echo "/cygdrive/c/cbn_gits/delete.py"|open_in_app
function open_in_app(){

	 # if (( $# == 0 )) ; then
  #       echo < /dev/stdin
  #       echo
  #   else
  #       echo  <<< "$1"
  #       echo
  #   fi
read filepath #</dev/tty

textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
yellow=$(tput setaf 2)

echo "!!${yellow} file: ${textreset} ${red} $filepath ${textreset}."


# echo
# filepath=$(</dev/stdin)

# # sublime notepadpp explorer ranger cdbash vim emacs clipb
# Get a carriage return into `cr` -- there *has* to be a better way to do this
cr=`echo $'\n.'`
cr=${cr%.}


while true; do
    read -n 1 -s -p " s sublime                           c clipss         q quit $cr n notepad++     d desktop           cc windows $cr v vim           r ranger            cc cygdrive$cr e emacs         o open default $cr l less          b cd                p details $cr $cr f=foldersearch r=recent again d=directory search] $cr" pressedkey </dev/tty
	# if [ "$pressedkey" = $'\e' ]; then
	#         echo -e "\n [ESC] Pressed"

	# elif [ "$pressedkey" == $'\x0a' ] ;then
	#         echo -e "\n [Enter] Pressed"

	# fi
	escaped_filepath=$(echo "$filepath"|escape_spaces)
	# echo -e "escaped_filepath=$escaped_filepath\n"
    case $pressedkey in
	    # [Yy]* ) rm ~/cron/beeb.txt; /usr/bin/get-iplayer --type tv>>~/cron/beeb.txt; break;;
	    l ) less -iN "$filepath"; break;;
	    r ) echo "$filepath"|open_in_ranger ; break;;
	    d ) open_in_explorer $(echo "$filepath"); break;;

	    b ) cd_to_directory "$(echo "$filepath")"; break;;

	    c ) echo "$filepath"|clip;
				read -n 1 -s -p "c/d " pressedkey < /dev/tty;
				case $pressedkey in
					 c ) echo "$filepath"|clip; break;;
					 d ) echo "cd to directory $filepath"|clip; break;;
				esac

	     break;;
	    o ) default_run $(echo "$filepath"); break;;
	    p ) echo "extra details like size if it exists or not TODO";ls -lh "$filepath";break;;
	    [Nn]* ) open_in_npp $(echo "$filepath"); break;;
	    [Ss]* ) open_in_sublime_text $(echo "$filepath"); exit;break;;
	    [Qq]* ) echo; exit; break;;
	    v ) echo "$filepath"|open_in_vim; break;;
	    * ) echo "$filepath"|open_in_vim ; break;;
    esac
	echo "try again" #;break;
done


}




# echo "/cygdrive/c/Users/cibin/Downloads/raspberrypi notes.txt:3"|open_in_vim
# OR  echo /cygdrive/c/Users/cibin/Downloads/raspberrypi\ notes.txt|open_in_vim
# fzf|extract_path_and_line|escape_spaces|open_in_vim

function open_in_vim(){
	# should be able to open paths starting with filepath:line number or  similar format
	read -r arg # < /dev/tty $@
	echo "arg=$arg="
	line=$(echo "$arg"|awk 'BEGIN { FS=":" } { printf "+%d", $2 } ')
	File=$(echo "$arg"|awk 'BEGIN { FS=":" } { printf "%s", $1 } ')
	vim < /dev/tty $line "$File"
	echo "$line"
	echo "$File"
	# TODO strip linenum and check if exists
	# if [ ! -z "$arg" ]
	# 	then
	# vim -- "$(echo $arg)" #|sed -e 's/\x1b\[[0-9;]*m//g')"
	# vim $(echo "$arg"|awk 'BEGIN { FS=":" } { printf "+%d %s\n", $2, $1 } ')
		# 	# below works for ag.vim plugin; check what it does
		# 	# vim $(echo "$arg"|escape_spaces | awk 'BEGIN { FS=":" } { printf "+%d %s\n", $2, $1 } ') + "LAg! '$*'" "+wincmd k"
	# fi
}



function open_in_ranger(){
# should be able to open paths starting with filepath:line number or  similar format
arg=$(return_arg_or_piped_input $*)

	# read -r arg
	echo "opening file: $arg in ranger..."
	if [ ! -z "$arg" ]
	then
		/usr/bin/python3.6m.exe /cygdrive/c/cygwin64/bin/ranger # --selectfile="$arg"
		# ranger #--selectfile="$arg"
	fi
}




function open_in_emacs(){
	~/my-scripts/emacs.sh "$(~/my-scripts/convert_path_to_windows.sh $*)"
}
function open_in_explorer(){
	~/my-scripts/open_explorer.sh "$(~/my-scripts/convert_path_to_windows.sh $*)"
}
function open_in_npp(){
	~/my-scripts/npp.sh "$(~/my-scripts/convert_path_to_windows.sh $*)"
}
function open_in_sublime_text(){
	~/my-scripts/sublime_text.sh "$(~/my-scripts/convert_path_to_windows.sh $*)"
}
function default_run(){
	~/my-scripts/default_run.sh "$(~/my-scripts/convert_path_to_windows.sh $*)"

}
