class_name ApiClient
extends Node


func _generate_headers(
	upsert_headers: Dictionary, auth: bool, method := HTTPClient.METHOD_GET
) -> PackedStringArray:
	var building_headers: Dictionary

	if auth and Services.user_local_data != null:
		var token := Services.user_local_data.get_access_token()
		if token:
			building_headers["Authorization"] = "Bearer {0}".format([token])

	if method == HTTPClient.METHOD_POST or method == HTTPClient.METHOD_PUT:
		building_headers["Content-Type"] = "application/json"

	var headers: PackedStringArray = []

	for key: String in building_headers:
		headers.append("{0}: {1}".format([key, building_headers[key]]))

	for key: String in upsert_headers:
		headers.append("{0}: {1}".format([key, upsert_headers[key]]))

	return headers


func _log_error(url: String, response: HTTPResult) -> void:
	if !response.success() or response.status_err():
		var error := "{0}: Received status code [ {1} ]\nBody:\n{2}".format(
			[url, str(response.status), response.body_as_string()]
		)
		push_error(error)


func delete(url: String, auth: bool, upsert_headers: Dictionary = {}) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth, HTTPClient.METHOD_DELETE)

	var response: HTTPResult = await Http.http_client.http.async_request(
		url, headers, HTTPClient.METHOD_DELETE
	)

	_log_error(url, response)

	return response


func fetch(url: String, auth: bool, upsert_headers: Dictionary = {}) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth)

	var response: HTTPResult = await Http.http_client.http.async_request(
		url, headers, HTTPClient.METHOD_GET
	)

	_log_error(url, response)

	return response


func post(
	url: String,
	auth: bool,
	body: Dictionary = {},
	upsert_headers: Dictionary = {},
	nb_retries: int = 0
) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth, HTTPClient.METHOD_POST)
	var request_data := JSON.stringify(body)

	var lambda := func() -> HTTPResult:
		var result := await Http.http_client.http.async_request(
			url, headers, HTTPClient.METHOD_POST, request_data
		)

		return result

	var response: HTTPResult = await RetryUtils.run_http_request(lambda, nb_retries)

	_log_error(url, response)

	return response


func put(
	url: String, auth: bool, body: Dictionary = {}, upsert_headers: Dictionary = {}
) -> HTTPResult:
	var headers := _generate_headers(upsert_headers, auth, HTTPClient.METHOD_PUT)
	var request_data := JSON.stringify(body)

	var response: HTTPResult = await Http.http_client.http.async_request(
		url, headers, HTTPClient.METHOD_PUT, request_data
	)

	_log_error(url, response)

	return response
