#!/bin/zsh

current_dir=$(pwd)
goconf_alias="alias goconf='cd $current_dir'"
valid_aliases_args=(bat exa git nvim)

help()
{
	echo "Usage:"
	echo ""
	echo "  ./instal.zsh (options) [<arguments>]"
	echo ""
	echo "  options:"
	echo ""
	echo "    -h                   Show list of options and arguments"
	echo ""
	echo "    -a (<arguments>...)  Install aliases by the given arguments in ~/.aliases"
	echo "                         The arguments must be added separated by comma"
	echo "                         The valid arguments are: bat,exa,git,nvim"
	echo ""
	echo "    -g                   Install git alias in ~/.gitconfig file"
	echo ""
	echo "    -s                   Install Starship config in ~/.config/.starship.toml"
	echo ""
	echo "    -w                   Install war workflows in ~/.warp/workflows"
	echo ""
	echo "    -f                   Install all the above, it is just like full instalation"
	echo ""
	echo "  arguments:"
	echo ""
	echo "    bat:                Copy bat aliases"
	echo ""
	echo "    exa:                Copy exa aliases"
	echo ""
	echo "    git:                Copy git aliases"
	echo ""
	echo "    nvim:               Copy nvim aliases"
}

concat_file_lines () 
{
	IFS=''
	while read line; do
		grep -qF "$line" $2 || echo "$line" >> $2
	done < $1
}

install_starship_config()
{
	mkdir -p $HOME/.config
	cp -rf starship/starship.toml $HOME/.config/starship.toml
}

install_warp_workflows()
{
	mkdir -p $HOME/.warp/workflows
	cp -rf warp/workflows/. $HOME/.warp/workflows
}

install_gitconfig()
{
	touch $HOME/.gitconfig
	concat_file_lines "git/.gitconfig" "$HOME/.gitconfig"
}

install_config_proyect_alias()
{
	grep -qF "$goconf_alias" "$HOME/.aliases" || echo "$goconf_alias" >> "$HOME/.aliases"
}

install_aliases_config()
{
	touch $HOME/.zshrc
	concat_file_lines "aliases/.zshrc" "$HOME/.zshrc"
	touch $HOME/.aliases
}

check_aliases_args()
{
	valid=true
	args=($@)

	for arg in $args
	do
		if ! (( $valid_aliases_args[(Ie)$arg] ))
		then
			echo "Invalid argument $arg"
			valid=false
		fi
	done

	if [[ $valid = false ]]
	then
		help
		exit 1
	fi
}

install_aliases()
{
	args=($@)

	install_aliases_config
	install_config_proyect_alias

	for arg in $args
	do
		concat_file_lines "aliases/$arg/.aliases" "$HOME/.aliases"
	done
}

while getopts ":hgswfa:" option; do
	case $option in
		h)
		help
		exit;;

		f)
		install_aliases $valid_aliases_args[@]
		install_gitconfig
		install_starship_config
		install_warp_workflows
		exit;;

		a)
		args=(${(@s:,:)OPTARG})
		check_aliases_args $args[@]
		install_aliases $args[@]
		exit;;

		g)
		install_gitconfig
		exit;;

		s)
		install_starship_config
		exit;;

		w)
		install_warp_workflows
		exit;;

		\?)
		echo "Wrong usage"
		echo ""
		help
		exit 1;;
		
		:)
		echo "Missing parameter "
		echo "Use valid parameters $valid_aliases_args[@]"
		echo ""
		help
		exit 1;;

	esac
done

help

