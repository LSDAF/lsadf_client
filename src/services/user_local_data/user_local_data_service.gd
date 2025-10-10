class_name UserLocalDataService

const USER_DATA_PATH = "user://user_data.res"

var _auth_api: AuthApi
var _user_local_data: UserLocalData
var _resource_loader_service: ResourceLoaderService
var _resource_saver_service: ResourceSaverService


func _init(
	auth_api: AuthApi,
	user_local_data: UserLocalData,
	resource_loader_service: ResourceLoaderService,
	resource_saver_service: ResourceSaverService
) -> void:
	_auth_api = auth_api
	_user_local_data = user_local_data
	_resource_loader_service = resource_loader_service
	_resource_saver_service = resource_saver_service


func create_new_user_data() -> void:
	var new_user_data := UserData.new()

	# If user wishes to remember his email
	if (
		_user_local_data._user_data
		and _user_local_data._user_data.remember_me
		and _user_local_data._user_data.email
	):
		new_user_data.remember_me = true
		new_user_data.email = _user_local_data._user_data.email

	_user_local_data._user_data = new_user_data
	save_to_device()


func load() -> UserData:
	if _resource_loader_service.exists(USER_DATA_PATH):
		var user_data := _resource_loader_service.load(USER_DATA_PATH)
		if user_data is UserData:  # Check that the data is valid
			_user_local_data._user_data = user_data
			return _user_local_data._user_data

	# If error on loading of the data, generate a new one
	create_new_user_data()

	return _user_local_data._user_data


func relog_user() -> bool:
	var user_data: UserData = _user_local_data._user_data

	if user_data.refresh_token == "" or user_data.email == "":
		return false

	var refresh_login_response := await _auth_api.refresh_login(
		_user_local_data._user_data.email,
		_user_local_data._user_data.refresh_token,
		_on_relog_failed
	)

	if refresh_login_response == null:
		return false

	save_access_token(refresh_login_response.access_token)
	save_refresh_token(refresh_login_response.refresh_token)

	return true


func save_to_device() -> Error:
	return _resource_saver_service.save(_user_local_data._user_data, USER_DATA_PATH)


func get_access_token() -> String:
	if _user_local_data._user_data && _user_local_data._user_data.access_token:
		return _user_local_data._user_data.access_token

	return ""


func get_email() -> String:
	return _user_local_data._user_data.email


func get_refresh_token() -> String:
	return _user_local_data._user_data.refresh_token


func get_remember_me() -> bool:
	return _user_local_data._user_data.remember_me


func save_access_token(access_token: String) -> bool:
	_user_local_data._user_data.access_token = access_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_access_token_and_expiration(access_token: String, expires_in: Dictionary) -> bool:
	_user_local_data._user_data.access_token = access_token
	_user_local_data._user_data.expires_in = expires_in

	var result: Error = save_to_device()
	return result == Error.OK


func save_refresh_token(refresh_token: String) -> bool:
	_user_local_data._user_data.refresh_token = refresh_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_refresh_token_and_expiration(
	refresh_token: String, refresh_expires_in: Dictionary
) -> bool:
	_user_local_data._user_data.refresh_token = refresh_token
	_user_local_data._user_data.refresh_expires_in = refresh_expires_in

	var result: Error = save_to_device()
	return result == Error.OK


func save_remember_me(remember_me: bool) -> bool:
	_user_local_data._user_data.remember_me = remember_me

	var result: Error = save_to_device()
	return result == Error.OK


func save_email(email: String) -> bool:
	_user_local_data._user_data.email = email

	var result: Error = save_to_device()
	return result == Error.OK


func _on_relog_failed(response: Variant) -> void:
	Services.toaster.toast("Error when relogging")
	print(response)
