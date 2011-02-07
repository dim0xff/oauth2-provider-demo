package OAuth2::Provider::Demo::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

=head1 NAME

OAuth2::Provider::Demo::View::TT - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->config({
        DEFAULT_ENCODING   => 'utf-8',
        INCLUDE_PATH       => [ OAuth2::Provider::Demo->path_to( 'root', 'base' ), ],
        WRAPPER            => 'wrapper.tt',
        TEMPLATE_EXTENSION => '.tt',
        render_die         => 1,
    });

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;
