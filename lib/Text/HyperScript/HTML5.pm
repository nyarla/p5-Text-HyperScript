package Text::HyperScript::HTML5;

use strict;
use warnings;

use Exporter::Lite;
use Text::HyperScript ();

our $h = Text::HyperScript->can('h');

BEGIN {
    # referenced from: https://developer.mozilla.org/en-US/docs/Web/HTML/Element
    # this elements list get by this oneliner:
    # Array.from(document.querySelectorAll('article section td:first-child a')).map(x => x.textContent.replace(/[<>]/g, `"`)).join(",\n")
    our @EXPORT = (

        # Main root
        "html",

        # Document metadata
        "base",
        "head",
        "link",
        "meta",
        "style",
        "title",

        # Sectioning root
        "body",

        # Content sectioning
        "address",
        "article",
        "aside",
        "footer",
        "header",
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
        "hgroup",
        "main",
        "nav",
        "section",
        "search",

        # Text content
        "blockquote",
        "dd",
        "div",
        "dl",
        "dt",
        "figcaption",
        "figure",
        "hr",
        "li",
        "menu",
        "ol",
        "p",
        "pre",
        "ul",

        # Inline text semantics
        "a",
        "abbr",
        "b",
        "bdi",
        "bdo",
        "br",
        "cite",
        "code",
        "data",
        "dfn",
        "em",
        "i",
        "kbd",
        "mark",
        "q_",
        "rp",
        "rt",
        "ruby",
        "s_",
        "samp",
        "small",
        "span",
        "strong",
        "sub_",
        "sup",
        "time_",
        "u",
        "var",
        "wbr",

        # Images and multimedia
        "area",
        "audio",
        "img",
        "map_",
        "track",
        "video",

        # Embedded content
        "embed",
        "iframe",
        "object",
        "picture",
        "portal",
        "source",

        # SVG and MathML
        "svg",
        "math",

        # Scripting
        "canvas",
        "noscript",
        "script",

        # Demarcating edits
        "del",
        "ins",

        # Table content
        "caption",
        "col",
        "colgroup",
        "table",
        "tbody",
        "td",
        "tfoot",
        "th",
        "thead",
        "tr_",

        # Forms
        "button",
        "datalist",
        "fieldset",
        "form",
        "input",
        "label",
        "legend",
        "meter",
        "optgroup",
        "option",
        "output",
        "progress",
        "select_",
        "textarea",

        # Interactive elements
        "details",
        "dialog",
        "summary",

        # Web Components
        "slot",
        "template",
    );

    no strict 'refs';
    for my $func (@EXPORT) {
        my $tag = $func;
        $tag =~ s{_}{};

        *{ __PACKAGE__ . "::${func}" } = sub {
            unshift @_, $tag;
            goto $h;
        };
    }
    use strict 'refs';
}

1;

=encoding utf-8

=head1 NAME

Text::HyperScript::HTML5 - The shorthands to html living standard tags by L<Text::HyperScript>.

=head1 SYNOPSIS

    use Text::HyperScript::HTML5 qw(p);

    print p('hi,'), "\n";
    # => "<p>hi,</p>\n"

=head1 SUPPORTED TAGS

Please looking at C<@EXPORT> in the source code.

=head1 GLOBAL VARIABLES

=head2 C<$Text::HyperScript::HTML5::h> : CodeRef (default is C<Text::HyperScript-E<gt>can('h')>)

The code reference to making tags.

This value exists for customizing tags generation.

=head1 NOTICE

Some shorthands have C<_> suffix.

This is prevent to conflict built-in syntax of perl 

=head1 LICENSE

Copyright (C) OKAMURA Naoki a.k.a nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

OKAMURA Naoki a.k.a nyarla: E<lt>nyarla@kalaclista.comE<gt>

=cut
