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
  git clone -q https://github.com/tluquez/mydotfiles.git $MYDOTFILES
  else
  rm -rf $MYDOTFILES
  git clone -q https://github.com/tluquez/mydotfiles.git $MYDOTFILES
fi

# Symlink dot files
printf "Your symlinks are:\n"
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
    printf "Getting .tmux.conf version 2\n"
    ln -sfv $MYDOTFILES/.tmux.conf.V2 $HOME/.tmux.conf
  else
    printf "Getting .tmux.conf version 3\n"
    ln -sfv $MYDOTFILES/.tmux.conf.V3 $HOME/.tmux.conf
  fi
fi

# Quiet log in to servers
touch $HOME/.hushlogin

# Check if mybin exists if not create it
if [[ ! -d "$HOME/mybin" ]]; then
  mkdir -p $HOME/mybin
fi

# Installing miniconda according to user's preference
if [[ ${CONDA} == "conda" ]]; then
  printf "\nLet's rock miniconda!\n"
  if [[ -d $HOME/miniconda3/bin ]]; then
    printf "\nMiniconda already exists at "$HOME/miniconda3". If you want to delete and re-install miniconda3 run $0 conda_reinstall.\n* Aborting repeated miniconda3 installation. *\n"
    exit 0
  else
    printf "\nMiniconda's default path is going to be "$HOME/miniconda".\n"
    #Download the latest shell script
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/mybin/

    #Make the miniconda installation script executable
    chmod +x $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

    #Run miniconda installation script
    $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    rm $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

    # Let's config and install some packages
    conda config --set auto_activate_base false
    conda config --add channels conda-forge
    conda config --add channels defaults
    conda config --add channels r
    conda config --add channels bioconda

    printf "Installing basic packages: samtools bedops parallel bcftools bedtools boto3 libopenblas\n"
    conda install -y samtools bedops parallel bcftools bedtools boto3 libopenblas

    # Silencing parallel's warnings
    parallel --cite
  fi
  elif [[ ${CONDA} == "conda_reinstall" ]]; then
    printf "\nLet's rock miniconda!\n"
    printf "Deleting miniconda3 from $HOME/miniconda3"
    rm -rf $HOME/miniconda3
    printf "\nMiniconda's new path is going to be "$HOME/miniconda3".\n"
    #Download the latest shell script
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/mybin/

    #Make the miniconda installation script executable
    chmod +x $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

    #Run miniconda installation script
    $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    rm $HOME/mybin/Miniconda3-latest-Linux-x86_64.sh

    # Let's config and install some packages
    conda config --set auto_activate_base false
    conda config --add channels conda-forge
    conda config --add channels defaults
    conda config --add channels r
    conda config --add channels bioconda

    printf "Installing basic packages: samtools bedops parallel bcftools bedtools boto3 libopenblas\n"
    conda install -y samtools bedops parallel bcftools bedtools boto3 libopenblas
fi

printf "\nSourcing .bashrc\n\n"
. $HOME/.bashrc
#bind -f  $HOME/.inputrc

printf "All done! It's a good idea to log out and back in to enable .inputrc.\nSee you later, alligator!\n"
exit 0
