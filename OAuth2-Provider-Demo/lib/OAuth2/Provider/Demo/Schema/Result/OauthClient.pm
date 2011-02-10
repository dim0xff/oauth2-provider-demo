package OAuth2::Provider::Demo::Schema::Result::OauthClient;

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
__PACKAGE__->table("oauth_clients");

__PACKAGE__->add_columns(
    id => { 
        data_type => "INT", 
        default_value => undef, 
        is_auto_increment => 1,
        is_nullable => 0, 
        size => 11 
    },
    name => {
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255
    },
    client_id => { 
        data_type => "VARCHAR", 
        default_value => "", 
        is_nullable => 1, 
        size => 255 
    },
    client_secret => { 
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255 
    },
    redirect_uri => { 
        data_type => "VARCHAR",
        default_value => "",
        is_nullable => 1,
        size => 255, 
    },
 
);
__PACKAGE__->set_primary_key("id");


1;
