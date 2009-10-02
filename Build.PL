use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Net::Route',
    license             => 'perl',
    dist_author         => 'Thomas Equeter <tequeter@straton-it.fr>',
    dist_version_from   => 'lib/Net/Route.pm',
    build_requires      => {
        'Test::More' => 0,
    },
    requires => {
        'NetAddr::IP' => 0,
        'Moose'       => 0,
        'Readonly'    => 0,
        'version'     => 0.74,
    },
    build_requires => {
        'Test::More'          => 0,
        'Test::Perl::Critic'  => 0,
        'Test::Pod'           => 0,
        'Test::Pod::Coverage' => 0,
    },
    add_to_cleanup     => [ 'Net-Route-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
