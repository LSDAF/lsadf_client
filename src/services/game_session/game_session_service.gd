class_name GameSessionService

const GAME_SESSION_DATA_PATH = "user://game_session_data.res"

var _game_session_data: GameSessionData
var _game_session_api: GameSessionApi

var _resource_loader: ResourceLoaderService
var _resource_saver: ResourceSaverService


func _init(
	game_session_api: GameSessionApi,
	game_session_data: GameSessionData,
	resource_loader: ResourceLoaderService,
	resource_saver: ResourceSaverService
) -> void:
	_game_session_api = game_session_api
	_game_session_data = game_session_data
	_resource_loader = resource_loader
	_resource_saver = resource_saver


func open_new_game_session(game_save_id: String) -> void:
	var fetched: GameSessionDto = await _game_session_api.open_new_game_session(
		game_save_id, _on_fetch_game_session_error
	)
	_game_session_data._game_session_id = fetched.id
	_game_session_data._end_time_str = fetched.end_time
	_game_session_data._version = fetched.version
	print(
		"Game Session ID: %s" % _game_session_data._game_session_id,
		" (V%d)" % _game_session_data._version
	)
	print("End Time: %s" % _game_session_data._end_time_str)


func refresh_game_session() -> void:
	var fetched: GameSessionDto = await _game_session_api.refresh_game_session(
		_game_session_data._game_session_id, _on_fetch_game_session_error
	)
	_game_session_data._game_session_id = fetched.id
	_game_session_data._end_time_str = fetched.end_time
	_game_session_data._version = fetched.version
	print(
		"Game Session ID: %s" % _game_session_data._game_session_id,
		" (V%d)" % _game_session_data._version
	)
	print("End Time: %s" % _game_session_data._end_time_str)


func _on_fetch_game_session_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch game session.")
	print(response)
