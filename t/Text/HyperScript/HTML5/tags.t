use strict;
use warnings;

use Test2::V0;

use Text::HyperScript        qw(true);
use Text::HyperScript::HTML5 qw(p hr script);

subtest examples => sub {
    is hr,                    '<hr />';
    is p(q|hi, guest user!|), '<p>hi, guest user!</p>';
    is( script( { crossorigin => true }, '' ), '<script crossorigin></script>' );
};

subtest html => sub {
    for my $sub (@Text::HyperScript::HTML5::EXPORT) {
        my $tag = $sub;
        $tag =~ s{_}{};
        my $done = lives {
            my $expect = qq|<${tag} id="msg"></${tag}>|;
            my $result = eval qq[
              package Text::HyperScript::HTML5::Test::${tag};
              use Text::HyperScript::HTML5;

              return ${sub}({id => 'msg'}, '');
            ];

            is $result, $expect, $sub;
        };

        ok $done;
    }
};

done_testing;
