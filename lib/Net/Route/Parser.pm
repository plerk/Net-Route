package Net::Route::Parser;

use Moose;
use English qw( -no_match_vars );
use POSIX qw( WIFEXITED WEXITSTATUS WIFSIGNALED WTERMSIG WIFSTOPPED WSTOPSIG );
use version; our ( $VERSION ) = '$Revision: 237 $' =~ m{(\d+)};    ## no critic


sub from_system
{
    my ( $self ) = @_;

    my $command = $self->command_line();
    open my $input_ref , "$command" or die "Cannot open or execute '$command': $OS_ERROR"; ## no critic

    my $routes_ref = $self->parse_routes( $input_ref );

    if ( !close $input_ref )
    {
        if ( !$OS_ERROR && $CHILD_ERROR )
        {
            if ( WIFSIGNALED($CHILD_ERROR) )
            {
                die "'$command' died with signal WTERMSIG($CHILD_ERROR)"; ## no critic
            }
            elsif (WEXITSTATUS($CHILD_ERROR) )
            {
                die "'$command' returned non-zero value WEXITSTATUS($CHILD_ERROR)"; ## no critic
            }
        }
        else
        {
            # Ignore, it doesn't invalidate the results
        }
    }

    return $routes_ref;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 NAME

Net::Route::Parser - Internal class


=head1 SYNOPSIS

Not used directly.


=head1 VERSION

Revision $Revision: 237 $.


=head1 DESCRIPTION

This is a base class for the system-specific parsers. It is not usable directly
(abstract).

System-specific parsers should inherit from this class to obtain common
functionality.


=head1 INTERFACE

This interface is subject to change until version 1.


=head2 Object Methods

=head3 from_system()

Implementation of C<Net::Route::Table::from_system()>.

=head3 command_line() [pure virtual]

What you want to read the information from, in L<open> format. Ie, if you want
to open a program end it with a C<|>, if you want to open a file use the usual
C<< < >>.

Implement this in subclasses.

=head3 parse_routes( $input_ref ) [pure virtual]

Reads and parses the routes from the output of the command, returns an arrayref
of L<Net::Route> objects.


=head1 AUTHOR

Created by Alexandre Storoz, C<< <astoroz@straton-it.fr> >>

Maintained by Thomas Equeter, C<< <tequeter@straton-it.fr> >>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 Straton IT.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

