# Package Management

## Update packages

You can choose which package managers you want to update the packages for. This is done by setting the `UPDATE_<package-manager>` variable to `true` or `false` in the [package-management.conf](package-management.conf) file.

## Install and remove packages

For each package manager, a script `<package-manager>-manage.sh` is provided. The main utility of this script is that it helps you to keep track of your installed packages, which can be useful when switching to a new machine.

To be able to use it, here is what you need to do:

1. Create a new GitHub repository with the name of your choice
2. Clone it on your machine wherever you want
3. Update the variable `PACKAGE_LISTS_REPO_PATH` in the [package-management.conf](package-management.conf) file with the path to the cloned repo.
4. You're now ready to use the script! See `<package-manager>-manage --help` to learn how to use the script.

When you switch to a new machine, clone both repositories, setup all scripts using the [setup.sh](../../setup.sh) script, and run the `install` command to install all your saved packages. You can choose to install only a subset of the packages by specifying the package manager(s) you want to install the packages for. This is done by setting the `INSTALL_<package-manager>` variable to `true` or `false` in the [package-management.conf](package-management.conf) file.
