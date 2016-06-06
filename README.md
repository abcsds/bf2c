# bf2c
Comment and adjustment from [this gist](https://gist.github.com/hasherezade/aa0fd5d16fd9cc0e9391) to work on MacOSX.
The binary created from this yacc definition converts brainfuck code to a c implementation of that same code.
```bash
make all
./brainfuck < test.bf > result.c
gcc -o helloworld result.c
```
