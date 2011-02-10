package OAuth2::Provider::Demo::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';


__PACKAGE__->load_namespaces( default_resultset_class => '+OAuth2::Provider::Demo::Schema::Base::ResultSet' );

# __PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-09-16 11:10:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AYsMXSm4+4hmiQdkS6C93w


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;

our $VERSION = 2;
1;
