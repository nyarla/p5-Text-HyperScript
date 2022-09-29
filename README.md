[![Actions Status](https://github.com/nyarla/p5-Text-HyperScript/actions/workflows/test.yml/badge.svg)](https://github.com/nyarla/p5-Text-HyperScript/actions)
# NAME

Text::HyperScript - The HyperScript library for Perl.

# SYNOPSIS

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

# DESCRIPTION

This library is a implementation of HTML generator like as hyperscirpt.

This library name contains **HyperScript**,
but library features different of another language or original implementation.

# FUNCTIONS

## h

This function makes html text by perl code. This function is complex. but it's powerful.

**Arguments**:

- `$tag`

    Tag name of element.

    This value should be `Str` value.

- `\%attrs` 

    Attributes of element.

    You can pass to these values as attribute value:

    - `Str`

        If passed to this value, attr value is `Str` value.

    - `Text::HyperScript::Boolean`

        If passed to this value, attrribute became a value-less attribute.

        For example, if you call this function like as:

            h('script' => {crossorigin => true}, '') # `true` return Text::HyperScript::Boolean value.

        You could get this result:

            '<script crossorigin></script>'

    - `ArrayRef[Str]`

        If passed to this value, attribute has **sorted** and delimited by whitespace `Str`. 

    - `HashRef[ Str | Text::HyperScript::Boolean | ArrayRef[Str] ]`

        If passed to this value, attribute has **prefixed** values.

        This feature is shorthand for `data` or `aria` properties.

        For Example:

            h('hr', { data => { key => 'id', enabled => true, flags => [qw(foo bar)]  } })

        Result is:

            '<hr data-enabled data-flags="bar foo" data-key="id" />'

- `$contnet`

    Contents of element.

    You can pass to these values:

    - `Str`

        Text value of content.

        **This value apply html escape by automatic**.

    - `Text::HyperScript::HTML`.

        HTML value of content.

        **This value is raw string of HTML**.

## text

This function return **escaped html** string.

This is useful for display text content from untrusted content,
Or contian special characters of html.

## raw

This function return raw html instance of `Text::HyperScript::HTML`.

**Return value does not auto escape of html**.

This function has risk of XSS or other script injection. Please be careful.

## true / false

This functions return blessed boolean value of `Text::HyperScript::Boolean`.

`Text::HyperScript::Boolean` has two methods:

- is\_true : Bool

    If boolean value pointed to true value, this method return true.
    Otherwise return false.

- is\_false : Bool

    If boolean value pointed to false value, this method return true.
    Otherwise return false.

This function values uses for html5 boolean attributes.

For exmaple:

    my $script = h('script', { crossorigin => true }, '...') # return <script crossorigin>...</script> 

# NOTE

## you should pass empty string to `h` function if you want content blank element like as `script`

If you want to get element of content is blank, you should call `h` function like as:

    h('scirpt', '') # => '<script></script>'

## all attributes and values are sorted by alphabetical accordion

This feature made that gets always same results of hyperscripted text,
Because perl's sort of hash keys always randomized.

# LICENSE

Copyright (C) nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

OKAMURA Naoki aka <nyarla@kalaclista.com>
