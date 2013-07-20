requires 'Nephia' => '0';
requires 'Nephia::View::TT' => '0';
requires 'Nephia::Plugin::Auth::Twitter';

on build => sub {
    requires 'Test::More';
};

