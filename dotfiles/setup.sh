#!/bin/bash
echo "Please enter your email:"
read user_email

if [ -n "$SUDO_USER" ]; then
    user_name=$SUDO_USER
else
    user_name=$(whoami)
fi

if [ -n "$SUDO_USER" ]; then
    user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    user_home=$HOME
fi

sudo apt update -y
sudo apt upgrade -y && sudo apt autoremove -y

####################
# Install packages #
####################
install_package() {
    if ! command -v $1 &> /dev/null; then
        sudo apt install -y $1
    else
        echo "$1 is already installed. Updating to the latest version..."
        sudo apt upgrade -y $1
    fi
}

curl -s https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/settings/packages.txt | while read package; do
    install_package "$package"
done

###########################################
# Check if installed, if not install them #
###########################################
commands=("zsh" "databricks" "az" "git-credential-manager" "poetry")
for command in "${commands[@]}"
do
    if ! command -v $command &> /dev/null
    then
        echo "Installing $command..."
        case $command in
            "zsh")
                if [ ! -d "$user_home/.oh-my-zsh" ]
                then
                    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
                    chsh -s /bin/zsh $user_name
                    sudo apt install fzf -y && sudo apt install zsh-autosuggestions -y
                fi
                ;;
            "databricks")
                curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sudo sh
                ;;
            "az")
                curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
                AZ_REPO=$(lsb_release -cs)
                echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
                sudo apt update
                sudo apt install azure-cli -y
                ;;
            "git-credential-manager")
                wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb" -O /tmp/gcmcore.deb && sudo dpkg -i /tmp/gcmcore.deb
                ;;
            "poetry")
                mkdir -v -p $user_home/.poetry/bin
                curl -sSL https://install.python-poetry.org | sudo python3 - --prefix=$user_home/.poetry/bin
                ;;
        esac
    else
        echo "$command is already installed."
    fi
done

########################################
# Download the configure-git.sh script #
########################################
configure_git_script_url="https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/configure/configure-git.sh"
configure_git_script="./configure-git.sh"

if curl -s -o "$configure_git_script" "$configure_git_script_url"; then
    # Only try to set permissions and run the script if the download succeeded
    chmod +x "$configure_git_script"

    if [ -x "$configure_git_script" ]; then
        # Only run the child script if it is executable
        (./configure-git.sh "$user_email" "$user_name" "$user_home") || echo "configure-git.sh script failed"
    else
        echo "Failed to set execute permissions on configure-git.sh"
        echo "Please run the script manually"
    fi
else
    echo "Failed to download configure-git.sh"
fi

#############################################
# Download the configure-dotfiles.sh script #
#############################################
configure_dotfiles_script_url="https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/configure/configure-dotfiles.sh"
configure_dotfiles_script="./configure-dotfiles.sh"

if curl -s -o "$configure_dotfiles_script" "$configure_dotfiles_script_url"; then
    # Only try to set permissions and run the script if the download succeeded
    chmod +x "$configure_dotfiles_script"

    if [ -x "$configure_dotfiles_script" ]; then
        # Only run the child script if it is executable
        ./configure-dotfiles.sh || echo "configure-dotfiles.sh script failed"
        # Source dotfiles.
        test -e $user_home/.zshrc && source $user_home/.zshrc
        test -e $user_home/.bashrc && source $user_home/.bashrc
        test -e $user_home/.config/envman/PATH.env && source $user_home/.config/envman/PATH.env
        test -e $user_home/.dotfiles/.commonrc && source $user_home/.dotfiles/.commonrc
    else
        echo "Failed to set execute permissions on configure-dotfiles.sh"
        echo "Please run the script manually"
    fi
else
    echo "Failed to download configure-dotfiles.sh"
fi

#######################
# Configure azure cli #
#######################
# Prompt the user to perform an interactive login
read -t 60 -p "Do you want to log in to Azure? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    echo "Please follow the instructions in your web browser to log in to Azure."
    # Perform an interactive login
    if az login; then
        echo "Successfully logged in to Azure."
    else
        echo "Failed to log in to Azure. Continuing with the script..."
    fi
else
    echo "Skipping Azure login. Continuing with the script..."
fi

############################
# Configure Databricks CLI #
############################
read -t 60 -p "Do you want to configure Databricks CLI? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    echo "Please follow the instructions to configure Databricks CLI."
    # Perform an interactive configuration
    if databricks configure --token; then
        if databricks workspace ls >/dev/null 2>&1; then
            echo "Successfully verified Databricks CLI configuration."
        else
            echo "Failed to verify Databricks CLI configuration. Please check your Databricks host and token."
        fi
    else
        echo "Failed to configure Databricks CLI. Continuing with the script..."
    fi
else
    echo "Skipping Databricks CLI configuration. Continuing with the script..."
fi

# Prompt the user for the organization, project, and repository names
echo "Please enter the Azure DevOps organization name:"
read organization
echo "Please enter the Azure DevOps project name:"
read project
echo "Please enter the Azure DevOps repository name:"
read repository

# Define the Azure DevOps repository URL
repo_url="https://dev.azure.com/${organization}/${project}/_git/${repository}"

# Change to the /mnt/c/dev directory
cd /mnt/c/dev

# Clone the repository
git clone $repo_url

# Verify that the repository was cloned
if [ $? -eq 0 ]; then
    echo "Successfully cloned the repository."
    cd $repository
    code .
else
    echo "Failed to clone the repository."
fi