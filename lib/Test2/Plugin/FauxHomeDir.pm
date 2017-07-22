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

my $real;
my $faux;
my $user;

sub import
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

1;
