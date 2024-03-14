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


## Install poetry
```shell
curl -sSL https://install.python-poetry.org | python3 -
```

Check that you are on version 2.x
```shell
poetry self update
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
