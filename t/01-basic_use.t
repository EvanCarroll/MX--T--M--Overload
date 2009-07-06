use Test::More tests=>13;

require_ok ( 'overload' );
require_ok ( 'Moose' );
require_ok ( 'Scalar::Util' );

package ShittyOverload;
use Moose;
use overload '""' => sub { "overload" };

package UnsuspectingMoose;
use Moose;
use MooseX::Types::Moose::Overload;

has [qw/foo bar/] => ( isa => 'Str', is => 'rw', coerce => 1 );

package InnocentMoose;
use Moose;

has 'foo' => ( isa => 'Str', is => 'rw', coerce => 1 );


package main;

my $mooseOverload;
eval { $mooseOverload = ShittyOverload->new; };
ok( ! $@, "Created the overloaded moose object" );
is( Scalar::Util::blessed( $mooseOverload ), 'ShittyOverload', 'It is the right object' );
ok( overload::Overloaded( $mooseOverload ), 'It is overloaded' );
is( $mooseOverload, "overload", 'It stringifies properly' );


##
## Testing the application of mooseOverload on a class that uses mxtmo
##
my $mxtmo;
eval { $mxtmo = UnsuspectingMoose->new };
ok ( ! $@, "didn't die creating object with MX:T:M:O" );

eval { $mxtmo->bar("regular string") };
ok( ! $@, "didn't die on setting mxtmo attribute to regular string" );

eval { $mxtmo->foo($mooseOverload) };
ok ( ! $@,  "didn't die on setting mxtmo attribute to overloaded object $@" );

is ( $mxtmo->foo, 'overload', "the attribute returns the stringified object" );


##
## FIXME Testing the application of mooseOverload on a class that doesn't use mxtmo
## I'd rather these tests not pass, but whatever.
##
my $NOTmxtmo = InnocentMoose->new;
eval { $NOTmxtmo->foo($mooseOverload) };
ok ( ! $@,  "didn't die on setting NOTmxtmo attribute to overloaded object $@" );

is ( $NOTmxtmo->foo, 'overload', "the attribute returns the stringified object" );

1;
