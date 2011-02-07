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


__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    INCLUDE_PATH => [
       OAuth2::Provider::Demo->path_to( 'root', 'base' ),
    ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt',
    ENCODING => 'utf-8',
);


__PACKAGE__->meta->make_immutable;

1;
