package OAuth2::Provider::Demo;
use Moose;
use namespace::autoclean;
use TestDataHandler;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Unicode::Encoding
    Authentication
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Session::PerUser
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in oauth2_provider_demo.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.


has 'data_handler' => (
    is      => 'rw',
    isa     => 'TestDataHandler',
    default =>  sub { TestDataHandler->new },
);


__PACKAGE__->config(
    name => '+OAuth2::Provider::Demo',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    default_view => 'TT',
);

__PACKAGE__->config( 'Plugin::Authentication' =>
               {
                   default => {
                       credential => {
                           class => 'Password',
                           password_field => 'password',
                           password_type => 'clear'
                       },
                       store => {
                           class => 'Minimal',
                           users => {
                               ac123 => {
                                   password => "123",
                               },
                           }
                       }
                   }
               }
   );

# Start the application
__PACKAGE__->setup();


=head1 NAME

OAuth2::Provider::Demo - Catalyst based application

=head1 SYNOPSIS

    script/oauth2_provider_demo_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<OAuth2::Provider::Demo::Controller::Root>, L<Catalyst>

=head1 AUTHOR

zdk

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
