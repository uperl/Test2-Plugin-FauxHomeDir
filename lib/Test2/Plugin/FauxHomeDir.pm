package Test2::Plugin::FauxHomeDir;

use strict;
use warnings;
use 5.008001;
use File::Temp qw( tempdir );
use File::Spec;
use File::Path qw( mkpath );
use if $^O eq 'cygwin', 'File::Spec::Win32';

# ABSTRACT: Setup a faux home directory for tests
# VERSION

=head1 SYNOPSIS

 use Test2::Plugin::FauxHomeDir;
 use Test2::V0;

=head1 DESCRIPTION

This module sets up a faux home directory for tests. The home directory 
is empty, and will be removed when the test completes.  This can be 
helpful when you are writing tests that may be reading from the real 
user configuration files, or if it writes output to the user home 
directory.

At the moment this module accomplishes this by setting the operating 
system appropriate environment variables. In the future, it may hook 
into some of the other methods used for determining home directories 
(such as C<getpwuid> and friends).  There are many ways of getting 
around this faux module and getting the real home directory (especially
from C).  But if your code uses standard Perl interfaces then this 
plugin should fool your code okay.

You should load this module as early as possible.

This systems are actively developed and tested:

=over 4

=item Linux

=item Strawberry Perl (Windows)

=item cygwin

=back

I expect that it should work on most other modern UNIX platforms.  It 
probably will not work on more esoteric systems like VMS or msys2.  
Patches to address this will be eagerly accepted.

=head1 SEE ALSO

=over 4

=item L<File::HomeDir::Test>

I used to use this module a lot.  It was good.  Unfortunately It has 
not, in this developers opinion been actively maintained for years, with 
the very brief exception when it was broken by changes introduced in the
Perl 5.25.x series when C<.> was removed from C<@INC>.  And it was not 
fixed without a degree of prodding of the maintainer.  It also comes 
bundled as part of L<File::HomeDir> which does a lot more than I really 
need.  This module also dies if it is C<use>d more than once which I
think is unnecessary.

=back

=cut

my $real;
my $faux;
my $user;

sub import
{
  unless(defined $faux)
  {
    if($^O eq 'MSWin32')
    {
      $real = $ENV{USERPROFILE};
      $real = File::Spec->catdir($ENV{HOMEDRIVE}, $ENV{HOMEPATH})
        unless defined $real;
      $user = $ENV{USERNAME};
    }
    else
    {
      $real = $ENV{HOME};
      $user = $ENV{USER};
    }
  
    die "unable to determine 'real' home directory"
      unless defined $real && -d $real;
  
    delete $ENV{USERPROFILE};
    delete $ENV{HOME};
    delete $ENV{HOMEDRIVE};
    delete $ENV{HOMEPATH};
  
    $faux = File::Spec->catdir(tempdir( CLEANUP => 1 ), 'home', $user);
    mkpath $faux, 0, 0700;

    if($^O eq 'MSWin32')
    {
      $ENV{USERPROFILE} = $faux;
      ($ENV{HOMEDRIVE}, $ENV{HOMEPATH}) = File::Spec->splitpath($faux,1);
    }
    elsif($^O eq 'cygwin')
    {
      $ENV{USERPROFILE} = Cygwin::posix_to_win_path($faux);
      ($ENV{HOMEDRIVE}, $ENV{HOMEPATH}) = File::Spec::Win32->splitpath($ENV{USERPROFILE},1);
      $ENV{HOME} = $faux;
    }
    else
    {
      $ENV{HOME} = $faux;
    }
  }
}

1;
