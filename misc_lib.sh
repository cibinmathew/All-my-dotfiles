
function myindexfolders() { 
if [ -z "$1" ]; then
    #display usage if no parameters given
    echo "Usage: cibin index all folders to ~/all_folders.db"
	lfind /cygdrive -type d -iname "*" > ~/"all_folders.db"
   cat ~/"all_folders.db" 
   cat ~/"all_folders.db" | sed -r "s/\\/cygdrive\\/(.)\\//\1:\\\\\\\/" | sed -e "s/\\//\\\\\\\/g"  > ~/"all_folders2.db"
fi
 }
 

function myindexemacs() { 
file="$Universal_home/AppData/Roaming/.emacs.d/my-files/emacs-tmp/.file_cache"
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: cibin index all files to $file"
	echo '(' > "$file"
#	lfind.exe /cygdrive/c/cbn_gits/AHK/LIB  -iname "*.ahk" -printf '("%P" "%h")\n'  | sed -r "s/\\/cygdrive\\/(.)\\//\1:\//" | tr -d '\n' >> "$file"
	lfind  /cygdrive/c/cbn_gits/AHK/*  $Universal_home/Downloads/* -iregex ".*\.\(txt\|py\|ini\|java\|ahk\)" -printf '("%f" "%h")\n'  | sed -r "s/\\/cygdrive\\/(.)\\//\1:\//" | tr -d '\n' >> "$file"
	echo ')' >> "$file"
fi
 }

function myindex() { 
if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "cibin/ indexing all files to ~/all_files_unfiltered.db"
	lfind /cygdrive -iname "*"  > ~/"all_files_unfiltered.db"
	cat ~/"all_files_unfiltered.db" | grep -i -v "/cygdrive/c/cygwin64/usr/" |  grep -i -v "/cygdrive/c/Users/$USERNAME/Anaconda" | grep -i -v "/cygdrive/c/MinGW/" | grep -i -v "/cygdrive/./\$Recycle.Bin/" | grep -v "/cygdrive/./\$WINDOWS.~BT/" | grep -v "/cygdrive/c/Users/cibin/AppData/" | grep -v "/cygdrive/c/my_bin/" | grep -v "/cygdrive/c/Python27/" | grep -v "/cygdrive/c/Program Files (x86)/" | grep -v "/cygdrive/c/Program Files/" | grep -v "/cygdrive/c/Windows/" | grep -v "/cygdrive/c/ProgramData/"  | grep -v "/cygdrive/c/Users/$USERNAME/AppData/" > ~/"all_files.db"
	 
	# cat ~/"all_files_unfiltered.db" | sed 's/ //g'| sed 's/_//g' | sed 's/-//g'  > ~/"all_files-fuzzy.db"
	cat ~/"all_files_unfiltered.db" |  sed 's/[!@#$%^&*()_ -]//g'  > ~/"all_files_unfiltered-fuzzy.db"
	cat ~/"all_files.db" |  sed 's/[!@#$%^&*()_ -]//g'  > ~/"all_files-fuzzy.db"
	# "/cygdrive/c/Windows/WinSxS/" | grep -v "/cygdrive/c/Windows/Microsoft.NET/" 
 
 fi
 }

function other_indexes() { 
if [ -z "$1" ]; then
    echo "indexing"
	lfind "$Universal_home/Box Sync/MMF/" > "C:/cbn_gits/AHK/searchInProject.db"
	
	lfind "C:/ProgramData/Microsoft/Windows/Start Menu/Programs" -iname "*.lnk" > "C:/cbn_gits/AHK/smart_search/db/start-menu.txt"
	# printf "\n" >> "C:/cbn_gits/AHK/smart_search/db/start-menu.txt"
	lfind "$Universal_home/AppData/Roaming/Microsoft/Windows/Start Menu/Programs" -iname "*.lnk" >> "C:/cbn_gits/AHK/smart_search/db/start-menu.txt"
	fi
 }

 function swap_filenames()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
