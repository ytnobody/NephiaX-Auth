package NephiaX::Auth;
use strict;
use warnings;
use Nephia plugins => [
    'Auth::Twitter' => {
        consumer_key    => 'your consumer key',
        consumer_secret => 'your consumer secret',
        callback_url    => 'http://127.0.0.1:5000/auth' ,
    },
];

our $VERSION = 0.05;
our $SESSION = {};

sub get_twitter_id {
    my $session_id = shift;
    warn $session_id.' => '. $SESSION->{$session_id};
    $SESSION->{$session_id};
}

path '/' => sub {
    my $req = shift;
    my $twitter_id = get_twitter_id(twitter_session);
    return {
        template => 'index.tt',
        title => 'NephiaX::Auth',
        envname  => $twitter_id || undef,
        apppath  => 'lib/' . __PACKAGE__ .'.pm',
    };
};

path '/auth' => sub {
    my $session_id = twitter_session;
    my $twitter_id = get_twitter_id($session_id);
    unless ($twitter_id) {
        return twitter_auth {
            # this code-block executes when authentication succeeded
            my ($session_id, $twitter_id) = @_;
            $SESSION->{$session_id} = $twitter_id;
        } 
    }
    res { redirect('/') };
};

path '/logout' => sub {
    twitter_session_expire;
    res { redirect('/') };
};



1;

=head1 NAME

NephiaX::Auth - Web Application

=head1 SYNOPSIS

  $ plackup

=head1 DESCRIPTION

NephiaX::Auth is web application based Nephia.

=head1 AUTHOR

ytnobody

=head1 SEE ALSO

Nephia

Nephia::View::TT

Nephia::Plugin::Auth::Twitter

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
