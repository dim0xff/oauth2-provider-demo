package OAuth2::Provider::Demo::Schema::Result::AccessToken;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE
use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;
__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table("access_tokens");

__PACKAGE__->add_columns(
    id => { 
        data_type => "INT", 
        default_value => undef, 
        is_auto_increment => 1,
        is_nullable => 0, 
        size => 11,
    },
    auth_id => {
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255,
    },
    token => {
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255,
    },
    expires_in => { 
        data_type => "INT",
        default_value => undef,
        is_nullable => 1,
        size => 11,
    },
    created_on => { 
        data_type => "INT",
        default_value => undef,
        is_nullable => 1,
        size => 11,
    },
    secret_type => {
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255,
    },
);
__PACKAGE__->set_primary_key("id");


1;
