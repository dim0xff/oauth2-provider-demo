package OAuth2::Provider::Demo::Controller::Oauth;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

OAuth2::Provider::Demo::Controller::Oauth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


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

sub token :Chained("base") :PathPart("token") :Args(0) {}



=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
