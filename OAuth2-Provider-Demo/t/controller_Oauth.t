use strict;
use warnings;
use Test::More;

eval "use Test::WWW::Mechanize::Catalyst 'Oauth'";
if ($@) {
    plan skip_all => 'Test::WWW::Mechanize::Catalyst required';
    exit 0;
}

ok( my $mech = Test::WWW::Mechanize::Catalyst->new, 'Created mech object' );

$mech->get_ok( 'http://localhost/oauth' );
done_testing();
