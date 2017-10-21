# fzy is faster than fzf


# Create path variables
WORKING_PATH="$(pwd)"
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")


# map C:\cbn_gits to linux also
# sublime $(convert_path path)
#convert_path(){
# if windows: convert to C:\ from cygdrive&/mnt/c
# if linux:
#
#}
# C:\cygwin64\bin\mintty.exe --dir "%1" /bin/bash
# C:\cygwin64\bin\mintty.exe --dir "%1" /bin/env CHERE_INVOKING=1 /bin/bash -l

# C:\cygwin\bin\mintty.exe -h always -e /bin/sh -c '/cygdrive/c/cygwin64/mysql2sqlite.sh| /bin/sqlite3 database.sqlite'

#grep "/.*" -E -o ~/.viminfo |sort |uniq -i|fzf|sed 's/"//g'
#echo "$(grep "/.*" -E -o ~/.viminfo |sed 's/"//g'|sort|uniq -i|fzf)"

###TODO

function network() {
	# ping abc,nslookup abc,traceroute,host,host -t CNAME www.redhat.com
	ping "$1"
	echo -e "\n\nnslookup\n"
	nslookup "$1"
	echo -e "\n\nhost -t CNAME"
	host -t CNAME "$1"
	echo -e "\n\ntraceroute\n"
	echo -e "\n\ndig\n"
	dig "$1"
	traceroute "$1"
}

function smart_recent(){
	pwd
	# call re
	# case $1 in
	# npp: npp choice
}




function cbn(){
echo "
alias sf='searchfiles'

alias st='searchtext'
# search is recursive by default
alias sth='searchhere'

# alias stf='searchtext .'

alias sn='searchnotes'
alias snf='searchnotes .|fzs' # sn fuzzy

alias sa='searchall'
alias saf='searchall .'


# TODO
alias srf='searchInRecentfiles .'


alias ex='exit'

alias ff='pcfind common_fuzzy fuzzy_db'
alias f='pcfind common db'
alias fa='pcfind all db'
alias ffa='pcfind all_fuzzy fuzzy_db'
alias faf='pcfind all_fuzzy fuzzy_db'
"|fzy -l 22
}

#set PATH $PATH=/usr/local/bin
export PATH=/usr/local/bin:$PATH
export PATH=~/anaconda3/bin:$PATH
export PATH=$PATH:/mnt/c/Windows/System32
# copy file path to clipboard
  #newline must be stripped http://stackoverflow.com/questions/12524308/bash-strip-trailing-linebreak-from-output
  mpf() {
    FILE=$(mdfind -name . 2> /dev/null | fzf) \
      && echo "${FILE}" | tr -d '\n' | pbcopy
  }


source $HOME/essential_functions.sh
source $HOME/search_functions.sh

#www.cibinmathew.com
#github.com/cibinmathew




# Go back to previous folder
# cd -

# for most of the regex lookaround searches defined here like
# cmd abc xyz$ can be used to search for .xyz extension


# credits:
# http://rejeep.github.io/bash/2009/06/03/bash-tips.html

# initial configuration
# to make startup faster; http://stackoverflow.com/questions/28410852/startup-is-really-slow-for-all-cygwin-applications

# for case insensitive autocompletion, in  /etc/inputrc or ~/.inputrc uncomment
# set completion-ignore-case on



# don't put duplicate lines or empty spaces in the history
export HISTCONTROL=ignoreboth

# merge session histories
shopt -s histappend



source $HOME/misc_lib.sh
source $HOME/lib.sh
#source $HOME/myalias.sh
function op() {
echo "$#"
echo "$2"
echo "$2" | head -"$1" | tail -1
# echo "$1"

}
alias mkcd='_(){ mkdir $1; cd $1; }; _'



# ls after cd
# I always, no matter what, want to list the current folders contents when I enter it. So after a while when gotten tired of typing ls all the time. I wrote a little function to do the job:
# Does ls after cd.
function cd()
{
  builtin cd ${1:-$HOME} && ls
}

# Fast ls
# As you might figure out from the previous tip, I like to know what I have in the current folder, all the time. The above only helps if I move around between different folders. So I needed something when changing a lot in the current folder.
function lss(){
#ls stats
ls
lfind . -type f | sed 's/.*\.//' | sort | uniq -c
ls|wc -l
#du
}
alias ls='_(){ ls --color=auto -p "$@" ; lfind . ! -name . -prune -print | grep -c /; }; _'


# Put this in your ~/.bashrc file and then source it with source ~/.bashrc and try it out by pressing C-o (Ctrl and o).





#switch case example
	#case $# in
	#2)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)" --color=auto $Universal_home/Downloads/all_files.db |  sed -e "s/\\/cygdrive\\///";;
	#3)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)" --color=auto $Universal_home/Downloads/all_files.db |  sed -e "s/\\/cygdrive\\///";;
	#4)  grep -PrIi "(?=.*$1[^/]*$)(?=.*$2[^/]*$)(?=.*$3[^/]*$)(?=.*$4[^/]*$)" --color=auto $Universal_home/Downloads/all_files.db |  sed -e "s/\\/cygdrive\\///";;
	#*)  echo "too many arguments"  ;;
	#esac

## RANGER
# Preventing nested ranger instances
# You can start a shell in the current directory with S, when you exit the shell you get back to your ranger instance.
# When you however forget that you already are in a ranger shell and start ranger again you end up with ranger running a shell running ranger.
# To prevent this you can create the following function in your shell's startup file:
# ranger() {
    # if [ -z "$RANGER_LEVEL" ]; then
				#####/usr/bin/ranger "$@"
        # ranger "$@"
    # else
        # exit
    # fi
# }

# alias ranger='/usr/bin/python3.6m.exe /cygdrive/c/cygwin64/bin/ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
alias ranger='/usr/bin/python3.6m.exe /cygdrive/c/cygwin64/bin/ranger' #; LASTDIR=`cat $(cd)`; cd "$LASTDIR"'

alias r='ranger'

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# https://stackoverflow.com/questions/12870928/mac-bash-git-ps1-command-not-found
source ~/.git-prompt.sh
if [[ "$TERM" == "emacs" ]]; then
  # No terminal escape sequences, only prompt escapes
  PS1='\u at \h in \w\n\$ '
  # PS1='$ '
else
  # Assuming a rich terminal, using terminal escape sequences

#PS1=$PS1'$(__git_ps1 "(%s) ")'
PS1='\# \[\e[0;31m\]$(r=$?; [[ $r == "0" ]] || echo "[$r] ")\[\e[0m\]\[\e[0;36m\]\u\[\e[0m\] \w\[\e[0;33m\]$(__git_branch)\[\e[0m\]> '
fi

__git_branch() {
    git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1)/'
}

#Sometimes you have multiple terminal windows open at the same time. By default, the window that closes last, will overwrite the bash history file, loosing the history of all the other terminal windows and ssh sessions in the process. This can be avoided by this little setting:

# merge session histories
shopt -s histappend

#colorize my man pages (and all less output in general):
# colorful man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m' # end the info box
export LESS_TERMCAP_so=$'\E[01;42;30m' # begin the info box
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# use colordiff instead of diff if available
command -v colordiff >/dev/null 2>&1 && alias diff="colordiff -u"

# use htop instead of top if installed
command -v htop >/dev/null 2>&1 && alias top=htop
#The command -v bit checks if the app in question is installed, and creates the alias only if it is found. I’m redirecting the output so that I don’t get error messages scrolling on the screen when I log in.

# corrects typos (eg: cd /ect becomes cd /etc)
shopt -s cdspell

export PAGER="/usr/bin/less -isM"
export LESS="/usr/bin/less -isM"


#z fuzzy cd completion
source ~/my-scripts/z/z.sh


source ~/my.keybindings.sh
# Rename command prompt
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
if [[ "$unamestr" == 'Darwin' ]]; then
  export PROMPT_COMMAND='echo -ne "\033]0;🍎${PWD##*/}\007"'
elif [[ "$unamestr" == 'Linux' ]]; then
  export PROMPT_COMMAND='echo -ne "\033]0;🐧${PWD##*/}\007"'
fi

# Set the PS1 prompt (with colors).
# Based on http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# And http://networking.ringofsaturn.com/Unix/Bash-prompts.php .
# http://ezprompt.net/
if [[ "$unamestr" == 'Darwin' ]]; then
  export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \D{%T} \n$ "
elif [[ "$unamestr" == 'Linux' ]]; then
  #extremely different colors for linux so I don't confuse myself when SSH'ing
  export PS1="\[\e[00;32m\] 🐧 \u\[\e[0m\]\[\e[00;45m\]@\h:\[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] \[\e[0m\] \D{%T} \n$ "
fi



# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss

PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login

if [[ "$unamestr" == 'Darwin' ]]; then
  export HISTFILE=$HOME/Dropbox/dev/bash_eternal_history_mac.txt
elif [[ "$unamestr" == 'Linux' ]]; then
  export HISTFILE=$HOME/dev/bash_eternal_history_linux.txt
fi





function xpl() {
	#alias vl='vim $(fc -s)' # will open the output of last command in vi
	file ="$(fc -s|head -$1 | tail -1)"
	echo "$file"
	# ff=$(echo /cygdrive/f/july\ 2/ |  sed -r "s/\\/cygdrive\\/(.)\\//\1:\\\\\\\/" | sed -e "s/\\//\\\\\\\/g" | sed -r "s/(.*)\\\\\\\/\"\1\"/")
	# echo "$ff"
	# explorer.exe "$ff"
	# if [ ! -f "$file" ]; then
		# echo "File exist"
    # else
		# echo "File not found!"
	# fi
}

function open() {

# http://robertmarkbramprogrammer.blogspot.in/2007/06/cygwin-bash-script-open-windows.html
if [ $# -eq 0 -o  -n "$1" ]; then
        if [ -n "$1" ];  then
		# normal argument
			filepath="$1"
		else
		# capture the piped input as an argument
			read filepath;
		fi
		echo "file is $filepath"
		filepath=$(echo "$filepath" | head -1)
	 #if [ -z "$1" ]; then


	# location=.
	# case "$1" in
	 # ""                 ) location=.;;
	 # "-help"            ) usage; exit 0;;
	 # *                  ) location="${1}";;
	# esac

	# if [ -e "$location" ]
	# then
	   # WIN_PATH=`cygpath -w -a "${location}"`
	   # cmd /C start "" "$WIN_PATH"
	# else
	 # echo ${location} does not exist!
	 # exit 2
	# fi

	b=$(echo $filepath | sed 's/\(.\)/\1:/' | sed -e "s/\\//\\\\/g")
	echo opening "$b"
	cmd /C start "" "$b"


 else
 {
        echo "else $*"
	 echo "Open Windows Explorer"
	 echo "Usage: $0 [-help] [path]"
	 echo "          [path]: folder at which to open Windows Explorer, will"
	 echo "              default to current dir if not supplied."
	 echo "          [-help] Display help (this message)."

	}
    fi
 }

#delete
# grep "~?/.*" -E -o ~/.viminfo |sed 's/"//g'>~/cbn_history.txt
# grep "~?/.*\"" -E -o "$sublime_file" |sed 's/"//g'>>~/cbn_history.txt
# grep "\\w:\\\[^\"]*\" " -E -o /cygdrive/c/Users/"$USERNAME"/AppData/Roaming/Notepad++/session.xml>>~/cbn_history.txt
# #remove ", trailing spaces
# echo  "$(cat ~/cbn_history.txt|convert_to_cygdrive|sed 's/"//g'|sed 's/ *$//'|sort|uniq)"
#delete


# fzf|escape_spaces|recent_in_app



function cd_to_directory() {
	arg=$*
	if [[ -d $arg ]]; then
		echo "$arg is a directory"
		command cd -- $arg
	elif [[ -f $arg ]]; then
		parentdir="$(dirname "$arg")"
		command cd -- "${parentdir}"
		echo "cd ing..."
		pwd

	else
	echo "$arg is not valid"
	# exit 1
	fi
}

function aaa(){
	c=$(return_arg_or_piped_input $*)
	echo "aaa=$c"
}

function return_arg_or_piped_input(){
	if [ -t 0 ]; then
	    echo "$1"
	else
	    read a
	    echo "$a"
	fi
}

# ls working colorful on all OS'es
#linux
if [[ `uname` == Linux ]]; then
    export LS1='--color=always'
#mac
elif [[ `uname` == Darwin* ]]; then
    export LS1='-G'
#win/cygwin/other
else
    export LS1='--color=auto'
fi

export LS2='-hF --time-style=long-iso'
alias l='ls $LS1 $LS2 -AB'

function gitp(){
gits

	read -n 1 -p "commit?? "
	read -p "commit message: " message
	git commit -a -m "$message"
	read -n 1 -p "push?? "
	git push
}

function gits()
{


# todo grep only modified or added
git remote show origin|grep Fetch|grep -P \\w+\.git$
# OR basename $(git remote show origin|grep Fetch|cut -d: -f2-)

# git status --short
git status --short| grep -E "^( M|A)"
# | less

# time consuming
echo "todays new files ..."
# lfind . -mtime -1 -type f -print| grep -v -E "^\./\.git"
}


function gitd() {
# gits advanced diff



echo "List deleted files"
git ls-files --deleted
read -n 1 -p "newly added files" pressedkey
git diff --name-only --diff-filter=A --cached # All new files in the index
echo "List modified files"
read -n 1 -p "enter to continue" pressedkey
git ls-files --modified
git ls-files --modified|wc -l
echo "List untracked files"
read -n 1 -p "enter to continue" pressedkey
git ls-files --others
git ls-files --others|wc -l
echo "List files with their statuses"
read -n 1 -p "enter to continue" pressedkey
git status --porcelain


}
# TODO
function gitinit(){

	# Create path variables
WORKING_PATH="$(pwd)"
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")


# Initialize empty git repo
if [ -d "$WORKING_PATH/.git" ]; then
  read -r -p ".git already exists in directory, do you want to reinitialize? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      git init

      read -p "remote? : git@github.com:User/UserRepo.git" remote_url< /dev/tty
	echo "$remote_url: "
	git remote add origin "$remote_url"

      ;;
    *)
      fatal "Program exiting"
    ;;
  esac
else
  git init
  read -p "remote? : " remote_url< /dev/tty
	echo "$remote_url"
	git remote add origin "$remote_url"
fi


# Create README.md
README="$WORKING_PATH/README.md"
[ -e "$README" ] && rm "$README"
touch "$README"

# Add project name as title of README
if [ "$project_name" ]; then
  echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" > "$README"
else
  while [[ $project_name == '' ]]
  do
    read -r -p "What is the name your project (added as title to README):" project_name
  done
  echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" > "$README"
  info "Title added to README"
fi

# Copy .gitignore

git add README.md
# git add .
git commit -m "Initial commit: Project created"

# git remote set-url origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
# git push --set-upstream origin master

}

function git2() {
# https://github.com/chrissimpkins/scriptacular/blob/master/version-control/gitinit.sh



	# Initialize a directory with git, stage and commit existing files
# Copyright 2013 Christopher Simpkins
# MIT License

FILE_TYPE="."
INITIAL_COMMIT_MESSAGE="Initial commit"

if [ -d ".git" ]; then
	echo "This directory has already been initialized with git."
	exit 1
else
	git init
	if (( $? )); then
		echo "Unable to initialize your directory" >&2
		exit 1
	fi
	git add "$FILE_TYPE"
	if (( $? )); then
		echo "Unable to stage files" >&2
		exit 1
	fi
	git commit -m "$INITIAL_COMMIT_MESSAGE"
	if (( $? )); then
		echo "Unable to create the initial commit" >&2
		exit 1
	fi
	touch README.md
	touch .gitignore
	echo " ----- "
	echo "The directory was initialized and an initial commit was performed with the files matching the pattern '$FILE_TYPE'"
fi
exit 0
}
