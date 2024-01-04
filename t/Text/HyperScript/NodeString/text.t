use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw(text);

subtest text => sub {
    is text('<^o^>'), '&lt;^o^&gt;';
};

done_testing;

