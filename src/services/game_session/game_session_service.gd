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
	if load_game_session_data():
		print("Found saved game session: %s" % _game_session_data._game_session_id)
		if is_game_session_valid():
			print("Game session is still valid, using saved data")
			return
		print("Saved game session expired, requesting new one")

	var fetched: GameSessionDto = await _game_session_api.open_new_game_session(
		game_save_id, _on_fetch_game_session_error
	)
	_set_game_session_data_from_dto(fetched)

	print(
		"Game Session ID: %s" % _game_session_data._game_session_id,
		" (V%d)" % _game_session_data._version
	)
	print("End Time: %s" % _game_session_data._end_time_str)

	# Save the game session data locally
	save_game_session_data()


func refresh_game_session() -> void:
	var fetched: GameSessionDto = await _game_session_api.refresh_game_session(
		_game_session_data._game_session_id, _on_fetch_game_session_error
	)
	_set_game_session_data_from_dto(fetched)
	print(
		"Game Session ID: %s" % _game_session_data._game_session_id,
		" (V%d)" % _game_session_data._version
	)
	print("End Time: %s" % _game_session_data._end_time_str)

	# Save the updated game session data
	save_game_session_data()


func _on_fetch_game_session_error(response: Variant) -> void:
	Services.toaster.toast("Failed to fetch game session.")
	print(response)


func save_game_session_data() -> void:
	var result: int = _resource_saver.save(_game_session_data, GAME_SESSION_DATA_PATH)
	if result != OK:
		push_error("Failed to save game session data. Error code: %d" % result)
	else:
		print("Game session data saved successfully")


func load_game_session_data() -> bool:
	if not _resource_loader.exists(GAME_SESSION_DATA_PATH):
		return false

	var loaded_data: Resource = _resource_loader.load(GAME_SESSION_DATA_PATH)
	if loaded_data == null or not (loaded_data is GameSessionData):
		push_error("Failed to load game session data")
		return false
	_set_game_session_data_from_resource(loaded_data)
	return true


func is_game_session_valid() -> bool:
	if (
		_game_session_data._game_session_id.is_empty()
		or _game_session_data._end_time == null
		or _game_session_data._end_time.is_empty()
	):
		return false

	# Check if the end time is still in the future
	var now := Time.get_datetime_dict_from_system(true)
	var end_time := _game_session_data._end_time

	# Compare dates - session is valid if end_time is after current_time
	return DateUtils.compare_datetime_dicts(end_time, now) > 0


func _set_game_session_data_from_dto(game_session_dto: GameSessionDto) -> void:
	_game_session_data._game_session_id = game_session_dto.id
	_game_session_data._end_time = Time.get_datetime_dict_from_datetime_string(
		game_session_dto.end_time, false
	)
	_game_session_data._version = game_session_dto.version


func _set_game_session_data_from_resource(game_session_resource: GameSessionData) -> void:
	_game_session_data._game_session_id = game_session_resource._game_session_id
	_game_session_data._end_time = game_session_resource._end_time
	_game_session_data._version = game_session_resource._version
