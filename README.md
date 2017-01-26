# NAME

JSON::Schema::ToJSON - Generate example JSON structures from JSON Schema definitions

# VERSION

0.05

# SYNOPSIS

    use JSON::Schema::ToJSON;

    my $to_json  = JSON::Schema::ToJSON->new(
        example_key => undef, # set to a key to take example from
    );

    my $perl_string_hash_or_arrayref = $to_json->json_schema_to_json(
        schema     => $already_parsed_json_schema,  # either this
        schema_str => '{ "type" : "boolean" }',     # or this
    );

# DESCRIPTION

[JSON::Schema::ToJSON](https://metacpan.org/pod/JSON::Schema::ToJSON) is a class for generating "fake" or "example" JSON data
structures from JSON Schema structures.

Note this distribution is currently **EXPERIMENTAL** and subject to breaking changes.

# CONSTRUCTOR ARGUMENTS

## example\_key

The key that will be used to find example data for use in the returned structure. In
the case of the following schema:

    {
        "type" : "object",
        "properties" : {
            "id" : {
                "type" : "string",
                "description" : "ID of the payment.",
                "x-example" : "123ABC"
            }
        }
    }

Setting example\_key to `x-example` will make the generator return the content of
the `"x-example"` (123ABC) rather than a random string/int/etc. This is more so
for things like OpenAPI specifications.

You can set this to any key you like, although be careful as you could end up with
invalid data being used (for example an integer field and then using the description
key as the content would not be sensible or valid).

# METHODS

## json\_schema\_to\_json

    my $perl_string_hash_or_arrayref = $to_json->json_schema_to_json(
        schema     => $already_parsed_json_schema,  # either this
        schema_str => '{ "type" : "boolean" }',     # or this
    );

Returns a randomly generated representative data structure that corresponds to the
passed JSON schema. Can take either an already parsed JSON Schema or the raw JSON
Schema string.

# BUGS, CAVEATS, AND GOTCHAS

Bugs? Almost certainly.

Caveats? The implementation is currently incomplete, this is a work in progress so
using some of the more edge case JSON schema validation options will not generate
representative JSON so they will not validate against the schema on a round trip.
These include:

    additionalItems
    patternProperties
    additionalProperties
    dependencies
    allOf
    anyOf
    oneOf
    not

It is also entirely possible to pass a schema that could never be validated, but
will result in a generated structure anyway, example: an integer that has a "minimum"
value of 2, "maximum" value of 4, and must be a "multipleOf" 5 - a nonsensical
combination.

Gotchas? The data generated is completely random, don't expect it to be the same
across runs or calls. The data is also meaningless in terms of what it represents
such that an object property of "name" that is a string will be generated as, for
example, "kj02@#fjs01je#$42wfjs" - The JSON generated is so you have a representative
**structure**, not representative **data**. Set example keys in your schema and then
set the `example_key` in the constructor if you want this to be repeatable and/or
more representative.

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. If you would like to contribute documentation,
features, bug fixes, or anything else then please raise an issue / pull request:

    https://github.com/Humanstate/json-schema-tojson

# AUTHOR

Lee Johnson - `leejo@cpan.org`
