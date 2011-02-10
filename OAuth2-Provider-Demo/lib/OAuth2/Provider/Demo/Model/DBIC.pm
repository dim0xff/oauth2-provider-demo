package OAuth2::Provider::Demo::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'OAuth2::Provider::Demo::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:demo.sqlite',
        user => '',
        password => '',
        on_connect_do => q{PRAGMA foreign_keys = ON},
    }
);

=head1 NAME

OAuth2::Provider::Demo::Model::DBIC - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<OAuth2::Provider::Demo>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<OAuth2::Provider::Demo::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.43

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
