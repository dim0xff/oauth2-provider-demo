#!/usr/bin/env perl
use strict;
use warnings;
use OAuth2::Provider::Demo;
use Plack::Builder;
use DemoDataHandler;

OAuth2::Provider::Demo->setup_engine('PSGI');
my $app = sub { OAuth2::Provider::Demo->run(@_) };

builder {
     enable "Plack::Middleware::Auth::OAuth2::ProtectedResource", data_handler => "DemoDataHandler";
     enable "Plack::Middleware::JSONP";
     enable "Plack::Middleware::ContentLength";
     $app;
};


# my $schema = OAuth2::Provider::Demo::Schema->connect('dbi:SQLite:dbname=demo.sqlite','','') or die "Can't connect to katalog";
# 
# #Get all link data
# my $client = $schema->resultset('OauthToken')->find( { client_id => "af5859b5bf7b35f172a0eab126d072a5227f4465" } );