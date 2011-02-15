package OAuth2::Provider::Demo::Controller::ProtectedResource;
use Moose;
use namespace::autoclean;


use Plack::Util::Accessor qw(realm data_handler error_uri);
use OAuth::Lite2::Server::Error;
use OAuth::Lite2::ParamMethods;
use Carp();

use DemoDataHandler;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

OAuth2::Provider::Demo::Controller::ProtectedResource - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 base
=cut

sub base :Chained('/') :PathPart('protected') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->forward('check_protected_resource');
}

=head2 resource
  Example protected resource
=cut

sub resource :Chained('base') :PathPart('resource') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{is_protected} = 'True';
    $c->forward($c->view('JSON'));
}

=head2 check_protected_resource
  Determine valid if it's a valid request regarding the protected resource.
=cut

sub check_protected_resource : Private {
    my ( $self, $c ) = @_;
    my $req = $c->req;
    my $parser = OAuth::Lite2::ParamMethods->get_param_parser($req)
        or OAuth::Lite2::Server::Error::InvalidRequest->throw;

    # after draft-v6, $params aren't required.
    my ($token, $params) = $parser->parse($req);
    OAuth::Lite2::Server::Error::InvalidRequest->throw unless $token;

    my $dh = DemoDataHandler->new;

    my $access_token = $dh->get_access_token($token);

    OAuth::Lite2::Server::Error::InvalidToken->throw
        unless $access_token;

    Carp::croak "OAuth::Lite2::Server::DataHandler::get_access_token doesn't return OAuth::Lite2::Model::AccessToken"
        unless $access_token->isa("OAuth::Lite2::Model::AccessToken");

    OAuth::Lite2::Server::Error::ExpiredToken->throw
        unless ($access_token->created_on + $access_token->expires_in > time());

    my $auth_info = $dh->get_auth_info_by_id($access_token->auth_id);

    OAuth::Lite2::Server::Error::InvalidToken->throw
        unless $auth_info;

    Carp::croak "OAuth::Lite2::Server::DataHandler::get_auth_info_by_id doesn't return OAuth::Lite2::Model::AuthInfo"
        unless $auth_info->isa("OAuth::Lite2::Model::AuthInfo");

    $dh->validate_client_by_id($auth_info->client_id)
        or OAuth::Lite2::Server::Error::InvalidToken->throw;

    $dh->validate_user_by_id($auth_info->user_id)
        or OAuth::Lite2::Server::Error::InvalidToken->throw;
}

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
