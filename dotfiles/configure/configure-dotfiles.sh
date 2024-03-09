#!/bin/sh

# Ensure the Fira Code Nerd Font is installed.
mkdir -v -p ~/.local/share/fonts/
for type in Bold Light Medium Regular Retina; do 
wget -nc -O ~/.local/share/fonts//FiraCode-$type.ttf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/$type/complete/Fira%20Code%20$type%20Nerd%20Font%20Complete.ttf?raw=true"; 
done
fc-cache -f ~/.local/share/fonts/

# Ensure Starship is installed and up to date.
mkdir -v -p ~/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --force --bin-dir ~/.local/bin
export PATH="~/.local/bin:$PATH"

# Ensure McFly is installed.
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to ~/.local/bin

# Ensure zoxide is installed.
curl -sS https://webinstall.dev/zoxide | bash

# Ensure dotfiles are downloaded.
mkdir -v -p ~/.dotfiles
wget -O ~/.dotfiles/starship.toml "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/starship.toml"
wget -O ~/.dotfiles/.commonrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.commonrc"
wget -O ~/.dotfiles/.zshrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.zshrc"
wget -O ~/.dotfiles/.bashrc "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/.dotfiles/.bashrc"


echo "Creating zsh symlinks..."
rm -v -f ~/.zshrc
ln -v -s ~/.dotfiles/.zshrc ~/.zshrc
        
echo "Creating bash symlinks..."
rm -v -f ~/.bashrc
ln -v -s ~/.dotfiles/.bashrc ~/.bashrc

mkdir -v -p ~/.config
rm -v -f ~/.config/starship.toml
ln -v -s ~/.dotfiles/starship.toml ~/.config/starship.toml

# Source dotfiles.
test -e ~/.zshrc && . ~/.zshrc
test -e ~/.bashrc && . ~/.bashrc

# Finished
echo "Done. Remember to move or symlink any local rc to ~/.localrc"