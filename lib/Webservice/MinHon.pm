package WebService::MinHon;
use 5.008001;
use strict;
use warnings;

use JSON::PP;
use LWP::UserAgent;

our $VERSION = "0.01";

my $URL = 'https://mt-auto-minhon-mlt.ucri.jgn-x.jp/api/mt/';
my $tokenURL = 'https://mt-auto-minhon-mlt.ucri.jgn-x.jp/oauth2/token.php';

sub new {
    my ($class, $name, $key, $secret) = @_;
    my $ua = LWP::UserAgent->new();
    my $self = {
        name => $name,
        key => $key,
        secret => $secret,
        ua => $ua,
      };

    bless $self, $class;
    return $self;
}

sub get_token {
    my ($self) = @_;

    my $res = $self->{ua}->post($tokenURL, [
        grant_type => 'client_credentials',
        client_id => $self->{key},
        client_secret => $self->{secret},
    ]);

    if($res->is_success){
        my $data = $res->content;
        my $ret = decode_json($data);
        $self->{token} = $ret->{access_token};
    }
    return $res;
}

sub translate {
    my ($self, $type, $text) = @_;

    if(!defined $self->{token}){
        my $res1 = $self->get_token();
        if(!$res1->is_success){
            return ($res1, undef);
        }
    }

    my $param = {
        access_token => $self->{token},
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

WebService::MinHon is Perl interface to Minna-no-Jidou-Honyaku@TexTra
(みんなの自動翻訳＠TexTra).

=head1 METHOD

=over 4

=item $ua = WebService::MinHon->new($userID, $APIkey, $APIsecret)

Constructor.

=item ($res, $ret) = $ua->translate($type, $text)

Call the translation API.

Return a list consisting of the L<LWP::Response> object ($res) and a hash
converted from the return value of the API ($ret).

=back

=head1 LICENSE

Copyright (C) SHIRAKATA Kentaro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

SHIRAKATA Kentaro E<lt>argrath@ub32.orgE<gt>

=cut

