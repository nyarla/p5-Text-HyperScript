use strict;
use warnings;

use Test2::V0;

use Text::HyperScript qw(true);
use Text::HyperScript::HTML5 qw(p hr script);

sub main {
    is( hr, '<hr />' );

    is( p( 'hello, ', 'guest!' ), '<p>hello, guest!</p>' );

    is( script( { crossorigin => true }, '' ), '<script crossorigin></script>' );

    done_testing;
}

main;
