class_name UriParser


static func parse_query_parameters(uri: String) -> Dictionary:
	var query_parameters: Dictionary = {}
	var uri_parts: Array = uri.split("?")
	if uri_parts.size() < 2:
		return query_parameters  # No query parameters found

	var query_string: String = uri_parts[1]
	if query_string == null or query_string.is_empty():
		return query_parameters
	var pairs: Array = query_string.split("&")

	for pair: String in pairs:
		var key_value: Array = pair.split("=")
		if key_value.size() == 2:
			var key_encoded: String = key_value[0] as String
			var value_encoded: String = key_value[1] as String
			if key_encoded.is_empty() or value_encoded.is_empty():
				continue
			var key := key_encoded.uri_decode()
			var value := value_encoded.uri_decode()
			query_parameters[key] = value

	return query_parameters
