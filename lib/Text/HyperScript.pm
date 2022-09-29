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
    return Text::HyperScript::Element->new($html);
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
        if ( ref $data eq 'Text::HyperScript::Element' ) {
            push @contents, $data->markup;
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
        return Text::HyperScript::Element->new(qq(<${tag}${attrs} />));
    }

    return Text::HyperScript::Element->new( qq(<${tag}${attrs}>) . ( join q{}, @contents ) . qq(</${tag}>) );
}

package Text::HyperScript::Element;

use overload q("") => \&markup;

sub new {
    my ( $class, $html ) = @_;
    return bless \$html, $class;
}

sub markup {
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

Text::HyperScript - The HyperScript like library for Perl.

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

This module is a html/xml like string generator like as hyperscirpt.

The name of this module contains B<HyperScript>,
but this module features isn't same of another language or original implementation.

=head1 FUNCTIONS

=head2 h

This function makes html/xml text by perl code. 

This function is complex. but it's powerful.

B<Arguments>:

    h($tag, [ \%attrs, $content, ...])

=over

=item C<$tag>

Tag name of element.

This value should be C<Str> value.

=item C<\%attrs> 

Attributes of element.

Result of attributes sorted by alphabetical according.

You could pass to multiple theses types as attribute values:

=over

=item C<Str>

If you passed to this type, attribute value became a C<Str> value.

For example:

    h('hr', { id => 'id' }); # => '<hr id="id" />'

=item C<Text::HyperScript::Boolean>

If you passed to this type, attribute value became a value-less attribute.

For example:

    # `true()` returns Text::HyperScript::Boolean value as !!1 (true)
    h('script', { classorigin => true }); # => '<script crossorigin></script>'

=item C<ArrayRef[Str]>

If you passed to this type, attribute value became a B<sorted> (alphabetical according),
delimited by whitespace C<Str> value,

For example:

    h('hr', { class => [qw( foo bar baz )] });
    # => '<hr class="bar baz foo">'

=item C<HashRef[ Str | ArrayRef[Str] | Text::HyperScript::Boolean ]>

This type is a shorthand of prefixed attributes.

For example:

    h('hr', { data => { id => 'foo', flags => [qw(bar baz)], enabled => true } });
    # => '<hr data-enabled data-flags="bar baz" data-id="foo" />'

=back

=item C<$contnet>

Contents of element.

You could pass to these types:

=over

=item C<Str>

Plain text as content.

This value always applied html/xml escape by L<HTML::Escape::escape_html>.

=item C<Text::HyperScript::Element>

Raw html/xml string as content.

B<This value does not applied html/xml escape>,
B<you should not use this type for untrusted text>.

=back

=back

=head2 text

This function returns a html/xml escaped text.

If you use untrusted stirng for display,
you should use this function for wrapping untrusted content.

=head2 raw

This function makes a instance of C<Text::HyperScript::Element>.

Instance of C<Text::HyperScript::Element> has C<markup> method,
that return text with html/xml markup.

The value of C<Text::HyperScript::Element> is not escaped by L<HTML::Escape::escape_html>,
you should not use this function for display untrusted content. 
Please use C<text> insted of this function.

=head2 true / false

This functions makes instance of C<Text::HyperScript::Boolean> value.

Instance of C<Text::HyperScript::Boolean> has two method as C<is_true> and C<is_false>,
these method returns that value pointed C<true> ot C<false>.

Usage of these functions for make html5 value-less attribute.

For example:

    h('script', { crossorigin => true }); # => '<script crossorigin></script>'

=head1 QUESTION AND ANSWERS

=head2 How do I get element of empty content like as `script`?

This case you chould gets element string by pass to empty string.

For example:

    h('script', ''); # <script></script>

=head2 Why all attributes and attribute values sorted by alphabetical according?

This reason that gets same result on randomized orderd hash keys. 

=head1 LICENSE

Copyright (C) OKAMURA Naoki a.k.a nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

OKAMURA Naoki a.k.a nyarla: E<lt>nyarla@kalaclista.comE<gt>

=cut
