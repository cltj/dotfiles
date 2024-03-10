#!/bin/bash
echo "################ configuring git ################" >> setuplog.txt
# Assign passed arguments to variables
user_email="$1"
user_name="$2"
user_home="$3"
echo "Run as: $user_email , $user_name , $user_home" >> setuplog.txt
# Check if git-credential-manager is installed
if ! command -v git-credential-manager &> /dev/null; then
    echo "git-credential-manager is required but not installed. Please install it first." >> setuplog.txt
else
    # Prompt the user for their Azure DevOps PAT
    echo "Please enter your Azure DevOps PAT:"

    # Disable echo
    stty -echo
    read -p azure_pat
    # Enable echo
    stty echo
    echo

    # Store the Azure DevOps PAT in git-credential-manager
    echo "protocol=https
    host=dev.azure.com
    username=$user_name
    password=$azure_pat" | git credential-manager store

    # Verify that the PAT was stored
    if [ $? -eq 0 ]; then
        echo "Azure DevOps PAT stored successfully." >> setuplog.txt
    else
        echo "Failed to store Azure DevOps PAT." >> setuplog.txt
    fi

    # Attempt to find the path to git-credential-manager
    credential_manager_path=$(which git-credential-manager)

    # Check if git-credential-manager was found
    if [ -z "$credential_manager_path" ]; then
        echo "path for git-credential-manager not found. Configure your git globals manually" >> setuplog.txt
    else

    # Set Git global configurations
    git config --global user.email "$user_email"
    git config --global user.name "$user_name"
    git config --global credential.helper "$credential_manager_path"
    fi

    if [ -f "$user_home/.gitconfig" ]; then
        echo "Git global configuration has been updated." >> setuplog.txt
    fi
fi
echo "############### configure-git.sh done! #################" >> setuplog.txt