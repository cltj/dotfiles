#!/bin/bash
echo "################ configuring poetry ################" | tee -a setuplog.txt

#repository="$1"  # Get the first argument passed to the script
user_home="$1"  # Get the second argument passed to the script

# Create the .cache/pypoetry and .config/pypoetry directories and check if they were created successfully
mkdir -p $user_home/.cache/pypoetry
mkdir -p $user_home/.config/pypoetry
if [ -d "$user_home/.cache/pypoetry" ] && [ -d "$user_home/.config/pypoetry" ]; then
    echo "$(date) - .cache/pypoetry and .config/pypoetry were created successfully." | tee -a setuplog.txt
else
    echo "$(date) -Failed to create directories." | tee -a setuplog.txt
    exit 1
fi

# Set permissions for the .cache/pypoetry and .config/pypoetry directories and check if they were set successfully
chmod a+rwx $user_home/.cache/pypoetry
chmod a+rwx $user_home/.config/pypoetry

permissions_cache=$(ls -ld $user_home/.cache/pypoetry | cut -d' ' -f1)
permissions_config=$(ls -ld $user_home/.config/pypoetry | cut -d' ' -f1)

if [[ $permissions_cache == drwxrwxrwx ]] && [[ $permissions_config == drwxrwxrwx ]]; then
    echo "$(date) - Permissions were set successfully." | tee -a setuplog.txt
else
    echo "$(date) - Failed to set permissions." | tee -a setuplog.txt
    exit 1
fi


poetry config cache-dir "$user_home/.cache/pypoetry" --local
poetry config virtualenvs.create true --local
poetry config virtualenvs.path "$user_home/.cache/pypoetry/virtualenvs" --local

# Check if the directory exists and is a directory
# if [ -d "$repository" ]; then
#     echo "Directory $repository exists." | tee -a setuplog.txt
# else
#     echo "Directory $repository does not exist." | tee -a setuplog.txt
#     return 1
# fi

# Assign passed arguments to variables
# if ! command -v poetry &> /dev/null
# then
#     echo "Installing poetry..."
#     curl -sSL https://install.python-poetry.org | python3 -
#     echo "$(date) - Poetry version installed: $(poetry --version)" | tee -a setuplog.txt
# else
#     echo "$(date) - Poetry version installed: $(poetry --version)" | tee -a setuplog.txt
# fi

# (
#     cd $repository
#     poetry install
#     poetry update
#     poetry_env_path=$(poetry env info | grep 'Path:' | head -1 | awk -F': ' '{print $2}')
#     poetry_executable_path=$(poetry env info | grep 'Executable:' | head -1 | awk -F': ' '{print $2}')
# )

# echo "Poetry Virtualenv Path: $poetry_env_path" | tee -a setuplog.txt
# echo "Poetry Executable Path: $poetry_executable_path" | tee -a setuplog.txt

# # Append the path to the .bashrc file
# echo "export PATH=\$PATH:$poetry_env_path" >> $user_home/.bashrc
# echo "export PATH=\$PATH:$poetry_executable_path" >> $user_home/.bashrc

# source $user_home/.bashrc

echo "############### configure-poetry.sh done! #################" >> setuplog.txt