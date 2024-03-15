#!/bin/bash
echo "#####################  Setup log #######################" >> setuplog.txt

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

# Create and set permissions for the .local/bin and .config directories
mkdir -v -p $user_home/.local
mkdir -v -p $user_home/.local/bin
mkdir -v -p $user_home/.config
mkdir -v -p $user_home/.dotfiles
sudo chown -R $user_name:$user_name $user_home/.local
sudo chmod -R 755 $user_home/.local
sudo chown -R $user_name:$user_name $user_home/.config
sudo chmod -R 755 $user_home/.config
sudo chown -R $user_name:$user_name $user_home/.dotfiles
sudo chmod -R 755 $user_home/.dotfiles


echo "$(date) - Bringing image up to speed. This will take a while..." | tee -a setuplog.txt
sudo apt update -y > /dev/null 2>&1
sudo apt upgrade -y > /dev/null 2>&1 && sudo apt autoremove -y > /dev/null 2>&1

####################
# Install packages #
####################
install_package() {
    if ! command -v $1 &> /dev/null; then
        ERRORS=$(sudo apt install -y $1 2>&1 >/dev/null)
        if [ $? -eq 0 ]; then
            echo "$(date) - $1 installed" | tee -a setuplog.txt
        else
            echo "$(date) - Failed to install $1. Error message: $ERRORS" | tee -a setuplog.txt
        fi
    else
        ERRORS=$(sudo apt upgrade -y $1 2>&1 >/dev/null)
        if [ $? -eq 0 ]; then
            echo "$(date) - $1 updated" | tee -a setuplog.txt
        else
            echo "$(date) - Failed to update $1. Error message: $ERRORS" | tee -a setuplog.txt
        fi
    fi
}

curl -s https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/settings/packages.txt | while read package; do
    install_package "$package"
done

###########################################
# Check if installed, if not install them #
###########################################
commands=("databricks" "az" "git-credential-manager")
for command in "${commands[@]}"
do
    if ! command -v $command &> /dev/null
    then
    ERRORS=$(sudo apt install -y $1 2>&1 >/dev/null)
        echo "Installing $command..."
        case $command in
            "databricks")
                curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sudo sh
                echo "$(date) - $command installed." | tee -a setuplog.txt
                ;;
            "az")
                curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
                AZ_REPO=$(lsb_release -cs)
                echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
                sudo apt update
                sudo apt install azure-cli -y
                echo "$(date) - $command installed." | tee -a setuplog.txt
                ;;
            "git-credential-manager")
                wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb" -O /tmp/gcmcore.deb && sudo dpkg -i /tmp/gcmcore.deb
                sudo apt update
                ;;
        esac
    else
        echo "$(date) - $command is already installed." | tee -a setuplog.txt
    fi
done

# Give rights to log file
chmod a+w setuplog.txt


#############################################
# Download the configure-dotfiles.sh script #
#############################################
read -p "Do you want to setup dotfiles? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    configure_dotfiles_script_url="https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/configure/configure-dotfiles.sh"
    configure_dotfiles_script="$user_home/configure-dotfiles.sh"

    if curl -s -o "$configure_dotfiles_script" "$configure_dotfiles_script_url"; then
        # Only try to set permissions and run the script if the download succeeded
        chmod a+x "$configure_dotfiles_script"

        if [ -x "$configure_dotfiles_script" ]; then
            # Only run the child script if it is executable
            $configure_dotfiles_script $user_home || echo "$(date) - configure-dotfiles.sh script failed" | tee -a setuplog.txt
            # Source dotfiles.
            test -e $user_home/.config/envman/PATH.env && source $user_home/.config/envman/PATH.env
            test -e $user_home/.dotfiles/.commonrc && source $user_home/.dotfiles/.commonrc
            test -e $user_home/.zshrc && source $user_home/.zshrc
            test -e $user_home/.bashrc && source $user_home/.bashrc
        else
            echo "$(date) - Failed to set execute permissions on configure-dotfiles.sh" | tee -a setuplog.txt
            echo "$(date) - Please run configure-dotfiles.sh manually" | tee -a setuplog.txt
        fi
    else
        echo "$(date) - Failed to download configure-dotfiles.sh" | tee -a setuplog.txt
    fi
else
    echo "$(date) - Skipping dotfiles setup. Continuing with the script..." | tee -a setuplog.txt
fi

#################
# Configure git #
#################
read -p "Do you want to setup git? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    configure_git_script_url="https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/configure/configure-git.sh"
    configure_git_script="$user_home/configure-git.sh"

    if curl -s -o "$configure_git_script" "$configure_git_script_url"; then
        # Only try to set permissions and run the script if the download succeeded
        chmod a+x "$configure_git_script"

        if [ -x "$configure_git_script" ]; then
            # Only run the child script if it is executable
            (./configure-git.sh "$user_name" "$user_home") || echo "$(date) - configure-git.sh script failed" >> setuplog.txt
        else
            echo "$(date) - Failed to set execute permissions on configure-git.sh" | tee -a setuplog.txt
            echo "$(date) - Please run configure.sh manually" | tee -a setuplog.txt
        fi
    else
        echo "$(date) - Failed to download configure-git.sh" | tee -a setuplog.txt
    fi
else
    echo "$(date) - Skipping git setup. Continuing with the script..." | tee -a setuplog.txt
fi

#######################
# Configure azure cli #
#######################
read -p "Do you want to log in to Azure? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    echo "Please follow the instructions in your web browser to log in to Azure."
    # Perform an interactive login
    if az login; then
        echo "$(date) - Successfully logged in to Azure." | tee -a setuplog.txt
        # az config set extension.use_dynamic_install=yes_without_prompt # For running az extension
    else
        echo "$(date) - Failed to log in to Azure. Continuing with the script..." | tee -a setuplog.txt
    fi
else
    echo "$(date) - Skipping Azure login. Continuing with the script..." | tee -a setuplog.txt
fi

############################
# Configure Databricks CLI #
############################
read -p "Do you want to configure Databricks CLI? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
    echo "Please follow the instructions to configure Databricks CLI."
    # Perform an interactive configuration
    if databricks configure --token; then
        if databricks workspace ls >/dev/null 2>&1; then
            echo "$(date) - Successfully verified Databricks CLI configuration." | tee -a setuplog.txt
        else
            echo "$(date) - Failed to verify Databricks CLI configuration. Please check your Databricks host and token." | tee -a setuplog.txt
        fi
    else
        echo "$(date) - Failed to configure Databricks CLI." | tee -a setuplog.txt
    fi
else
    echo "$(date) - Skipping Databricks CLI configuration. Continuing with the script..." | tee -a setuplog.txt
fi

######################
# Clone a repository #
######################
read -p "Do you want to clone repo? (y/n) " answer

if [[ $answer =~ ^[Yy]$ ]]
then
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
    git -u $user_name clone $repo_url

    # Verify that the repository was cloned
    if [ $? -eq 0 ]; then
        sudo -u $user_name mkdir -p "/mnt/c/dev/$repository/.vscode"
        wget "https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/settings/extensions.json" -O "$repository/.vscode/extensions.json"

        readme_contents=$(cat "$repository/README.md")
        cd $user_home
        echo "$(date) - $readme_contents in the $project project" | tee -a setuplog.txt
    else
        cd $user_home
        echo "$(date) - Failed to clone the repository." | tee -a setuplog.txt
    fi
else
    echo "$(date) - Skipping repo cloning. Continuing with the script..." | tee -a setuplog.txt
fi

echo "#####################  setup.sh done! #######################" >> setuplog.txt