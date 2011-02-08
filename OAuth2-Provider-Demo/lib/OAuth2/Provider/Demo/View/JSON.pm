package OAuth2::Provider::Demo::View::JSON;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::JSON';
use JSON::XS ();

=head1 NAME

OAuth2::Provider::Demo::View::JSON - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->config->{expose_stash} = qr/[^current_view]/;

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
