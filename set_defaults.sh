# function set_home_directory() {

	if [ "$OS" == "Windows_NT" ]; then
		Universal_home=$(cygpath -H)
	else
		Universal_home=$HOME
		echo "linux machine"
	fi
	Universal_home="$Universal_home/$USERNAME"
	export Universal_home
	# echo "$Universal_home"
	
# }
