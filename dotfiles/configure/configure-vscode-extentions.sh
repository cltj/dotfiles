#!/bin/bash

# URL of the extensions list
EXTENSIONS_URL="https://raw.githubusercontent.com/fktj/dotfiles/main/settings/vscode-extensions.txt"

# Check if Visual Studio Code command 'code' is available
if ! command -v code &> /dev/null
then
    echo "Visual Studio Code command 'code' could not be found"
    exit 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null
then
    echo "curl could not be found"
    exit 1
fi

# Fetch the list and install extensions
echo "Fetching extension list from $EXTENSIONS_URL"
curl -s $EXTENSIONS_URL | while IFS= read -r extension; do
    if [ -n "$extension" ]; then  # Ensure the line is not empty
        echo "Attempting to install $extension"
        code --install-extension "$extension" --force || echo "Failed to install $extension"
    else
        echo "Encountered an empty line, skipping..."
    fi
done

echo "All extensions have been installed."