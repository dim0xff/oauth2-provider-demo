package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

use OAuth::Lite2::Client::WebServer;
use Data::Dumper;

use HTTP::Request::Common;
use LWP::UserAgent;

use MIME::Base64;
use Crypt::CBC;
use Digest::SHA qw/hmac_sha1/;

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

    my $user = $ctx->authenticate({},'oauth2');

    $ctx->detach unless $user;

    $ctx->response->body('success');
}

=head2 callback
=cut
sub callback :Local {
    my ( $self, $c )  = @_;

    if ( $c->authenticate( undef, 'oauth2' ) ) {
        $c->res->body("<a href='/auth'>AUTH</a> Logged in successfully." . Dumper($c->user)) ;
     } else {
        $c->res->body("Log in failed.");
     }
}

sub my_info : Global {  #To access api
    my ( $self, $c ) = @_;
    my $token     = $c->user->{token};
    my $timestamp = localtime();
    my $nonce     = Digest::SHA::hmac_sha1($token, 'hmackey');
    my $cipher    = Crypt::CBC->new( {'key' => 'length16length16', 'cipher'=> 'Blowfish', } );
    my $signature = encode_base64( $cipher->encrypt($c->user->{code}) );
    $signature    =~ s/\R//g;
    
    
    my $r = HTTP::Request->new( GET => "http://localhost.provider:3000/my/test",
                                HTTP::Headers->new( Authorization => "MAC token=$token,timestamp=$timestamp,nonce=$nonce,signature=$signature" ), 
                              );
    my $ua       = LWP::UserAgent->new;
    my $response = $ua->request($r);
    $c->res->body( Dumper( $response->content ) );
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $c->res->body( Dumper($c->user) . " <a href='/auth'>auth</a> " );
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
