package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

use OAuth::Lite2::Client::WebServer;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

TestApp::Controller::Root - Root Controller for TestApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS
=cut

sub auth : Local {
    my ($self, $ctx) = @_;

    my $user = $ctx->authenticate({}, 'default');

    $ctx->detach unless $user;

    $ctx->response->body('success');
}

my $client = OAuth::Lite2::Client::WebServer->new(
    id               => q{af5859b5bf7b35f172a0eab126d072a5227f4465},
    secret           => q{13a152404029e4fa1ee8a680cddac8ee97698293},
    authorize_uri    => q{http://localhost:3000/oauth/authorize},
    access_token_uri => q{http://localhost:3000/oauth/token},
);

# redirect user to authorize page.
sub start :Local {
    my ( $self, $c ) = @_;

    my $redirect_url = $client->uri_to_redirect(
        redirect_uri => q{http://localhost:3333/callback},
        scope        => q{photo},
        state        => q{optional_state},
    );

    $c->res->redirect( $redirect_url );
}


=head2 callback
=cut
sub callback :Local {
    my ( $self, $c )  = @_;

    if ( $c->authenticate( undef, 'default' ) ) {
        # $c->stash->{message} = "Logged in successfully.";
        # $c->res->redirect( $c->uri_for( q[/] ) );
        $c->res->body("Logged in successfully.");
     } else {
        $c->res->body("Log in failed.");
     }

    # $c->response->body( "CALLBACK with CODE:" . $c->req->param("code") );
    # my $your_app = $c;
    # my $code = $your_app->request->param("code");
    # my $access_token = $client->get_access_token(
    #     code         => $code,
    #     redirect_uri => q{http://localhost:3333/callback},
    # ) or return $your_app->error( $client->errstr );
}


=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
