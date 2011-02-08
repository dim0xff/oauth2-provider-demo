package OAuth2::Provider::Demo::Controller::Oauth;
use Moose;
use namespace::autoclean;

use OAuth::Lite2::Server::GrantHandler::AuthorizationCode;
use OAuth::Lite2::Server::GrantHandler::Password;
use OAuth::Lite2::Server::GrantHandler::RefreshToken;

# Testing
use Data::Dumper;
use Data::Dump qw/pp/;

BEGIN {extends 'Catalyst::Controller'; }

TestDataHandler->clear;
TestDataHandler->add_client(id => q{af5859b5bf7b35f172a0eab126d072a5227f4465}, secret => q{13a152404029e4fa1ee8a680cddac8ee97698293});
TestDataHandler->add_user(username => q{ac123}, password => q{123});

=head1 NAME

OAuth2::Provider::Demo::Controller::Oauth - Catalyst Controller

=head1 DESCRIPTION

Oauth Controller manages the protocol 'Endpoints'

=head1 METHODS

=cut

=head2 auto
=cut

sub auto : Private {
  my ( $self, $c ) = @_;
  $c->stash( current_view => 'JSON' );
  return 1;
}


=head2 base
    Base for chained method  #match /oauth
=cut

sub base :Chained("/") :PathPart("oauth") :CaptureArgs(0) {}

=head2 authorize
     Authorization endpoint #match /oauth/authorize
    - used to obtain authorization from the resource owner via user-agent redirection.
=cut

sub authorize :Chained("base") :PathPart("authorize") :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 token
    Access Token Endpoint #match /oauth/token
    - used to exchange an authorization grant for an access token,
      typically with client authentication.
=cut

sub token :Chained("base") :PathPart("token") :Args(0) {
    my ( $self, $c ) = @_;

    # Bunch of IFs and duplicated code
    # Keep it simple and stupid, just for 'learning' and 'testing'

    if ( $c->req->param("grant_type") eq "authorization_code" ) {
        my $authorizationCodeHandler = OAuth::Lite2::Server::GrantHandler::AuthorizationCode->new;
        my $dh = TestDataHandler->new;
        my $auth_info = $dh->create_or_update_auth_info(
            client_id     => q{af5859b5bf7b35f172a0eab126d072a5227f4465},
            client_secret => q{13a152404029e4fa1ee8a680cddac8ee97698293},
            code          => q{code_bar},
            redirect_uri  => q{http://localhost:3333/callback},
        );
        $c->data_handler( $dh );
        my $res = $authorizationCodeHandler->handle_request( $c );
        $c->stash( $res );
        return;
    }

    if ( $c->req->param("grant_type") eq "password" ) {
        my $passwordHandler = OAuth::Lite2::Server::GrantHandler::Password->new;
        my $dh = TestDataHandler->new;
        $c->data_handler( $dh );

        my $res = $passwordHandler->handle_request( $c );
        $c->stash( $res );
        return;
    }

    if ( $c->req->param("grant_type") eq "refresh_token" ) {
        my $refreshHandler = OAuth::Lite2::Server::GrantHandler::RefreshToken->new;
        my $dh = TestDataHandler->new;
        my $auth_info = $dh->create_or_update_auth_info(
            refresh_token => $c->req->param("refresh_token"),
        );
        $c->data_handler( $dh );

        my $res = $refreshHandler->handle_request( $c );
        $c->stash( $res );
        return;
    }
}



=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
