# Test2::Plugin::FauxHomeDir [![Build Status](https://secure.travis-ci.org/plicease/Test2-Plugin-FauxHomeDir.png)](http://travis-ci.org/plicease/Test2-Plugin-FauxHomeDir)

Setup a faux home directory for tests

# SYNOPSIS

    use Test2::Plugin::FauxHomeDir;
    use Test2::V0;

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

You should load this module as early as possible.

This systems are actively developed and tested:

- Linux
- Strawberry Perl (Windows)
- cygwin

I expect that it should work on most other modern UNIX platforms.  It 
probably will not work on more esoteric systems like VMS or msys2.  
Patches to address this will be eagerly accepted.

# SEE ALSO

- [File::HomeDir::Test](https://metacpan.org/pod/File::HomeDir::Test)

    I used to use this module a lot.  It was good.  Unfortunately It has 
    not, in this developers opinion been actively maintained for years, with 
    the very brief exception when it was broken by changes introduced in the
    Perl 5.25.x series when `.` was removed from `@INC`.  And it was not 
    fixed without a degree of prodding of the maintainer.  It also comes 
    bundled as part of [File::HomeDir](https://metacpan.org/pod/File::HomeDir) which does a lot more than I really 
    need.  This module also dies if it is `use`d more than once which I
    think is unnecessary.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
