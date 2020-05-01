package Net::Route::Parser::linux::proc;
use 5.008;
use strict;
use warnings;
use version; our ( $VERSION ) = '$Revision: 363 $' =~ m{(\d+)}xms;
use Moose;
use Net::Route;
use constant RTF_UP        => 0x0001;  # Route usable.
use constant RTF_GATEWAY   => 0x0002;  # Destination is a gateway.
use constant RTF_HOST      => 0x0004;  # Host entry (net otherwise).
use constant RTF_REINSTATE => 0x0008;  # Reinstate route after timeout.
use constant RTF_DYNAMIC   => 0x0010;  # Created dyn. (by redirect).
use constant RTF_MODIFIED  => 0x0020;  # Modified dyn. (by redirect).

extends 'Net::Route::Parser';

sub command_line
{
    return [qw(cat /proc/net/route)];
}

sub _hex_to_ip
{
  my($hex) = @_;
  if($hex =~ /^([A-F0-9]{2})([A-F0-9]{2})([A-F0-9]{2})([A-F0-9]{2})$/)
  {
    return join('.', map { hex $_ } ($4,$3,$2,$1));
  }
  else
  {
    die "unable to parse $hex as hex address";
  }
}

sub parse_routes
{
    my ( $self, $text_lines_ref ) = @_;

    splice @{$text_lines_ref}, 0, 1;

    my @routes;
    foreach my $line ( @{$text_lines_ref} )
    {
        chomp $line;

        my @values = split /\s+/xms, $line;
        my ( $interface, # 1
             $dest,      # 2
             $gateway,   # 3
             $flags,     # 4
             $ref,       # 5
             $use,       # 6
             $metric,    # 7
             $dest_mask, # 8
             undef,      # 9
             undef,      # 10
             undef,      # 11
            ) = @values;

        $dest      = _hex_to_ip( $dest );
        $gateway   = _hex_to_ip( $gateway );
        $dest_mask = _hex_to_ip( $dest_mask );

        my $is_active  = !!($flags & RTF_UP);
        my $is_dynamic = !!($flags & (RTF_REINSTATE|RTF_DYNAMIC|RTF_MODIFIED));
        my $route_ref = Net::Route->new( {
               'destination' => $self->create_ip_object( $dest, $dest_mask ),
               'gateway'     => $self->create_ip_object( $gateway ),
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

Revision $Revision: 363 $.


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

