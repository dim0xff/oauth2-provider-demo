package DemoDataHandler;

use strict;
use warnings;

use parent 'OAuth::Lite2::Server::DataHandler';

use String::Random;

use OAuth::Lite2::Server::Error;
use OAuth::Lite2::Model::AuthInfo;
use OAuth::Lite2::Model::AccessToken;

use OAuth2::Provider::Demo::Schema;

my $schema = OAuth2::Provider::Demo::Schema
            ->connect('dbi:SQLite:dbname=demo.sqlite','','') or die "Can't connect to katalog";

sub get_access_token {
    my ($self, $token) = @_;
    my $access_token = $schema->resultset('AccessToken')->find( { token => $token } );
    return unless $access_token;
    my %attrs = (
        auth_id    => $access_token->auth_id,
        token      => $access_token->token,
        expires_in => 3600,
        created_on => time(),
    );

    return OAuth::Lite2::Model::AccessToken->new(\%attrs);
}

sub get_auth_info_by_id {
   my ($self, $auth_id) = @_;
   my $auth_info = $schema->resultset('AuthInfo')->find( $auth_id  );
   return unless $auth_info;
   return OAuth::Lite2::Model::AuthInfo->new({
          id            => $auth_info->id,
          client_id     => $auth_info->client_id,
          user_id       => $auth_info->user_id,
          # scope         => $scope,
          # refresh_token => $refresh_token,
      });
}

1;

