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

        if ( ref $data eq 'Text::HyperScript::Boolean' && $data->is_ture ) {
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

                if ( ref $value eq 'Text::HyperScript::Boolean' && $value->is_ture ) {
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

    # TODO

=head1 DESCRIPTION

TODO

=head1 FUNCTIONS

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

=item is_ture : Bool

If boolean value pointed to true value, this method return true.
Otherwise return false.

=item is_false : Bool

If boolean value pointed to false value, this method return true.
Otherwise return false.

=back

This function values uses for html5 boolean attributes.

For exmaple:

  my $script = h('script', { crossorigin => true }, '...') # return <script crossorigin>...</script> 

=head1 LICENSE

Copyright (C) nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

nyarla E<lt>nyarla@kalaclista.comE<gt>

=cut
