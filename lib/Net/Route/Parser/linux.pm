package Net::Route::Parser::linux;
use version; our ( $VERSION ) = '$Revision: 218 $' =~ m{(\d+)};    ## no critic
use Moose;
use Net::Route;


extends 'Net::Route::Parser';

sub command_line
{
    return '/sbin/route -n |';
}

sub parse_routes
{
    my ( $self, $input_ref ) = @_;

    for ( 1 .. 2 )
    {
        readline $input_ref; ## no critic
    }

    my @routes;
    while ( my $line = readline $input_ref )
    {
        chomp $line;

        my @values = split /\s+/xms, $line ;

        # These values will be stored in a configuration hash
        my ( $dest, $dest_mask, $gateway, $flags, $metric, $interface ) = @values[ 0, 2, 1, 3, 4, 7 ];## no critic ( Perl::Critic::Policy::ValuesAndExpressions::ProhibitMagicNumbers )

        my $is_active      = $flags =~ /U/xms;
        my $is_dynamic = $flags =~ /[RDM]/xms;
        my $route_ref = Net::Route->new( {
                'destination' => NetAddr::IP->new( $dest, $dest_mask ),
                'gateway'     => NetAddr::IP->new( $gateway ),
                'is_active'   => $is_active,
                'is_dynamic'  => $is_dynamic,
                'metric'      => $metric,
                'interface'   => $interface,

            } );
        push @routes, $route_ref;
    }

    return \@routes;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Net::Route::Parser::linux - Internal class


=head1 SYNOPSIS

Internal.


=head1 VERSION

Revision $Revision: 218 $.


=head1 DESCRIPTION

This class parses Linux' C<route> output. It implements
L<Net::Route::Parser>.


=head1 INTERFACE

See L<Net::Route::Parser>.

=head2 Object Methods

=head3 command_line()

=head3 parse_routes()


=head1 AUTHOR

Created by Alexandre Storoz, C<< <astoroz@straton-it.fr> >>

Maintained by Thomas Equeter, C<< <tequeter@straton-it.fr> >>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 Straton IT.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

