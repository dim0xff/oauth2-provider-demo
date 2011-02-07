package OAuth2::Provider::Demo::Controller::Oauth;
use Moose;
use namespace::autoclean;

use OAuth::Lite2::Server::Context;
use OAuth::Lite2::Server::GrantHandler::AuthorizationCode;
use OAuth::Lite2::Util qw(build_content);

BEGIN {extends 'Catalyst::Controller'; }


=head1 NAME

OAuth2::Provider::Demo::Controller::Oauth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 begin
=cut

sub begin {
    TestDataHandler->clear;
    TestDataHandler->add_client(id => q{foo}, secret => q{secret_value});
    our $dh = TestDataHandler->new;
    our $auth_info = $dh->create_or_update_auth_info(
        client_id    => q{foo},
        user_id      => q{1},
        scope        => q{email},
        code         => q{code_bar},
        redirect_uri => q{http://example.org/callback},
    );

    is($auth_info->refresh_token, "refresh_token_0");
    our $action = OAuth::Lite2::Server::GrantHandler::AuthorizationCode->new;
}


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
    AuthorizationHandler #match /oauth/authorize
=cut

sub authorize :Chained("base") :PathPart("authorize") :Args(0) {}

=head2 token
    AccessTokenHandler #match /oauth/token
=cut

sub token :Chained("base") :PathPart("token") :Args(0) {
    my ( $self, $c ) = @_;
}



=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
