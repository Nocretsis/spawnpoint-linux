# SpawnPoint for Linux

> `SpawnPoint` is a bash script that allows you to store and load your current working directory.

## Installation

```bash
git clone https://github.com/Nocretsis/spawnpoint-linux.git
cd spawnpoint-linux
bash ./install.sh
source ~/.bashrc
```

## Usage

* To save your current working directory, run:

```bash
spawnpoint set #setted to the first index by default
# or
spawnpoint set <index> #setted to the index you specified
# in default, your home directory is setted to the first index
```

* To load a saved working directory, run:

```bash
spawnpoint teleport #teleported to the first index of the spawnpoints list by default
# or
spawnpoint teleport <index> #teleported to the index you specified
```

* To list all saved working directories, run:

```bash
spawnpoint list
```

* To remove a saved working directory, run:

```bash
spawnpoint remove #removed the first index of the spawnpoints list by default
# or
spawnpoint remove <index> #removed the index you specified
```

* To remove all saved working directories, run:

```bash
spawnpoint clear
```

* To get help, run:

```bash
spawnpoint help #or -h
```

## Alias

### Default alias

Defaultly, `spawnpoint` is aliased to `sp`. At the same time, also some covenient aliases are added.

```bash
# spawnpoint set 
sp set

# spawnpoint teleport
sp tp
SP.tp

# spawnpoint list
sp.ls 
sp..

# spawnpoint remove
sp.rm

# spawnpoint clear
sp.clr
```

### Custom alias

you can also add your own alias to the `spawnpoint-magic-alias` file by following the format as bash alias.

### Disable alias

To disable this alias, add flag `--no-alias` to the `install.sh` script.

```bash
bash ./install.sh --no-alias
```

## License

[MIT](LICENSE)
