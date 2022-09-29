use 5.008001;
use strict;
use warnings;

package Text::HyperScript;

our $VERSION = "0.01";

use Exporter::Lite;
use HTML::Escape ();

our @EXPORT = qw(raw true false text h);

sub raw {
    my $html = shift;
    return Text::HyperScript::HTML->new($html);
}

sub true {
    my $true = !!1;
    return bless \$true, 'Text::HyperScript::Boolean';
}

sub false {
    my $false = !!0;
    return bless \$false, 'Text::HyperScript::Boolean';
}

sub text {
    my $text = shift;
    return HTML::Escape::escape_html($text);
}

sub h {
    my $tag = HTML::Escape::escape_html(shift);

    my %attrs;
    my @contents;

    for my $data (@_) {
        if ( ref $data eq 'Text::HyperScript::HTML' ) {
            push @contents, $data->html;
            next;
        }

        if ( ref $data eq 'HASH' ) {
            %attrs = ( %attrs, %{$data} );
            next;
        }

        if ( ref $data eq 'ARRAY' ) {
            push @contents, @{$data};
            next;
        }

        push @contents, text($data);
    }

    my $attrs = q{};
    for my $prefix ( sort keys %attrs ) {
        my $data = $attrs{$prefix};
        if ( !ref $data ) {
            $attrs .= q{ };
            $attrs .= HTML::Escape::escape_html($prefix);
            $attrs .= q{="};
            $attrs .= HTML::Escape::escape_html($data);
            $attrs .= q{"};

            next;
        }

        if ( ref $data eq 'Text::HyperScript::Boolean' && $data->is_true ) {
            $attrs .= " ";
            $attrs .= HTML::Escape::escape_html($prefix);

            next;
        }

        if ( ref $data eq 'HASH' ) {
        PREFIX:
            for my $suffix ( sort keys %{$data} ) {
                my $key   = HTML::Escape::escape_html($prefix) . '-' . HTML::Escape::escape_html($suffix);
                my $value = $data->{$suffix};

                if ( !ref $value ) {
                    $attrs .= " ";
                    $attrs .= $key;
                    $attrs .= q{="};
                    $attrs .= HTML::Escape::escape_html($value);
                    $attrs .= q{"};

                    next PREFIX;
                }

                if ( ref $value eq 'Text::HyperScript::Boolean' && $value->is_true ) {
                    $attrs .= " ";
                    $attrs .= $key;

                    next PREFIX;
                }

                if ( ref $value eq 'ARRAY' ) {
                    $attrs .= q{ };
                    $attrs .= $key;
                    $attrs .= q{="};
                    $attrs .= join q{ }, map { HTML::Escape::escape_html($_) } sort @{$value};
                    $attrs .= q{"};

                    next PREFIX;
                }

                $attrs .= " ";
                $attrs .= $key;
                $attrs .= q{="};
                $attrs .= HTML::Escape::escape_html($value);
                $attrs .= q{"};
            }

            next;
        }

        if ( ref $data eq 'ARRAY' ) {
            $attrs .= q{ };
            $attrs .= HTML::Escape::escape_html($prefix);
            $attrs .= q{="};
            $attrs .= join q{ }, map { HTML::Escape::escape_html($_) } sort @{$data};
            $attrs .= q{"};

            next;
        }

        $attrs .= q{ };
        $attrs .= HTML::Escape::escape_html($prefix);
        $attrs .= q{="};
        $attrs .= HTML::Escape::escape_html($data);
        $attrs .= q{"};
    }

    if ( @contents == 0 ) {
        return Text::HyperScript::HTML->new(qq(<${tag}${attrs} />));
    }

    return Text::HyperScript::HTML->new( qq(<${tag}${attrs}>) . ( join q{}, @contents ) . qq(</${tag}>) );
}

package Text::HyperScript::HTML;

use overload q("") => \&html;

sub new {
    my ( $class, $html ) = @_;
    return bless \$html, $class;
}

sub html {
    return ${ $_[0] };
}

package Text::HyperScript::Boolean;

use overload ( q(bool) => \&is_true, q(==) => \&is_true );

sub is_true {
    return !!${ $_[0] };
}

sub is_false {
    return !${ $_[0] };
}

package Text::HyperScript;

1;

=encoding utf-8

=head1 NAME

Text::HyperScript - The HyperScript library for Perl.

=head1 SYNOPSIS

    use feature qw(say);
    use Text::HyperScript qw(h true);

    # tag only
    say h('hr');          # => '<hr />'
    say h(script => q{}); # => '<script></script>'

    # tag with content
    say h('p', 'hi,');    # => '<p>hi,</p>'
    say h('p', ['hi,']);  # => '<p>hi,</p>'

    say h('p', 'hi', h('b', ['anonymous']));  # => '<p>hi,<b>anonymous</b></p>'
    say h('p', 'foo', ['bar'], 'baz');        # => '<p>foobarbarz</p>'

    # tag with attributes
    say h('hr', { id => 'foo' });                     # => '<hr id="foo" />'
    say h('hr', { id => 'foo', class => 'bar'});      # => '<hr class="bar" id="foo">'
    say h('hr', { class => ['foo', 'bar', 'baz'] });  # => '<hr class="bar baz foo">' 

    # tag with prefixed attributes
    say h('hr', { data => { foo => 'bar' } });              # => '<hr data-foo="bar">'
    say h('hr', { data => { foo => [qw(foo bar baz)] } });  # => '<hr data-foo="bar baz foo">'

    # tag with value-less attribute
    say h('script', { crossorigin => true }, ""); # <script crossorigin></script>

=head1 DESCRIPTION

This library is a implementation of HTML generator like as hyperscirpt.

This library name contains B<HyperScript>,
but library features different of another language or original implementation.

=head1 FUNCTIONS

=head2 h

This function makes html text by perl code. This function is complex. but it's powerful.

B<Arguments>:

=over

=item C<$tag>

Tag name of element.

This value should be C<Str> value.

=item C<\%attrs> 

Attributes of element.

You can pass to these values as attribute value:

=over

=item C<Str>

If passed to this value, attr value is C<Str> value.

=item C<Text::HyperScript::Boolean>

If passed to this value, attrribute became a value-less attribute.

For example, if you call this function like as:

    h('script' => {crossorigin => true}, '') # `true` return Text::HyperScript::Boolean value.

You could get this result:

    '<script crossorigin></script>'

=item C<ArrayRef[Str]>

If passed to this value, attribute has B<sorted> and delimited by whitespace C<Str>. 

=item C<HashRef[ Str | Text::HyperScript::Boolean | ArrayRef[Str] ]>

If passed to this value, attribute has B<prefixed> values.

This feature is shorthand for C<data> or C<aria> properties.

For Example:

    h('hr', { data => { key => 'id', enabled => true, flags => [qw(foo bar)]  } })

Result is:

    '<hr data-enabled data-flags="bar foo" data-key="id" />'

=back

=item C<$contnet>

Contents of element.

You can pass to these values:

=over

=item C<Str>

Text value of content.

B<This value apply html escape by automatic>.

=item C<Text::HyperScript::HTML>.

HTML value of content.

B<This value is raw string of HTML>.

=back

=back

=head2 text

This function return B<escaped html> string.

This is useful for display text content from untrusted content,
Or contian special characters of html.

=head2 raw

This function return raw html instance of C<Text::HyperScript::HTML>.

B<Return value does not auto escape of html>.

This function has risk of XSS or other script injection. Please be careful.

=head2 true / false

This functions return blessed boolean value of C<Text::HyperScript::Boolean>.

C<Text::HyperScript::Boolean> has two methods:

=over

=item is_true : Bool

If boolean value pointed to true value, this method return true.
Otherwise return false.

=item is_false : Bool

If boolean value pointed to false value, this method return true.
Otherwise return false.

=back

This function values uses for html5 boolean attributes.

For exmaple:

  my $script = h('script', { crossorigin => true }, '...') # return <script crossorigin>...</script> 

=head1 NOTE

=head2 you should pass empty string to C<h> function if you want content blank element like as C<script>

If you want to get element of content is blank, you should call C<h> function like as:

    h('scirpt', '') # => '<script></script>'

=head2 all attributes and values are sorted by alphabetical accordion

This feature made that gets always same results of hyperscripted text,
Because perl's sort of hash keys always randomized.

=head1 LICENSE

Copyright (C) nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

OKAMURA Naoki aka E<lt>nyarla@kalaclista.comE<gt>

=cut
