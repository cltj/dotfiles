#!/bin/bash
echo "################ configuring git ################" | tee -a setuplog.txt
# Assign passed arguments to variables
user_email="$1"
user_name="$2"
user_home="$3"
echo "Run as: $user_email , $user_name , $user_home" | tee -a setuplog.txt

# Check if gpg is installed
if ! command -v gpg &> /dev/null; then
    echo "gpg is required but not installed. Please install it first." | tee -a setuplog.txt
    return 1
fi

# Check if pass is installed
if ! command -v pass &> /dev/null; then
    echo "pass is required but not installed. Please install it first." | tee -a setuplog.txt
    return 1
fi
# Check if git-credential-manager is installed
if ! command -v git-credential-manager &> /dev/null; then
    echo "git-credential-manager is required but not installed. Please install it first." | tee -a setuplog.txt
    return 1
fi

echo "Setting up git" | tee -a setuplog.txt
# Attempt to find the path to git-credential-manager
credential_manager_path=$(which git-credential-manager)
# Set Git global configurations
git config --file "$user_home/.gitconfig" user.email "$user_email"
git config --file "$user_home/.gitconfig" user.name "$user_name"
git config --file "$user_home/.gitconfig" credential.helper "$credential_manager_path"
git config --file "$user_home/.gitconfig" credential.useHttpPath true
git config --file "$user_home/.gitconfig" credential.credentialStore gpg

export GCM_CREDENTIAL_STORE=gpg

# Verify that the Git global configurations were set
if [ -f "$user_home/.gitconfig" ]; then
    echo "Git global configuration has been updated." | tee -a setuplog.txt
    git config --list | tee -a setuplog.txt
fi


# setup gpg
echo "Setting up gpg" | tee -a setuplog.txt
# Generate a new GPG key

sudo -u $user_name gpg --gen-key
# List GPG keys to find the GPG key ID
gpg_output=$(sudo -u $user_name gpg --list-secret-keys --keyid-format LONG)
# Export the GPG key ID to a variable
key_id=$(echo "$gpg_output" | grep -Po 'rsa3072/\K[^ ]+' | head -n 1)
sudo -u $user_name pass init "$key_id"
# Verify that the GPG key was created
if [ $? -eq 0 ]; then
    echo "GPG key created successfully." | tee -a setuplog.txt
else
    echo "Failed to create GPG key." | tee -a setuplog.txt
fi


# Prompt the user for their Azure DevOps PAT and read it into a variable
read -sp "Enter your Azure DevOps PAT: " azure_pat
echo
# Replace each character of the PAT with a * and store the result in a variable
masked_pat=$(echo "$azure_pat" | sed 's/./*/g')
# Display the masked PAT
echo "$masked_pat"
read -p "Enter your your organization: " organization
git-credential-manager azure-repos bind $organization $user_email
# Store the Azure DevOps PAT in git-credential-manager
echo -e "protocol=https\nhost=$organization.visualstudio.com\nusername=$user_email\npassword=$azure_pat" | git-credential-manager store

# Verify that the PAT was stored
if [ $? -eq 0 ]; then
    echo "Azure DevOps PAT stored successfully." | tee -a setuplog.txt
else
    echo "Failed to store Azure DevOps PAT." | tee -a setuplog.txt
fi

echo "############### configure-git.sh done! #################" | tee -a setuplog.txt