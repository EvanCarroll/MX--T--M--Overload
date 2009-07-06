#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::Types::Moose::Overload' );
}

diag( "Testing MooseX::Types::Moose::Overload $MooseX::Types::Moose::Overload::VERSION, Perl $], $^X" );
