# Test2::Plugin::FauxHomeDir ![linux](https://github.com/uperl/Test2-Plugin-FauxHomeDir/workflows/linux/badge.svg) ![macos](https://github.com/uperl/Test2-Plugin-FauxHomeDir/workflows/macos/badge.svg) ![windows](https://github.com/uperl/Test2-Plugin-FauxHomeDir/workflows/windows/badge.svg) ![msys2-mingw](https://github.com/uperl/Test2-Plugin-FauxHomeDir/workflows/msys2-mingw/badge.svg)

Setup a faux home directory for tests

# SYNOPSIS

```perl
use Test2::Plugin::FauxHomeDir;
use Test2::V0;
```

# DESCRIPTION

This module sets up a faux home directory for tests. The home directory
is empty, and will be removed when the test completes.  This can be
helpful when you are writing tests that may be reading from the real
user configuration files, or if it writes output to the user home
directory.

At the moment this module accomplishes this by setting the operating
system appropriate environment variables. In the future, it may hook
into some of the other methods used for determining home directories
(such as `getpwuid` and friends).  There are many ways of getting
around this faux module and getting the real home directory (especially
from C).  But if your code uses standard Perl interfaces then this
plugin should fool your code okay.

This module sets the native environment variables for the home directory
on your platform.  That means on Windows `USERPROFILE`, `HOMEDRIVE`
and `HOMEPATH` will be set, but `HOME` will not.  This is important
because your testing environment should match as closely as possible
what the actual environment will look like.

You should load this module as early as possible.

This systems are actively developed and tested:

- Linux
- Strawberry Perl (Windows)
- cygwin

I expect that it should work on most other modern UNIX platforms.  It
probably will not work on more esoteric systems like VMS or msys2.
Patches to address this will be eagerly accepted.

# METHODS

## real\_home\_dir

Returns the real home directory as detected during startup.  If
initialization hasn't happened then this will return `undef`.

# CAVEATS

Arguably your code shouldn't depend on or be affected by stuff in your
home directory, or have a hook for your tests to alternate configuration
files.

Strange things may happen if you try to use both this plugin and
[File::HomeDir::Test](https://metacpan.org/pod/File::HomeDir::Test).  A notice or diagnostic (depending on if the
test is passing) will be raised at the end of the test if you attempt this.

# SEE ALSO

- [File::HomeDir::Test](https://metacpan.org/pod/File::HomeDir::Test)

    I used to use this module a lot.  It was good.  Unfortunately It has
    not, in this developers opinion, been actively maintained for years, with
    the very brief exception when it was broken by changes introduced in the
    Perl 5.25.x series when `.` was removed from `@INC`.

    This module also comes bundled as part of [File::HomeDir](https://metacpan.org/pod/File::HomeDir) which does a
    lot more than I really need.

    This module also dies if it is `use`d more than once which I think is
    unnecessary.

    This module also sets `HOME` on all platforms, even on ones where that
    is not the native environment variable for the home directory.  This can
    be a problem, because if your code is using `HOME`, and your testing
    environment fakes it so that works, then your testing environment may be
    hiding bugs.

# AUTHOR

Author: Graham Ollis <plicease@cpan.org>

Contributors:

Shawn Laffan (SLAFFAN)

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017-2024 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
