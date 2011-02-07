use strict;
use warnings;
use Test::More;

eval "use Test::WWW::Mechanize::Catalyst";
if ($@) {
    plan skip_all => 'Test::WWW::Mechanize::Catalyst required';
    exit 0;
}

ok( my $mech = Test::WWW::Mechanize::Catalyst->new({catalyst_app=>'OAuth2::Provider::Demo'}), 'Created mech object' );

#Define standard interface for OAuth2 as needed.

$mech->get_ok( '/oauth/authorize' );
$mech->get_ok( '/oauth/token' );
$mech->get_ok( '/protected/resource' );
$mech->get_ok( '/admin/clients' );

done_testing();
