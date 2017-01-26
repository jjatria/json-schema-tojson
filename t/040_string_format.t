#!perl

use strict;
use warnings;

use JSON::Schema::ToJSON;
use Test::Most;

my $ToJSON = JSON::Schema::ToJSON->new;

isa_ok( $ToJSON,'JSON::Schema::ToJSON' );

my $schema = {
	"type" => "object",
	"properties" => {
		(
			map {
				( "a_$_" => {
					"type"   => "string",
					"format" => $_,
				} )
			} qw/ date-time email hostname ipv4 ipv6 uri uriref /
		),
	},
};

my $json = $ToJSON->json_schema_to_json(
	schema => $schema,
);

note explain $json;

cmp_deeply(
	$json,
	{
		'a_date-time' => re( '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.000Z$' ),
		'a_email' => re( '^[A-Za-z]{12}@[A-Za-z]{12}.com$' ),
		'a_hostname' => re( '^[A-Za-z]{12}$' ),
		'a_ipv4' => re( '^\d+\.\d+\.\d+\.\d+$' ),
		'a_ipv6' => '2001:0db8:0000:0000:0000:0000:1428:57ab',
		'a_uri' => 'https://www.google.com',
		'a_uriref' => 'https://www.google.com'
	},
	'object'
);

done_testing();

# vim:noet:sw=4:ts=4
