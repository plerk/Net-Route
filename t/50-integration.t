use Test::More tests => 2;
use Net::Route::Table;
use NetAddr::IP;

my $table_ref = Net::Route::Table->from_system();
my $default_network = NetAddr::IP->new( '0.0.0.0', '0.0.0.0' );

is( $table_ref->default_route()->destination(), $default_network, 'The default gateway is 0.0.0.0' );

my $size = @{ $table_ref->all_routes() };
cmp_ok( $size, '>' , 1, 'There are at least two routes' );

#foreach my $route_ref ( @{ $table_ref->all_routes() } )
#{
#    if ( $route_ref != $table_ref->default_route )
#    {
#        isnt( $route_ref->destination, $default_network, "No other 0.0.0.0 route" );
#    }
#}

