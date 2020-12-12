# name-maimer
Shell script for mangling first names, last names, and single strings into one or more common username formats.

# Usage
```
./name-maimer.sh [input file] -f [format] [options]
```
* **[input file]** must be the first parameter.
  - "first last" and "last, first" formatted lines will be mangled according to the format specified.
  - "string" lines will be assumed to be usernames. They won't be manged, but rules to prepend or append strings will be applied.
* **-f [value]** specifies the mangling format(s):
  - ALL
  - a - jsmith - [first initial][*last name*]
  - b - j~smith - [first initial][seperator][*last name*] - requires seperator
  - c - jxsmith - [first initial][generate a-z][*last name*]
  - d - jxs - [first initial][generate a-z][last initial]
  - e - john~smith - [first name][seperator][last name] - requires seperator
  - f - johnsmith - [first name][last name]
  - g - johnxsmith - [first name][generate a-z][last name]
  - h - johns - [*first name*][last initial]
  - i - johnxs - [*first name*][generate a-z][last initial]
  - j - john - [*first name*]
  - k - smith - [*last name*]
  - l - smithj - [*last name*][first initial]
  - m - smithjx - [*last name*][first initial][generate a-z]
  - Note: *italic* name portions are the ones that may be truncated if **-m [value]** is used to set a max length.
* **-s [value]** provides the seperator for formats that require one.
* **-m [value]** sets a max length for mangled names. Doesn't apply to unmangled single strings, and doesn't count prepending or appended strings.
* **-b [value]** prepends a string before each output username.
* **-a [value]** appends a string after each output username.
* **--list-formats** lists the formats shown above for reference.
* **-v** enables verbose output to show how each line is read and converted. By default, only rejected lines display as output.
* Output will include unique, lowercase usernames.

# Examples
```
Command:                                    Turns 'john smith' or 'smith, john' into:
./name-maimer.sh names.txt -f ahl           jsmith, johns, smithj
./name-maimer.sh names.txt -f b -s _        j_smith
./name-maimer.sh names.txt -f a -b admin_   admin_jsmith
./name-maimer.sh names.txt -f am -m 4       jsmi, smj[a-z]
```
