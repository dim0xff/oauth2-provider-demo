package OAuth2::Provider::Demo::Controller::Oauth;
use Moose;
use namespace::autoclean;

use OAuth::Lite2::Server::GrantHandler::AuthorizationCode;
use OAuth::Lite2::Server::GrantHandler::Password;
use OAuth::Lite2::Server::GrantHandler::RefreshToken;

use OAuth::Lite2::Server::Endpoint::Token;
use OAuth::Lite2::Util qw(build_content);


use Try::Tiny;

# Testing
use Data::Dumper;
use Data::Dump qw/pp/;

BEGIN {extends 'Catalyst::Controller'; }


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

sub base :Chained('/') :PathPart('oauth') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    my $client                 = $c->model('DBIC::OauthClient')
                                    ->find( { client_id => $c->req->param('client_id') } );
    $c->stash->{client_id}     = $client->client_id;
    $c->stash->{client_secret} = $client->client_secret;
    $c->stash->{redirect_uri}  = $client->redirect_uri;

    TestDataHandler->clear;
    TestDataHandler->add_client(  id     => $client->client_id,
                                  secret => $client->client_secret);
    my $users    = $c->config->{'Plugin::Authentication'}->{default}->{store}->{users};
    my $username = (keys %{$users} )[0];
    my $password = $users->{$username}->{password};
    TestDataHandler->add_user( username => $username,
                               password => $password );
}

=head2 authorize
     Authorization endpoint #match /oauth/authorize
    - used to obtain authorization from the resource owner via user-agent redirection.
=cut

sub authorize :Chained('base') :PathPart('authorize') :Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->req->method eq 'GET' ) {
        # $c->res->body("login_form with CLIENT_ID=af5859b5bf7b35f172a0eab126d072a5227f4465") unless $c->user;
        #LOGIN REQUIRED
        if (! $c->user ) {
            $c->stash( template => 'form/login.tt')
        } else {
            $c->stash( template => 'oauth/authorize.tt' );
        }
        $c->forward( $c->view('TT') );
    }

    if ( $c->req->method eq 'POST' ) {

        my $redirect_uri = $c->req->param('redirect_uri');
        my $user         = $c->req->param('user');
        my $password     = $c->req->param('password');

        if ( $c->authenticate( { username => $user,
                                 password => $password } ) ) {
            $c->res->redirect( $c->uri_for('/oauth/authorize') );
        } else {
            $c->res->body('login incorrect');
        }

        $c->res->redirect( $redirect_uri . q{?} . build_content( { code => q{code_bar} }) );
    }
}

=head2 token
    Access Token Endpoint #match /oauth/token
    - used to exchange an authorization grant for an access token,
      typically with client authentication.
=cut

sub token :Chained('base') :PathPart('token') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{grant_type}    = $c->req->param('grant_type');
    $c->stash->{refresh_token} = $c->req->param('refresh_token');
    $c->forward('handle');
}

sub handle :Private {
    my ( $self, $c ) = @_;
    try {
        my $app = OAuth::Lite2::Server::Endpoint::Token->new(
            data_handler => "TestDataHandler",
        );
        $app->support_grant_type( $c->stash->{grant_type} );
        $c->detach( 'handle_' . $c->stash->{grant_type} );
    } catch {
        $c->log->info("------- <ERROR> ------");
        if ($_->isa("OAuth::Lite2::Server::Error")) {
            use Data::Dumper;
            $c->log->debug ( "ERROR DUMP:" );
            $c->log->debug ( Dumper $_ );
            my %error_params = ( error => $_->type );
            my $formatter = OAuth::Lite2::Formatters->get_formatter_by_name("json");
            $error_params{error_description} = $_->description if $_->description;
            $c->res->status( $_->code );
            $c->res->headers->header( 'Content-Type' => $formatter->type,
                                           'Cache-Control' => 'no-store' );
            $c->res->body( $formatter->format(\%error_params) );
        } else {
            # rethrow
            die $_;
        }
    };
}


sub handle_authorization_code : Private {
    my ( $self, $c ) = @_;
    my $authorizationCodeHandler = OAuth::Lite2::Server::GrantHandler::AuthorizationCode->new;
    my $dh = TestDataHandler->new;
    my $auth_info = $dh->create_or_update_auth_info(
        client_id     => $c->stash->{client_id},
        client_secret => $c->stash->{client_secret},
        code          => q{code_bar},
        redirect_uri  => $c->stash->{redirect_uri},
    );
    $c->data_handler( $dh );
    my $res = $authorizationCodeHandler->handle_request( $c );
    $c->stash( $res );
}

sub handle_password :Private {
    my ( $self, $c ) = @_;
    my $passwordHandler = OAuth::Lite2::Server::GrantHandler::Password->new;
    my $dh = TestDataHandler->new;
    $c->data_handler( $dh );

    my $res = $passwordHandler->handle_request( $c );
    $c->stash( $res );
}

sub handle_refresh_token :Private {
    my ( $self, $c ) = @_;
    my $refreshHandler = OAuth::Lite2::Server::GrantHandler::RefreshToken->new;
    my $dh = TestDataHandler->new;
    my $auth_info = $dh->create_or_update_auth_info(
        client_id     => $c->stash->{client_id},
        client_secret => $c->stash->{client_secret},
        refresh_token => $c->stash->{refresh_token}, 
    );
    $c->data_handler( $dh );

    my $res = $refreshHandler->handle_request( $c );
    $c->stash( $res );
}



=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
