# NAME

WebService::MinHon - Perl Interface to Minna-no-Jidou-Honyaku@TexTra

# SYNOPSIS

    use WebService::MinHon;

    my $ua = WebService::MinHon->new(
      'userID', 'APIkey', 'APIsecret'
    );
    my ($res, $ret) = $ua->translate(
                        'generalNT_en_ja',
                        'This is a pen.');
    print $ret->{resultset}->{result}->{text};

# DESCRIPTION

WebService::MinHon is Perl interface to Minna-no-Jidou-Honyaku@TexTra.

# LICENSE

Copyright (C) SHIRAKATA Kentaro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

SHIRAKATA Kentaro <argrath@ub32.org>
