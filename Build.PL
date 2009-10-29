use strict;
use warnings;
use Module::Build;

die "OS $^O not supported" unless -e "lib/Net/Route/Parser/$^O.pm";

my $builder = Module::Build->new(
    module_name         => 'Net::Route',
    license             => 'perl',
    dist_author         => 'Straton IT <tequeter@straton-it.fr>',
    dist_version_from   => 'lib/Net/Route.pm',
    requires => {
        'NetAddr::IP' => 0,
        'Moose'       => 0,
        'Readonly'    => 0,
        'IPC::Run3'   => 0,
        'version'     => 0.74,
        'perl'        => '5.8.0',
    },
    build_requires => {
        'Test::More'          => 0,
    },
    add_to_cleanup     => [ 'Net-Route-*' ],
    create_makefile_pl => 'passthrough',
);

$builder->create_build_script();
