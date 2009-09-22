package Net::Route::Parser::win32;
use version; our ( $VERSION ) = '$Revision: 218 $' =~ m{(\d+)};    ## no critic
use Moose;
use Readonly;
use Net::Route;


extends 'Net::Route::Parser';

# Very loose matching, it's just meant to filter lines
Readonly my $IPV4_RE  => qr/ (?: \d+ ){3} \. \d+ /xms;
Readonly my $IPV6_RE  => qr/ (?: \p{IsXDigit}+ : :? )+ \p{IsXDigit}+ /xms;
Readonly my $IP_RE    => qr/ (?: $IPV4_RE | $IPV6_RE ) /xms;
Readonly my $ROUTE_RE => qr/^ \s* ($IP_RE) \s+ ($IP_RE) \s+ ($IP_RE) \s+ ($IP_RE) \s+ (\d+) \s* $/xms;

sub command_line
{
    return 'route print';
}

sub parse_routes
{
    my ( $self, $input_ref ) = @_;

    my @routes;
    while (  my $line = readline $input_ref  )
    {
        chomp $line;
    
        if ( my @values = ( $line =~ $ROUTE_RE ) )
        {
            my ( $dest, $dest_mask, $gateway, $interface, $metric) = @values;

            my $route_ref = Net::Route->new( {
                    'destination' => NetAddr::IP->new( $dest, $dest_mask ),
                    'gateway'     => NetAddr::IP->new( $gateway ),
                    'is_active'   => 1, # TODO
                    'is_dynamic'  => 0, # TODO
                    'metric'      => $metric,
                    'interface'   => $interface,

                } );
            push @routes, $route_ref;
        }
    }

    return \@routes;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Net::Route::Parser::win32 - Internal class


=head1 SYNOPSIS

Internal.


=head1 VERSION

Revision $Revision: 218 $.


=head1 DESCRIPTION

This class parses Windows' C<route print> output. It implements
L<Net::Route::Parser>.

=head2 Object Methods

=head3 command_line()

=head3 parse_routes()


=head1 INTERFACE

See L<Net::Route::Parser>.


=head1 AUTHOR

Created by Alexandre Storoz, C<< <astoroz@straton-it.fr> >>

Maintained by Thomas Equeter, C<< <tequeter@straton-it.fr> >>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 Straton IT.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

