[![Actions Status](https://github.com/nyarla/p5-Text-HyperScript/actions/workflows/test.yml/badge.svg)](https://github.com/nyarla/p5-Text-HyperScript/actions)
# NAME

Text::HyperScript - The HyperScript library for Perl.

# SYNOPSIS

    # TODO

# DESCRIPTION

TODO

# FUNCTIONS

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

- is\_ture : Bool

    If boolean value pointed to true value, this method return true.
    Otherwise return false.

- is\_false : Bool

    If boolean value pointed to false value, this method return true.
    Otherwise return false.

This function values uses for html5 boolean attributes.

For exmaple:

    my $script = h('script', { crossorigin => true }, '...') # return <script crossorigin>...</script> 

# LICENSE

Copyright (C) nyarla.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

nyarla <nyarla@kalaclista.com>
