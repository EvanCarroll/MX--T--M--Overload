use Test::More tests=>5;

require_ok ( 'overload' );
require_ok ( 'Moose' );
require_ok ( 'Scalar::Util' );

package ShittyOverload;
use Moose;
use overload '""' => sub { "overload" };

sub new { bless \my $obj, __PACKAGE__ };

package UsingMoose;
use Moose;
use MooseX::Types::Moose 'Str';
use MooseX::Types::Moose::Overload;

use Test::More;

has 'foo' => ( isa => Str, is => 'rw', coerce => 1 );
has 'bar' => ( isa => Str, is => 'rw' );

eval { UsingMoose->new->foo( ShittyOverload->new ); };
like ( $@, qr/Validation failed|Cannot coerce without a type coercion/, 'No coercion with base type Str so error' );

eval { UsingMoose->new({ foo => ShittyOverload->new }); };
like ( $@, qr/Validation failed|Cannot coerce without a type coercion/, 'No coercion with base type Str so error' );

1;
