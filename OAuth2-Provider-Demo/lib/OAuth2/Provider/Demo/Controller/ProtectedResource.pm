package OAuth2::Provider::Demo::Controller::ProtectedResource;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

OAuth2::Provider::Demo::Controller::ProtectedResource - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index : Path('/protected/resource') {
    my ( $self, $c ) = @_;
    warn $c->request->env->{REMOTE_USER};
    warn $c->request->env->{X_OAUTH_CLIENT_ID};
    warn $c->request->env->{X_OAUTH_SCOPE};
    $c->response->body('This is a protected resource');
}


=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
