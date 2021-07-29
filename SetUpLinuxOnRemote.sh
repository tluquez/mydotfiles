#!/bin/bash

set -u -o pipefail

# Set up variables
CONDA=${1:-no}

# Let's rock it!
printf "\nLet's begging setting up your bash environment baby!!!\n"
printf "**** Remember this script overwrites any previous files or symlinks ****\n"

# Bash version
if [[ `echo "${BASH_VERSINFO:-0}"'<='3.9 | bc -l` == 1 ]]; then
  echo -e "Upgrading bash\n"
  sudo apt-get install --only-upgrade bash
fi

# Git clone mydotfiles
MYDOTFILES="$HOME/mydotfiles"
if [[ ! -d $MYDOTFILES ]]; then
  git clone https://github.com/tluquez/mydotfiles.git $MYDOTFILES
  else
  rm -rf $MYDOTFILES
  git clone https://github.com/tluquez/mydotfiles.git $MYDOTFILES
fi

# Symlink dot files
ln -sfv $MYDOTFILES/my.bashrc_linux $HOME/.bashrc
ln -sfv $MYDOTFILES/my.bash_profile $HOME/.bash_profile
ln -sfv $MYDOTFILES/my.bash_prompt $HOME/.bash_prompt
ln -sfv $MYDOTFILES/my.bash_aliases $HOME/.bash_aliases
ln -sfv $MYDOTFILES/my.bash_functions $HOME/.bash_functions
#ln -sfv $MYDOTFILES/my.private_info $HOME/.private_info
ln -sfv $MYDOTFILES/my.inputrc $HOME/.inputrc
if [[ ! -d $HOME/.tmux.conf ]]; then
  mkdir -p $HOME/.config/htop/
  ln -sfv $MYDOTFILES/my.htoprc $HOME/.config/htop/htoprc
  else
  ln -sfv $MYDOTFILES/my.htoprc $HOME/.config/htop/htoprc
fi
if [[ ! -d $HOME/.vim/colors/ ]]; then
  mkdir -p $HOME/.vim/colors/
  ln -sfv $MYDOTFILES/my.vimrc_monokai-phenix.vim $HOME/.vim/colors/monokai-phoenix.vim
  else
    ln -sfv $MYDOTFILES/my.vimrc_monokai-phenix.vim $HOME/.vim/colors/monokai-phoenix.vim
fi
ln -sfv $MYDOTFILES/my.vimrc $HOME/.vimrc

#Set up .tmux.conf depending on the version
if [[ ! -f $HOME/.tmux.conf ]]; then
  if [[ `tmux -V` < 3  ]]; then
    printf "\nGetting .tmux.conf version 2\n"
    ln -sfv $MYDOTFILES/.tmux.conf.V2 $HOME/.tmux.conf
  else
    printf "\nGetting .tmux.conf version 3\n"
    ln -sfv $MYDOTFILES/.tmux.conf.V3 $HOME/.tmux.conf
  fi
fi

# Quiet log in to servers
touch $HOME/.hushlogin

printf "\nSourcing and binding\n\n"
. $HOME/.bashrc
#bind -f  $HOME/.inputrc

# Check if mybin exists if not create it
if [[ ! -d "$HOME/mybin" ]]; then
  mkdir -p $HOME/mybin
fi

# Installing miniconda according to user's preference
if [[ ${CONDA} == "conda" ]]; then
  printf "\nMiniconda's default path is going to be "$HOME/miniconda".\n"
  #Download the latest shell script
  wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/mybin/

  #Make the miniconda installation script executable
  chmod +x $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

  #Run miniconda installation script
  $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
  rm $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

  # Let's config and install some packages
  conda config --add channels conda-forge;conda config --add channels defaults;conda config --add channels r;conda config --add channels bioconda
  conda install samtools bedops parallel bcftools bedtools boto3 libopenblas
  parallel --cite
fi

printf "All done! It's a good idea to log out and back in to enable .inputrc.\nSee you later, alligator!\n"
exit 0
