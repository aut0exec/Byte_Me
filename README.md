# Byte_Me
Perl tool for byte array generation


## Why?
Well I often find that there are times I need to create a byte string to place into a CTF/Exploit Dev challenge. May not be using Mona or something else that can generate these sequences for me. Rather than hand-jamming I just decided to write a tool for it. Hopefully it'll be beneficial to someone other than just me!

## How to use

Program can be invoked in a number of was. The most common would be to simply use the Perl interpreter directly.

```
perl Byte_Me.pl
```

The alternative option is to make the script executable and then it can be run like most other executable scripts/programs.

```
chmod +x Byte_Me.pl
./Byte_Me.pl
```

To see the help, use:

```
./Byte_Me.pl -h
```

The default options will simply dump ASCII represenation of all bytes from 0x00 to 0xff. The program supports the ability to remove known bad bytes from the output using the '-b' argument. For example:

```
./Byte_Me.pl -b \x00\x01\xde\xad\xbe\xef
```

Sometimes there might be a need to have the raw bytes written to a file. This program supports that as well using the '-f' argument and specifying RAW and specifying the output file with the '-o' argument. For example:

```
./Byte_Me.pl -b \x00\x01\xde\xad\xbe\xef -f RAW -o raw_bytes.bin
```

The '-f RAW' argument is only useful with the '-o' argument but the program will support '-o' with the default ascii output if desired. For example:

```
./Byte_Me.pl -b \x00\x01\xde\xad\xbe\xef -o bytes.txt
```
## Future additions
Nothing currently but if you come up with a request, let me know and I'll try to implement it.
