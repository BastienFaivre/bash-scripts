# Package Management

## Install and remove packages

For each package manager, a script `<package-manager>-manage.sh` is provided. The main utility of this script is that it helps you to keep track of your installed packages, which can be useful when switching to a new machine.

To be able to use it, here is what you need to do:

1. Create a new GitHub repository with the name of your choice
2. Clone it on your machine wherever you want
3. Update the variable `PACKAGE_LISTS_REPO_PATH` in the [package-management.conf](package-management.conf) file with the path to the cloned repo.
4. You're now ready to use the script! See `<package-manager>-manage --help` to learn how to use the script.
