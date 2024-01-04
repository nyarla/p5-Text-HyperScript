use strict;
use warnings;

use Test2::V0;

my $done = lives {
    use Text::HyperScript::HTML5 ();
};

ok $done;

done_testing;
