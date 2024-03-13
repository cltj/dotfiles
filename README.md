# Setup and install



## Setup

To get quickly up and running run these commands on a fresh install

```shell
curl -o setup.sh https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/setup.sh
```

```shell
chmod +x setup.sh
```

```shell
sudo ./setup.sh
```

After the script is done source your shell (the promt will now change)
```shell
. .bashrc
```

![explanation.png](https://github.com/cltj/dotfiles/blob/6f9f72f212410e199d216cc9afa6beb49f1840a0/explanation.png)


⚠️ Warning, this will irrevocably replace your config with mine, and install a bunch of stuff on your system.

The installation script is idempotent, so to update your config to the latest version, simply re-run the command above, or use the alias that was defined the first time you ran the installation script:

```shell
updot
```

## VS code

Open vs code by using `code .` command, close the application again and verify that you now have a folder called `.vscode-server` in your home directory. You can now install the extensions


```shell
./configure-vscode-ext.sh
```

If the setup script was not sucessfull in getting the script the first time you can get it from here

```shell
curl -o configure-vscode-extensions.sh https://raw.githubusercontent.com/cltj/dotfiles/master/dotfiles/configure/configure-vscode-ext.sh
```

```shell
chmod +x configure-vscode-extensions.sh && chmod u+x setuplogs.txt
```



## Install poetry
Poetry should already be installed by the setup script. You can check by typing in

```shell
poetry --version
```

Otherwise you have to get it from here
```shell
curl -sSL https://install.python-poetry.org | python3 -
```


Navigate to the project folder, if you havent cloned the repo before you need to do this first

```shell
poetry install
```

```shell
poetry update
```
Check your environment info and export the virtual paths to your .bashrc
```shell
poetry env info
```

```shell
export /my/virtual/environment/path
```

Configure you path for poetry and make sure test_setup.py works without
When you have got your poetry environment setup check that setup_test.py is working correctly

## Setup databricks connect
Navigate to the project and open vscode

Configure databricks connect
- Click on the databricks vs code extension
- Click on `Configure`
- Choose `Azure CLI`

  Once configured you can run the file test_databricks.py to verify that it works as expected.
  It will give you the 5 first rows of new york taxt sample data.


## Local git setup

Navigate to project and set local git configurations (run `git remote -v` to get the path)
```Shell
git config credential.useHttpPath true
git remote set-url origin https://<domain>@dev.azure.com/<project>/<path>
```

```Shell
git remote -v
```

```Shell
git remote set-url origin https://<domain>@dev.azure.com/<project>/<path>
```

