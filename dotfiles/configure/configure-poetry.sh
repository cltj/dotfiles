#!/bin/bash
echo "################ configuring poetry ################" >> setuplog.txt

repository=$1  # Get the first argument passed to the script
user_home=$2  # Get the second argument passed to the script
echo "$(pwd)" >> setuplog.txt
# Check if the directory exists and is a directory
if [ -d "$repository" ]; then
    echo "Directory $repository exists."
else
    echo "Directory $repository does not exist."
    return 1
fi

# Assign passed arguments to variables
if ! command -v poetry &> /dev/null
then
    echo "Installing poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    echo "$(date) - Poetry version installed: $(poetry --version)" >> setuplog.txt
else
    echo "$(date) - Poetry version installed: $(poetry --version)" >> setuplog.txt
fi

(
    cd $repository
    poetry install
    poetry update
    poetry_env_path=$(poetry env info | grep 'Path:' | head -1 | awk -F': ' '{print $2}')
    poetry_executable_path=$(poetry env info | grep 'Executable:' | head -1 | awk -F': ' '{print $2}')
)

echo "Poetry Virtualenv Path: $poetry_env_path" >> setuplog.txt
echo "Poetry Executable Path: $poetry_executable_path" >> setuplog.txt

# Append the path to the .bashrc file
echo "export PATH=\$PATH:$poetry_env_path" >> $user_home/.bashrc
echo "export PATH=\$PATH:$poetry_executable_path" >> $user_home/.bashrc

source $user_home/.bashrc

echo "############### configure-poetry.sh done! #################" >> setuplog.txt