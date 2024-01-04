use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw( true false );

subtest "true" => sub {
    my $true = true;

    ok $true->is_true;
    ok !$true->is_false;

    ok !!$true;
};

subtest "false" => sub {
    my $false = false;

    ok $false->is_false;
    ok !$false->is_true;

    ok !$false;
};

done_testing;
