use Test::More tests=>4;

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

has 'foo' => ( isa => Str, is => 'rw', coerce => 1 );

package main;

TODO: {
	local $TODO = "MXTMO Should not interfere with types it isn't exporting";
	my $str = ShittyOverload->new;
	my $o = UsingMoose->new;
	unlike (
		$o->foo($str)
		, qr/overload/
		, "The order here should specify that foo should not have the coercion"
	);
};

1;
