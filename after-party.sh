#!/usr/bin/env bash

################################################
# Developed by: Andrey M.
# Purpose: Make RHEL linux system comfortable to use after clean install
#	   By updating system packages, install neccessary packages, vim plugins and aliases
# Date: 21-02-2025
# Version: 1.0.0
################################################
set -o errexit
set -o pipefail
#set -o nounset
################################################

############################################################################
# Main
############################################################################
Main()
{
	if [[ "$1" == "" ]]; then
                Run_all
                exit 0
        else

		# check options -
		while [[ "$#" -gt 0 ]]; do
    			case "$1" in
      				-h | --help )
         				Help
         				exit
					;;
				-a | --alias )
					Alias
					;;
				-u | --update ) 
					Update_system
					;;
				-v | --vim ) 
					Vim
					;;
				-i | --packages ) 
					Install_packages
					;;
				-p | --prompt ) 
					Prompt
					;;

     				-- ) shift; break ;;  # End of options
        			-* )  ;;
        			* ) break ;;
   			esac
			shift
		done

	fi
	
}

#############################################################################
# Init
#############################################################################
Init()
{
	# Script initalization
	# Check if the script is run with sudo
	if [ "$EUID" -eq 0 ]; then
  		echo "Please run this script not with  sudo."
  		exit 1
	fi

	conf_file_path="after-party.conf"
	conf_sourced=False
	root_pwd=-1
	alias_run=False
	update_run=Flase
	vim_run=False
	packages_run=False
	promt_run=False


}

#############################################################################
# Destruct
#############################################################################
Destruct()
{
	# Destruct, delete local variables
	unset root_pwd
	unset conf_file_path
	unset conf_sourced
	unset alias_run
	unset update_run
	unset vim_run
	unset packages_run
	unset promt_run
}


##############################################################################
# Get_root
##############################################################################
Get_root(){
	# Take root password from user
	if [[ $root_pwd == -1 ]]; then
		read -sp "Enter root password: " root_pwd
	fi
}


##############################################################################
# Import_config
##############################################################################
Import_config()
{
	if [[ $conf_sourced != True ]]; then
		conf_sourced=True
		if [[ -f "$conf_file_path" ]]; then
			. "$conf_file_path" 
		else
			echo "Configuration file not found in path $conf_file_path"
			exit 1
		fi
	fi
}

#############################################################################
# Run_all
#############################################################################
Run_all(){
	Update_system
	Install_packages
	Alias
        Vim
        Prompt
}


#############################################################################
# Update_system
#############################################################################
Update_system()
{
	if [[ $update_run == True ]]; then
		echo update already run
		return 0
	fi
	
	update_run=True
	echo System update

	set +o errexit
	Get_root
	echo $root_pwd | sudo -S yum check-update; sudo yum update -yv
	set -o errexit
}


#############################################################################
# Install_packages
#############################################################################
Install_packages()
{
	if [[ $packages_run == True ]]; then
                return 0
        fi

	packages_run=True

	# install packages from conf file
	Import_config

	Get_root

	# add repos
	echo $root_pwd | sudo -S dnf -y install dnf-plugins-core
	for item in "${package_sources[@]}"
	do
		echo $root_pwd | sudo -S sudo dnf config-manager --add-repo "$item"
	done

	# install packages
	echo $root_pwd | sudo -S yum -y install "${package_list[@]}"

}


###############################################################################
# Alias
###############################################################################
Alias()
{
	if [[ $alias_run == True ]]; then
                return 0
        fi
	
	alias_run=true

	Import_config

	#  create alias
	for item in "${alias_list[@]}"
        do
        	echo "alias $item" >> ~/.bashrc
        done
	. ~/.bashrc

}


##############################################################################
# Vim
##############################################################################
Vim()
{
	if [[ $vim_run == True ]]; then
                return 0
        fi

	vim_run=True

	Import_config
	
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	# install vim modules from conf file
	cat <<< "set nocompatible 
filetype off                  
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'" > ~/.vimrc
	
	for item in "${vim_plug_list[@]}"
        do
               echo "Plugin '$item'" >> ~/.vimrc
        done
	
	echo "call vundle#end()" >> ~/.vimrc
	echo "filetype plugin indent on" >> ~/.vimrc 
	vim +PluginInstall +qall
}


###############################################################################
# Prompt
###############################################################################
Prompt()
{
	if [[ $promt_run == True ]]; then
                return 0
        fi


	prompt_run=True

	# Update promt
	echo "PS1='\u@\h \[\e[32m\]\w \[\e[91m\]$(__git_ps1)\[\e[00m\]$ '" >> ~/.bashrc
	. ~/.bashrc

}


################################################################################
# Help                                                                         
################################################################################
Help()
{
	# Display Help
	echo "Make RHED Linux comfortable to use after fresh install."
	echo "Without any parrameters will make all options"
	echo
	echo "Syntax: after-party.sh [-h|a|u|v|i|p] [--help|alias|update|vim|packages|promt]"
	echo "options:"
	echo "help       Print this Help."
	echo "alias      Create aliasses for user from conf file. cc: clear, ll: ls -lah "
	echo "update     Update installed packages."
	echo "vim        Install vim modules."
	echo "packages   Install usefull packages like git, k8s."
	echo "promt      Make promt more informative. Add git branch"
	echo "h          Alias to 'help'"
	echo "a          Alias to 'alias'"
	echo "u          Alias to 'update'"
	echo "v          Alias to 'vim'"
	echo "i          Install packages, alias to 'packages'"
	echo "p          Alias to 'prompt'"
	echo
}


Init
Main "$@"
Destruct
exit 0

