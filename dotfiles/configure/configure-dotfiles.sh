#!/bin/sh
echo "####################### configuring dotfiles ######################" | tee -a setuplog.txt

user_home="$1"
echo "$(date) - Run as: $user_home" | tee -a setuplog.txt

# Ensure Starship is installed and up to date.
mkdir -v -p $user_home/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --force --bin-dir $user_home/.local/bin

# Ensure dotfiles are downloaded.
mkdir -v -p $user_home/.dotfiles
wget -O $user_home/.dotfiles/starship.toml "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/starship.toml"
wget -O $user_home/.dotfiles/.commonrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.commonrc"
wget -O $user_home/.dotfiles/.zshrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.zshrc"
wget -O $user_home/.dotfiles/.bashrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.bashrc"

# Ensure dotfiles are symlinked.
rm -v -f $user_home/.zshrc
ln -v -s $user_home/.dotfiles/.zshrc $user_home/.zshrc && echo "$(date) - Created symlink for .zshrc" >> setuplog.txt || echo "$(date) - Failed to create symlink for .zshrc" | tee -a setuplog.txt
        
rm -v -f $user_home/.bashrc
ln -v -s $user_home/.dotfiles/.bashrc $user_home/.bashrc && echo "$(date) - Created symlink for .bashrc" >> setuplog.txt || echo "$(date) - Failed to create symlink for .bashrc" | tee -a setuplog.txt

mkdir -v -p $user_home/.config
rm -v -f $user_home/.config/starship.toml
ln -v -s $user_home/.dotfiles/starship.toml $user_home/.config/starship.toml && echo "$(date) - Created symlink for starship.toml" >> setuplog.txt || echo "$(date) - Failed to create symlink for starship.toml" | tee -a setuplog.txt

echo "$(date) - Remember to move or symlink any local rc to ~/.localrc" | tee -a setuplog.txt
echo "##################### configure-dotfiles.sh done ######################" | tee -a setuplog.txt