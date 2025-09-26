class_name GameSessionService

var _game_session_data: GameSessionData
var _game_session_api: GameSessionApi


func _init(game_session_api: GameSessionApi, game_session_data: GameSessionData) -> void:
	_game_session_api = game_session_api
	_game_session_data = game_session_data


func open_new_game_session(game_save_id: String) -> void:
	var fetched: GameSessionDto = await _game_session_api.open_new_game_session(
		game_save_id, _on_fetch_game_session_error
	)
	_game_session_data._game_session_id = fetched.id
	_game_session_data._end_time_str = fetched.end_time
	_game_session_data._version = fetched.version
	print(
		(
			"Game Session ID: %s" % _game_session_data._game_session_id
			+ " End Time: %s" % _game_session_data._end_time_str
			+ " (Version: %d)" % _game_session_data._version
		)
	)


func refresh_game_session(game_session_id: String) -> void:
	var fetched: GameSessionDto = await _game_session_api.refresh_game_session(
		game_session_id, _on_fetch_game_session_error
	)
	_game_session_data._game_session_id = fetched.id
	_game_session_data._end_time_str = fetched.end_time
	_game_session_data._version = fetched.version


func _on_fetch_game_session_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch game session.")
	print(response)
