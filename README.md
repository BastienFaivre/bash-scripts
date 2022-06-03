# bash scripts

This repository aims to provide multiple useful bash scripts.

## Scripts

- package-management
  - apt
    - [apt-install](scripts/package-management/apt/apt-install.sh)
    - [apt-remove](scripts/package-management/apt/apt-remove.sh)
    - [apt-update](scripts/package-management/apt/apt-update.sh)
  - snap
    - [snap-install](scripts/package-management/snap/snap-install.sh)
    - [snap-remove](scripts/package-management/snap/snap-remove.sh)
    - [snap-update](scripts/package-management/snap/snap-update.sh)
  - [update](scripts/package-management/update.sh)

## Setup and use the scripts

To be able to use the scripts, simply give execution permission to the [setup script](setup.sh) located in the scripts folder:

```bash
sudo chmod u+x setup.sh
```

Then run the script (see  `./setup.sh --help` for more information about options):

```bash
./setup.sh
```

It will install the required packages, give all scripts execution permission, and finally create soft links in the specified target directory or in `/usr/local/bin`, which is the default target directory.

NOTE: the specified target directory must be present in the path of your bash profile. You can check this by running `echo $PATH`. If it is not present, you can add it by adding the following line to your bash profile:

```bash
export PATH="$PATH:/path/to/target-directory"
```

To execute a script `foo.sh`, just type its name in the terminal (without the extension):

```bash
foo
```

To remove all the soft links from the target directory, simply run the [clean script](clean.sh) also located in the scripts folder:

```bash
./clean.sh
```

This will remove all the soft links created by the setup script. Note that it won't delete your personal files located in the target directory where the soft links were added!

## Contribution

If you've any improvement and/or tool suggestions, feel free to fork the project, implement your ideas following the [conventions](#conventions), and make a pull request in this repository.

## Conventions

All the scripts must follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) conventions.
Optionally, the [ShellCheck](https://www.shellcheck.net/) tool can be used to detect potential errors or warnings in the scripts.
