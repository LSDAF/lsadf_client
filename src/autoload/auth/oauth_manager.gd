extends Node

signal token_ready(access_token: String, refresh_token: String)

# Preload UUID utility
const UUID = preload("res://addons/uuid/uuid.gd")

# Keycloak configuration constants
const KEYCLOAK_SERVER: String = "https://keycloak.k8s.local"
const REALM: String = "LSADF"
const SCOPE: String = "openid profile email"

# OAuth URLs
const AUTH_URL: String = KEYCLOAK_SERVER + "/realms/" + REALM + "/protocol/openid-connect/auth"
const TOKEN_URL: String = KEYCLOAK_SERVER + "/realms/" + REALM + "/protocol/openid-connect/token"
const TOKEN_INFO_URL: String = (
	KEYCLOAK_SERVER + "/realms/" + REALM + "/protocol/openid-connect/userinfo"
)

const PORT := 31419
const BINDING := "127.0.0.1"
const CLIENT_ID: String = "lsadf-api"
const CLIENT_SECRET: String = "oWNAxvq3UXZlaKQLr5jn5iI1ozIiqI39"

var redirect_server := TCPServer.new()  #
var redirect_uri := "http://%s:%s" % [BINDING, PORT]

var token: String
var refresh_token: String
var expires_in: Dictionary
var refresh_expires_in: Dictionary


func _ready() -> void:
	set_process(false)


func authorize() -> void:
	#load_tokens()
	var loaded_data: UserData = Services.user_local_data.load()
	if loaded_data.access_token and loaded_data.access_token != "":
		token = loaded_data.access_token
		expires_in = loaded_data.expires_in
	if loaded_data.refresh_token and loaded_data.refresh_token != "":
		refresh_token = loaded_data.refresh_token
		refresh_expires_in = loaded_data.refresh_expires_in
	var is_valid_token: bool = is_token_valid()
	if is_valid_token:
		token_ready.emit(token, refresh_token)
	else:
		#if not await is_token_valid():
		#if not await refresh_tokens():
		get_auth_code()


func _process(_delta: float) -> void:
	if redirect_server.is_connection_available():
		var connection := redirect_server.take_connection()
		var request := connection.get_string(connection.get_available_bytes())
		if request:
			set_process(false)
			var url: String = (
				"http://%s:%s" % [BINDING, PORT] + request.split("\n")[0].split(" ")[1]
			)
			var query_parameters: Dictionary = UriParser.parse_query_parameters(url)
			var auth_code: String = query_parameters["code"]
			get_token_from_auth(auth_code)

			connection.put_data(("HTTP/1.1 %d\r\n" % 200).to_ascii_buffer())
			#connection.put_data(load_HTML("res://OAuth2/display_page.html").to_ascii_buffer())
			redirect_server.stop()


func get_auth_code() -> void:
	set_process(true)
	var redir_err := redirect_server.listen(PORT, BINDING)

	var body_parts := [
		"client_id=%s" % CLIENT_ID,
		"redirect_uri=%s" % redirect_uri.uri_encode(),
		"response_type=code",
		"scope=%s" % SCOPE.uri_encode(),
	]
	var url := AUTH_URL + "?" + "&".join(body_parts)
	OS.shell_open(url)  # Opens window for user authentication


func get_token_from_auth(auth_code: String) -> void:
	var headers := ["Content-Type: application/x-www-form-urlencoded"]
	headers = PackedStringArray(headers)

	var body_parts := [
		"code=%s" % auth_code,
		"client_id=%s" % CLIENT_ID,
		"client_secret=%s" % CLIENT_SECRET,
		"redirect_uri=%s" % redirect_uri,
		"grant_type=authorization_code"
	]

	var body := "&".join(PackedStringArray(body_parts))

# warning-ignore:return_value_discarded
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var now := Time.get_datetime_dict_from_system(true)
	var error := http_request.request(TOKEN_URL, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)

	var response: Array = await http_request.request_completed

	var response_body_str: PackedByteArray = response.get(3)
	var response_json: Dictionary = JSON.parse_string(response_body_str.get_string_from_utf8())
	if response_json != null:
		token = response_json["access_token"]
		refresh_token = response_json["refresh_token"]
		var expires_in_float: float = response_json["expires_in"]
		var refresh_expires_in_float: float = response_json["refresh_expires_in"]
		var expires_in_int: int = int(expires_in_float)
		var refresh_expires_in_int: int = int(refresh_expires_in_float)
		expires_in = DateUtils.add_seconds_to_time(now, expires_in_int)
		refresh_expires_in = DateUtils.add_seconds_to_time(now, refresh_expires_in_int)

		#save_tokens(token, expires_in_dict, refresh_token, refresh_expires_in_dict)
		Services.user_local_data.save_access_token_and_expiration(token, expires_in)
		Services.user_local_data.save_refresh_token_and_expiration(
			refresh_token, refresh_expires_in
		)
		token_ready.emit(token, refresh_token)
	else:
		print_debug("ERROR WHILE PARSING JSON")


func refresh_tokens() -> bool:
	if (not refresh_token) or refresh_token == "":
		return false

	print("refreshing")
	var headers := ["Content-Type: application/x-www-form-urlencoded"]

	var body_parts := [
		"client_id=%s" % CLIENT_ID,
		"client_secret=%s" % CLIENT_SECRET,
		"refresh_token=%s" % refresh_token,
		"grant_type=refresh_token"
	]
	var body := "&".join(PackedStringArray(body_parts))

# warning-ignore:return_value_discarded
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var now: Dictionary = Time.get_date_dict_from_system(true)
	var error := http_request.request(TOKEN_URL, headers, HTTPClient.METHOD_POST, body)

	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)

	var response: Array = await http_request.request_completed
	var response_body: PackedByteArray = response.get(3)
	var response_body_str: Dictionary = JSON.parse_string(response_body.get_string_from_utf8())

	if response_body_str.get("access_token"):
		token = response_body_str["access_token"]
		refresh_token = response_body_str["refresh_token"]
		var expires_in_str: String = response_body_str["expires_in"]
		var refresh_expires_in_str: String = response_body_str["refresh_expires_in"]
		var expires_in_int: int = int(expires_in_str)
		var refresh_expires_in_int: int = int(refresh_expires_in_str)
		var expires_in_dict: Dictionary = DateUtils.add_seconds_to_time(now, expires_in_int)
		var refresh_expires_in_dict: Dictionary = DateUtils.add_seconds_to_time(
			now, refresh_expires_in_int
		)

		#save_tokens(token, expires_in_dict, refresh_token, refresh_expires_in_dict)
		print("token refreshed")
		token_ready.emit(token, refresh_token)
		return true
	return false


func is_token_valid() -> bool:
	if !token or token.is_empty() or !expires_in or expires_in.is_empty():
		return false

	var now: Dictionary = Time.get_datetime_dict_from_system(true)
	var diff := DateUtils.compare_datetime_dicts(now, expires_in)
	return diff <= 0


func load_html(path: String) -> String:
	if FileAccess.file_exists(path):
		var file: FileAccess = FileAccess.open(path, FileAccess.READ)
		var html: String = file.get_as_text().replace("    ", "\t").insert(0, "\n")
		file.close()
		return html
	return ""
