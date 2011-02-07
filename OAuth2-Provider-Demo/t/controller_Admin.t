use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'OAuth2::Provider::Demo' }
BEGIN { use_ok 'OAuth2::Provider::Demo::Controller::Admin' }

ok( request('/admin')->is_success, 'Request should succeed' );
done_testing();
