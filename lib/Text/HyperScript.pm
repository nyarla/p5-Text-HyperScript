use 5.008001;
use strict;
use warnings;

package Text::HyperScript;

our $VERSION = "0.01";

use Exporter::Lite;
use HTML::Escape ();

our @EXPORT = qw(raw true false text);

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
