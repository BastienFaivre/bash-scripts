# bash scripts

This repository aims to provide multiple useful bash scripts.

## Scripts

- to be completed

## Setup and use the scripts

To be able to use the scripts, simply give execution permission to the [setup script](setup.sh) located in the scripts folder:

```
sudo chmod u+x setup.sh
```

Then run the script:

```
./setup.sh
```

It will install the required packages, give all scripts execution permission, and finally create soft links in `/usr/local/bin`.

NOTE: THIS SCRIPT ASSUMES THAT `/usr/local/bin` IS ALREADY IN THE PATH. To verify, simply run `$PATH` and check if the path is in the output.

To execute a script `foo.sh`, just type its name in the terminal (without the extension):

```
foo
```

To remove all the soft links from `/usr/local/bin`, simply run the [clean script](clean.sh) also located in the scripts folder:

```
./clean.sh
```

This will remove all the soft links created in `/usr/local/bin` by the setup script. Note that it won't delete your personal files located in this folder!

## Contribution

If you've any improvement and/or tool suggestions, feel free to fork the project, implement your ideas, and make a pull request in this repository.
