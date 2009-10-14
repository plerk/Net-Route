package Net::Route::Parser::solaris;
use 5.008;
use strict;
use warnings;
use version; our ( $VERSION ) = '$Revision: 297 $' =~ m{(\d+)}xms;
use Moose;
use Net::Route;
use Net::Route::Parser qw(:ip_re);
use Readonly;

extends 'Net::Route::Parser';

sub command_line
{
    return '/bin/netstat -rnv';
}

sub parse_routes
{
    my ( $self, $text_lines_ref ) = @_;

    my @routes;
    foreach my $line ( @{$text_lines_ref} )
    {
        if ( $line =~ $IP_RE )
        {
            chomp $line;

            my @values = split /\s+/xms, $line;

            # These values will be stored in a configuration hash
            if ( $line =~ $IPV6_RE )
            {
                my ( $dest, $gateway, $interface, $pmtu, $rtt, $metric, $flags, $out, $in_fwd ) = @values;
                my $is_active  = $flags =~ /U/xms;
                my $is_dynamic = $flags =~ /[RDM]/xms;
                my $route_ref = Net::Route->new( { 'destination' => NetAddr::IP->new( $dest ),
                                                   'gateway'     => NetAddr::IP->new( $gateway ),
                                                   'is_active'   => $is_active,
                                                   'is_dynamic'  => $is_dynamic,
                                                   'metric'      => $metric,
                                                   'interface'   => $interface,
                                                 } );
                push @routes, $route_ref;
            }
            else
            {
                my ( $dest, $mask, $gateway, $interface, $mxfrg, $rtt, $metric, $flags, $out, $in_fwd ) = @values;

                if ( $dest eq 'default' )
                {
                    $dest = '0.0.0.0';
                }

                my $is_active  = $flags =~ /U/xms;
                my $is_dynamic = $flags =~ /[RDM]/xms;
                my $route_ref = Net::Route->new( {
                       'destination' => NetAddr::IP->new( $dest, $mask ),
                       'gateway'     => NetAddr::IP->new( $gateway ),
                       'is_active'   => $is_active,
                       'is_dynamic'  => $is_dynamic,
                       'metric'      => $metric,
                       'interface'   => $interface,

                    } );
                push @routes, $route_ref;
            }
        }
    }

    return \@routes;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Net::Route::Parser::solaris - Internal class


=head1 SYNOPSIS

Internal.


=head1 VERSION

Revision $Revision: 297 $.


=head1 DESCRIPTION

This class parses Solaris' C<netstat> output. It implements
L<Net::Route::Parser>.


=head1 INTERFACE

See L<Net::Route::Parser>.

=head2 Object Methods

=head3 command_line()

=head3 parse_routes()


=head1 AUTHOR

Created by Alexandre Storoz, C<< <astoroz@straton-it.fr> >>

Maintained by Thomas Equeter, C<< <tequeter@straton-it.fr> >>


=head1  LICENSE AND COPYRIGHT

Copyright 2009 Straton IT, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

