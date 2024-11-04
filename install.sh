#!/bin/bash

# Ensure the script is run from the root of the dotfiles repo
cd "$(dirname "$0")"

# Update and install necessary packages from packages.list
echo "Updating package list and installing necessary packages..."
sudo apt update

# Read and install packages from packages.list
if [ -f "$HOME/dotfiles/programs/packages.list" ]; then
  xargs -a "$HOME/dotfiles/programs/packages.list" sudo apt install -y
else
  echo "packages.list file not found!"
  exit 1
fi

# Install Zap if not already installed
if [ ! -f "$HOME/.local/share/zap/zap.zsh" ]; then
  echo "Installing Zap..."
  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)
fi

# Install Rust and Cargo if not already installed
if ! command -v cargo &> /dev/null; then
  echo "Installing Rust and Cargo..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
fi

# Install Zellij if not already installed
if ! command -v zellij &> /dev/null; then
  echo "Installing Zellij..."
  cargo install --locked zellij
fi

# Install Starship if not already installed
if ! command -v starship &> /dev/null; then
  echo "Installing Starship..."
  curl -fsSL https://starship.rs/install.sh | bash
fi

# Clone or update the dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/cltj/dotfiles.git "$DOTFILES_DIR"
else
  echo "Updating dotfiles repository..."
  cd "$DOTFILES_DIR"
  git pull
fi

# Ensure the projects directory exists
PROJECTS_DIR="$HOME/projects"
if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Creating projects directory..."
  mkdir -p "$PROJECTS_DIR"
fi

# Change to the dotfiles directory
cd "$DOTFILES_DIR"

# Use Stow to symlink configuration files
echo "Symlinking configuration files using Stow..."

# Symlink .zshrc and .bashrc to home directory
stow --target=$HOME --dotfiles zsh
stow --target=$HOME --dotfiles bash

# Symlink all other configurations to .config directory
stow --target=$HOME/.config nvim
stow --target=$HOME/.config starship
stow --target=$HOME/.config programs
stow --target=$HOME/.config git
stow --target=$HOME/.config zellij
stow --target=$HOME/.config zsh

# Ensure Zsh is the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to Zsh..."
  chsh -s /bin/zsh
fi

echo "Setup complete! Please restart your terminal."
