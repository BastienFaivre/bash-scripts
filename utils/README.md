# utils

The script `utils.sh` is a package of utility functions that can be used in other scripts. It is not made to be executed directly, but rather to be sourced in other scripts using the command:

```bash
. ./path/to/utils.sh
```

Then, the functions defined in this script can be executed by simply typing their name. For example, a function `utils::foo()` that takes two arguments can be executed by typing:

```bash
utils::foo arg1 arg2
```