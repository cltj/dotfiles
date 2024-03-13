#!/bin/sh
echo "####################### configuring dotfiles ######################" | tee -a setuplog.txt

user_home="$1"
echo "$(date) - Run as: $user_home" | tee -a setuplog.txt
if 
# Ensure the Fira Code Nerd Font is installed.
# mkdir -v -p $user_home/.local/share/fonts/
# for type in Bold Light Medium Regular Retina; do 
# wget -nc -O $user_home/.local/share/fonts/FiraCode-$type.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/$type/complete/Fira%20Code%20$type%20Nerd%20Font%20Complete.ttf?raw=true"; 
# done
# fc-cache -f $user_home/.local/share/fonts/

# Ensure Starship is installed and up to date.
mkdir -v -p $user_home/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --force --bin-dir $user_home/.local/bin

# Ensure McFly is installed.
mkdir -v -p $user_home/.local/share/mcfly
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to $user_home/.local /share/mcfly

# Ensure zoxide is installed.
# sudo apt incurl -sS https://webinstall.dev/zoxide | bash

# Ensure dotfiles are downloaded.
mkdir -v -p $user_home/.dotfiles
wget -O $user_home/.dotfiles/starship.toml "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/starship.toml"
wget -O $user_home/.dotfiles/.commonrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.commonrc"
wget -O $user_home/.dotfiles/.zshrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.zshrc"
wget -O $user_home/.dotfiles/.bashrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.bashrc"
wget -O $user_home/.gitconfig "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.gitconfig"

# Ensure dotfiles are symlinked.
rm -v -f $user_home/.zshrc
ln -v -s $user_home/.dotfiles/.zshrc $user_home/.zshrc && echo "$(date) - Created symlink for .zshrc" >> setuplog.txt || echo "$(date) - Failed to create symlink for .zshrc" | tee -a setuplog.txt
        
rm -v -f $user_home/.bashrc
ln -v -s $user_home/.dotfiles/.bashrc $user_home/.bashrc && echo "$(date) - Created symlink for .bashrc" >> setuplog.txt || echo "$(date) - Failed to create symlink for .bashrc" | tee -a setuplog.txt

mkdir -v -p $user_home/.config
rm -v -f $user_home/.config/starship.toml
ln -v -s $user_home/.dotfiles/starship.toml $user_home/.config/starship.toml && echo "$(date) - Created symlink for starship.toml" >> setuplog.txt || echo "$(date) - Failed to create symlink for starship.toml" | tee -a setuplog.txt

# Source dotfiles.
#test -e $user_home/.zshrc && . $user_home/.zshrc
#test -e $user_home/.bashrc && . $user_home/.bashrc

# Finished
echo "$(date) - Remember to move or symlink any local rc to ~/.localrc" | tee -a setuplog.txt
echo "##################### configure-dotfiles.sh done ######################" | tee -a setuplog.txt