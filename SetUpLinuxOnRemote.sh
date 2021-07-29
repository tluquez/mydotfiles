#!/bin/bash

set -u -o pipefail

CONDA=${1:-no}

printf "\nLet's begging setting up your bash environment baby!!!\n\n"
printf "**** Remember this script overwrites any previous files or symlinks ****\n\n"

# Bash version
if [[ `echo "${BASH_VERSINFO:-0}"'<='3.9 | bc -l` ]]; then
  echo -e "Upgrading bash\n"
  sudo apt-get install --only-upgrade bash
fi

# Git clone mydotfiles
git clone https://github.com/tluquez/mydotfiles.git $HOME

# Symlink dot files
ln -sfv $HOME/mydotfiles/my.bashrc_linux $HOME/.bashrc
ln -sfv $HOME/mydotfiles/my.bash_profile $HOME/.bash_profile
ln -sfv $HOME/mydotfiles/my.bash_prompt $HOME/.bash_prompt
ln -sfv $HOME/mydotfiles/my.bash_aliases $HOME/.bash_aliases
ln -sfv $HOME/mydotfiles/my.bash_functions $HOME/.bash_functions
#ln -sfv $HOME/mydotfiles/my.private_info $HOME/.private_info
ln -sfv $HOME/mydotfiles/my.inputrc $HOME/.inputrc
if [[ ! -d $HOME/.tmux.conf ]]; then
  mkdir -p $HOME/.config/htop/
  ln -sfv $HOME/mydotfiles/my.htoprc $HOME/.config/htop/htoprc
  else
  ln -sfv $HOME/mydotfiles/my.htoprc $HOME/.config/htop/htoprc
fi
if [[ ! -d $HOME/.vim/colors/ ]]; then
  mkdir -p $HOME/.vim/colors/
  ln -sfv $HOME/mydotfiles/my.vimrc_monokai-phenix.vim $HOME/.vim/colors/monokai-phoenix.vim
  else
    ln -sfv $HOME/mydotfiles/my.vimrc_monokai-phenix.vim $HOME/.vim/colors/monokai-phoenix.vim
fi
ln -sfv $HOME/mydotfiles/my.vimrc $HOME/.vimrc

#Set up .tmux.conf depending on the version
if [[ ! -f $HOME/.tmux.conf ]]; then
  if [[ `tmux -V` < 3  ]]; then
    printf "\nGetting .tmux.conf version 2\n"
    ln -sfv $HOME/mydotfiles/.tmux.conf.V2 $HOME/.tmux.conf
  else
    printf "\nGetting .tmux.conf version 3\n"
    ln -sfv $HOME/mydotfiles/.tmux.conf.V3 $HOME/.tmux.conf
  fi
fi

# Quiet log in to servers
touch $HOME/.hushlogin

printf "\nSourcing and binding\n\n"
. $HOME/.bashrc
bind -f  $HOME/.inputrc

# Check if mybin exists if not create it
if [[ ! -d "$HOME/mybin" ]]; then
  mkdir -p $HOME/mybin
fi

# Installing miniconda according to user's preference
if [[ ${CONDA} == "conda" ]]; then
  printf "Downloading, installing, and configuring miniconda"
  #Download the latest shell script
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh $HOME/mybin/

  #Make the miniconda installation script executable
  chmod +x $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

  #Run miniconda installation script
  $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh
  rm $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

  # Let's config and install some packages
  conda config --add channels conda-forge;conda config --add channels defaults;conda config --add channels r;conda config --add channels bioconda
  conda install samtools bedops parallel bcftools bedtools boto3 libopenblas
  parallel --cite
fi

printf "All done!\n See you later, alligator!\n"
exit 0
