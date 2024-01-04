use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw(h raw true);

my $tests = [
    'tag' => [
        ['hr']   => '<hr />',
        ['<hr>'] => '<&lt;hr&gt; />',
    ],

    'attribute' => [
        [ 'hr', { id      => 'msg' } ]                 => '<hr id="msg" />',
        [ 'hr', { id      => 'msg', class => 'foo' } ] => '<hr class="foo" id="msg" />',
        [ 'hr', { id      => 'm&g' } ]                 => '<hr id="m&amp;g" />',
        [ 'hr', { class   => [qw|foo bar baz|] } ]     => '<hr class="bar baz foo" />',
        [ 'hr', { '<foo>' => '<bar>' } ]               => '<hr &lt;foo&gt;="&lt;bar&gt;" />',
        [ 'hr', { '<foo>' => ['<bar>'] } ]             => '<hr &lt;foo&gt;="&lt;bar&gt;" />',
    ],

    'content' => [
        [ 'p', h('hr') ]              => '<p><hr /></p>',
        [ 'p', raw('<hr />') ]        => '<p><hr /></p>',
        [ 'p', '<hr />' ]             => '<p>&lt;hr /&gt;</p>',
        [ 'p', h( strong => 'hey' ) ] => '<p><strong>hey</strong></p>',
    ],

    'boolean' => [
        [ 'script', { crossorigin => true }, '' ] => '<script crossorigin></script>',
    ],

    'prefixed' => [
        [ 'hr', { data => { id     => 'msg' } } ]                 => '<hr data-id="msg" />',
        [ 'hr', { data => { id     => 'msg', class => 'foo' } } ] => '<hr data-class="foo" data-id="msg" />',
        [ 'hr', { data => { key    => [qw| foo bar baz |] } } ]   => '<hr data-key="bar baz foo" />',
        [ 'hr', { data => { '<id>' => '<msg>' } } ]               => '<hr data-&lt;id&gt;="&lt;msg&gt;" />',
        [ 'hr', { data => { '<id>' => ['<msg>'] } } ]             => '<hr data-&lt;id&gt;="&lt;msg&gt;" />',
        [ 'hr', { data => { key    => true } } ]                  => '<hr data-key />',
    ],

    compelex => [
        [ 'p', { id => 'msg' }, h( 'b', [ 'hello', ' ', 'world!' ], { data => { foo => '<bar>' } } ) ],
        '<p id="msg"><b data-foo="&lt;bar&gt;">hello world!</b></p>'
    ],
];

while ( my ( $label, $cases ) = splice @{$tests}, 0, 2 ) {
    subtest $label => sub {
        while ( my ( $test, $expect ) = splice @{$cases}, 0, 2 ) {
            is h( @{$test} ), $expect, $expect;
        }
    };
}

done_testing;
