package MooseX::Types::Moose::Overload;
use strict;
use warnings;

use overload;

our $VERSION = '0.01_07';

use Moose::Util::TypeConstraints;
use MooseX::Types;

my @types;
BEGIN {
	@types = grep Moose::Util::TypeConstraints::find_type_constraint( $_ )->is_subtype_of( 'Value' )
		, Moose::Util::TypeConstraints->list_all_builtin_type_constraints
	;
}

use Sub::Exporter -setup => { exports => \@types };
## We need Object too, it isn't a subtype of Value
use MooseX::Types::Moose (@types, 'Object');

sub unOverload {
	overload::Overloaded( $_[0] ) && overload::Method( $_[0], '""' )
	? "$_[0]"
	: $_[0]
}

my $p = Class::MOP::Package->initialize( __PACKAGE__ );
for ( @types ) {
	my $copy = $p
		->get_package_symbol( "&$_" )
		->()
		->create_child_type(name=>"Overload capable $_")
	;

	coerce $copy , from Object , via \&unOverload;
	$p->add_package_symbol( "&$_", sub{ $copy } );
}

no MooseX::Types;
no overload;

1;

__END__

=head1 NAME

MooseX::Types::Moose::Overload - Deal with overload, in the overloaded sense ;)

=head1 DESCRIPTION

This module is like L<MooseX::Types::Moose> except it will transparently handle L<overload>ed objects. All you have to do is use it, and then add C<coerce =E<gt> 1> to the attributes you wish to enable it on. It will then stringify all objects that support the stringifiy method. This works in the style of overload, forcing Moose to just do you want. Something that stringifies to a string should simply work when the attribute isa Str, right‽ Good, thought so.

This only attaches a coercion to subtypes of "Value", and it only coerces from "Objects", and only executes on Objects that support stringification via overload.

=head1 SYNOPSIS

	use MooseX::Types::Moose::Overload 'Str';
	use MooseX::Types::Moose::Overload qw/Str Int/;
	use MooseX::Types::Moose::Overload ':all';

	## Now takes a URI object, or HTTP::Element, and of course a plain string.
	has 'uri' => ( isa => Str, is => 'rw', coerce => 1 );

=head1 CAVEAT

Overloading in perl is a nasty hack.

There is a subset of overload which is even more of a nasty hack. Unoverloading types which are implimented in obscure hard-to-detect fashion is not supported. I will evaluate patches that support said method for completeness. I do not want to go into detail for fear someone will accidently learn it -- and I don't know of any modules on CPAN that use it. It is very probably a moot case.

As just said, this does not supply an overload for Object. So it does not support stringification that returns references or any other suprememly goofy shit. "$foo"->bar should not be a valid API unless you want to die in the face.

=head1 AUTHOR

Evan Carroll, C<< <me at evancarroll.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-types-overload at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Types-Moose-Overload>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Types::Overload


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Types-Overload>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Types-Overload>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Types-Overload>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Types-Overload/>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Evan Carroll, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
