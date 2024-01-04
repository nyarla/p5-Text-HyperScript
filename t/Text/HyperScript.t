use strict;
use warnings;

use Test2::V0;

my $done = lives {
    use Text::HyperScript;
};

ok $done;

done_testing;
