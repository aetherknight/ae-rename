ae-rename 0.1
=============

- <http://github.com/aetherknight/ae-rename>


Description
-----------

A renaming tool that uses regular expressions to mass rename specified
files. Inspired by the [rename perl script][1] that comes with Debian
and Ubuntu. It is named ae-rename to avoid a name collision with one
of the many other rename tools out there. You could change its name to
whatever you like if you install it yourself, however.

[1]: http://tips.webdesign10.com/files/rename.pl.txt


Features/Problems
-----------------

This particular command line renaming tool has the following features:

**0.1**:

- Uses regular expressions to match and replace substrings of filenames
- `--verbose` or `-v` to print how files get renamed as they get renamed
- `--pretend` or `-p` to print how files will be renamed, but not actually
  rename them
- Will not accidentally overwrite another input file. If one specified
  file might overwrite another specified file, it will be renamed to a
  temporary name in order to move the file it will replace out of the way
  first. Note that non-input files may still get overwritten.
- The ability to specify such a temporary filename's suffix


Synopsis
--------

To use it, call it with something like:

    $ ae-rename '\.pdf' '\0.bak' *.pdf

The first argument should be a regular expression to match within each
filename passed to the command. The second argument is the pattern to
replace the matched expression with. The rest of the arguments are the
files to rename.

Run:

    $ ae-rename --help

for all options.


Requirements
------------

`ae-rename` is written in Ruby but has no other dependencies. If you
want to run the specs however, you need `RSpec` and `mkdtemp`. Rake
would make running the specs easier as well.

To get them with rubygems:

    $ gem install rspec mkdtemp

To run the specs, just do:

    $ rake spec

from the ae-rename project directory.


Install
-------

No gem or anything yet, so download an archive of the package from
github or run:

    $ git clone git://github.com/aetherknight/ae-rename.git

to download the git repository. While in the project directory, copy
the command from `bin/ae-rename` to some place in your path, such as
`/usr/local/bin`, or `~/bin` (if you have added it to your path).


License
-------

`ae-rename` is licensed under an MIT-style license. See [LICENSE][L] for
details.

[L]: LICENSE
