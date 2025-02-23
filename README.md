![Fresh-install](asset/fresh-install.webp)

# Linux Task

- Create bash script that run on fresh install Linux Distro and make it comfortable to use for your prefirences
- Make backup of config files that was created


## Table Of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Contributing](#contributing)


## Prerequisites
1. Linux RHED distribution


## Usage 
Make RHED Linux comfortable to use after fresh install.
Run script without any flags to make all changes or choose flags to run only things you want to change.

Syntax: after-party.sh [-h|a|u|v|i|p|b] [--help|alias|update|vim|packages|promt|backup]
options:
help       Print this Help.
alias      Create aliasses for user from conf file. cc: clear, ll: ls -lah 
update     Update installed packages.
vim        Install vim modules.
packages   Install usefull packages like git, k8s.
promt      Make promt more informative. Add git branch
backup     Make backup to created and updated files to after-party-backup.tar.gz file in home directory
h          Alias to 'help'
a          Alias to 'alias'
u          Alias to 'update'
v          Alias to 'vim'
i          Install packages, alias to 'packages'
p          Alias to 'prompt'
b          Alias to 'backup'

## Contributing 

Just me, myself and I :-)
