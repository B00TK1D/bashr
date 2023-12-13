# bashr

Keep your system utils to yourself.

# Install

`wget -O - https://raw.githubusercontent.com/B00TK1D/bashr/master/install.sh | bash`

# Usage

First, run `bashr -e <password>` to obfuscate all your system utils.

Then, in order to use your system utils, prepend `bashr <password>` to your command.

For example, `bashr <password> ls -al /root`

If you want to deobfuscate your system utils, run `bashr -d <password>`

```{bash}
$ bashr -h

  Usage: bashr [options] <password> <binary> [args]
  Options:
    -e  Obfuscate the binary with the given password
            (if no binary is given, obfuscate all the binaries)
    -d  Deobfuscate the binary with the given password
            (if no binary is given, deobfuscate all the binaries)
    -h  Display this help message
```