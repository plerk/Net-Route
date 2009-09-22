package Net::Route;

use Moose;
use version; our $VERSION = qv('v0.00_01');

use NetAddr::IP;

has 'destination' => ( is => 'ro', required => 1, isa => 'NetAddr::IP' );
has 'gateway'     => ( is => 'ro', required => 1, isa => 'NetAddr::IP' );
has 'metric'      => ( is => 'ro', required => 1, isa => 'Int' );
has 'interface'   => ( is => 'ro', required => 1, isa => 'Str' );
has 'is_active'   => ( is => 'ro', required => 1, );
has 'is_dynamic'  => ( is => 'ro', required => 1, );

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Net::Route - Portable interface to your system's routing table


=head1 SYNOPSIS

    use Net::Route::Table;
    my $table_ref = Net::Route::Table->from_system();
    my $route_ref = $table_ref->default_route();
    print "Default gateway: ", $route_ref->gateway(), "\n";

=head1 VERSION

Version 0.00_01, $Revision: 220 $


=head1 DESCRIPTION

=head2 The Net::Route Module

Every OS provides its custom interface to the routing table: Linux' C<route>
utility is different from BSD's C<route show>, from Windows' C<route print>,
etc. Parsing all these different output styles in an (otherwise portable)
script can quickly become inconvenient.

L<Net::Route> abstracts the system specifics and hides them behind a single
interface.

=head2 The Net::Route Class

L<Net::Route> objects represent single entries from a L<Net::Route::Table>.

=head1 INTERFACE

This documents L<Net::Route> as a class. To know how to use the module, refer
to the L<SYNOPSIS|synopsys> or L<Net::Route::Table> (the entry point from a
user perspective).

=head2 Object Methods

=head3 destination()

=head3 gateway()

=head3 metric()

=head3 interface()

=head3 is_active()

=head3 is_dynamic()

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-route at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Route>. I will be
notified, and then you'll automatically be notified of progress on your bug as
I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Route


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Route>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Route>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Route>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Route>

=back


=head1 AUTHOR

Created by Alexandre Storoz, C<< <astoroz@straton-it.fr> >>

Maintained by Thomas Equeter, C<< <tequeter@straton-it.fr> >>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 Straton IT.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

