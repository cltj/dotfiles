#!/bin/bash
echo "############## Running configure-vscode-extentions.sh ####################" | tee -a setuplog.txt
# URL of the extensions list
EXTENSIONS_URL="https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/settings/vs-code-extensions.txt"

# Check if Visual Studio Code command 'code' is available
if ! command -v code &> /dev/null
then
    echo "$(date) - Visual Studio Code command 'code' could not be found" | tee -a setuplog.txt
    return 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null
then
    echo "$(date) - curl could not be found" | tee -a setuplog.txt
    return 1
fi

# Fetch the list and install extensions
echo "$(date) - Fetching extension list from $EXTENSIONS_URL" | tee -a setuplog.txt
curl -s $EXTENSIONS_URL | grep -v '^$' | while IFS= read -r extension; do
    echo "$(date) - Attempting to install $extension" >> setuplog.txt
    code --install-extension "$extension" --force || echo "$(date) - Failed to install $extension" | tee -a setuplog.txt
done

echo "$(date) - All extensions have been installed." | tee -a setuplog.txt
echo "############## configure-vscode-extentions.sh done! ####################" | tee -a setuplog.txt