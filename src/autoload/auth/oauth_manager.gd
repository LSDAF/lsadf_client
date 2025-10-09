class_name OauthManager
extends Node

# Signals for OAuth flow events
#signal auth_success(tokens: Dictionary)
signal auth_error(error_message: String)
#signal auth_cancelled

# Platform detection
enum Platform { DESKTOP, MOBILE_IOS, MOBILE_ANDROID }

# Preload UUID utility
const UUID = preload("res://addons/uuid/uuid.gd")

# Keycloak configuration constants
const KEYCLOAK_SERVER: String = "https://keycloak.k8s.local"
const REALM: String = "lsadf"
const CLIENT_ID: String = "lsadf-client"  # You'll need to configure this in Keycloak
const SCOPE: String = "openid profile email"

# Platform-specific redirect URIs
const MOBILE_REDIRECT_URI: String = "lsadf://oauth/callback"
const DESKTOP_PORT: int = 9999
const DESKTOP_REDIRECT_URI: String = "http://localhost:%d/callback" % DESKTOP_PORT

# OAuth URLs
const AUTH_URL: String = KEYCLOAK_SERVER + "/realms/" + REALM + "/protocol/openid-connect/auth"
const TOKEN_URL: String = KEYCLOAK_SERVER + "/realms/" + REALM + "/protocol/openid-connect/token"

# Internal state
var current_platform: Platform
var oauth_state: String
var http_server: TCPServer
var http_request: HTTPRequest
var is_auth_in_progress: bool = false


func _ready() -> void:
	_detect_platform()
	_setup_http_request()


func _detect_platform() -> void:
	"""Detect the current platform and set appropriate configuration"""
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			current_platform = Platform.DESKTOP
		"iOS":
			current_platform = Platform.MOBILE_IOS
		"Android":
			current_platform = Platform.MOBILE_ANDROID
		_:
			current_platform = Platform.DESKTOP  # Default fallback

	print("OAuth Manager: Detected platform - ", _get_platform_name())


func _get_platform_name() -> String:
	"""Get human-readable platform name"""
	match current_platform:
		Platform.DESKTOP:
			return "Desktop"
		Platform.MOBILE_IOS:
			return "iOS"
		Platform.MOBILE_ANDROID:
			return "Android"
		_:
			return "Unknown"


func _setup_http_request() -> void:
	"""Setup HTTPRequest node for token exchange"""
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_token_request_completed)


func _get_redirect_uri() -> String:
	"""Get platform-appropriate redirect URI"""
	match current_platform:
		Platform.DESKTOP:
			return DESKTOP_REDIRECT_URI
		Platform.MOBILE_IOS, Platform.MOBILE_ANDROID:
			return MOBILE_REDIRECT_URI
		_:
			return DESKTOP_REDIRECT_URI


func _generate_state() -> String:
	"""Generate a random state parameter for CSRF protection"""
	return UUID.v4()


func login() -> void:
	"""
	Main public method to initiate OAuth login flow
	This method will:
	1. Generate security state
	2. Start platform-specific callback listener
	3. Open browser with OAuth authorization URL
	"""
	if is_auth_in_progress:
		auth_error.emit("Authentication already in progress")
		return

	is_auth_in_progress = true
	oauth_state = _generate_state()

	print("OAuth Manager: Starting login flow on ", _get_platform_name())

	# Start platform-specific callback handling
	match current_platform:
		Platform.DESKTOP:
			_start_desktop_server()
		Platform.MOBILE_IOS, Platform.MOBILE_ANDROID:
			_setup_mobile_callback_handling()

	# Build authorization URL
	var auth_url: String = _build_auth_url()
	print("OAuth Manager: Opening browser with URL: ", auth_url)

	# Open browser
	OS.shell_open(auth_url)


func _build_auth_url() -> String:
	"""Build the complete OAuth authorization URL"""
	var params: Dictionary = {
		"client_id": CLIENT_ID,
		"redirect_uri": _get_redirect_uri(),
		"response_type": "code",
		"scope": SCOPE,
		"state": oauth_state
	}

	var query_string: String = ""
	for key: String in params:
		if query_string != "":
			query_string += "&"
		query_string += key + "=" + params[key].uri_encode()

	return AUTH_URL + "?" + query_string


func _start_desktop_server() -> void:
	"""Start HTTP server for desktop callback handling (Step 2 implementation)"""
	# This will be implemented in Step 2
	print("OAuth Manager: Starting desktop HTTP server on port ", DESKTOP_PORT)


func _setup_mobile_callback_handling() -> void:
	"""Setup mobile callback handling for custom URI scheme (Step 2 implementation)"""
	# This will be implemented in Step 2
	print("OAuth Manager: Setting up mobile callback handling")


func _on_token_request_completed(
	_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray
) -> void:
	"""Handle token exchange response (Step 5 implementation)"""
	# This will be implemented in Step 5


func _cleanup_auth_flow() -> void:
	"""Clean up resources after auth flow completion"""
	is_auth_in_progress = false
	oauth_state = ""

	# Clean up desktop server if running
	if http_server:
		http_server.stop()
		http_server = null
