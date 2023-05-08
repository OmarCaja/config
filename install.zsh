#!/bin/zsh

current_dir=$(pwd)
goconf_alias="alias goconf='cd $current_dir'"
valid_aliases_args=(bat exa git nvim zsh)

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
	grep -qF $1 $2 || echo $1 >> $2
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

	if ! grep -qF $1 "$HOME/.gitconfig"
	then
		echo "[include]" >> "$HOME/.gitconfig"
		echo $1 >> "$HOME/.gitconfig"
	fi
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

	touch $HOME/.zshrc

	for arg in $args
	do
		concat_file_lines "# $arg aliases" "$HOME/.zshrc"
		concat_file_lines "[[ -s \"$current_dir/aliases/$arg/.aliases\" ]] && source \"$current_dir/aliases/$arg/.aliases\"" "$HOME/.zshrc"
		if [[ $arg = nvim ]]
		then
			install_gitconfig "    path = $current_dir/git/nvim/.gitconfig"
		fi	
	done
}

while getopts ":hgswfa:" option; do
	case $option in
		h)
		help
		exit;;

		f)
		install_aliases $valid_aliases_args
		install_gitconfig "    path = $current_dir/git/.gitconfig"
		install_starship_config
		install_warp_workflows
		exit;;

		a)
		args=(${(@s:,:)OPTARG})
		check_aliases_args $args[@]
		install_aliases $args[@]
		exit;;

		g)
		install_gitconfig "$current_dir/git/.gitconfig"
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

