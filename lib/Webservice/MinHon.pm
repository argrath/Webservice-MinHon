package WebService::MinHon;
use 5.008001;
use strict;
use warnings;

use JSON::PP;
use LWP::UserAgent;
use LWP::Authen::OAuth;

our $VERSION = "0.01";

my $URL = 'https://mt-auto-minhon-mlt.ucri.jgn-x.jp/api/mt/';

sub new {
    my ($class, $name, $key, $secret) = @_;
    my $ua = LWP::Authen::OAuth->new(
        oauth_consumer_key => $key,
        oauth_consumer_secret => $secret,
        );
    my $self = {
        name => $name,
        key => $key,
        secret => $secret,
        ua => $ua,
      };

    bless $self, $class;
    return $self;
}

sub translate {
    my ($self, $type, $text) = @_;

    my $param = {
        key => $self->{key},
        type => 'json',
        name => $self->{name},
        text => $text,
    };

    my $res = $self->{ua}->post(
        $URL . $type . '/',
        $param);

    if($res->is_success){
        my $data = $res->content;
        my $ret = decode_json($data);
        return ($res, $ret);
    } else {
        return ($res, undef);
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::MinHon - Perl Interface to Minna-no-Jidou-Honyaku@TexTra

=head1 SYNOPSIS

    use WebService::MinHon;

    my $ua = WebService::MinHon->new(
      'userID', 'APIkey', 'APIsecret'
    );
    my ($res, $ret) = $ua->translate(
                        'generalNT_en_ja',
                        'This is a pen.');
    print $ret->{resultset}->{result}->{text};

=head1 DESCRIPTION

WebService::MinHon is Perl interface to Minna-no-Jidou-Honyaku@TexTra.

=head1 LICENSE

Copyright (C) SHIRAKATA Kentaro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

SHIRAKATA Kentaro E<lt>argrath@ub32.orgE<gt>

=cut

