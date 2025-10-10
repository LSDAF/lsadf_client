class_name UriParserTest

extends GutTest

var uri: String
var result: Dictionary


func test_parse_query_parameters_with_multiple_params() -> void:
	uri = "https://example.com/page?foo=bar&baz=qux"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {"foo": "bar", "baz": "qux"})


func test_parse_query_parameters_with_no_query() -> void:
	uri = "https://example.com/page"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {})


func test_parse_query_parameters_with_empty_query() -> void:
	uri = "https://example.com/page?"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {})


func test_parse_query_parameters_with_encoded_params() -> void:
	uri = "https://example.com/page?name=John%20Doe&city=New%20York"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {"name": "John Doe", "city": "New York"})


func test_parse_query_parameters_with_missing_value() -> void:
	uri = "https://example.com/page?foo="
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {})


func test_parse_query_parameters_with_missing_key() -> void:
	uri = "https://example.com/page?=bar"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {})


func test_parse_query_parameters_with_extra_equal_sign() -> void:
	uri = "https://example.com/page?foo=bar=baz"
	result = UriParser.parse_query_parameters(uri)
	assert_eq(result, {})
